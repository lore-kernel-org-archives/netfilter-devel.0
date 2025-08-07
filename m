Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 57F9319006B
	for <netfilter-devel@vger.kernel.org>; Thu,  7 Aug 2025 01:55:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.12
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1754531731; cv=none; b=Rn5r6DdWkzPxPaKeaKnSS9+GzK/rT5lnEfRGHiCsawy0eoArYihtqB2d8g01NK/q2lEjWcjIZpamSXGb3TBft0xd+rwuPzHoDN9rIbHC6xYKhmhYJUdhN0RbFsy6qrJZgeBKKfnFDVWQpr6nzDyE9Dt0FhW4yK3jI8o4zmBYesY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1754531731; c=relaxed/simple;
	bh=Ikzuf4oEND6UNDQ6hf1HVFl1EBdET/5/77CG1QLnjFY=;
	h=Date:From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type:
	 Content-Disposition; b=iZb3i/7nvK4w2VvCupCfUuXmd10FkhKFTebinSpd7ACwBBFJRViYR16mk5IDDepnzC5PNIKZmMGXsVjeQcl+F+6QH+3kiDWxldjL0bKkMpXhop8CcDZur8wctfINU2CSjlfzLSYRsN6Sj10G0RKy6OwjAYD6v/hvviVM7xqElpY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=bYruqVAQ; arc=none smtp.client-ip=192.198.163.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="bYruqVAQ"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1754531728; x=1786067728;
  h=date:from:to:cc:subject:message-id:mime-version;
  bh=Ikzuf4oEND6UNDQ6hf1HVFl1EBdET/5/77CG1QLnjFY=;
  b=bYruqVAQruglvDuCABLK3QSii/sIK5ft2MOVNK2Ak7NUOXuIoPHuz08q
   nzQN6+7d28ffq/ZctI+IBckdMxfY6ip/WZ2BL3LFOw7mlKUI2CuxjxVey
   7oC1W+pvKpFfQhXjnU6A55js68/XwccezN9Bc7HcvhbLPpUynVEDrnNic
   aWCOrkXmZejDdY3q6n2YRy7mp9Dbhzb+EIvGBj8LUWAFasPMch58gIRtG
   QojtMDiguGVOojQgF/9wBVB9/uL1iA5QfyxqfGSHQptM2OHvmApGMF15L
   Kjco7OAlY5O4oqv6iSOiz/9Q7kcMabqBMuc/o4HLU/WR0xdERXZt+xiSN
   A==;
X-CSE-ConnectionGUID: DLnQKA47Sxe1ZxdtVq++hg==
X-CSE-MsgGUID: 2kwIiOyJTkShmDVmqu2QEg==
X-IronPort-AV: E=McAfee;i="6800,10657,11514"; a="60669693"
X-IronPort-AV: E=Sophos;i="6.17,271,1747724400"; 
   d="scan'208";a="60669693"
Received: from fmviesa003.fm.intel.com ([10.60.135.143])
  by fmvoesa106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Aug 2025 18:55:28 -0700
X-CSE-ConnectionGUID: HqG/kz4LRCeQs36chzY5KA==
X-CSE-MsgGUID: QzqtEqvWSV+N/fij0/XtjQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.17,271,1747724400"; 
   d="scan'208";a="169049579"
Received: from lkp-server02.sh.intel.com (HELO 4ea60e6ab079) ([10.239.97.151])
  by fmviesa003.fm.intel.com with ESMTP; 06 Aug 2025 18:55:25 -0700
Received: from kbuild by 4ea60e6ab079 with local (Exim 4.96)
	(envelope-from <lkp@intel.com>)
	id 1ujpql-0002GY-2A;
	Thu, 07 Aug 2025 01:55:23 +0000
Date: Thu, 7 Aug 2025 09:55:22 +0800
From: kernel test robot <lkp@intel.com>
To: Sharath Chandra Vurukala <quic_sharathv@quicinc.com>
Cc: oe-kbuild-all@lists.linux.dev, netfilter-devel@vger.kernel.org,
	coreteam@netfilter.org, Jakub Kicinski <kuba@kernel.org>,
	Eric Dumazet <edumazet@google.com>
Subject: [netfilter-nf:main 21/38] ERROR: modpost: __ex_table+0x15a8
 references non-executable section '.bss.dfs_dir_mtd'
Message-ID: <202508070928.cQL7ftm2-lkp@intel.com>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

