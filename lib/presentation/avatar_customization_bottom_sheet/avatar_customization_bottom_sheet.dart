import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sizer/sizer.dart';

import '../../core/app_export.dart';
import './widgets/accessory_category_tabs.dart';
import './widgets/accessory_detail_dialog.dart';
import './widgets/accessory_grid.dart';
import './widgets/bottom_action_buttons.dart';
import './widgets/drag_handle.dart';
import './widgets/skin_tone_selector.dart';

class AvatarCustomizationBottomSheet extends StatefulWidget {
  const AvatarCustomizationBottomSheet({super.key});

  @override
  State<AvatarCustomizationBottomSheet> createState() =>
      _AvatarCustomizationBottomSheetState();
}

class _AvatarCustomizationBottomSheetState
    extends State<AvatarCustomizationBottomSheet>
    with TickerProviderStateMixin {
  late AnimationController _slideController;
  late Animation<double> _slideAnimation;

  // State variables
  int _selectedCategoryIndex = 0;
  Color _selectedSkinTone = const Color(0xFFD4A574);
  String? _selectedHairId;
  String? _selectedClothingId;
  String? _selectedAccessoryId;
  bool _isLoading = false;

  // Mock data
  final List<Color> _skinTones = [
    const Color(0xFFF5DEB3), // Light
    const Color(0xFFDEB887), // Medium Light
    const Color(0xFFD4A574), // Medium
    const Color(0xFFCD853F), // Medium Dark
    const Color(0xFFA0522D), // Dark
    const Color(0xFF8B4513), // Very Dark
  ];

  final List<String> _categories = ['Rambut', 'Pakaian', 'Aksesori'];

  final List<Map<String, dynamic>> _hairAccessories = [
    {
      "id": "hair_1",
      "name": "Rambut Pendek",
      "image":
          "https://images.unsplash.com/photo-1733452358021-3474b988a1ca",
      "semanticLabel": "Short black hair style for avatar customization",
      "description":
          "Gaya rambut pendek klasik yang cocok untuk berbagai kesempatan",
      "price": "Gratis"
    },
    {
      "id": "hair_2",
      "name": "Rambut Panjang",
      "image":
          "https://images.unsplash.com/photo-1638064432601-18b99cb31acb",
      "semanticLabel": "Long wavy hair style for avatar customization",
      "description": "Rambut panjang bergelombang yang elegan dan menawan",
      "price": "Rp 5.000"
    },
    {
      "id": "hair_3",
      "name": "Rambut Keriting",
      "image":
          "https://images.unsplash.com/photo-1701977153677-c844d445f169",
      "semanticLabel": "Curly hair style for avatar customization",
      "description":
          "Gaya rambut keriting yang memberikan kesan natural dan unik",
      "price": "Rp 3.000"
    },
    {
      "id": "hair_4",
      "name": "Rambut Bob",
      "image":
          "https://images.unsplash.com/photo-1556755140-e34e22dcb26c",
      "semanticLabel": "Bob cut hair style for avatar customization",
      "description": "Potongan bob modern yang stylish dan mudah diatur",
      "price": "Rp 4.000"
    },
    {
      "id": "hair_5",
      "name": "Rambut Pixie",
      "image":
          "https://images.unsplash.com/photo-1544198841-dbeb20d385ed",
      "semanticLabel": "Pixie cut hair style for avatar customization",
      "description": "Gaya pixie cut yang berani dan penuh karakter",
      "price": "Rp 6.000"
    },
    {
      "id": "hair_6",
      "name": "Rambut Braids",
      "image":
          "https://images.unsplash.com/photo-1540991099105-24b889d85b8d",
      "semanticLabel": "Braided hair style for avatar customization",
      "description": "Kepangan rambut yang artistik dan penuh kreativitas",
      "price": "Rp 8.000"
    },
  ];

  final List<Map<String, dynamic>> _clothingAccessories = [
    {
      "id": "clothing_1",
      "name": "Kaos Casual",
      "image":
          "https://images.unsplash.com/photo-1610007620023-f434ea6c0c70",
      "semanticLabel": "Casual t-shirt clothing for avatar customization",
      "description": "Kaos casual yang nyaman untuk aktivitas sehari-hari",
      "price": "Gratis"
    },
    {
      "id": "clothing_2",
      "name": "Kemeja Formal",
      "image":
          "https://images.unsplash.com/photo-1593030617604-91d25b589e61",
      "semanticLabel": "Formal shirt clothing for avatar customization",
      "description": "Kemeja formal yang cocok untuk acara resmi dan kantor",
      "price": "Rp 12.000"
    },
    {
      "id": "clothing_3",
      "name": "Hoodie",
      "image":
          "https://images.unsplash.com/photo-1601754664414-aa3e4f42e6d4",
      "semanticLabel": "Hoodie clothing for avatar customization",
      "description": "Hoodie hangat yang trendy untuk cuaca dingin",
      "price": "Rp 15.000"
    },
    {
      "id": "clothing_4",
      "name": "Dress Elegan",
      "image":
          "https://images.unsplash.com/photo-1646855350893-6aec39a1e17b",
      "semanticLabel": "Elegant dress clothing for avatar customization",
      "description": "Dress elegan untuk acara spesial dan pesta",
      "price": "Rp 20.000"
    },
    {
      "id": "clothing_5",
      "name": "Jaket Denim",
      "image":
          "https://images.unsplash.com/photo-1669486376990-e86857e8347d",
      "semanticLabel": "Denim jacket clothing for avatar customization",
      "description": "Jaket denim klasik yang tidak pernah ketinggalan zaman",
      "price": "Rp 18.000"
    },
    {
      "id": "clothing_6",
      "name": "Blazer",
      "image":
          "https://images.unsplash.com/photo-1690076703377-00fe0594b6b9",
      "semanticLabel": "Blazer clothing for avatar customization",
      "description": "Blazer profesional untuk tampilan yang berkelas",
      "price": "Rp 25.000"
    },
  ];

  final List<Map<String, dynamic>> _otherAccessories = [
    {
      "id": "accessory_1",
      "name": "Kacamata",
      "image":
          "https://images.unsplash.com/photo-1687582394246-8a69f3e273cf",
      "semanticLabel": "Glasses accessory for avatar customization",
      "description": "Kacamata stylish yang menambah kesan intelektual",
      "price": "Rp 7.000"
    },
    {
      "id": "accessory_2",
      "name": "Topi Baseball",
      "image":
          "https://images.unsplash.com/photo-1543659549-368f612ecce2",
      "semanticLabel": "Baseball cap accessory for avatar customization",
      "description": "Topi baseball casual untuk gaya sporty",
      "price": "Rp 5.000"
    },
    {
      "id": "accessory_3",
      "name": "Anting",
      "image":
          "https://images.unsplash.com/photo-1544198841-6ae3e25ea8f0",
      "semanticLabel": "Earrings accessory for avatar customization",
      "description": "Anting cantik yang menambah pesona wajah",
      "price": "Rp 3.000"
    },
    {
      "id": "accessory_4",
      "name": "Kalung",
      "image":
          "https://images.unsplash.com/photo-1544198841-dbeb20d385ed",
      "semanticLabel": "Necklace accessory for avatar customization",
      "description": "Kalung elegan untuk melengkapi penampilan",
      "price": "Rp 10.000"
    },
    {
      "id": "accessory_5",
      "name": "Jam Tangan",
      "image":
          "https://images.unsplash.com/photo-1544198841-6ae3e25ea8f0",
      "semanticLabel": "Watch accessory for avatar customization",
      "description": "Jam tangan mewah yang menunjukkan status",
      "price": "Rp 15.000"
    },
    {
      "id": "accessory_6",
      "name": "Syal",
      "image":
          "https://images.unsplash.com/photo-1569388330292-79cc1ec67270",
      "semanticLabel": "Scarf accessory for avatar customization",
      "description": "Syal hangat dan stylish untuk musim dingin",
      "price": "Rp 8.000"
    },
  ];

  @override
  void initState() {
    super.initState();
    _slideController = AnimationController(
      duration: AppTheme.standardAnimation,
      vsync: this,
    );
    _slideAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _slideController,
      curve: Curves.easeOutCubic,
    ));

    _slideController.forward();
  }

  @override
  void dispose() {
    _slideController.dispose();
    super.dispose();
  }

  List<Map<String, dynamic>> _getCurrentAccessories() {
    switch (_selectedCategoryIndex) {
      case 0:
        return _hairAccessories;
      case 1:
        return _clothingAccessories;
      case 2:
        return _otherAccessories;
      default:
        return [];
    }
  }

  String? _getCurrentSelectedId() {
    switch (_selectedCategoryIndex) {
      case 0:
        return _selectedHairId;
      case 1:
        return _selectedClothingId;
      case 2:
        return _selectedAccessoryId;
      default:
        return null;
    }
  }

  void _onAccessorySelected(Map<String, dynamic> accessory) {
    setState(() {
      switch (_selectedCategoryIndex) {
        case 0:
          _selectedHairId = accessory['id'] as String;
          break;
        case 1:
          _selectedClothingId = accessory['id'] as String;
          break;
        case 2:
          _selectedAccessoryId = accessory['id'] as String;
          break;
      }
    });
  }

  void _onAccessoryLongPress(Map<String, dynamic> accessory) {
    showDialog(
      context: context,
      builder: (context) => AccessoryDetailDialog(accessory: accessory),
    );
  }

  void _onSkinToneSelected(Color tone) {
    setState(() {
      _selectedSkinTone = tone;
    });
    HapticFeedback.lightImpact();
  }

  void _onCategorySelected(int index) {
    setState(() {
      _selectedCategoryIndex = index;
    });
    HapticFeedback.selectionClick();
  }

  Future<void> _resetAvatar() async {
    HapticFeedback.mediumImpact();
    setState(() {
      _selectedSkinTone = const Color(0xFFD4A574);
      _selectedHairId = null;
      _selectedClothingId = null;
      _selectedAccessoryId = null;
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          'Avatar berhasil direset',
          style: AppTheme.darkTheme.textTheme.bodyMedium?.copyWith(
            color: AppTheme.textPrimary,
          ),
        ),
        backgroundColor: AppTheme.surfaceElevated,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppTheme.radiusMedium),
        ),
      ),
    );
  }

  Future<void> _savePreset() async {
    setState(() {
      _isLoading = true;
    });

    HapticFeedback.mediumImpact();

    // Simulate API call
    await Future.delayed(const Duration(seconds: 2));

    setState(() {
      _isLoading = false;
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            CustomIconWidget(
              iconName: 'check_circle',
              color: AppTheme.successGreen,
              size: 5.w,
            ),
            SizedBox(width: 3.w),
            Expanded(
              child: Text(
                'Preset avatar berhasil disimpan!',
                style: AppTheme.darkTheme.textTheme.bodyMedium?.copyWith(
                  color: AppTheme.textPrimary,
                ),
              ),
            ),
          ],
        ),
        backgroundColor: AppTheme.surfaceElevated,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppTheme.radiusMedium),
        ),
        duration: const Duration(seconds: 3),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _slideAnimation,
      builder: (context, child) {
        return Transform.translate(
          offset: Offset(0, (1 - _slideAnimation.value) * 100.h),
          child: Container(
            decoration: BoxDecoration(
              color: AppTheme.surfaceElevated,
              borderRadius: BorderRadius.vertical(
                top: Radius.circular(AppTheme.radiusXLarge),
              ),
              boxShadow: [
                BoxShadow(
                  color: AppTheme.shadowColor,
                  blurRadius: 16,
                  offset: const Offset(0, -4),
                ),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Drag Handle
                const DragHandle(),

                // Header
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.h),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Kustomisasi Avatar',
                        style:
                            AppTheme.darkTheme.textTheme.titleLarge?.copyWith(
                          color: AppTheme.textPrimary,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      GestureDetector(
                        onTap: () => Navigator.of(context).pop(),
                        child: Container(
                          padding: EdgeInsets.all(2.w),
                          decoration: BoxDecoration(
                            color: AppTheme.surfaceNearBlack,
                            shape: BoxShape.circle,
                          ),
                          child: CustomIconWidget(
                            iconName: 'close',
                            color: AppTheme.textSecondary,
                            size: 5.w,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                // Skin Tone Selector
                SkinToneSelector(
                  skinTones: _skinTones,
                  selectedTone: _selectedSkinTone,
                  onToneSelected: _onSkinToneSelected,
                ),

                // Category Tabs
                AccessoryCategoryTabs(
                  categories: _categories,
                  selectedIndex: _selectedCategoryIndex,
                  onCategorySelected: _onCategorySelected,
                ),

                // Accessory Grid
                Flexible(
                  child: AccessoryGrid(
                    accessories: _getCurrentAccessories(),
                    selectedAccessoryId: _getCurrentSelectedId(),
                    onAccessorySelected: _onAccessorySelected,
                    onAccessoryLongPress: _onAccessoryLongPress,
                  ),
                ),

                // Bottom Action Buttons
                BottomActionButtons(
                  onResetAvatar: _resetAvatar,
                  onSavePreset: _savePreset,
                  isLoading: _isLoading,
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