tree:   https://git.kernel.org/pub/scm/linux/kernel/git/netfilter/nf.git main
head:   d942fe13f72bec92f6c689fbd74c5ec38228c16a
commit: 1dbf1d590d10a6d1978e8184f8dfe20af22d680a [21/38] net: Add locking to protect skb->dev access in ip_output
config: riscv-randconfig-002-20250807 (https://download.01.org/0day-ci/archive/20250807/202508070928.cQL7ftm2-lkp@intel.com/config)
compiler: riscv32-linux-gcc (GCC) 8.5.0
reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20250807/202508070928.cQL7ftm2-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202508070928.cQL7ftm2-lkp@intel.com/

All errors (new ones prefixed by >>, old ones prefixed by <<):

WARNING: modpost: vmlinux: section mismatch in reference: rfkill_fop_read+0xac (section: .text.rfkill_fop_read) -> newvision_nv3051d_driver_exit (section: .exit.text)
WARNING: modpost: vmlinux: section mismatch in reference: rfkill_fop_read+0xc2 (section: .text.rfkill_fop_read) -> newvision_nv3051d_driver_init (section: .init.text)
WARNING: modpost: vmlinux: section mismatch in reference: rfkill_fop_read+0xdc (section: .text.rfkill_fop_read) -> d53e6ea8966_driver_init (section: .init.text)
WARNING: modpost: vmlinux: section mismatch in reference: receive+0x54 (section: .text.receive) -> nt35950_driver_exit (section: .exit.text)
WARNING: modpost: vmlinux: section mismatch in reference: receive+0x76 (section: .text.receive) -> nt35510_driver_init (section: .init.text)
WARNING: modpost: vmlinux: section mismatch in reference: receive+0x92 (section: .text.receive) -> nt35950_driver_init (section: .init.text)
WARNING: modpost: vmlinux: section mismatch in reference: receive+0xc4 (section: .text.receive) -> nt35950_driver_init (section: .init.text)
WARNING: modpost: vmlinux: section mismatch in reference: receive+0x24a (section: .text.receive) -> nt35510_driver_exit (section: .exit.text)
WARNING: modpost: vmlinux: section mismatch in reference: receive+0x252 (section: .text.receive) -> nt35950_driver_exit (section: .exit.text)
WARNING: modpost: vmlinux: section mismatch in reference: cfcnfg_set_phy_state+0x4a (section: .text.cfcnfg_set_phy_state) -> nt36672a_panel_driver_exit (section: .exit.text)
WARNING: modpost: vmlinux: section mismatch in reference: cfcnfg_set_phy_state+0x5a (section: .text.cfcnfg_set_phy_state) -> nt36672e_panel_driver_exit (section: .exit.text)
WARNING: modpost: vmlinux: section mismatch in reference: cfcnfg_set_phy_state+0x64 (section: .text.cfcnfg_set_phy_state) -> nt36672e_panel_driver_exit (section: .exit.text)
WARNING: modpost: vmlinux: section mismatch in reference: cfcnfg_set_phy_state+0x72 (section: .text.cfcnfg_set_phy_state) -> nt36672a_panel_driver_init (section: .init.text)
WARNING: modpost: vmlinux: section mismatch in reference: cfcnfg_set_phy_state+0x7e (section: .text.cfcnfg_set_phy_state) -> nt36672e_panel_driver_init (section: .init.text)
WARNING: modpost: vmlinux: section mismatch in reference: cfcnfg_set_phy_state+0xa4 (section: .text.cfcnfg_set_phy_state) -> nt36672e_panel_driver_init (section: .init.text)
WARNING: modpost: vmlinux: section mismatch in reference: cfcnfg_set_phy_state+0xa6 (section: .text.cfcnfg_set_phy_state) -> nt36672e_panel_driver_exit (section: .exit.text)
WARNING: modpost: vmlinux: section mismatch in reference: cfcnfg_set_phy_state+0x244 (section: .text.cfcnfg_set_phy_state) -> nt36672e_panel_driver_init (section: .init.text)
WARNING: modpost: vmlinux: section mismatch in reference: cfmuxl_receive+0x23c (section: .text.cfmuxl_receive) -> novatek_nt37801_driver_init (section: .init.text)
WARNING: modpost: vmlinux: section mismatch in reference: cfmuxl_transmit+0x32 (section: .text.cfmuxl_transmit) -> novatek_nt37801_driver_init (section: .init.text)
WARNING: modpost: vmlinux: section mismatch in reference: cfmuxl_transmit+0x5c (section: .text.cfmuxl_transmit) -> novatek_nt37801_driver_exit (section: .exit.text)
WARNING: modpost: vmlinux: section mismatch in reference: cfmuxl_transmit+0x270 (section: .text.cfmuxl_transmit) -> novatek_nt37801_driver_init (section: .init.text)
WARNING: modpost: vmlinux: section mismatch in reference: cfmuxl_ctrlcmd+0x182 (section: .text.cfmuxl_ctrlcmd) -> novatek_nt37801_driver_init (section: .init.text)
WARNING: modpost: vmlinux: section mismatch in reference: nl802154_send_scan_msg+0x1a4 (section: .text.nl802154_send_scan_msg) -> s6e63m0_dsi_driver_init (section: .init.text)
WARNING: modpost: vmlinux: section mismatch in reference: nl802154_scan_done+0x8 (section: .text.nl802154_scan_done) -> s6e63m0_dsi_driver_init (section: .init.text)
WARNING: modpost: vmlinux: section mismatch in reference: nl802154_scan_done+0x3a (section: .text.nl802154_scan_done) -> s6e63m0_dsi_driver_exit (section: .exit.text)
WARNING: modpost: vmlinux: section mismatch in reference: nl802154_list_associations+0x176 (section: .text.nl802154_list_associations) -> s6e63m0_dsi_driver_init (section: .init.text)
WARNING: modpost: vmlinux: section mismatch in reference: nl802154_list_associations+0x17a (section: .text.nl802154_list_associations) -> s6e8aa0_driver_init (section: .init.text)
WARNING: modpost: vmlinux: section mismatch in reference: nl802154_pre_doit+0x128 (section: .text.nl802154_pre_doit) -> s6e63m0_dsi_driver_exit (section: .exit.text)
WARNING: modpost: vmlinux: section mismatch in reference: nl802154_pre_doit+0x13a (section: .text.nl802154_pre_doit) -> s6e63m0_dsi_driver_exit (section: .exit.text)
WARNING: modpost: vmlinux: section mismatch in reference: nl802154_pre_doit+0x13e (section: .text.nl802154_pre_doit) -> s6e8aa0_driver_exit (section: .exit.text)
WARNING: modpost: vmlinux: section mismatch in reference: nl802154_pre_doit+0x14a (section: .text.nl802154_pre_doit) -> s6e63m0_dsi_driver_init (section: .init.text)
WARNING: modpost: vmlinux: section mismatch in reference: nl802154_pre_doit+0x15e (section: .text.nl802154_pre_doit) -> s6e8aa0_driver_init (section: .init.text)
WARNING: modpost: vmlinux: section mismatch in reference: nl802154_pre_doit+0x160 (section: .text.nl802154_pre_doit) -> s6e63m0_dsi_driver_init (section: .init.text)
WARNING: modpost: vmlinux: section mismatch in reference: nl802154_pre_doit+0x19e (section: .text.nl802154_pre_doit) -> s6e63m0_dsi_driver_init (section: .init.text)
WARNING: modpost: vmlinux: section mismatch in reference: nl802154_pre_doit+0x1dc (section: .text.nl802154_pre_doit) -> s6e8aa0_driver_init (section: .init.text)
WARNING: modpost: vmlinux: section mismatch in reference: nl802154_pre_doit+0x1fc (section: .text.nl802154_pre_doit) -> s6e63m0_dsi_driver_exit (section: .exit.text)
WARNING: modpost: vmlinux: section mismatch in reference: nl802154_pre_doit+0x204 (section: .text.nl802154_pre_doit) -> s6e8aa0_driver_exit (section: .exit.text)
WARNING: modpost: vmlinux: section mismatch in reference: nl802154_pre_doit+0x212 (section: .text.nl802154_pre_doit) -> s6e8aa0_driver_init (section: .init.text)
WARNING: modpost: vmlinux: section mismatch in reference: nl802154_pre_doit+0x22c (section: .text.nl802154_pre_doit) -> s6e63m0_dsi_driver_init (section: .init.text)
WARNING: modpost: vmlinux: section mismatch in reference: nl802154_pre_doit+0x25a (section: .text.nl802154_pre_doit) -> s6e63m0_dsi_driver_init (section: .init.text)
WARNING: modpost: vmlinux: section mismatch in reference: nl802154_pre_doit+0x25e (section: .text.nl802154_pre_doit) -> s6e63m0_dsi_driver_init (section: .init.text)
WARNING: modpost: vmlinux: section mismatch in reference: nl802154_pre_doit+0x27a (section: .text.nl802154_pre_doit) -> s6e8aa0_driver_init (section: .init.text)
WARNING: modpost: vmlinux: section mismatch in reference: nl802154_pre_doit+0x27c (section: .text.nl802154_pre_doit) -> s6e63m0_dsi_driver_init (section: .init.text)
WARNING: modpost: vmlinux: section mismatch in reference: nl802154_abort_scan+0x7e (section: .text.nl802154_abort_scan) -> s6e8aa0_driver_exit (section: .exit.text)
WARNING: modpost: vmlinux: section mismatch in reference: nl802154_abort_scan+0x18c (section: .text.nl802154_abort_scan) -> s6e8aa0_driver_exit (section: .exit.text)
WARNING: modpost: vmlinux: section mismatch in reference: nl802154_abort_scan+0x194 (section: .text.nl802154_abort_scan) -> s6e63m0_dsi_driver_exit (section: .exit.text)
WARNING: modpost: vmlinux: section mismatch in reference: nl802154_abort_scan+0x1c4 (section: .text.nl802154_abort_scan) -> s6e8aa0_driver_init (section: .init.text)
WARNING: modpost: vmlinux: section mismatch in reference: perf_trace_802154_wdev_template+0x30 (section: .text.perf_trace_802154_wdev_template) -> .LVL245 (section: .init.text)
WARNING: modpost: vmlinux: section mismatch in reference: perf_trace_802154_wdev_template+0x4e (section: .text.perf_trace_802154_wdev_template) -> st7789v_driver_init (section: .init.text)
WARNING: modpost: vmlinux: section mismatch in reference: perf_trace_802154_wdev_template+0x6c (section: .text.perf_trace_802154_wdev_template) -> .LVL248 (section: .init.text)
WARNING: modpost: vmlinux: section mismatch in reference: perf_trace_802154_wdev_template+0xca (section: .text.perf_trace_802154_wdev_template) -> st7789v_driver_init (section: .init.text)
WARNING: modpost: vmlinux: section mismatch in reference: dns_resolver_preparse+0x11c (section: .text.dns_resolver_preparse) -> stk_panel_driver_exit (section: .exit.text)
WARNING: modpost: vmlinux: section mismatch in reference: dns_resolver_preparse+0x160 (section: .text.dns_resolver_preparse) -> tdo_tl070wsh30_panel_driver_exit (section: .exit.text)
WARNING: modpost: vmlinux: section mismatch in reference: dns_resolver_preparse+0x168 (section: .text.dns_resolver_preparse) -> tdo_tl070wsh30_panel_driver_exit (section: .exit.text)
WARNING: modpost: vmlinux: section mismatch in reference: dns_resolver_preparse+0x1a4 (section: .text.dns_resolver_preparse) -> stk_panel_driver_init (section: .init.text)
WARNING: modpost: vmlinux: section mismatch in reference: dns_resolver_preparse+0x1aa (section: .text.dns_resolver_preparse) -> tdo_tl070wsh30_panel_driver_init (section: .init.text)
WARNING: modpost: vmlinux: section mismatch in reference: dns_resolver_preparse+0x1ae (section: .text.dns_resolver_preparse) -> tdo_tl070wsh30_panel_driver_init (section: .init.text)
WARNING: modpost: vmlinux: section mismatch in reference: dns_resolver_preparse+0x1b8 (section: .text.dns_resolver_preparse) -> stk_panel_driver_init (section: .init.text)
WARNING: modpost: vmlinux: section mismatch in reference: dns_resolver_preparse+0x1bc (section: .text.dns_resolver_preparse) -> tdo_tl070wsh30_panel_driver_exit (section: .exit.text)
WARNING: modpost: vmlinux: section mismatch in reference: dns_resolver_preparse+0x1c8 (section: .text.dns_resolver_preparse) -> tdo_tl070wsh30_panel_driver_exit (section: .exit.text)
WARNING: modpost: vmlinux: section mismatch in reference: dns_resolver_preparse+0x1e6 (section: .text.dns_resolver_preparse) -> tdo_tl070wsh30_panel_driver_exit (section: .exit.text)
WARNING: modpost: vmlinux: section mismatch in reference: batadv_v_ogm_send+0x36e (section: .text.batadv_v_ogm_send) -> tda998x_driver_exit (section: .exit.text)
WARNING: modpost: vmlinux: section mismatch in reference: batadv_tp_list_find+0x154 (section: .text.batadv_tp_list_find) -> nwl_dsi_driver_init (section: .init.text)
WARNING: modpost: vmlinux: section mismatch in reference: batadv_tp_list_find+0x186 (section: .text.batadv_tp_list_find) -> nwl_dsi_driver_exit (section: .exit.text)
WARNING: modpost: vmlinux: section mismatch in reference: batadv_tp_list_find_session+0x78 (section: .text.batadv_tp_list_find_session) -> nwl_dsi_driver_init (section: .init.text)
WARNING: modpost: vmlinux: section mismatch in reference: batadv_tp_list_find_session+0xa4 (section: .text.batadv_tp_list_find_session) -> nwl_dsi_driver_init (section: .init.text)
WARNING: modpost: vmlinux: section mismatch in reference: batadv_tp_list_find_session+0x108 (section: .text.batadv_tp_list_find_session) -> anx7625_driver_init (section: .init.text)
WARNING: modpost: vmlinux: section mismatch in reference: batadv_tp_send+0x47a (section: .text.batadv_tp_send) -> nwl_dsi_driver_exit (section: .exit.text)
WARNING: modpost: vmlinux: section mismatch in reference: batadv_tp_send+0x4ca (section: .text.batadv_tp_send) -> nwl_dsi_driver_exit (section: .exit.text)
WARNING: modpost: vmlinux: section mismatch in reference: batadv_tp_send+0x4d8 (section: .text.batadv_tp_send) -> anx7625_driver_exit (section: .exit.text)
WARNING: modpost: vmlinux: section mismatch in reference: batadv_tp_send+0x4f4 (section: .text.batadv_tp_send) -> anx7625_driver_exit (section: .exit.text)
WARNING: modpost: vmlinux: section mismatch in reference: _batadv_is_ap_isolated.isra.13+0x16 (section: .text._batadv_is_ap_isolated.isra.13) -> anx78xx_driver_exit (section: .exit.text)
WARNING: modpost: vmlinux: section mismatch in reference: _batadv_is_ap_isolated.isra.13+0x1e (section: .text._batadv_is_ap_isolated.isra.13) -> anx78xx_driver_exit (section: .exit.text)
WARNING: modpost: vmlinux: section mismatch in reference: batadv_tt_local_purge+0x32 (section: .text.batadv_tt_local_purge) -> anx7625_driver_exit (section: .exit.text)
WARNING: modpost: vmlinux: section mismatch in reference: batadv_tt_local_entry_release+0x2e (section: .text.batadv_tt_local_entry_release) -> anx78xx_driver_init (section: .init.text)
WARNING: modpost: vmlinux: section mismatch in reference: batadv_tt_local_table_free.isra.23+0x90 (section: .text.batadv_tt_local_table_free.isra.23) -> anx78xx_driver_exit (section: .exit.text)
WARNING: modpost: vmlinux: section mismatch in reference: batadv_tt_local_table_transmit_size+0xa0 (section: .text.batadv_tt_local_table_transmit_size) -> anx78xx_driver_init (section: .init.text)
WARNING: modpost: vmlinux: section mismatch in reference: batadv_tt_local_table_transmit_size+0x132 (section: .text.batadv_tt_local_table_transmit_size) -> anx78xx_driver_init (section: .init.text)
WARNING: modpost: vmlinux: section mismatch in reference: batadv_tt_local_table_transmit_size+0x13c (section: .text.batadv_tt_local_table_transmit_size) -> anx78xx_driver_init (section: .init.text)
WARNING: modpost: vmlinux: section mismatch in reference: batadv_tt_local_table_transmit_size+0x162 (section: .text.batadv_tt_local_table_transmit_size) -> anx78xx_driver_init (section: .init.text)
WARNING: modpost: vmlinux: section mismatch in reference: batadv_tt_local_table_transmit_size+0x18c (section: .text.batadv_tt_local_table_transmit_size) -> anx78xx_driver_init (section: .init.text)
WARNING: modpost: vmlinux: section mismatch in reference: batadv_tt_global_orig_entry_find+0x1a (section: .text.batadv_tt_global_orig_entry_find) -> anx78xx_driver_exit (section: .exit.text)
WARNING: modpost: vmlinux: section mismatch in reference: memparse+0x2e (section: .text.memparse) -> __platform_driver_probe (section: .init.text)
WARNING: modpost: vmlinux: section mismatch in reference: memparse+0x36 (section: .text.memparse) -> __platform_create_bundle (section: .init.text)
WARNING: modpost: vmlinux: section mismatch in reference: mte_dead_leaves+0x30 (section: .text.mte_dead_leaves) -> cacheinfo_sysfs_init (section: .init.text)
WARNING: modpost: vmlinux: section mismatch in reference: mas_empty_area_rev+0x5e (section: .text.mas_empty_area_rev) -> cacheinfo_sysfs_init (section: .init.text)
WARNING: modpost: vmlinux: section mismatch in reference: mas_empty_area_rev+0x6c (section: .text.mas_empty_area_rev) -> cacheinfo_sysfs_init (section: .init.text)
WARNING: modpost: vmlinux: section mismatch in reference: mas_empty_area_rev+0x9a (section: .text.mas_empty_area_rev) -> cacheinfo_sysfs_init (section: .init.text)
WARNING: modpost: vmlinux: section mismatch in reference: mas_empty_area_rev+0x9e (section: .text.mas_empty_area_rev) -> cacheinfo_sysfs_init (section: .init.text)
WARNING: modpost: vmlinux: section mismatch in reference: mas_empty_area_rev+0xa8 (section: .text.mas_empty_area_rev) -> software_node_init (section: .init.text)
WARNING: modpost: vmlinux: section mismatch in reference: mas_empty_area_rev+0xb2 (section: .text.mas_empty_area_rev) -> software_node_init (section: .init.text)
WARNING: modpost: vmlinux: section mismatch in reference: mac_address_string+0x2c (section: .text.mac_address_string) -> wakeup_sources_debugfs_init (section: .init.text)
WARNING: modpost: vmlinux: section mismatch in reference: mac_address_string+0x36 (section: .text.mac_address_string) -> wakeup_sources_debugfs_init (section: .init.text)
WARNING: modpost: vmlinux: section mismatch in reference: mac_address_string+0x3e (section: .text.mac_address_string) -> wakeup_sources_debugfs_init (section: .init.text)
WARNING: modpost: vmlinux: section mismatch in reference: mac_address_string+0x62 (section: .text.mac_address_string) -> wakeup_sources_sysfs_init (section: .init.text)
WARNING: modpost: vmlinux: section mismatch in reference: mac_address_string+0x82 (section: .text.mac_address_string) -> wakeup_sources_sysfs_init (section: .init.text)
WARNING: modpost: vmlinux: section mismatch in reference: mac_address_string+0x8a (section: .text.mac_address_string) -> wakeup_sources_sysfs_init (section: .init.text)
WARNING: modpost: vmlinux: section mismatch in reference: mac_address_string+0xb0 (section: .text.mac_address_string) -> wakeup_sources_sysfs_init (section: .init.text)
WARNING: modpost: vmlinux: section mismatch in reference: mac_address_string+0x100 (section: .text.mac_address_string) -> wakeup_sources_sysfs_init (section: .init.text)
WARNING: modpost: vmlinux: section mismatch in reference: 0x15a8 (section: __ex_table) -> dfs_dir_mtd (section: .bss.dfs_dir_mtd)
>> ERROR: modpost: __ex_table+0x15a8 references non-executable section '.bss.dfs_dir_mtd'
WARNING: modpost: vmlinux: section mismatch in reference: 0x15ac (section: __ex_table) -> mtd_expert_analysis_mode (section: .bss.mtd_expert_analysis_mode)
>> ERROR: modpost: __ex_table+0x15ac references non-executable section '.bss.mtd_expert_analysis_mode'
WARNING: modpost: vmlinux: section mismatch in reference: 0x15b4 (section: __ex_table) -> mtdparts (section: .bss.mtdparts)
>> ERROR: modpost: __ex_table+0x15b4 references non-executable section '.bss.mtdparts'
WARNING: modpost: vmlinux: section mismatch in reference: 0x15b8 (section: __ex_table) -> __key (section: .bss.__key.50450)
ERROR: modpost: __ex_table+0x15b8 references non-executable section '.bss.__key.50450'
WARNING: modpost: vmlinux: section mismatch in reference: 0x15c0 (section: __ex_table) -> __key (section: .bss.__key.50467)
ERROR: modpost: __ex_table+0x15c0 references non-executable section '.bss.__key.50467'
WARNING: modpost: vmlinux: section mismatch in reference: 0x15c4 (section: __ex_table) -> block_size (section: .bss.block_size)
>> ERROR: modpost: __ex_table+0x15c4 references non-executable section '.bss.block_size'
WARNING: modpost: vmlinux: section mismatch in reference: 0x15cc (section: __ex_table) -> __key (section: .bss.__key.47363)
ERROR: modpost: __ex_table+0x15cc references non-executable section '.bss.__key.47363'
WARNING: modpost: vmlinux: section mismatch in reference: 0x15d0 (section: __ex_table) -> block_size (section: .bss.block_size)
ERROR: modpost: __ex_table+0x15d0 references non-executable section '.bss.block_size'
WARNING: modpost: vmlinux: section mismatch in reference: 0x15d8 (section: __ex_table) -> header (section: .bss.header)
>> ERROR: modpost: __ex_table+0x15d8 references non-executable section '.bss.header'
WARNING: modpost: vmlinux: section mismatch in reference: 0x15dc (section: __ex_table) -> block_size (section: .bss.block_size)
ERROR: modpost: __ex_table+0x15dc references non-executable section '.bss.block_size'
WARNING: modpost: vmlinux: section mismatch in reference: 0x15e4 (section: __ex_table) -> .LASF4221 (section: .debug_str)
ERROR: modpost: __ex_table+0x15e4 references non-executable section '.debug_str'
WARNING: modpost: vmlinux: section mismatch in reference: 0x15e8 (section: __ex_table) -> .LASF4223 (section: .debug_str)
ERROR: modpost: __ex_table+0x15e8 references non-executable section '.debug_str'
WARNING: modpost: vmlinux: section mismatch in reference: 0x15f0 (section: __ex_table) -> .LASF4225 (section: .debug_str)
ERROR: modpost: __ex_table+0x15f0 references non-executable section '.debug_str'
WARNING: modpost: vmlinux: section mismatch in reference: 0x15f4 (section: __ex_table) -> .LASF4227 (section: .debug_str)
ERROR: modpost: __ex_table+0x15f4 references non-executable section '.debug_str'
WARNING: modpost: vmlinux: section mismatch in reference: 0x15fc (section: __ex_table) -> .LASF4229 (section: .debug_str)
ERROR: modpost: __ex_table+0x15fc references non-executable section '.debug_str'
WARNING: modpost: vmlinux: section mismatch in reference: 0x1600 (section: __ex_table) -> .LASF4227 (section: .debug_str)
ERROR: modpost: __ex_table+0x1600 references non-executable section '.debug_str'
WARNING: modpost: vmlinux: section mismatch in reference: 0x1608 (section: __ex_table) -> .LASF4232 (section: .debug_str)
ERROR: modpost: __ex_table+0x1608 references non-executable section '.debug_str'
WARNING: modpost: vmlinux: section mismatch in reference: 0x160c (section: __ex_table) -> .LASF4227 (section: .debug_str)
ERROR: modpost: __ex_table+0x160c references non-executable section '.debug_str'
WARNING: modpost: vmlinux: section mismatch in reference: 0x1614 (section: __ex_table) -> .LASF4235 (section: .debug_str)
ERROR: modpost: __ex_table+0x1614 references non-executable section '.debug_str'
WARNING: modpost: vmlinux: section mismatch in reference: 0x1618 (section: __ex_table) -> .LASF4237 (section: .debug_str)
ERROR: modpost: __ex_table+0x1618 references non-executable section '.debug_str'
WARNING: modpost: vmlinux: section mismatch in reference: 0x1620 (section: __ex_table) -> .LASF4239 (section: .debug_str)
ERROR: modpost: __ex_table+0x1620 references non-executable section '.debug_str'
WARNING: modpost: vmlinux: section mismatch in reference: 0x1624 (section: __ex_table) -> .LASF4241 (section: .debug_str)
ERROR: modpost: __ex_table+0x1624 references non-executable section '.debug_str'
WARNING: modpost: vmlinux: section mismatch in reference: 0x162c (section: __ex_table) -> .LASF4243 (section: .debug_str)
ERROR: modpost: __ex_table+0x162c references non-executable section '.debug_str'
WARNING: modpost: vmlinux: section mismatch in reference: 0x1630 (section: __ex_table) -> .LASF4245 (section: .debug_str)
ERROR: modpost: __ex_table+0x1630 references non-executable section '.debug_str'
WARNING: modpost: vmlinux: section mismatch in reference: 0x1638 (section: __ex_table) -> .LASF4247 (section: .debug_str)
ERROR: modpost: __ex_table+0x1638 references non-executable section '.debug_str'
WARNING: modpost: vmlinux: section mismatch in reference: 0x163c (section: __ex_table) -> .LASF4249 (section: .debug_str)
ERROR: modpost: __ex_table+0x163c references non-executable section '.debug_str'
WARNING: modpost: vmlinux: section mismatch in reference: 0x1644 (section: __ex_table) -> .LASF4251 (section: .debug_str)
ERROR: modpost: __ex_table+0x1644 references non-executable section '.debug_str'
WARNING: modpost: vmlinux: section mismatch in reference: 0x1648 (section: __ex_table) -> .LASF4253 (section: .debug_str)
ERROR: modpost: __ex_table+0x1648 references non-executable section '.debug_str'
WARNING: modpost: vmlinux: section mismatch in reference: 0x1650 (section: __ex_table) -> .LASF4255 (section: .debug_str)
ERROR: modpost: __ex_table+0x1650 references non-executable section '.debug_str'
WARNING: modpost: vmlinux: section mismatch in reference: 0x1654 (section: __ex_table) -> .LASF4257 (section: .debug_str)
ERROR: modpost: __ex_table+0x1654 references non-executable section '.debug_str'
WARNING: modpost: vmlinux: section mismatch in reference: 0x165c (section: __ex_table) -> .LASF4259 (section: .debug_str)
ERROR: modpost: __ex_table+0x165c references non-executable section '.debug_str'
WARNING: modpost: vmlinux: section mismatch in reference: 0x1660 (section: __ex_table) -> .LASF4261 (section: .debug_str)
ERROR: modpost: __ex_table+0x1660 references non-executable section '.debug_str'
WARNING: modpost: vmlinux: section mismatch in reference: 0x1668 (section: __ex_table) -> .LASF2776 (section: .debug_str)
ERROR: modpost: __ex_table+0x1668 references non-executable section '.debug_str'
WARNING: modpost: vmlinux: section mismatch in reference: 0x166c (section: __ex_table) -> .LASF2778 (section: .debug_str)
ERROR: modpost: __ex_table+0x166c references non-executable section '.debug_str'
WARNING: modpost: vmlinux: section mismatch in reference: 0x1674 (section: __ex_table) -> .LASF2780 (section: .debug_str)
ERROR: modpost: __ex_table+0x1674 references non-executable section '.debug_str'
WARNING: modpost: vmlinux: section mismatch in reference: 0x1678 (section: __ex_table) -> .LASF2782 (section: .debug_str)
ERROR: modpost: __ex_table+0x1678 references non-executable section '.debug_str'
WARNING: modpost: vmlinux: section mismatch in reference: 0x1680 (section: __ex_table) -> .LASF2784 (section: .debug_str)
ERROR: modpost: __ex_table+0x1680 references non-executable section '.debug_str'
WARNING: modpost: vmlinux: section mismatch in reference: 0x1684 (section: __ex_table) -> .LASF2786 (section: .debug_str)
ERROR: modpost: __ex_table+0x1684 references non-executable section '.debug_str'
WARNING: modpost: vmlinux: section mismatch in reference: 0x168c (section: __ex_table) -> .LASF2788 (section: .debug_str)
ERROR: modpost: __ex_table+0x168c references non-executable section '.debug_str'
WARNING: modpost: vmlinux: section mismatch in reference: 0x1690 (section: __ex_table) -> .LASF2782 (section: .debug_str)
ERROR: modpost: __ex_table+0x1690 references non-executable section '.debug_str'
WARNING: modpost: vmlinux: section mismatch in reference: 0x1698 (section: __ex_table) -> .LASF2791 (section: .debug_str)
ERROR: modpost: __ex_table+0x1698 references non-executable section '.debug_str'
WARNING: modpost: vmlinux: section mismatch in reference: 0x169c (section: __ex_table) -> .LASF2782 (section: .debug_str)
ERROR: modpost: __ex_table+0x169c references non-executable section '.debug_str'
WARNING: modpost: vmlinux: section mismatch in reference: 0x16a4 (section: __ex_table) -> .LASF2794 (section: .debug_str)
ERROR: modpost: __ex_table+0x16a4 references non-executable section '.debug_str'
WARNING: modpost: vmlinux: section mismatch in reference: 0x16a8 (section: __ex_table) -> .LASF2796 (section: .debug_str)
ERROR: modpost: __ex_table+0x16a8 references non-executable section '.debug_str'
WARNING: modpost: vmlinux: section mismatch in reference: 0x16b0 (section: __ex_table) -> .LASF3022 (section: .debug_str)
ERROR: modpost: __ex_table+0x16b0 references non-executable section '.debug_str'
WARNING: modpost: vmlinux: section mismatch in reference: 0x16b4 (section: __ex_table) -> .LASF3024 (section: .debug_str)
ERROR: modpost: __ex_table+0x16b4 references non-executable section '.debug_str'
WARNING: modpost: vmlinux: section mismatch in reference: 0x16bc (section: __ex_table) -> .LASF3026 (section: .debug_str)
ERROR: modpost: __ex_table+0x16bc references non-executable section '.debug_str'
WARNING: modpost: vmlinux: section mismatch in reference: 0x16c0 (section: __ex_table) -> .LASF3028 (section: .debug_str)
ERROR: modpost: __ex_table+0x16c0 references non-executable section '.debug_str'
WARNING: modpost: vmlinux: section mismatch in reference: 0x17dc (section: __ex_table) -> .LASF3403 (section: .debug_str)
ERROR: modpost: __ex_table+0x17dc references non-executable section '.debug_str'
WARNING: modpost: vmlinux: section mismatch in reference: 0x17e0 (section: __ex_table) -> .LASF3405 (section: .debug_str)
ERROR: modpost: __ex_table+0x17e0 references non-executable section '.debug_str'
WARNING: modpost: vmlinux: section mismatch in reference: 0x17e8 (section: __ex_table) -> .LASF4606 (section: .debug_str)
ERROR: modpost: __ex_table+0x17e8 references non-executable section '.debug_str'
WARNING: modpost: vmlinux: section mismatch in reference: 0x17ec (section: __ex_table) -> .LASF4608 (section: .debug_str)
ERROR: modpost: __ex_table+0x17ec references non-executable section '.debug_str'
WARNING: modpost: vmlinux: section mismatch in reference: 0x18fc (section: __ex_table) -> .LASF176 (section: .debug_str)
ERROR: modpost: __ex_table+0x18fc references non-executable section '.debug_str'
WARNING: modpost: vmlinux: section mismatch in reference: 0x1900 (section: __ex_table) -> .LASF178 (section: .debug_str)
ERROR: modpost: __ex_table+0x1900 references non-executable section '.debug_str'
WARNING: modpost: vmlinux: section mismatch in reference: 0x1908 (section: __ex_table) -> .LASF180 (section: .debug_str)
ERROR: modpost: __ex_table+0x1908 references non-executable section '.debug_str'
WARNING: modpost: vmlinux: section mismatch in reference: 0x190c (section: __ex_table) -> .LASF182 (section: .debug_str)
ERROR: modpost: __ex_table+0x190c references non-executable section '.debug_str'
WARNING: modpost: vmlinux: section mismatch in reference: 0x1914 (section: __ex_table) -> .LASF184 (section: .debug_str)
ERROR: modpost: __ex_table+0x1914 references non-executable section '.debug_str'
WARNING: modpost: vmlinux: section mismatch in reference: 0x1918 (section: __ex_table) -> .LASF186 (section: .debug_str)
ERROR: modpost: __ex_table+0x1918 references non-executable section '.debug_str'
WARNING: modpost: vmlinux: section mismatch in reference: 0x1920 (section: __ex_table) -> .LASF188 (section: .debug_str)
ERROR: modpost: __ex_table+0x1920 references non-executable section '.debug_str'

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki
