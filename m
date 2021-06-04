Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.2 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,
	SPF_HELO_NONE,SPF_PASS,UPPERCASE_50_75,URIBL_BLOCKED,USER_AGENT_SANE_1
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 96E14C47096
	for <netfilter-devel@archiver.kernel.org>; Fri,  4 Jun 2021 02:44:49 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 4761961406
	for <netfilter-devel@archiver.kernel.org>; Fri,  4 Jun 2021 02:44:49 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229718AbhFDCqd (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 3 Jun 2021 22:46:33 -0400
Received: from mga09.intel.com ([134.134.136.24]:9952 "EHLO mga09.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229695AbhFDCqc (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 3 Jun 2021 22:46:32 -0400
IronPort-SDR: NFBQDS26z89Stk/pFvW3JUB/h78A5dYfatVyA7Cvtod6024RKTyMMYHhZPLrtTA+Uoai4BhXa9
 7OrSEQUQTQJw==
X-IronPort-AV: E=McAfee;i="6200,9189,10004"; a="204189055"
X-IronPort-AV: E=Sophos;i="5.83,246,1616482800"; 
   d="xz'?yaml'?scan'208";a="204189055"
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Jun 2021 19:44:41 -0700
IronPort-SDR: gQYy5CkdGc4OR9cEwJee8PBAWVQ2xIt86W7ufveqgAh490ZU15UwUfARbZixn5dhmzcJRstdWi
 fTORPr/Vo2XA==
X-IronPort-AV: E=Sophos;i="5.83,246,1616482800"; 
   d="xz'?yaml'?scan'208";a="480475132"
Received: from xsang-optiplex-9020.sh.intel.com (HELO xsang-OptiPlex-9020) ([10.239.159.41])
  by orsmga001-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Jun 2021 19:44:36 -0700
Date:   Fri, 4 Jun 2021 11:00:57 +0800
From:   kernel test robot <oliver.sang@intel.com>
To:     Florian Westphal <fw@strlen.de>
Cc:     0day robot <lkp@intel.com>, LKML <linux-kernel@vger.kernel.org>,
        lkp@lists.01.org, netfilter-devel@vger.kernel.org,
        Florian Westphal <fw@strlen.de>
Subject: [netfilter]  a0aa657b74:
 WARNING:at_kernel/locking/lockdep.c:#lockdep_init_map_type
Message-ID: <20210604030057.GA2227@xsang-OptiPlex-9020>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="BOKacYhQ+x31HxR3"
Content-Disposition: inline
In-Reply-To: <20210601162136.19444-3-fw@strlen.de>
User-Agent: NeoMutt/20170113 (1.7.2)
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org


--BOKacYhQ+x31HxR3
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline



Greeting,

FYI, we noticed the following commit (built with gcc-9):

commit: a0aa657b74904f1ffff77eeb194591f99311e33f ("[PATCH nf-next 2/2] netfilter: add new hook nfnl subsystem")
url: https://github.com/0day-ci/linux/commits/Florian-Westphal/netfilter-new-hook-nfnl-subsystem/20210602-002351
base: https://git.kernel.org/cgit/linux/kernel/git/pablo/nf-next.git master

in testcase: kernel-selftests
version: kernel-selftests-x86_64-0d95472a-1_20210507
with following parameters:

	group: mptcp
	ucode: 0xe2

test-description: The kernel contains a set of "self tests" under the tools/testing/selftests/ directory. These are intended to be small unit tests to exercise individual code paths in the kernel.
test-url: https://www.kernel.org/doc/Documentation/kselftest.txt


on test machine: 4 threads Intel(R) Core(TM) i5-6500 CPU @ 3.20GHz with 32G memory

caused below changes (please refer to attached dmesg/kmsg for entire log/backtrace):



If you fix the issue, kindly add following tag
Reported-by: kernel test robot <oliver.sang@intel.com>


[   54.258402] # INFO: set ns3-60b8d5e0-vW4bi8 dev ns3eth2: ethtool -K  gro off
[   54.258406]
[   54.268410] # INFO: set ns4-60b8d5e0-vW4bi8 dev ns4eth3: ethtool -K  gro off
[   54.268414]
[   54.279358] # Created /tmp/tmp.MZihAkuxIV (size 3921948	/tmp/tmp.MZihAkuxIV) containing data sent by client
[   54.279361]
[   54.293013] # Created /tmp/tmp.uoehaNIVCu (size 851996	/tmp/tmp.uoehaNIVCu) containing data sent by server
[   54.293017]
[   54.305424] # New MPTCP socket can be blocked via sysctl		[ OK ]
[   54.305427]
[   54.314233] # setsockopt(..., TCP_ULP, "mptcp", ...) blocked	[ OK ]
[   54.314237]
[   54.323136] # INFO: validating network environment with pings
[   54.323141]
[   54.332447] # INFO: Using loss of 0.43% delay 19 ms reorder 96% 8% with delay 4ms on ns3eth4
[   54.332451]
[   54.487247] # ns1 MPTCP -> ns1 (10.0.1.1:10000      ) MPTCP	(duration    69ms) [ OK ]
[   54.487254]
[   54.686272] # ns1 MPTCP -> ns1 (10.0.1.1:10001      ) TCP  	(duration    28ms) [ OK ]
[   54.686278]
[   54.885654] # ns1 TCP   -> ns1 (10.0.1.1:10002      ) MPTCP	(duration    28ms) [ OK ]
[   54.885660]
[   55.127091] # ns1 MPTCP -> ns1 (dead:beef:1::1:10003) MPTCP	(duration    70ms) [ OK ]
[   55.127097]
[   55.327814] # ns1 MPTCP -> ns1 (dead:beef:1::1:10004) TCP  	(duration    28ms) [ OK ]
[   55.327820]
[   55.530772] # ns1 TCP   -> ns1 (dead:beef:1::1:10005) MPTCP	(duration    29ms) [ OK ]
[   55.530778]
[   55.804079] # ns1 MPTCP -> ns2 (10.0.1.2:10006      ) MPTCP	(duration    81ms) [ OK ]
[   55.804085]
[   56.042806] # ns1 MPTCP -> ns2 (dead:beef:1::2:10007) MPTCP	(duration    48ms) [ OK ]
[   56.042813]
[   56.275550] # ns1 MPTCP -> ns2 (10.0.2.1:10008      ) MPTCP	(duration    40ms) [ OK ]
[   56.275557]
[   56.513802] # ns1 MPTCP -> ns2 (dead:beef:2::1:10009) MPTCP	(duration    47ms) [ OK ]
[   56.513808]
[   56.971818] # ns1 MPTCP -> ns3 (10.0.2.2:10010      ) MPTCP	(duration   267ms) [ OK ]
[   56.971824]
[   58.905948] # ns1 MPTCP -> ns3 (dead:beef:2::2:10011) MPTCP	(duration  1741ms) [ OK ]
[   58.905955]
[   59.323511] # ns1 MPTCP -> ns3 (10.0.3.2:10012      ) MPTCP	(duration   226ms) [ OK ]
[   59.323518]
[   59.762516] # ns1 MPTCP -> ns3 (dead:beef:3::2:10013) MPTCP	(duration   247ms) [ OK ]
[   59.762522]
[   60.843205] # ns1 MPTCP -> ns4 (10.0.3.1:10014      ) MPTCP	(duration   889ms) [ OK ]
[   60.843225]
[   64.381839] # ns1 MPTCP -> ns4 (dead:beef:3::1:10015) MPTCP	(duration  3348ms) [ OK ]
[   64.381845]
[   64.614494] # ns2 MPTCP -> ns1 (10.0.1.1:10016      ) MPTCP	(duration    41ms) [ OK ]
[   64.614500]
[   64.852847] # ns2 MPTCP -> ns1 (dead:beef:1::1:10017) MPTCP	(duration    46ms) [ OK ]
[   64.852853]
[   65.291994] # ns2 MPTCP -> ns3 (10.0.2.2:10018      ) MPTCP	(duration   246ms) [ OK ]
[   65.292000]
[   65.731649] # ns2 MPTCP -> ns3 (dead:beef:2::2:10019) MPTCP	(duration   246ms) [ OK ]
[   65.731655]
[   66.134331] # ns2 MPTCP -> ns3 (10.0.3.2:10020      ) MPTCP	(duration   209ms) [ OK ]
[   66.134337]
[   66.572638] # ns2 MPTCP -> ns3 (dead:beef:3::2:10021) MPTCP	(duration   247ms) [ OK ]
[   66.572644]
[   69.018863] # ns2 MPTCP -> ns4 (10.0.3.1:10022      ) MPTCP	(duration  2255ms) [ OK ]
[   69.018869]
[   69.801739] # ns2 MPTCP -> ns4 (dead:beef:3::1:10023) MPTCP	(duration   589ms) [ OK ]
[   69.801745]
[   70.199272] # ns3 MPTCP -> ns1 (10.0.1.1:10024      ) MPTCP	(duration   207ms) [ OK ]
[   70.199278]
[   70.599096] # ns3 MPTCP -> ns1 (dead:beef:1::1:10025) MPTCP	(duration   207ms) [ OK ]
[   70.599102]
[   70.978578] # ns3 MPTCP -> ns2 (10.0.1.2:10026      ) MPTCP	(duration   189ms) [ OK ]
[   70.978584]
[   71.496008] # ns3 MPTCP -> ns2 (dead:beef:1::2:10027) MPTCP	(duration   326ms) [ OK ]
[   71.496014]
[   71.880635] # ns3 MPTCP -> ns2 (10.0.2.1:10028      ) MPTCP	(duration   189ms) [ OK ]
[   71.880642]
[   72.264354] # ns3 MPTCP -> ns2 (dead:beef:2::1:10029) MPTCP	(duration   189ms) [ OK ]
[   72.264360]
[   72.512803] # ns3 MPTCP -> ns4 (10.0.3.1:10030      ) MPTCP	(duration    54ms) [ OK ]
[   72.512809]
[   72.775083] # ns3 MPTCP -> ns4 (dead:beef:3::1:10031) MPTCP	(duration    69ms) [ OK ]
[   72.775089]
[   73.157866] # ns4 MPTCP -> ns1 (10.0.1.1:10032      ) MPTCP	(duration   190ms) [ OK ]
[   73.157872]
[   74.025532] # ns4 MPTCP -> ns1 (dead:beef:1::1:10033) MPTCP	(duration   670ms) [ OK ]
[   74.025539]
[   74.514672] # ns4 MPTCP -> ns2 (10.0.1.2:10034      ) MPTCP	(duration   297ms) [ OK ]
[   74.514679]
[   75.221338] # ns4 MPTCP -> ns2 (dead:beef:1::2:10035) MPTCP	(duration   514ms) [ OK ]
[   75.221345]
[   75.622396] # ns4 MPTCP -> ns2 (10.0.2.1:10036      ) MPTCP	(duration   209ms) [ OK ]
[   75.622402]
[   76.026816] # ns4 MPTCP -> ns2 (dead:beef:2::1:10037) MPTCP	(duration   211ms) [ OK ]
[   76.026822]
[   76.262848] # ns4 MPTCP -> ns3 (10.0.2.2:10038      ) MPTCP	(duration    43ms) [ OK ]
[   76.262854]
[   76.501989] # ns4 MPTCP -> ns3 (dead:beef:2::2:10039) MPTCP	(duration    49ms) [ OK ]
[   76.501995]
[   76.737026] # ns4 MPTCP -> ns3 (10.0.3.2:10040      ) MPTCP	(duration    44ms) [ OK ]
[   76.737032]
[   76.982968] # ns4 MPTCP -> ns3 (dead:beef:3::2:10041) MPTCP	(duration    50ms) [ OK ]
[   76.982974]
[   76.993431] # INFO: with peek mode: saveWithPeek
[   76.993435]
[   77.233278] # ns1 MPTCP -> ns1 (10.0.1.1:10042      ) MPTCP	(duration    68ms) [ OK ]
[   77.233284]
[   77.437650] # ns1 MPTCP -> ns1 (10.0.1.1:10043      ) TCP  	(duration    30ms) [ OK ]
[   77.437656]
[   77.640591] # ns1 TCP   -> ns1 (10.0.1.1:10044      ) MPTCP	(duration    29ms) [ OK ]
[   77.640597]
[   77.881944] # ns1 MPTCP -> ns1 (dead:beef:1::1:10045) MPTCP	(duration    68ms) [ OK ]
[   77.881950]
[   78.089406] # ns1 MPTCP -> ns1 (dead:beef:1::1:10046) TCP  	(duration    31ms) [ OK ]
[   78.089412]
[   78.293319] # ns1 TCP   -> ns1 (dead:beef:1::1:10047) MPTCP	(duration    28ms) [ OK ]
[   78.293325]
[   78.303574] # INFO: with peek mode: saveAfterPeek
[   78.303577]
[   78.538396] # ns1 MPTCP -> ns1 (10.0.1.1:10048      ) MPTCP	(duration    66ms) [ OK ]
[   78.538402]
[   78.742312] # ns1 MPTCP -> ns1 (10.0.1.1:10049      ) TCP  	(duration    31ms) [ OK ]
[   78.742318]
[   78.948698] # ns1 TCP   -> ns1 (10.0.1.1:10050      ) MPTCP	(duration    30ms) [ OK ]
[   78.948704]
[   79.191913] # ns1 MPTCP -> ns1 (dead:beef:1::1:10051) MPTCP	(duration    68ms) [ OK ]
[   79.191919]
[   79.396612] # ns1 MPTCP -> ns1 (dead:beef:1::1:10052) TCP  	(duration    30ms) [ OK ]
[   79.396618]
[   79.599150] # ns1 TCP   -> ns1 (dead:beef:1::1:10053) MPTCP	(duration    30ms) [ OK ]
[   79.599156]
[   79.608835] # Time: 29 seconds
[   79.608838]
[   79.659356] ok 1 selftests: net/mptcp: mptcp_connect.sh
[   79.659363]
[   79.677674] # selftests: net/mptcp: pm_netlink.sh
[   79.677679]
[   79.740387] # defaults addr list                                 [ OK ]
[   79.740393]
[   79.754668] # defaults limits                                    [ OK ]
[   79.754674]
[   79.789699] # simple add/get addr                                [ OK ]
[   79.789705]
[   79.803834] # dump addrs                                         [ OK ]
[   79.803840]
[   79.825668] # simple del addr                                    [ OK ]
[   79.825674]
[   79.839787] # dump addrs after del                               [ OK ]
[   79.839792]
[   79.861106] # duplicate addr                                     [ OK ]
[   79.861111]
[   79.882523] # id addr increment                                  [ OK ]
[   79.882528]
[   79.931474] # hard addr limit                                    [ OK ]
[   79.931480]
[   79.944650] # above hard addr limit                              [ OK ]
[   79.944655]
[   83.069154] # id limit                                           [ OK ]
[   83.069160]
[   83.089803] # flush addrs                                        [ OK ]
[   83.089808]
[   83.110585] # rcv addrs above hard limit                         [ OK ]
[   83.110590]
[   83.131493] # subflows above hard limit                          [ OK ]
[   83.131498]
[   83.151817] # set limits                                         [ OK ]
[   83.151822]
[   83.223174] # set ids                                            [ OK ]
[   83.223180]
[   83.294063] # wrap-around ids                                    [ OK ]
[   83.294069]
[   83.308822] ok 2 selftests: net/mptcp: pm_netlink.sh
[   83.308827]
[   83.326950] # selftests: net/mptcp: mptcp_join.sh
[   83.326955]
[   83.355329] ------------[ cut here ]------------
[   83.359909] DEBUG_LOCKS_WARN_ON(!name)
[   83.359913] WARNING: CPU: 0 PID: 4931 at kernel/locking/lockdep.c:4665 lockdep_init_map_type (kbuild/src/consumer/kernel/locking/lockdep.c:4665 (discriminator 9)) 
[   83.373072] Modules linked in: nfnetlink(+) btrfs blake2b_generic xor zstd_compress raid6_pq libcrc32c sd_mod intel_rapl_msr intel_rapl_common t10_pi sg x86_pkg_temp_thermal intel_powerclamp coretemp crct10dif_pclmul crc32_pclmul crc32c_intel ghash_clmulni_intel i915 ipmi_devintf ipmi_msghandler mei_wdt wmi_bmof ahci libahci rapl intel_cstate i2c_i801 intel_uncore libata i2c_smbus intel_pch_thermal mei_me mei wmi intel_gtt video intel_pmc_core acpi_pad ip_tables
[   83.413628] CPU: 0 PID: 4931 Comm: modprobe Not tainted 5.13.0-rc3-00737-ga0aa657b7490 #1
[   83.421755] Hardware name: Dell Inc. OptiPlex 7040/0Y7WYT, BIOS 1.8.1 12/05/2017
[   83.429102] RIP: 0010:lockdep_init_map_type (kbuild/src/consumer/kernel/locking/lockdep.c:4665 (discriminator 9)) 
[ 83.434317] Code: ff ff e8 9a 00 d6 00 85 c0 74 21 44 8b 1d f7 6a 4f 02 45 85 db 75 15 48 c7 c6 06 90 7d 82 48 c7 c7 88 7a 7b 82 e8 c8 b0 cf 00 <0f> 0b 48 c7 45 18 ec df 80 82 e9 15 ff ff ff e8 63 00 d6 00 85 c0
All code
========
   0:	ff                   	(bad)  
   1:	ff                   	(bad)  
   2:	e8 9a 00 d6 00       	callq  0xd600a1
   7:	85 c0                	test   %eax,%eax
   9:	74 21                	je     0x2c
   b:	44 8b 1d f7 6a 4f 02 	mov    0x24f6af7(%rip),%r11d        # 0x24f6b09
  12:	45 85 db             	test   %r11d,%r11d
  15:	75 15                	jne    0x2c
  17:	48 c7 c6 06 90 7d 82 	mov    $0xffffffff827d9006,%rsi
  1e:	48 c7 c7 88 7a 7b 82 	mov    $0xffffffff827b7a88,%rdi
  25:	e8 c8 b0 cf 00       	callq  0xcfb0f2
  2a:*	0f 0b                	ud2    		<-- trapping instruction
  2c:	48 c7 45 18 ec df 80 	movq   $0xffffffff8280dfec,0x18(%rbp)
  33:	82 
  34:	e9 15 ff ff ff       	jmpq   0xffffffffffffff4e
  39:	e8 63 00 d6 00       	callq  0xd600a1
  3e:	85 c0                	test   %eax,%eax

Code starting with the faulting instruction
===========================================
   0:	0f 0b                	ud2    
   2:	48 c7 45 18 ec df 80 	movq   $0xffffffff8280dfec,0x18(%rbp)
   9:	82 
   a:	e9 15 ff ff ff       	jmpq   0xffffffffffffff24
   f:	e8 63 00 d6 00       	callq  0xd60077
  14:	85 c0                	test   %eax,%eax
[   83.452896] RSP: 0018:ffffc90009befc68 EFLAGS: 00010286
[   83.458070] RAX: 0000000000000000 RBX: ffffffffc02efd00 RCX: 0000000000000000
[   83.465133] RDX: 0000000000000001 RSI: ffffffff8122fa0f RDI: ffffffff8122fa0f
[   83.472230] RBP: ffffffffc02efd68 R08: 0000000000000000 R09: 0000000000000000
[   83.479295] R10: 0000000000000001 R11: 0000000000000001 R12: ffffffffc02ef5c0
[   83.486372] R13: 0000000000000000 R14: 0000000000000000 R15: ffffffffc02ee0cc
[   83.493434] FS:  00007ff69dc4e480(0000) GS:ffff88881dc00000(0000) knlGS:0000000000000000
[   83.501457] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[   83.507160] CR2: 00007ff69dd43d00 CR3: 0000000812316004 CR4: 00000000003706f0
[   83.514238] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[   83.521314] DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
[   83.528376] Call Trace:
[   83.530802] debug_mutex_init (kbuild/src/consumer/kernel/locking/mutex-debug.c:90) 
[   83.534616] nfnetlink_init (kbuild/src/consumer/net/netfilter/nfnetlink.c:98) nfnetlink
[   83.539464]  ? 0xffffffffc01a8000
[   83.542761] do_one_initcall (kbuild/src/consumer/init/main.c:1249) 
[   83.546574] ? do_init_module (kbuild/src/consumer/kernel/module.c:3649) 
[   83.550473] ? kmem_cache_alloc_trace (kbuild/src/consumer/include/trace/events/kmem.h:46 kbuild/src/consumer/include/trace/events/kmem.h:46 kbuild/src/consumer/mm/slub.c:2939) 
[   83.555149] do_init_module (kbuild/src/consumer/kernel/module.c:3664) 
[   83.558879] load_module (kbuild/src/consumer/kernel/module.c:4064) 
[   83.562607] ? __kernel_read (kbuild/src/consumer/fs/read_write.c:454 (discriminator 1)) 
[   83.566496] ? __do_sys_finit_module (kbuild/src/consumer/kernel/module.c:4155) 
[   83.570997] __do_sys_finit_module (kbuild/src/consumer/kernel/module.c:4155) 
[   83.575329] do_syscall_64 (kbuild/src/consumer/arch/x86/entry/common.c:47) 
[   83.578872] entry_SYSCALL_64_after_hwframe (kbuild/src/consumer/arch/x86/entry/entry_64.S:112) 
[   83.583890] RIP: 0033:0x7ff69dd68f59
[ 83.587446] Code: 00 c3 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 44 00 00 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 8b 0d 07 6f 0c 00 f7 d8 64 89 01 48
All code
========
   0:	00 c3                	add    %al,%bl
   2:	66 2e 0f 1f 84 00 00 	nopw   %cs:0x0(%rax,%rax,1)
   9:	00 00 00 
   c:	0f 1f 44 00 00       	nopl   0x0(%rax,%rax,1)
  11:	48 89 f8             	mov    %rdi,%rax
  14:	48 89 f7             	mov    %rsi,%rdi
  17:	48 89 d6             	mov    %rdx,%rsi
  1a:	48 89 ca             	mov    %rcx,%rdx
  1d:	4d 89 c2             	mov    %r8,%r10
  20:	4d 89 c8             	mov    %r9,%r8
  23:	4c 8b 4c 24 08       	mov    0x8(%rsp),%r9
  28:	0f 05                	syscall 
  2a:*	48 3d 01 f0 ff ff    	cmp    $0xfffffffffffff001,%rax		<-- trapping instruction
  30:	73 01                	jae    0x33
  32:	c3                   	retq   
  33:	48 8b 0d 07 6f 0c 00 	mov    0xc6f07(%rip),%rcx        # 0xc6f41
  3a:	f7 d8                	neg    %eax
  3c:	64 89 01             	mov    %eax,%fs:(%rcx)
  3f:	48                   	rex.W

Code starting with the faulting instruction
===========================================
   0:	48 3d 01 f0 ff ff    	cmp    $0xfffffffffffff001,%rax
   6:	73 01                	jae    0x9
   8:	c3                   	retq   
   9:	48 8b 0d 07 6f 0c 00 	mov    0xc6f07(%rip),%rcx        # 0xc6f17
  10:	f7 d8                	neg    %eax
  12:	64 89 01             	mov    %eax,%fs:(%rcx)
  15:	48                   	rex.W
[   83.606022] RSP: 002b:00007ffee0b699f8 EFLAGS: 00000246 ORIG_RAX: 0000000000000139
[   83.613533] RAX: ffffffffffffffda RBX: 000055db753fefe0 RCX: 00007ff69dd68f59
[   83.620610] RDX: 0000000000000000 RSI: 000055db73e673f0 RDI: 0000000000000000
[   83.627674] RBP: 000055db73e673f0 R08: 0000000000000000 R09: 000055db75400840
[   83.634739] R10: 0000000000000000 R11: 0000000000000246 R12: 0000000000000000
[   83.641803] R13: 000055db753ff1e0 R14: 0000000000040000 R15: 000055db753fefe0
[   83.648881] irq event stamp: 13915
[   83.652267] hardirqs last enabled at (13915): kfree (kbuild/src/consumer/arch/x86/include/asm/irqflags.h:45 kbuild/src/consumer/arch/x86/include/asm/irqflags.h:80 kbuild/src/consumer/arch/x86/include/asm/irqflags.h:140 kbuild/src/consumer/mm/slub.c:1553 kbuild/src/consumer/mm/slub.c:1607 kbuild/src/consumer/mm/slub.c:3167 kbuild/src/consumer/mm/slub.c:4217) 
[   83.660048] hardirqs last disabled at (13914): kfree (kbuild/src/consumer/mm/slub.c:1552 kbuild/src/consumer/mm/slub.c:1607 kbuild/src/consumer/mm/slub.c:3167 kbuild/src/consumer/mm/slub.c:4217) 
[   83.667829] softirqs last enabled at (13524): __do_softirq (kbuild/src/consumer/arch/x86/include/asm/preempt.h:27 kbuild/src/consumer/kernel/softirq.c:403 kbuild/src/consumer/kernel/softirq.c:588) 
[   83.676200] softirqs last disabled at (13515): irq_exit_rcu (kbuild/src/consumer/kernel/softirq.c:433 kbuild/src/consumer/kernel/softirq.c:637 kbuild/src/consumer/kernel/softirq.c:649) 
[   83.684570] ---[ end trace 1fde30da01da819d ]---
[   83.803196] IPv6: ADDRCONF(NETDEV_CHANGE): ns1eth1: link becomes ready
[   83.822293] IPv6: ADDRCONF(NETDEV_CHANGE): ns1eth2: link becomes ready
[   83.842134] IPv6: ADDRCONF(NETDEV_CHANGE): ns1eth3: link becomes ready
[   83.861286] IPv6: ADDRCONF(NETDEV_CHANGE): ns1eth4: link becomes ready
[   83.872973] # Created /tmp/tmp.VfxfwYPDnG (size 1 KB) containing data sent by client
[   83.872977]
[   83.883980] # Created /tmp/tmp.hlfBNtDvU9 (size 1 KB) containing data sent by server
[   83.883983]
[   83.940371] IPv6: ADDRCONF(NETDEV_CHANGE): ns1eth1: link becomes ready
[   83.959883] IPv6: ADDRCONF(NETDEV_CHANGE): ns1eth2: link becomes ready
[   83.979383] IPv6: ADDRCONF(NETDEV_CHANGE): ns1eth3: link becomes ready
[   83.998852] IPv6: ADDRCONF(NETDEV_CHANGE): ns1eth4: link becomes ready
[   86.045398] # 01 no JOIN                              syn[ ok ] - synack[ ok ] - ack[ ok ]
[   86.045402]
[   86.105724] IPv6: ADDRCONF(NETDEV_CHANGE): ns1eth1: link becomes ready
[   86.125818] IPv6: ADDRCONF(NETDEV_CHANGE): ns1eth2: link becomes ready
[   86.146001] IPv6: ADDRCONF(NETDEV_CHANGE): ns1eth3: link becomes ready
[   86.166235] IPv6: ADDRCONF(NETDEV_CHANGE): ns1eth4: link becomes ready
[   87.097237] IPv6: ADDRCONF(NETDEV_CHANGE): ns2eth1: link becomes ready
[   88.214868] # 02 single subflow, limited by client    syn[ ok ] - synack[ ok ] - ack[ ok ]
[   88.214872]
[   88.275442] IPv6: ADDRCONF(NETDEV_CHANGE): ns1eth1: link becomes ready
[   88.295112] IPv6: ADDRCONF(NETDEV_CHANGE): ns1eth2: link becomes ready
[   88.314873] IPv6: ADDRCONF(NETDEV_CHANGE): ns1eth3: link becomes ready
[   88.335157] IPv6: ADDRCONF(NETDEV_CHANGE): ns1eth4: link becomes ready
[   89.273243] IPv6: ADDRCONF(NETDEV_CHANGE): ns2eth1: link becomes ready
[   90.386044] # 03 single subflow, limited by server    syn[ ok ] - synack[ ok ] - ack[ ok ]
[   90.386048]
[   90.446936] IPv6: ADDRCONF(NETDEV_CHANGE): ns1eth1: link becomes ready
[   90.466365] IPv6: ADDRCONF(NETDEV_CHANGE): ns1eth2: link becomes ready
[   90.485943] IPv6: ADDRCONF(NETDEV_CHANGE): ns1eth3: link becomes ready
[   90.506385] IPv6: ADDRCONF(NETDEV_CHANGE): ns1eth4: link becomes ready
[   91.449197] IPv6: ADDRCONF(NETDEV_CHANGE): ns2eth1: link becomes ready
[   92.560066] # 04 single subflow                       syn[ ok ] - synack[ ok ] - ack[ ok ]
[   92.560071]
[   92.620724] IPv6: ADDRCONF(NETDEV_CHANGE): ns1eth1: link becomes ready
[   92.641102] IPv6: ADDRCONF(NETDEV_CHANGE): ns1eth2: link becomes ready
[   92.660982] IPv6: ADDRCONF(NETDEV_CHANGE): ns1eth3: link becomes ready
[   92.681101] IPv6: ADDRCONF(NETDEV_CHANGE): ns1eth4: link becomes ready
[   93.625217] IPv6: ADDRCONF(NETDEV_CHANGE): ns2eth1: link becomes ready
[   94.736875] # 05 multiple subflows                    syn[ ok ] - synack[ ok ] - ack[ ok ]
[   94.736880]
[   94.796968] IPv6: ADDRCONF(NETDEV_CHANGE): ns1eth1: link becomes ready
[   94.817036] IPv6: ADDRCONF(NETDEV_CHANGE): ns1eth2: link becomes ready
[   94.836692] IPv6: ADDRCONF(NETDEV_CHANGE): ns1eth3: link becomes ready
[   94.857253] IPv6: ADDRCONF(NETDEV_CHANGE): ns1eth4: link becomes ready
[   95.801243] IPv6: ADDRCONF(NETDEV_CHANGE): ns2eth1: link becomes ready


To reproduce:

        git clone https://github.com/intel/lkp-tests.git
        cd lkp-tests
        bin/lkp install                job.yaml  # job file is attached in this email
        bin/lkp split-job --compatible job.yaml  # generate the yaml file for lkp run
        bin/lkp run                    generated-yaml-file



---
0DAY/LKP+ Test Infrastructure                   Open Source Technology Center
https://lists.01.org/hyperkitty/list/lkp@lists.01.org       Intel Corporation

Thanks,
Oliver Sang


--BOKacYhQ+x31HxR3
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename="config-5.13.0-rc3-00737-ga0aa657b7490"

#
# Automatically generated file; DO NOT EDIT.
# Linux/x86_64 5.13.0-rc3 Kernel Configuration
#
CONFIG_CC_VERSION_TEXT="gcc-9 (Debian 9.3.0-22) 9.3.0"
CONFIG_CC_IS_GCC=y
CONFIG_GCC_VERSION=90300
CONFIG_CLANG_VERSION=0
CONFIG_AS_IS_GNU=y
CONFIG_AS_VERSION=23502
CONFIG_LD_IS_BFD=y
CONFIG_LD_VERSION=23502
CONFIG_LLD_VERSION=0
CONFIG_CC_CAN_LINK=y
CONFIG_CC_CAN_LINK_STATIC=y
CONFIG_CC_HAS_ASM_GOTO=y
CONFIG_CC_HAS_ASM_INLINE=y
CONFIG_IRQ_WORK=y
CONFIG_BUILDTIME_TABLE_SORT=y
CONFIG_THREAD_INFO_IN_TASK=y

#
# General setup
#
CONFIG_INIT_ENV_ARG_LIMIT=32
# CONFIG_COMPILE_TEST is not set
CONFIG_LOCALVERSION=""
CONFIG_LOCALVERSION_AUTO=y
CONFIG_BUILD_SALT=""
CONFIG_HAVE_KERNEL_GZIP=y
CONFIG_HAVE_KERNEL_BZIP2=y
CONFIG_HAVE_KERNEL_LZMA=y
CONFIG_HAVE_KERNEL_XZ=y
CONFIG_HAVE_KERNEL_LZO=y
CONFIG_HAVE_KERNEL_LZ4=y
CONFIG_HAVE_KERNEL_ZSTD=y
CONFIG_KERNEL_GZIP=y
# CONFIG_KERNEL_BZIP2 is not set
# CONFIG_KERNEL_LZMA is not set
# CONFIG_KERNEL_XZ is not set
# CONFIG_KERNEL_LZO is not set
# CONFIG_KERNEL_LZ4 is not set
# CONFIG_KERNEL_ZSTD is not set
CONFIG_DEFAULT_INIT=""
CONFIG_DEFAULT_HOSTNAME="(none)"
CONFIG_SWAP=y
CONFIG_SYSVIPC=y
CONFIG_SYSVIPC_SYSCTL=y
CONFIG_POSIX_MQUEUE=y
CONFIG_POSIX_MQUEUE_SYSCTL=y
# CONFIG_WATCH_QUEUE is not set
CONFIG_CROSS_MEMORY_ATTACH=y
# CONFIG_USELIB is not set
CONFIG_AUDIT=y
CONFIG_HAVE_ARCH_AUDITSYSCALL=y
CONFIG_AUDITSYSCALL=y

#
# IRQ subsystem
#
CONFIG_GENERIC_IRQ_PROBE=y
CONFIG_GENERIC_IRQ_SHOW=y
CONFIG_GENERIC_IRQ_EFFECTIVE_AFF_MASK=y
CONFIG_GENERIC_PENDING_IRQ=y
CONFIG_GENERIC_IRQ_MIGRATION=y
CONFIG_GENERIC_IRQ_INJECTION=y
CONFIG_HARDIRQS_SW_RESEND=y
CONFIG_IRQ_DOMAIN=y
CONFIG_IRQ_SIM=y
CONFIG_IRQ_DOMAIN_HIERARCHY=y
CONFIG_GENERIC_MSI_IRQ=y
CONFIG_GENERIC_MSI_IRQ_DOMAIN=y
CONFIG_IRQ_MSI_IOMMU=y
CONFIG_GENERIC_IRQ_MATRIX_ALLOCATOR=y
CONFIG_GENERIC_IRQ_RESERVATION_MODE=y
CONFIG_IRQ_FORCED_THREADING=y
CONFIG_SPARSE_IRQ=y
# CONFIG_GENERIC_IRQ_DEBUGFS is not set
# end of IRQ subsystem

CONFIG_CLOCKSOURCE_WATCHDOG=y
CONFIG_ARCH_CLOCKSOURCE_INIT=y
CONFIG_CLOCKSOURCE_VALIDATE_LAST_CYCLE=y
CONFIG_GENERIC_TIME_VSYSCALL=y
CONFIG_GENERIC_CLOCKEVENTS=y
CONFIG_GENERIC_CLOCKEVENTS_BROADCAST=y
CONFIG_GENERIC_CLOCKEVENTS_MIN_ADJUST=y
CONFIG_GENERIC_CMOS_UPDATE=y
CONFIG_HAVE_POSIX_CPU_TIMERS_TASK_WORK=y
CONFIG_POSIX_CPU_TIMERS_TASK_WORK=y

#
# Timers subsystem
#
CONFIG_TICK_ONESHOT=y
CONFIG_NO_HZ_COMMON=y
# CONFIG_HZ_PERIODIC is not set
# CONFIG_NO_HZ_IDLE is not set
CONFIG_NO_HZ_FULL=y
CONFIG_CONTEXT_TRACKING=y
# CONFIG_CONTEXT_TRACKING_FORCE is not set
CONFIG_NO_HZ=y
CONFIG_HIGH_RES_TIMERS=y
# end of Timers subsystem

CONFIG_BPF=y
CONFIG_HAVE_EBPF_JIT=y
CONFIG_ARCH_WANT_DEFAULT_BPF_JIT=y

#
# BPF subsystem
#
CONFIG_BPF_SYSCALL=y
CONFIG_BPF_JIT=y
CONFIG_BPF_JIT_ALWAYS_ON=y
CONFIG_BPF_JIT_DEFAULT_ON=y
# CONFIG_BPF_UNPRIV_DEFAULT_OFF is not set
# CONFIG_BPF_PRELOAD is not set
# CONFIG_BPF_LSM is not set
# end of BPF subsystem

# CONFIG_PREEMPT_NONE is not set
# CONFIG_PREEMPT_VOLUNTARY is not set
CONFIG_PREEMPT=y
CONFIG_PREEMPT_COUNT=y
CONFIG_PREEMPTION=y
CONFIG_PREEMPT_DYNAMIC=y

#
# CPU/Task time and stats accounting
#
CONFIG_VIRT_CPU_ACCOUNTING=y
CONFIG_VIRT_CPU_ACCOUNTING_GEN=y
CONFIG_IRQ_TIME_ACCOUNTING=y
CONFIG_HAVE_SCHED_AVG_IRQ=y
CONFIG_BSD_PROCESS_ACCT=y
CONFIG_BSD_PROCESS_ACCT_V3=y
CONFIG_TASKSTATS=y
CONFIG_TASK_DELAY_ACCT=y
CONFIG_TASK_XACCT=y
CONFIG_TASK_IO_ACCOUNTING=y
# CONFIG_PSI is not set
# end of CPU/Task time and stats accounting

CONFIG_CPU_ISOLATION=y

#
# RCU Subsystem
#
CONFIG_TREE_RCU=y
CONFIG_PREEMPT_RCU=y
# CONFIG_RCU_EXPERT is not set
CONFIG_SRCU=y
CONFIG_TREE_SRCU=y
CONFIG_TASKS_RCU_GENERIC=y
CONFIG_TASKS_RCU=y
CONFIG_TASKS_RUDE_RCU=y
CONFIG_TASKS_TRACE_RCU=y
CONFIG_RCU_STALL_COMMON=y
CONFIG_RCU_NEED_SEGCBLIST=y
CONFIG_RCU_NOCB_CPU=y
# end of RCU Subsystem

CONFIG_BUILD_BIN2C=y
CONFIG_IKCONFIG=y
CONFIG_IKCONFIG_PROC=y
# CONFIG_IKHEADERS is not set
CONFIG_LOG_BUF_SHIFT=20
CONFIG_LOG_CPU_MAX_BUF_SHIFT=12
CONFIG_PRINTK_SAFE_LOG_BUF_SHIFT=13
CONFIG_HAVE_UNSTABLE_SCHED_CLOCK=y

#
# Scheduler features
#
# CONFIG_UCLAMP_TASK is not set
# end of Scheduler features

CONFIG_ARCH_SUPPORTS_NUMA_BALANCING=y
CONFIG_ARCH_WANT_BATCHED_UNMAP_TLB_FLUSH=y
CONFIG_CC_HAS_INT128=y
CONFIG_ARCH_SUPPORTS_INT128=y
CONFIG_NUMA_BALANCING=y
CONFIG_NUMA_BALANCING_DEFAULT_ENABLED=y
CONFIG_CGROUPS=y
CONFIG_PAGE_COUNTER=y
CONFIG_MEMCG=y
CONFIG_MEMCG_SWAP=y
CONFIG_MEMCG_KMEM=y
CONFIG_BLK_CGROUP=y
CONFIG_CGROUP_WRITEBACK=y
CONFIG_CGROUP_SCHED=y
CONFIG_FAIR_GROUP_SCHED=y
CONFIG_CFS_BANDWIDTH=y
CONFIG_RT_GROUP_SCHED=y
CONFIG_CGROUP_PIDS=y
CONFIG_CGROUP_RDMA=y
CONFIG_CGROUP_FREEZER=y
CONFIG_CGROUP_HUGETLB=y
CONFIG_CPUSETS=y
CONFIG_PROC_PID_CPUSET=y
CONFIG_CGROUP_DEVICE=y
CONFIG_CGROUP_CPUACCT=y
CONFIG_CGROUP_PERF=y
CONFIG_CGROUP_BPF=y
# CONFIG_CGROUP_MISC is not set
# CONFIG_CGROUP_DEBUG is not set
CONFIG_SOCK_CGROUP_DATA=y
CONFIG_NAMESPACES=y
CONFIG_UTS_NS=y
CONFIG_TIME_NS=y
CONFIG_IPC_NS=y
CONFIG_USER_NS=y
CONFIG_PID_NS=y
CONFIG_NET_NS=y
CONFIG_CHECKPOINT_RESTORE=y
CONFIG_SCHED_AUTOGROUP=y
# CONFIG_SYSFS_DEPRECATED is not set
CONFIG_RELAY=y
CONFIG_BLK_DEV_INITRD=y
CONFIG_INITRAMFS_SOURCE=""
CONFIG_RD_GZIP=y
CONFIG_RD_BZIP2=y
CONFIG_RD_LZMA=y
CONFIG_RD_XZ=y
CONFIG_RD_LZO=y
CONFIG_RD_LZ4=y
CONFIG_RD_ZSTD=y
# CONFIG_BOOT_CONFIG is not set
CONFIG_CC_OPTIMIZE_FOR_PERFORMANCE=y
# CONFIG_CC_OPTIMIZE_FOR_SIZE is not set
CONFIG_LD_ORPHAN_WARN=y
CONFIG_SYSCTL=y
CONFIG_HAVE_UID16=y
CONFIG_SYSCTL_EXCEPTION_TRACE=y
CONFIG_HAVE_PCSPKR_PLATFORM=y
CONFIG_EXPERT=y
CONFIG_UID16=y
CONFIG_MULTIUSER=y
CONFIG_SGETMASK_SYSCALL=y
CONFIG_SYSFS_SYSCALL=y
CONFIG_FHANDLE=y
CONFIG_POSIX_TIMERS=y
CONFIG_PRINTK=y
CONFIG_PRINTK_NMI=y
CONFIG_BUG=y
CONFIG_ELF_CORE=y
CONFIG_PCSPKR_PLATFORM=y
CONFIG_BASE_FULL=y
CONFIG_FUTEX=y
CONFIG_FUTEX_PI=y
CONFIG_EPOLL=y
CONFIG_SIGNALFD=y
CONFIG_TIMERFD=y
CONFIG_EVENTFD=y
CONFIG_SHMEM=y
CONFIG_AIO=y
CONFIG_IO_URING=y
CONFIG_ADVISE_SYSCALLS=y
CONFIG_HAVE_ARCH_USERFAULTFD_WP=y
CONFIG_HAVE_ARCH_USERFAULTFD_MINOR=y
CONFIG_MEMBARRIER=y
CONFIG_KALLSYMS=y
CONFIG_KALLSYMS_ALL=y
CONFIG_KALLSYMS_ABSOLUTE_PERCPU=y
CONFIG_KALLSYMS_BASE_RELATIVE=y
CONFIG_USERFAULTFD=y
CONFIG_ARCH_HAS_MEMBARRIER_SYNC_CORE=y
CONFIG_KCMP=y
CONFIG_RSEQ=y
# CONFIG_DEBUG_RSEQ is not set
CONFIG_EMBEDDED=y
CONFIG_HAVE_PERF_EVENTS=y
# CONFIG_PC104 is not set

#
# Kernel Performance Events And Counters
#
CONFIG_PERF_EVENTS=y
# CONFIG_DEBUG_PERF_USE_VMALLOC is not set
# end of Kernel Performance Events And Counters

CONFIG_VM_EVENT_COUNTERS=y
CONFIG_SLUB_DEBUG=y
# CONFIG_COMPAT_BRK is not set
# CONFIG_SLAB is not set
CONFIG_SLUB=y
# CONFIG_SLOB is not set
CONFIG_SLAB_MERGE_DEFAULT=y
CONFIG_SLAB_FREELIST_RANDOM=y
# CONFIG_SLAB_FREELIST_HARDENED is not set
CONFIG_SHUFFLE_PAGE_ALLOCATOR=y
CONFIG_SLUB_CPU_PARTIAL=y
CONFIG_SYSTEM_DATA_VERIFICATION=y
CONFIG_PROFILING=y
CONFIG_TRACEPOINTS=y
# end of General setup

CONFIG_64BIT=y
CONFIG_X86_64=y
CONFIG_X86=y
CONFIG_INSTRUCTION_DECODER=y
CONFIG_OUTPUT_FORMAT="elf64-x86-64"
CONFIG_LOCKDEP_SUPPORT=y
CONFIG_STACKTRACE_SUPPORT=y
CONFIG_MMU=y
CONFIG_ARCH_MMAP_RND_BITS_MIN=28
CONFIG_ARCH_MMAP_RND_BITS_MAX=32
CONFIG_ARCH_MMAP_RND_COMPAT_BITS_MIN=8
CONFIG_ARCH_MMAP_RND_COMPAT_BITS_MAX=16
CONFIG_GENERIC_ISA_DMA=y
CONFIG_GENERIC_BUG=y
CONFIG_GENERIC_BUG_RELATIVE_POINTERS=y
CONFIG_ARCH_MAY_HAVE_PC_FDC=y
CONFIG_GENERIC_CALIBRATE_DELAY=y
CONFIG_ARCH_HAS_CPU_RELAX=y
CONFIG_ARCH_HAS_FILTER_PGPROT=y
CONFIG_HAVE_SETUP_PER_CPU_AREA=y
CONFIG_NEED_PER_CPU_EMBED_FIRST_CHUNK=y
CONFIG_NEED_PER_CPU_PAGE_FIRST_CHUNK=y
CONFIG_ARCH_HIBERNATION_POSSIBLE=y
CONFIG_ARCH_SUSPEND_POSSIBLE=y
CONFIG_ARCH_WANT_GENERAL_HUGETLB=y
CONFIG_ZONE_DMA32=y
CONFIG_AUDIT_ARCH=y
CONFIG_HAVE_INTEL_TXT=y
CONFIG_X86_64_SMP=y
CONFIG_ARCH_SUPPORTS_UPROBES=y
CONFIG_FIX_EARLYCON_MEM=y
CONFIG_DYNAMIC_PHYSICAL_MASK=y
CONFIG_PGTABLE_LEVELS=5
CONFIG_CC_HAS_SANE_STACKPROTECTOR=y

#
# Processor type and features
#
CONFIG_ZONE_DMA=y
CONFIG_SMP=y
CONFIG_X86_FEATURE_NAMES=y
CONFIG_X86_X2APIC=y
CONFIG_X86_MPPARSE=y
# CONFIG_GOLDFISH is not set
CONFIG_RETPOLINE=y
CONFIG_X86_CPU_RESCTRL=y
CONFIG_X86_EXTENDED_PLATFORM=y
# CONFIG_X86_NUMACHIP is not set
# CONFIG_X86_VSMP is not set
CONFIG_X86_UV=y
# CONFIG_X86_GOLDFISH is not set
# CONFIG_X86_INTEL_MID is not set
CONFIG_X86_INTEL_LPSS=y
CONFIG_X86_AMD_PLATFORM_DEVICE=y
CONFIG_IOSF_MBI=y
# CONFIG_IOSF_MBI_DEBUG is not set
CONFIG_X86_SUPPORTS_MEMORY_FAILURE=y
# CONFIG_SCHED_OMIT_FRAME_POINTER is not set
CONFIG_HYPERVISOR_GUEST=y
CONFIG_PARAVIRT=y
# CONFIG_PARAVIRT_DEBUG is not set
CONFIG_PARAVIRT_SPINLOCKS=y
CONFIG_X86_HV_CALLBACK_VECTOR=y
CONFIG_XEN=y
# CONFIG_XEN_PV is not set
CONFIG_XEN_PVHVM=y
CONFIG_XEN_PVHVM_SMP=y
CONFIG_XEN_PVHVM_GUEST=y
CONFIG_XEN_SAVE_RESTORE=y
# CONFIG_XEN_DEBUG_FS is not set
# CONFIG_XEN_PVH is not set
CONFIG_KVM_GUEST=y
CONFIG_ARCH_CPUIDLE_HALTPOLL=y
# CONFIG_PVH is not set
CONFIG_PARAVIRT_TIME_ACCOUNTING=y
CONFIG_PARAVIRT_CLOCK=y
# CONFIG_JAILHOUSE_GUEST is not set
# CONFIG_ACRN_GUEST is not set
# CONFIG_MK8 is not set
# CONFIG_MPSC is not set
# CONFIG_MCORE2 is not set
# CONFIG_MATOM is not set
CONFIG_GENERIC_CPU=y
CONFIG_X86_INTERNODE_CACHE_SHIFT=6
CONFIG_X86_L1_CACHE_SHIFT=6
CONFIG_X86_TSC=y
CONFIG_X86_CMPXCHG64=y
CONFIG_X86_CMOV=y
CONFIG_X86_MINIMUM_CPU_FAMILY=64
CONFIG_X86_DEBUGCTLMSR=y
CONFIG_IA32_FEAT_CTL=y
CONFIG_X86_VMX_FEATURE_NAMES=y
# CONFIG_PROCESSOR_SELECT is not set
CONFIG_CPU_SUP_INTEL=y
CONFIG_CPU_SUP_AMD=y
CONFIG_CPU_SUP_HYGON=y
CONFIG_CPU_SUP_CENTAUR=y
CONFIG_CPU_SUP_ZHAOXIN=y
CONFIG_HPET_TIMER=y
CONFIG_HPET_EMULATE_RTC=y
CONFIG_DMI=y
# CONFIG_GART_IOMMU is not set
CONFIG_MAXSMP=y
CONFIG_NR_CPUS_RANGE_BEGIN=8192
CONFIG_NR_CPUS_RANGE_END=8192
CONFIG_NR_CPUS_DEFAULT=8192
CONFIG_NR_CPUS=8192
CONFIG_SCHED_SMT=y
CONFIG_SCHED_MC=y
CONFIG_SCHED_MC_PRIO=y
CONFIG_X86_LOCAL_APIC=y
CONFIG_X86_IO_APIC=y
CONFIG_X86_REROUTE_FOR_BROKEN_BOOT_IRQS=y
CONFIG_X86_MCE=y
CONFIG_X86_MCELOG_LEGACY=y
CONFIG_X86_MCE_INTEL=y
CONFIG_X86_MCE_AMD=y
CONFIG_X86_MCE_THRESHOLD=y
CONFIG_X86_MCE_INJECT=m

#
# Performance monitoring
#
CONFIG_PERF_EVENTS_INTEL_UNCORE=m
CONFIG_PERF_EVENTS_INTEL_RAPL=m
CONFIG_PERF_EVENTS_INTEL_CSTATE=m
CONFIG_PERF_EVENTS_AMD_POWER=m
# end of Performance monitoring

CONFIG_X86_16BIT=y
CONFIG_X86_ESPFIX64=y
CONFIG_X86_VSYSCALL_EMULATION=y
CONFIG_X86_IOPL_IOPERM=y
CONFIG_I8K=m
CONFIG_MICROCODE=y
CONFIG_MICROCODE_INTEL=y
CONFIG_MICROCODE_AMD=y
CONFIG_MICROCODE_OLD_INTERFACE=y
CONFIG_X86_MSR=y
CONFIG_X86_CPUID=y
CONFIG_X86_5LEVEL=y
CONFIG_X86_DIRECT_GBPAGES=y
# CONFIG_X86_CPA_STATISTICS is not set
CONFIG_AMD_MEM_ENCRYPT=y
# CONFIG_AMD_MEM_ENCRYPT_ACTIVE_BY_DEFAULT is not set
CONFIG_NUMA=y
CONFIG_AMD_NUMA=y
CONFIG_X86_64_ACPI_NUMA=y
CONFIG_NUMA_EMU=y
CONFIG_NODES_SHIFT=10
CONFIG_ARCH_SPARSEMEM_ENABLE=y
CONFIG_ARCH_SPARSEMEM_DEFAULT=y
CONFIG_ARCH_SELECT_MEMORY_MODEL=y
# CONFIG_ARCH_MEMORY_PROBE is not set
CONFIG_ARCH_PROC_KCORE_TEXT=y
CONFIG_ILLEGAL_POINTER_VALUE=0xdead000000000000
CONFIG_X86_PMEM_LEGACY_DEVICE=y
CONFIG_X86_PMEM_LEGACY=m
CONFIG_X86_CHECK_BIOS_CORRUPTION=y
# CONFIG_X86_BOOTPARAM_MEMORY_CORRUPTION_CHECK is not set
CONFIG_X86_RESERVE_LOW=64
CONFIG_MTRR=y
CONFIG_MTRR_SANITIZER=y
CONFIG_MTRR_SANITIZER_ENABLE_DEFAULT=1
CONFIG_MTRR_SANITIZER_SPARE_REG_NR_DEFAULT=1
CONFIG_X86_PAT=y
CONFIG_ARCH_USES_PG_UNCACHED=y
CONFIG_ARCH_RANDOM=y
CONFIG_X86_SMAP=y
CONFIG_X86_UMIP=y
CONFIG_X86_INTEL_MEMORY_PROTECTION_KEYS=y
CONFIG_X86_INTEL_TSX_MODE_OFF=y
# CONFIG_X86_INTEL_TSX_MODE_ON is not set
# CONFIG_X86_INTEL_TSX_MODE_AUTO is not set
CONFIG_X86_SGX=y
CONFIG_EFI=y
CONFIG_EFI_STUB=y
CONFIG_EFI_MIXED=y
# CONFIG_HZ_100 is not set
# CONFIG_HZ_250 is not set
# CONFIG_HZ_300 is not set
CONFIG_HZ_1000=y
CONFIG_HZ=1000
CONFIG_SCHED_HRTICK=y
CONFIG_KEXEC=y
CONFIG_KEXEC_FILE=y
CONFIG_ARCH_HAS_KEXEC_PURGATORY=y
# CONFIG_KEXEC_SIG is not set
CONFIG_CRASH_DUMP=y
CONFIG_KEXEC_JUMP=y
CONFIG_PHYSICAL_START=0x1000000
CONFIG_RELOCATABLE=y
CONFIG_RANDOMIZE_BASE=y
CONFIG_X86_NEED_RELOCS=y
CONFIG_PHYSICAL_ALIGN=0x200000
CONFIG_DYNAMIC_MEMORY_LAYOUT=y
CONFIG_RANDOMIZE_MEMORY=y
CONFIG_RANDOMIZE_MEMORY_PHYSICAL_PADDING=0xa
CONFIG_HOTPLUG_CPU=y
CONFIG_BOOTPARAM_HOTPLUG_CPU0=y
# CONFIG_DEBUG_HOTPLUG_CPU0 is not set
# CONFIG_COMPAT_VDSO is not set
CONFIG_LEGACY_VSYSCALL_EMULATE=y
# CONFIG_LEGACY_VSYSCALL_XONLY is not set
# CONFIG_LEGACY_VSYSCALL_NONE is not set
# CONFIG_CMDLINE_BOOL is not set
CONFIG_MODIFY_LDT_SYSCALL=y
CONFIG_HAVE_LIVEPATCH=y
CONFIG_LIVEPATCH=y
# end of Processor type and features

CONFIG_ARCH_HAS_ADD_PAGES=y
CONFIG_ARCH_MHP_MEMMAP_ON_MEMORY_ENABLE=y
CONFIG_USE_PERCPU_NUMA_NODE_ID=y

#
# Power management and ACPI options
#
CONFIG_ARCH_HIBERNATION_HEADER=y
CONFIG_SUSPEND=y
CONFIG_SUSPEND_FREEZER=y
# CONFIG_SUSPEND_SKIP_SYNC is not set
CONFIG_HIBERNATE_CALLBACKS=y
CONFIG_HIBERNATION=y
CONFIG_HIBERNATION_SNAPSHOT_DEV=y
CONFIG_PM_STD_PARTITION=""
CONFIG_PM_SLEEP=y
CONFIG_PM_SLEEP_SMP=y
# CONFIG_PM_AUTOSLEEP is not set
# CONFIG_PM_WAKELOCKS is not set
CONFIG_PM=y
CONFIG_PM_DEBUG=y
# CONFIG_PM_ADVANCED_DEBUG is not set
# CONFIG_PM_TEST_SUSPEND is not set
CONFIG_PM_SLEEP_DEBUG=y
# CONFIG_DPM_WATCHDOG is not set
# CONFIG_PM_TRACE_RTC is not set
CONFIG_PM_CLK=y
# CONFIG_WQ_POWER_EFFICIENT_DEFAULT is not set
# CONFIG_ENERGY_MODEL is not set
CONFIG_ARCH_SUPPORTS_ACPI=y
CONFIG_ACPI=y
CONFIG_ACPI_LEGACY_TABLES_LOOKUP=y
CONFIG_ARCH_MIGHT_HAVE_ACPI_PDC=y
CONFIG_ACPI_SYSTEM_POWER_STATES_SUPPORT=y
# CONFIG_ACPI_DEBUGGER is not set
CONFIG_ACPI_SPCR_TABLE=y
# CONFIG_ACPI_FPDT is not set
CONFIG_ACPI_LPIT=y
CONFIG_ACPI_SLEEP=y
CONFIG_ACPI_REV_OVERRIDE_POSSIBLE=y
CONFIG_ACPI_EC_DEBUGFS=m
CONFIG_ACPI_AC=y
CONFIG_ACPI_BATTERY=y
CONFIG_ACPI_BUTTON=y
CONFIG_ACPI_VIDEO=m
CONFIG_ACPI_FAN=y
CONFIG_ACPI_TAD=m
CONFIG_ACPI_DOCK=y
CONFIG_ACPI_CPU_FREQ_PSS=y
CONFIG_ACPI_PROCESSOR_CSTATE=y
CONFIG_ACPI_PROCESSOR_IDLE=y
CONFIG_ACPI_CPPC_LIB=y
CONFIG_ACPI_PROCESSOR=y
CONFIG_ACPI_IPMI=m
CONFIG_ACPI_HOTPLUG_CPU=y
CONFIG_ACPI_PROCESSOR_AGGREGATOR=m
CONFIG_ACPI_THERMAL=y
CONFIG_ACPI_PLATFORM_PROFILE=m
CONFIG_ARCH_HAS_ACPI_TABLE_UPGRADE=y
CONFIG_ACPI_TABLE_UPGRADE=y
# CONFIG_ACPI_DEBUG is not set
CONFIG_ACPI_PCI_SLOT=y
CONFIG_ACPI_CONTAINER=y
CONFIG_ACPI_HOTPLUG_MEMORY=y
CONFIG_ACPI_HOTPLUG_IOAPIC=y
CONFIG_ACPI_SBS=m
CONFIG_ACPI_HED=y
# CONFIG_ACPI_CUSTOM_METHOD is not set
CONFIG_ACPI_BGRT=y
# CONFIG_ACPI_REDUCED_HARDWARE_ONLY is not set
CONFIG_ACPI_NFIT=m
# CONFIG_NFIT_SECURITY_DEBUG is not set
CONFIG_ACPI_NUMA=y
# CONFIG_ACPI_HMAT is not set
CONFIG_HAVE_ACPI_APEI=y
CONFIG_HAVE_ACPI_APEI_NMI=y
CONFIG_ACPI_APEI=y
CONFIG_ACPI_APEI_GHES=y
CONFIG_ACPI_APEI_PCIEAER=y
CONFIG_ACPI_APEI_MEMORY_FAILURE=y
CONFIG_ACPI_APEI_EINJ=m
# CONFIG_ACPI_APEI_ERST_DEBUG is not set
# CONFIG_ACPI_DPTF is not set
CONFIG_ACPI_WATCHDOG=y
CONFIG_ACPI_EXTLOG=m
CONFIG_ACPI_ADXL=y
# CONFIG_ACPI_CONFIGFS is not set
CONFIG_PMIC_OPREGION=y
CONFIG_X86_PM_TIMER=y

#
# CPU Frequency scaling
#
CONFIG_CPU_FREQ=y
CONFIG_CPU_FREQ_GOV_ATTR_SET=y
CONFIG_CPU_FREQ_GOV_COMMON=y
CONFIG_CPU_FREQ_STAT=y
CONFIG_CPU_FREQ_DEFAULT_GOV_PERFORMANCE=y
# CONFIG_CPU_FREQ_DEFAULT_GOV_POWERSAVE is not set
# CONFIG_CPU_FREQ_DEFAULT_GOV_USERSPACE is not set
# CONFIG_CPU_FREQ_DEFAULT_GOV_SCHEDUTIL is not set
CONFIG_CPU_FREQ_GOV_PERFORMANCE=y
CONFIG_CPU_FREQ_GOV_POWERSAVE=y
CONFIG_CPU_FREQ_GOV_USERSPACE=y
CONFIG_CPU_FREQ_GOV_ONDEMAND=y
CONFIG_CPU_FREQ_GOV_CONSERVATIVE=y
CONFIG_CPU_FREQ_GOV_SCHEDUTIL=y

#
# CPU frequency scaling drivers
#
CONFIG_X86_INTEL_PSTATE=y
# CONFIG_X86_PCC_CPUFREQ is not set
CONFIG_X86_ACPI_CPUFREQ=m
CONFIG_X86_ACPI_CPUFREQ_CPB=y
CONFIG_X86_POWERNOW_K8=m
CONFIG_X86_AMD_FREQ_SENSITIVITY=m
# CONFIG_X86_SPEEDSTEP_CENTRINO is not set
CONFIG_X86_P4_CLOCKMOD=m

#
# shared options
#
CONFIG_X86_SPEEDSTEP_LIB=m
# end of CPU Frequency scaling

#
# CPU Idle
#
CONFIG_CPU_IDLE=y
# CONFIG_CPU_IDLE_GOV_LADDER is not set
CONFIG_CPU_IDLE_GOV_MENU=y
# CONFIG_CPU_IDLE_GOV_TEO is not set
# CONFIG_CPU_IDLE_GOV_HALTPOLL is not set
CONFIG_HALTPOLL_CPUIDLE=y
# end of CPU Idle

CONFIG_INTEL_IDLE=y
# end of Power management and ACPI options

#
# Bus options (PCI etc.)
#
CONFIG_PCI_DIRECT=y
CONFIG_PCI_MMCONFIG=y
CONFIG_PCI_XEN=y
CONFIG_MMCONF_FAM10H=y
# CONFIG_PCI_CNB20LE_QUIRK is not set
# CONFIG_ISA_BUS is not set
CONFIG_ISA_DMA_API=y
CONFIG_AMD_NB=y
# CONFIG_X86_SYSFB is not set
# end of Bus options (PCI etc.)

#
# Binary Emulations
#
CONFIG_IA32_EMULATION=y
# CONFIG_X86_X32 is not set
CONFIG_COMPAT_32=y
CONFIG_COMPAT=y
CONFIG_COMPAT_FOR_U64_ALIGNMENT=y
CONFIG_SYSVIPC_COMPAT=y
# end of Binary Emulations

#
# Firmware Drivers
#
CONFIG_EDD=m
# CONFIG_EDD_OFF is not set
CONFIG_FIRMWARE_MEMMAP=y
CONFIG_DMIID=y
CONFIG_DMI_SYSFS=y
CONFIG_DMI_SCAN_MACHINE_NON_EFI_FALLBACK=y
# CONFIG_ISCSI_IBFT is not set
CONFIG_FW_CFG_SYSFS=y
# CONFIG_FW_CFG_SYSFS_CMDLINE is not set
# CONFIG_GOOGLE_FIRMWARE is not set

#
# EFI (Extensible Firmware Interface) Support
#
CONFIG_EFI_VARS=y
CONFIG_EFI_ESRT=y
CONFIG_EFI_VARS_PSTORE=y
CONFIG_EFI_VARS_PSTORE_DEFAULT_DISABLE=y
CONFIG_EFI_RUNTIME_MAP=y
# CONFIG_EFI_FAKE_MEMMAP is not set
CONFIG_EFI_RUNTIME_WRAPPERS=y
CONFIG_EFI_GENERIC_STUB_INITRD_CMDLINE_LOADER=y
# CONFIG_EFI_BOOTLOADER_CONTROL is not set
# CONFIG_EFI_CAPSULE_LOADER is not set
# CONFIG_EFI_TEST is not set
CONFIG_APPLE_PROPERTIES=y
# CONFIG_RESET_ATTACK_MITIGATION is not set
# CONFIG_EFI_RCI2_TABLE is not set
# CONFIG_EFI_DISABLE_PCI_DMA is not set
# end of EFI (Extensible Firmware Interface) Support

CONFIG_UEFI_CPER=y
CONFIG_UEFI_CPER_X86=y
CONFIG_EFI_DEV_PATH_PARSER=y
CONFIG_EFI_EARLYCON=y
CONFIG_EFI_CUSTOM_SSDT_OVERLAYS=y

#
# Tegra firmware driver
#
# end of Tegra firmware driver
# end of Firmware Drivers

CONFIG_HAVE_KVM=y
CONFIG_HAVE_KVM_IRQCHIP=y
CONFIG_HAVE_KVM_IRQFD=y
CONFIG_HAVE_KVM_IRQ_ROUTING=y
CONFIG_HAVE_KVM_EVENTFD=y
CONFIG_KVM_MMIO=y
CONFIG_KVM_ASYNC_PF=y
CONFIG_HAVE_KVM_MSI=y
CONFIG_HAVE_KVM_CPU_RELAX_INTERCEPT=y
CONFIG_KVM_VFIO=y
CONFIG_KVM_GENERIC_DIRTYLOG_READ_PROTECT=y
CONFIG_KVM_COMPAT=y
CONFIG_HAVE_KVM_IRQ_BYPASS=y
CONFIG_HAVE_KVM_NO_POLL=y
CONFIG_KVM_XFER_TO_GUEST_WORK=y
CONFIG_VIRTUALIZATION=y
CONFIG_KVM=y
# CONFIG_KVM_WERROR is not set
CONFIG_KVM_INTEL=y
# CONFIG_X86_SGX_KVM is not set
# CONFIG_KVM_AMD is not set
# CONFIG_KVM_XEN is not set
CONFIG_KVM_MMU_AUDIT=y
CONFIG_AS_AVX512=y
CONFIG_AS_SHA1_NI=y
CONFIG_AS_SHA256_NI=y
CONFIG_AS_TPAUSE=y

#
# General architecture-dependent options
#
CONFIG_CRASH_CORE=y
CONFIG_KEXEC_CORE=y
CONFIG_HOTPLUG_SMT=y
CONFIG_GENERIC_ENTRY=y
CONFIG_KPROBES=y
CONFIG_JUMP_LABEL=y
# CONFIG_STATIC_KEYS_SELFTEST is not set
# CONFIG_STATIC_CALL_SELFTEST is not set
CONFIG_OPTPROBES=y
CONFIG_KPROBES_ON_FTRACE=y
CONFIG_UPROBES=y
CONFIG_HAVE_EFFICIENT_UNALIGNED_ACCESS=y
CONFIG_ARCH_USE_BUILTIN_BSWAP=y
CONFIG_KRETPROBES=y
CONFIG_USER_RETURN_NOTIFIER=y
CONFIG_HAVE_IOREMAP_PROT=y
CONFIG_HAVE_KPROBES=y
CONFIG_HAVE_KRETPROBES=y
CONFIG_HAVE_OPTPROBES=y
CONFIG_HAVE_KPROBES_ON_FTRACE=y
CONFIG_HAVE_FUNCTION_ERROR_INJECTION=y
CONFIG_HAVE_NMI=y
CONFIG_HAVE_ARCH_TRACEHOOK=y
CONFIG_HAVE_DMA_CONTIGUOUS=y
CONFIG_GENERIC_SMP_IDLE_THREAD=y
CONFIG_ARCH_HAS_FORTIFY_SOURCE=y
CONFIG_ARCH_HAS_SET_MEMORY=y
CONFIG_ARCH_HAS_SET_DIRECT_MAP=y
CONFIG_HAVE_ARCH_THREAD_STRUCT_WHITELIST=y
CONFIG_ARCH_WANTS_DYNAMIC_TASK_STRUCT=y
CONFIG_HAVE_ASM_MODVERSIONS=y
CONFIG_HAVE_REGS_AND_STACK_ACCESS_API=y
CONFIG_HAVE_RSEQ=y
CONFIG_HAVE_FUNCTION_ARG_ACCESS_API=y
CONFIG_HAVE_HW_BREAKPOINT=y
CONFIG_HAVE_MIXED_BREAKPOINTS_REGS=y
CONFIG_HAVE_USER_RETURN_NOTIFIER=y
CONFIG_HAVE_PERF_EVENTS_NMI=y
CONFIG_HAVE_HARDLOCKUP_DETECTOR_PERF=y
CONFIG_HAVE_PERF_REGS=y
CONFIG_HAVE_PERF_USER_STACK_DUMP=y
CONFIG_HAVE_ARCH_JUMP_LABEL=y
CONFIG_HAVE_ARCH_JUMP_LABEL_RELATIVE=y
CONFIG_MMU_GATHER_TABLE_FREE=y
CONFIG_MMU_GATHER_RCU_TABLE_FREE=y
CONFIG_ARCH_HAVE_NMI_SAFE_CMPXCHG=y
CONFIG_HAVE_ALIGNED_STRUCT_PAGE=y
CONFIG_HAVE_CMPXCHG_LOCAL=y
CONFIG_HAVE_CMPXCHG_DOUBLE=y
CONFIG_ARCH_WANT_COMPAT_IPC_PARSE_VERSION=y
CONFIG_ARCH_WANT_OLD_COMPAT_IPC=y
CONFIG_HAVE_ARCH_SECCOMP=y
CONFIG_HAVE_ARCH_SECCOMP_FILTER=y
CONFIG_SECCOMP=y
CONFIG_SECCOMP_FILTER=y
# CONFIG_SECCOMP_CACHE_DEBUG is not set
CONFIG_HAVE_ARCH_STACKLEAK=y
CONFIG_HAVE_STACKPROTECTOR=y
CONFIG_STACKPROTECTOR=y
CONFIG_STACKPROTECTOR_STRONG=y
CONFIG_ARCH_SUPPORTS_LTO_CLANG=y
CONFIG_ARCH_SUPPORTS_LTO_CLANG_THIN=y
CONFIG_LTO_NONE=y
CONFIG_HAVE_ARCH_WITHIN_STACK_FRAMES=y
CONFIG_HAVE_CONTEXT_TRACKING=y
CONFIG_HAVE_CONTEXT_TRACKING_OFFSTACK=y
CONFIG_HAVE_VIRT_CPU_ACCOUNTING_GEN=y
CONFIG_HAVE_IRQ_TIME_ACCOUNTING=y
CONFIG_HAVE_MOVE_PUD=y
CONFIG_HAVE_MOVE_PMD=y
CONFIG_HAVE_ARCH_TRANSPARENT_HUGEPAGE=y
CONFIG_HAVE_ARCH_TRANSPARENT_HUGEPAGE_PUD=y
CONFIG_HAVE_ARCH_HUGE_VMAP=y
CONFIG_ARCH_WANT_HUGE_PMD_SHARE=y
CONFIG_HAVE_ARCH_SOFT_DIRTY=y
CONFIG_HAVE_MOD_ARCH_SPECIFIC=y
CONFIG_MODULES_USE_ELF_RELA=y
CONFIG_HAVE_IRQ_EXIT_ON_IRQ_STACK=y
CONFIG_HAVE_SOFTIRQ_ON_OWN_STACK=y
CONFIG_ARCH_HAS_ELF_RANDOMIZE=y
CONFIG_HAVE_ARCH_MMAP_RND_BITS=y
CONFIG_HAVE_EXIT_THREAD=y
CONFIG_ARCH_MMAP_RND_BITS=28
CONFIG_HAVE_ARCH_MMAP_RND_COMPAT_BITS=y
CONFIG_ARCH_MMAP_RND_COMPAT_BITS=8
CONFIG_HAVE_ARCH_COMPAT_MMAP_BASES=y
CONFIG_HAVE_STACK_VALIDATION=y
CONFIG_HAVE_RELIABLE_STACKTRACE=y
CONFIG_OLD_SIGSUSPEND3=y
CONFIG_COMPAT_OLD_SIGACTION=y
CONFIG_COMPAT_32BIT_TIME=y
CONFIG_HAVE_ARCH_VMAP_STACK=y
CONFIG_VMAP_STACK=y
CONFIG_HAVE_ARCH_RANDOMIZE_KSTACK_OFFSET=y
# CONFIG_RANDOMIZE_KSTACK_OFFSET_DEFAULT is not set
CONFIG_ARCH_HAS_STRICT_KERNEL_RWX=y
CONFIG_STRICT_KERNEL_RWX=y
CONFIG_ARCH_HAS_STRICT_MODULE_RWX=y
CONFIG_STRICT_MODULE_RWX=y
CONFIG_HAVE_ARCH_PREL32_RELOCATIONS=y
CONFIG_ARCH_USE_MEMREMAP_PROT=y
# CONFIG_LOCK_EVENT_COUNTS is not set
CONFIG_ARCH_HAS_MEM_ENCRYPT=y
CONFIG_HAVE_STATIC_CALL=y
CONFIG_HAVE_STATIC_CALL_INLINE=y
CONFIG_HAVE_PREEMPT_DYNAMIC=y
CONFIG_ARCH_WANT_LD_ORPHAN_WARN=y
CONFIG_ARCH_SUPPORTS_DEBUG_PAGEALLOC=y
CONFIG_ARCH_HAS_ELFCORE_COMPAT=y

#
# GCOV-based kernel profiling
#
# CONFIG_GCOV_KERNEL is not set
CONFIG_ARCH_HAS_GCOV_PROFILE_ALL=y
# end of GCOV-based kernel profiling

CONFIG_HAVE_GCC_PLUGINS=y
# end of General architecture-dependent options

CONFIG_RT_MUTEXES=y
CONFIG_BASE_SMALL=0
CONFIG_MODULE_SIG_FORMAT=y
CONFIG_MODULES=y
CONFIG_MODULE_FORCE_LOAD=y
CONFIG_MODULE_UNLOAD=y
# CONFIG_MODULE_FORCE_UNLOAD is not set
# CONFIG_MODVERSIONS is not set
# CONFIG_MODULE_SRCVERSION_ALL is not set
CONFIG_MODULE_SIG=y
# CONFIG_MODULE_SIG_FORCE is not set
CONFIG_MODULE_SIG_ALL=y
# CONFIG_MODULE_SIG_SHA1 is not set
# CONFIG_MODULE_SIG_SHA224 is not set
CONFIG_MODULE_SIG_SHA256=y
# CONFIG_MODULE_SIG_SHA384 is not set
# CONFIG_MODULE_SIG_SHA512 is not set
CONFIG_MODULE_SIG_HASH="sha256"
CONFIG_MODULE_COMPRESS_NONE=y
# CONFIG_MODULE_COMPRESS_GZIP is not set
# CONFIG_MODULE_COMPRESS_XZ is not set
# CONFIG_MODULE_COMPRESS_ZSTD is not set
# CONFIG_MODULE_ALLOW_MISSING_NAMESPACE_IMPORTS is not set
CONFIG_MODPROBE_PATH="/sbin/modprobe"
# CONFIG_TRIM_UNUSED_KSYMS is not set
CONFIG_MODULES_TREE_LOOKUP=y
CONFIG_BLOCK=y
CONFIG_BLK_SCSI_REQUEST=y
CONFIG_BLK_CGROUP_RWSTAT=y
CONFIG_BLK_DEV_BSG=y
CONFIG_BLK_DEV_BSGLIB=y
CONFIG_BLK_DEV_INTEGRITY=y
CONFIG_BLK_DEV_INTEGRITY_T10=m
# CONFIG_BLK_DEV_ZONED is not set
CONFIG_BLK_DEV_THROTTLING=y
# CONFIG_BLK_DEV_THROTTLING_LOW is not set
# CONFIG_BLK_CMDLINE_PARSER is not set
CONFIG_BLK_WBT=y
# CONFIG_BLK_CGROUP_IOLATENCY is not set
# CONFIG_BLK_CGROUP_IOCOST is not set
CONFIG_BLK_WBT_MQ=y
CONFIG_BLK_DEBUG_FS=y
# CONFIG_BLK_SED_OPAL is not set
# CONFIG_BLK_INLINE_ENCRYPTION is not set

#
# Partition Types
#
CONFIG_PARTITION_ADVANCED=y
# CONFIG_ACORN_PARTITION is not set
# CONFIG_AIX_PARTITION is not set
CONFIG_OSF_PARTITION=y
CONFIG_AMIGA_PARTITION=y
# CONFIG_ATARI_PARTITION is not set
CONFIG_MAC_PARTITION=y
CONFIG_MSDOS_PARTITION=y
CONFIG_BSD_DISKLABEL=y
CONFIG_MINIX_SUBPARTITION=y
CONFIG_SOLARIS_X86_PARTITION=y
CONFIG_UNIXWARE_DISKLABEL=y
# CONFIG_LDM_PARTITION is not set
CONFIG_SGI_PARTITION=y
# CONFIG_ULTRIX_PARTITION is not set
CONFIG_SUN_PARTITION=y
CONFIG_KARMA_PARTITION=y
CONFIG_EFI_PARTITION=y
# CONFIG_SYSV68_PARTITION is not set
# CONFIG_CMDLINE_PARTITION is not set
# end of Partition Types

CONFIG_BLOCK_COMPAT=y
CONFIG_BLK_MQ_PCI=y
CONFIG_BLK_MQ_VIRTIO=y
CONFIG_BLK_PM=y

#
# IO Schedulers
#
CONFIG_MQ_IOSCHED_DEADLINE=y
CONFIG_MQ_IOSCHED_KYBER=y
CONFIG_IOSCHED_BFQ=y
CONFIG_BFQ_GROUP_IOSCHED=y
# CONFIG_BFQ_CGROUP_DEBUG is not set
# end of IO Schedulers

CONFIG_PREEMPT_NOTIFIERS=y
CONFIG_PADATA=y
CONFIG_ASN1=y
CONFIG_UNINLINE_SPIN_UNLOCK=y
CONFIG_ARCH_SUPPORTS_ATOMIC_RMW=y
CONFIG_MUTEX_SPIN_ON_OWNER=y
CONFIG_RWSEM_SPIN_ON_OWNER=y
CONFIG_LOCK_SPIN_ON_OWNER=y
CONFIG_ARCH_USE_QUEUED_SPINLOCKS=y
CONFIG_QUEUED_SPINLOCKS=y
CONFIG_ARCH_USE_QUEUED_RWLOCKS=y
CONFIG_QUEUED_RWLOCKS=y
CONFIG_ARCH_HAS_NON_OVERLAPPING_ADDRESS_SPACE=y
CONFIG_ARCH_HAS_SYNC_CORE_BEFORE_USERMODE=y
CONFIG_ARCH_HAS_SYSCALL_WRAPPER=y
CONFIG_FREEZER=y

#
# Executable file formats
#
CONFIG_BINFMT_ELF=y
CONFIG_COMPAT_BINFMT_ELF=y
CONFIG_ELFCORE=y
CONFIG_CORE_DUMP_DEFAULT_ELF_HEADERS=y
CONFIG_BINFMT_SCRIPT=y
CONFIG_BINFMT_MISC=m
CONFIG_COREDUMP=y
# end of Executable file formats

#
# Memory Management options
#
CONFIG_SELECT_MEMORY_MODEL=y
CONFIG_SPARSEMEM_MANUAL=y
CONFIG_SPARSEMEM=y
CONFIG_NEED_MULTIPLE_NODES=y
CONFIG_SPARSEMEM_EXTREME=y
CONFIG_SPARSEMEM_VMEMMAP_ENABLE=y
CONFIG_SPARSEMEM_VMEMMAP=y
CONFIG_HAVE_FAST_GUP=y
CONFIG_NUMA_KEEP_MEMINFO=y
CONFIG_MEMORY_ISOLATION=y
CONFIG_HAVE_BOOTMEM_INFO_NODE=y
CONFIG_ARCH_ENABLE_MEMORY_HOTPLUG=y
CONFIG_MEMORY_HOTPLUG=y
CONFIG_MEMORY_HOTPLUG_SPARSE=y
# CONFIG_MEMORY_HOTPLUG_DEFAULT_ONLINE is not set
CONFIG_ARCH_ENABLE_MEMORY_HOTREMOVE=y
CONFIG_MEMORY_HOTREMOVE=y
CONFIG_MHP_MEMMAP_ON_MEMORY=y
CONFIG_SPLIT_PTLOCK_CPUS=4
CONFIG_ARCH_ENABLE_SPLIT_PMD_PTLOCK=y
CONFIG_MEMORY_BALLOON=y
CONFIG_BALLOON_COMPACTION=y
CONFIG_COMPACTION=y
CONFIG_PAGE_REPORTING=y
CONFIG_MIGRATION=y
CONFIG_ARCH_ENABLE_HUGEPAGE_MIGRATION=y
CONFIG_ARCH_ENABLE_THP_MIGRATION=y
CONFIG_CONTIG_ALLOC=y
CONFIG_PHYS_ADDR_T_64BIT=y
CONFIG_VIRT_TO_BUS=y
CONFIG_MMU_NOTIFIER=y
CONFIG_KSM=y
CONFIG_DEFAULT_MMAP_MIN_ADDR=4096
CONFIG_ARCH_SUPPORTS_MEMORY_FAILURE=y
CONFIG_MEMORY_FAILURE=y
CONFIG_HWPOISON_INJECT=m
CONFIG_TRANSPARENT_HUGEPAGE=y
CONFIG_TRANSPARENT_HUGEPAGE_ALWAYS=y
# CONFIG_TRANSPARENT_HUGEPAGE_MADVISE is not set
CONFIG_ARCH_WANTS_THP_SWAP=y
CONFIG_THP_SWAP=y
CONFIG_CLEANCACHE=y
CONFIG_FRONTSWAP=y
# CONFIG_CMA is not set
# CONFIG_MEM_SOFT_DIRTY is not set
CONFIG_ZSWAP=y
# CONFIG_ZSWAP_COMPRESSOR_DEFAULT_DEFLATE is not set
CONFIG_ZSWAP_COMPRESSOR_DEFAULT_LZO=y
# CONFIG_ZSWAP_COMPRESSOR_DEFAULT_842 is not set
# CONFIG_ZSWAP_COMPRESSOR_DEFAULT_LZ4 is not set
# CONFIG_ZSWAP_COMPRESSOR_DEFAULT_LZ4HC is not set
# CONFIG_ZSWAP_COMPRESSOR_DEFAULT_ZSTD is not set
CONFIG_ZSWAP_COMPRESSOR_DEFAULT="lzo"
CONFIG_ZSWAP_ZPOOL_DEFAULT_ZBUD=y
# CONFIG_ZSWAP_ZPOOL_DEFAULT_Z3FOLD is not set
# CONFIG_ZSWAP_ZPOOL_DEFAULT_ZSMALLOC is not set
CONFIG_ZSWAP_ZPOOL_DEFAULT="zbud"
# CONFIG_ZSWAP_DEFAULT_ON is not set
CONFIG_ZPOOL=y
CONFIG_ZBUD=y
# CONFIG_Z3FOLD is not set
CONFIG_ZSMALLOC=y
CONFIG_ZSMALLOC_STAT=y
CONFIG_GENERIC_EARLY_IOREMAP=y
CONFIG_DEFERRED_STRUCT_PAGE_INIT=y
CONFIG_IDLE_PAGE_TRACKING=y
CONFIG_ARCH_HAS_CACHE_LINE_SIZE=y
CONFIG_ARCH_HAS_PTE_DEVMAP=y
CONFIG_ZONE_DEVICE=y
CONFIG_DEV_PAGEMAP_OPS=y
CONFIG_HMM_MIRROR=y
CONFIG_DEVICE_PRIVATE=y
CONFIG_VMAP_PFN=y
CONFIG_ARCH_USES_HIGH_VMA_FLAGS=y
CONFIG_ARCH_HAS_PKEYS=y
# CONFIG_PERCPU_STATS is not set
CONFIG_GUP_TEST=y
# CONFIG_READ_ONLY_THP_FOR_FS is not set
CONFIG_ARCH_HAS_PTE_SPECIAL=y
CONFIG_IO_MAPPING=y
# end of Memory Management options

CONFIG_NET=y
CONFIG_NET_INGRESS=y
CONFIG_NET_EGRESS=y
CONFIG_NET_REDIRECT=y
CONFIG_SKB_EXTENSIONS=y

#
# Networking options
#
CONFIG_PACKET=y
CONFIG_PACKET_DIAG=m
CONFIG_UNIX=y
CONFIG_UNIX_SCM=y
CONFIG_UNIX_DIAG=m
CONFIG_TLS=m
CONFIG_TLS_DEVICE=y
# CONFIG_TLS_TOE is not set
CONFIG_XFRM=y
CONFIG_XFRM_OFFLOAD=y
CONFIG_XFRM_ALGO=y
CONFIG_XFRM_USER=y
# CONFIG_XFRM_USER_COMPAT is not set
# CONFIG_XFRM_INTERFACE is not set
CONFIG_XFRM_SUB_POLICY=y
CONFIG_XFRM_MIGRATE=y
CONFIG_XFRM_STATISTICS=y
CONFIG_XFRM_AH=m
CONFIG_XFRM_ESP=m
CONFIG_XFRM_IPCOMP=m
CONFIG_NET_KEY=m
CONFIG_NET_KEY_MIGRATE=y
CONFIG_XDP_SOCKETS=y
# CONFIG_XDP_SOCKETS_DIAG is not set
CONFIG_INET=y
CONFIG_IP_MULTICAST=y
CONFIG_IP_ADVANCED_ROUTER=y
CONFIG_IP_FIB_TRIE_STATS=y
CONFIG_IP_MULTIPLE_TABLES=y
CONFIG_IP_ROUTE_MULTIPATH=y
CONFIG_IP_ROUTE_VERBOSE=y
CONFIG_IP_ROUTE_CLASSID=y
CONFIG_IP_PNP=y
CONFIG_IP_PNP_DHCP=y
# CONFIG_IP_PNP_BOOTP is not set
# CONFIG_IP_PNP_RARP is not set
CONFIG_NET_IPIP=y
CONFIG_NET_IPGRE_DEMUX=y
CONFIG_NET_IP_TUNNEL=y
CONFIG_NET_IPGRE=y
CONFIG_NET_IPGRE_BROADCAST=y
CONFIG_IP_MROUTE_COMMON=y
CONFIG_IP_MROUTE=y
CONFIG_IP_MROUTE_MULTIPLE_TABLES=y
CONFIG_IP_PIMSM_V1=y
CONFIG_IP_PIMSM_V2=y
CONFIG_SYN_COOKIES=y
CONFIG_NET_IPVTI=m
CONFIG_NET_UDP_TUNNEL=y
CONFIG_NET_FOU=y
CONFIG_NET_FOU_IP_TUNNELS=y
CONFIG_INET_AH=m
CONFIG_INET_ESP=m
CONFIG_INET_ESP_OFFLOAD=m
# CONFIG_INET_ESPINTCP is not set
CONFIG_INET_IPCOMP=m
CONFIG_INET_XFRM_TUNNEL=m
CONFIG_INET_TUNNEL=y
CONFIG_INET_DIAG=m
CONFIG_INET_TCP_DIAG=m
CONFIG_INET_UDP_DIAG=m
CONFIG_INET_RAW_DIAG=m
# CONFIG_INET_DIAG_DESTROY is not set
CONFIG_TCP_CONG_ADVANCED=y
CONFIG_TCP_CONG_BIC=m
CONFIG_TCP_CONG_CUBIC=y
CONFIG_TCP_CONG_WESTWOOD=m
CONFIG_TCP_CONG_HTCP=m
CONFIG_TCP_CONG_HSTCP=m
CONFIG_TCP_CONG_HYBLA=m
CONFIG_TCP_CONG_VEGAS=m
CONFIG_TCP_CONG_NV=m
CONFIG_TCP_CONG_SCALABLE=m
CONFIG_TCP_CONG_LP=m
CONFIG_TCP_CONG_VENO=m
CONFIG_TCP_CONG_YEAH=m
CONFIG_TCP_CONG_ILLINOIS=m
CONFIG_TCP_CONG_DCTCP=m
# CONFIG_TCP_CONG_CDG is not set
CONFIG_TCP_CONG_BBR=m
CONFIG_DEFAULT_CUBIC=y
# CONFIG_DEFAULT_RENO is not set
CONFIG_DEFAULT_TCP_CONG="cubic"
CONFIG_TCP_MD5SIG=y
CONFIG_IPV6=y
CONFIG_IPV6_ROUTER_PREF=y
CONFIG_IPV6_ROUTE_INFO=y
CONFIG_IPV6_OPTIMISTIC_DAD=y
CONFIG_INET6_AH=m
CONFIG_INET6_ESP=m
CONFIG_INET6_ESP_OFFLOAD=m
# CONFIG_INET6_ESPINTCP is not set
CONFIG_INET6_IPCOMP=m
CONFIG_IPV6_MIP6=m
# CONFIG_IPV6_ILA is not set
CONFIG_INET6_XFRM_TUNNEL=m
CONFIG_INET6_TUNNEL=y
CONFIG_IPV6_VTI=m
CONFIG_IPV6_SIT=m
CONFIG_IPV6_SIT_6RD=y
CONFIG_IPV6_NDISC_NODETYPE=y
CONFIG_IPV6_TUNNEL=y
CONFIG_IPV6_GRE=y
CONFIG_IPV6_FOU=y
CONFIG_IPV6_FOU_TUNNEL=y
CONFIG_IPV6_MULTIPLE_TABLES=y
# CONFIG_IPV6_SUBTREES is not set
CONFIG_IPV6_MROUTE=y
CONFIG_IPV6_MROUTE_MULTIPLE_TABLES=y
CONFIG_IPV6_PIMSM_V2=y
CONFIG_IPV6_SEG6_LWTUNNEL=y
# CONFIG_IPV6_SEG6_HMAC is not set
CONFIG_IPV6_SEG6_BPF=y
# CONFIG_IPV6_RPL_LWTUNNEL is not set
CONFIG_NETLABEL=y
CONFIG_MPTCP=y
CONFIG_INET_MPTCP_DIAG=m
CONFIG_MPTCP_IPV6=y
CONFIG_NETWORK_SECMARK=y
CONFIG_NET_PTP_CLASSIFY=y
CONFIG_NETWORK_PHY_TIMESTAMPING=y
CONFIG_NETFILTER=y
CONFIG_NETFILTER_ADVANCED=y
CONFIG_BRIDGE_NETFILTER=m

#
# Core Netfilter Configuration
#
CONFIG_NETFILTER_INGRESS=y
CONFIG_NETFILTER_NETLINK=m
CONFIG_NETFILTER_FAMILY_BRIDGE=y
CONFIG_NETFILTER_FAMILY_ARP=y
# CONFIG_NETFILTER_NETLINK_HOOK is not set
# CONFIG_NETFILTER_NETLINK_ACCT is not set
CONFIG_NETFILTER_NETLINK_QUEUE=m
CONFIG_NETFILTER_NETLINK_LOG=m
CONFIG_NETFILTER_NETLINK_OSF=m
CONFIG_NF_CONNTRACK=m
CONFIG_NF_LOG_SYSLOG=m
CONFIG_NETFILTER_CONNCOUNT=m
CONFIG_NF_CONNTRACK_MARK=y
CONFIG_NF_CONNTRACK_SECMARK=y
CONFIG_NF_CONNTRACK_ZONES=y
CONFIG_NF_CONNTRACK_PROCFS=y
CONFIG_NF_CONNTRACK_EVENTS=y
CONFIG_NF_CONNTRACK_TIMEOUT=y
CONFIG_NF_CONNTRACK_TIMESTAMP=y
CONFIG_NF_CONNTRACK_LABELS=y
CONFIG_NF_CT_PROTO_DCCP=y
CONFIG_NF_CT_PROTO_GRE=y
CONFIG_NF_CT_PROTO_SCTP=y
CONFIG_NF_CT_PROTO_UDPLITE=y
CONFIG_NF_CONNTRACK_AMANDA=m
CONFIG_NF_CONNTRACK_FTP=m
CONFIG_NF_CONNTRACK_H323=m
CONFIG_NF_CONNTRACK_IRC=m
CONFIG_NF_CONNTRACK_BROADCAST=m
CONFIG_NF_CONNTRACK_NETBIOS_NS=m
CONFIG_NF_CONNTRACK_SNMP=m
CONFIG_NF_CONNTRACK_PPTP=m
CONFIG_NF_CONNTRACK_SANE=m
CONFIG_NF_CONNTRACK_SIP=m
CONFIG_NF_CONNTRACK_TFTP=m
CONFIG_NF_CT_NETLINK=m
CONFIG_NF_CT_NETLINK_TIMEOUT=m
CONFIG_NF_CT_NETLINK_HELPER=m
CONFIG_NETFILTER_NETLINK_GLUE_CT=y
CONFIG_NF_NAT=m
CONFIG_NF_NAT_AMANDA=m
CONFIG_NF_NAT_FTP=m
CONFIG_NF_NAT_IRC=m
CONFIG_NF_NAT_SIP=m
CONFIG_NF_NAT_TFTP=m
CONFIG_NF_NAT_REDIRECT=y
CONFIG_NF_NAT_MASQUERADE=y
CONFIG_NETFILTER_SYNPROXY=m
CONFIG_NF_TABLES=m
CONFIG_NF_TABLES_INET=y
CONFIG_NF_TABLES_NETDEV=y
CONFIG_NFT_NUMGEN=m
CONFIG_NFT_CT=m
CONFIG_NFT_FLOW_OFFLOAD=m
CONFIG_NFT_COUNTER=m
CONFIG_NFT_CONNLIMIT=m
CONFIG_NFT_LOG=m
CONFIG_NFT_LIMIT=m
CONFIG_NFT_MASQ=m
CONFIG_NFT_REDIR=m
CONFIG_NFT_NAT=m
# CONFIG_NFT_TUNNEL is not set
CONFIG_NFT_OBJREF=m
CONFIG_NFT_QUEUE=m
CONFIG_NFT_QUOTA=m
CONFIG_NFT_REJECT=m
CONFIG_NFT_REJECT_INET=m
CONFIG_NFT_COMPAT=m
CONFIG_NFT_HASH=m
CONFIG_NFT_FIB=m
CONFIG_NFT_FIB_INET=m
# CONFIG_NFT_XFRM is not set
CONFIG_NFT_SOCKET=m
# CONFIG_NFT_OSF is not set
# CONFIG_NFT_TPROXY is not set
# CONFIG_NFT_SYNPROXY is not set
CONFIG_NF_DUP_NETDEV=m
CONFIG_NFT_DUP_NETDEV=m
CONFIG_NFT_FWD_NETDEV=m
CONFIG_NFT_FIB_NETDEV=m
# CONFIG_NFT_REJECT_NETDEV is not set
CONFIG_NF_FLOW_TABLE_INET=m
CONFIG_NF_FLOW_TABLE=m
CONFIG_NETFILTER_XTABLES=y
CONFIG_NETFILTER_XTABLES_COMPAT=y

#
# Xtables combined modules
#
CONFIG_NETFILTER_XT_MARK=m
CONFIG_NETFILTER_XT_CONNMARK=m
CONFIG_NETFILTER_XT_SET=m

#
# Xtables targets
#
CONFIG_NETFILTER_XT_TARGET_AUDIT=m
CONFIG_NETFILTER_XT_TARGET_CHECKSUM=m
CONFIG_NETFILTER_XT_TARGET_CLASSIFY=m
CONFIG_NETFILTER_XT_TARGET_CONNMARK=m
CONFIG_NETFILTER_XT_TARGET_CONNSECMARK=m
CONFIG_NETFILTER_XT_TARGET_CT=m
CONFIG_NETFILTER_XT_TARGET_DSCP=m
CONFIG_NETFILTER_XT_TARGET_HL=m
CONFIG_NETFILTER_XT_TARGET_HMARK=m
CONFIG_NETFILTER_XT_TARGET_IDLETIMER=m
# CONFIG_NETFILTER_XT_TARGET_LED is not set
CONFIG_NETFILTER_XT_TARGET_LOG=m
CONFIG_NETFILTER_XT_TARGET_MARK=m
CONFIG_NETFILTER_XT_NAT=m
CONFIG_NETFILTER_XT_TARGET_NETMAP=m
CONFIG_NETFILTER_XT_TARGET_NFLOG=m
CONFIG_NETFILTER_XT_TARGET_NFQUEUE=m
CONFIG_NETFILTER_XT_TARGET_NOTRACK=m
CONFIG_NETFILTER_XT_TARGET_RATEEST=m
CONFIG_NETFILTER_XT_TARGET_REDIRECT=m
CONFIG_NETFILTER_XT_TARGET_MASQUERADE=m
CONFIG_NETFILTER_XT_TARGET_TEE=m
CONFIG_NETFILTER_XT_TARGET_TPROXY=m
CONFIG_NETFILTER_XT_TARGET_TRACE=m
CONFIG_NETFILTER_XT_TARGET_SECMARK=m
CONFIG_NETFILTER_XT_TARGET_TCPMSS=m
CONFIG_NETFILTER_XT_TARGET_TCPOPTSTRIP=m

#
# Xtables matches
#
CONFIG_NETFILTER_XT_MATCH_ADDRTYPE=m
CONFIG_NETFILTER_XT_MATCH_BPF=m
CONFIG_NETFILTER_XT_MATCH_CGROUP=m
CONFIG_NETFILTER_XT_MATCH_CLUSTER=m
CONFIG_NETFILTER_XT_MATCH_COMMENT=m
CONFIG_NETFILTER_XT_MATCH_CONNBYTES=m
CONFIG_NETFILTER_XT_MATCH_CONNLABEL=m
CONFIG_NETFILTER_XT_MATCH_CONNLIMIT=m
CONFIG_NETFILTER_XT_MATCH_CONNMARK=m
CONFIG_NETFILTER_XT_MATCH_CONNTRACK=m
CONFIG_NETFILTER_XT_MATCH_CPU=m
CONFIG_NETFILTER_XT_MATCH_DCCP=m
CONFIG_NETFILTER_XT_MATCH_DEVGROUP=m
CONFIG_NETFILTER_XT_MATCH_DSCP=m
CONFIG_NETFILTER_XT_MATCH_ECN=m
CONFIG_NETFILTER_XT_MATCH_ESP=m
CONFIG_NETFILTER_XT_MATCH_HASHLIMIT=m
CONFIG_NETFILTER_XT_MATCH_HELPER=m
CONFIG_NETFILTER_XT_MATCH_HL=m
# CONFIG_NETFILTER_XT_MATCH_IPCOMP is not set
CONFIG_NETFILTER_XT_MATCH_IPRANGE=m
CONFIG_NETFILTER_XT_MATCH_IPVS=m
# CONFIG_NETFILTER_XT_MATCH_L2TP is not set
CONFIG_NETFILTER_XT_MATCH_LENGTH=m
CONFIG_NETFILTER_XT_MATCH_LIMIT=m
CONFIG_NETFILTER_XT_MATCH_MAC=m
CONFIG_NETFILTER_XT_MATCH_MARK=m
CONFIG_NETFILTER_XT_MATCH_MULTIPORT=m
# CONFIG_NETFILTER_XT_MATCH_NFACCT is not set
CONFIG_NETFILTER_XT_MATCH_OSF=m
CONFIG_NETFILTER_XT_MATCH_OWNER=m
CONFIG_NETFILTER_XT_MATCH_POLICY=m
CONFIG_NETFILTER_XT_MATCH_PHYSDEV=m
CONFIG_NETFILTER_XT_MATCH_PKTTYPE=m
CONFIG_NETFILTER_XT_MATCH_QUOTA=m
CONFIG_NETFILTER_XT_MATCH_RATEEST=m
CONFIG_NETFILTER_XT_MATCH_REALM=m
CONFIG_NETFILTER_XT_MATCH_RECENT=m
CONFIG_NETFILTER_XT_MATCH_SCTP=m
CONFIG_NETFILTER_XT_MATCH_SOCKET=m
CONFIG_NETFILTER_XT_MATCH_STATE=m
CONFIG_NETFILTER_XT_MATCH_STATISTIC=m
CONFIG_NETFILTER_XT_MATCH_STRING=m
CONFIG_NETFILTER_XT_MATCH_TCPMSS=m
# CONFIG_NETFILTER_XT_MATCH_TIME is not set
# CONFIG_NETFILTER_XT_MATCH_U32 is not set
# end of Core Netfilter Configuration

CONFIG_IP_SET=m
CONFIG_IP_SET_MAX=256
CONFIG_IP_SET_BITMAP_IP=m
CONFIG_IP_SET_BITMAP_IPMAC=m
CONFIG_IP_SET_BITMAP_PORT=m
CONFIG_IP_SET_HASH_IP=m
CONFIG_IP_SET_HASH_IPMARK=m
CONFIG_IP_SET_HASH_IPPORT=m
CONFIG_IP_SET_HASH_IPPORTIP=m
CONFIG_IP_SET_HASH_IPPORTNET=m
CONFIG_IP_SET_HASH_IPMAC=m
CONFIG_IP_SET_HASH_MAC=m
CONFIG_IP_SET_HASH_NETPORTNET=m
CONFIG_IP_SET_HASH_NET=m
CONFIG_IP_SET_HASH_NETNET=m
CONFIG_IP_SET_HASH_NETPORT=m
CONFIG_IP_SET_HASH_NETIFACE=m
CONFIG_IP_SET_LIST_SET=m
CONFIG_IP_VS=m
CONFIG_IP_VS_IPV6=y
# CONFIG_IP_VS_DEBUG is not set
CONFIG_IP_VS_TAB_BITS=12

#
# IPVS transport protocol load balancing support
#
CONFIG_IP_VS_PROTO_TCP=y
CONFIG_IP_VS_PROTO_UDP=y
CONFIG_IP_VS_PROTO_AH_ESP=y
CONFIG_IP_VS_PROTO_ESP=y
CONFIG_IP_VS_PROTO_AH=y
CONFIG_IP_VS_PROTO_SCTP=y

#
# IPVS scheduler
#
CONFIG_IP_VS_RR=m
CONFIG_IP_VS_WRR=m
CONFIG_IP_VS_LC=m
CONFIG_IP_VS_WLC=m
CONFIG_IP_VS_FO=m
CONFIG_IP_VS_OVF=m
CONFIG_IP_VS_LBLC=m
CONFIG_IP_VS_LBLCR=m
CONFIG_IP_VS_DH=m
CONFIG_IP_VS_SH=m
# CONFIG_IP_VS_MH is not set
CONFIG_IP_VS_SED=m
CONFIG_IP_VS_NQ=m
# CONFIG_IP_VS_TWOS is not set

#
# IPVS SH scheduler
#
CONFIG_IP_VS_SH_TAB_BITS=8

#
# IPVS MH scheduler
#
CONFIG_IP_VS_MH_TAB_INDEX=12

#
# IPVS application helper
#
CONFIG_IP_VS_FTP=m
CONFIG_IP_VS_NFCT=y
CONFIG_IP_VS_PE_SIP=m

#
# IP: Netfilter Configuration
#
CONFIG_NF_DEFRAG_IPV4=m
CONFIG_NF_SOCKET_IPV4=m
CONFIG_NF_TPROXY_IPV4=m
CONFIG_NF_TABLES_IPV4=y
CONFIG_NFT_REJECT_IPV4=m
CONFIG_NFT_DUP_IPV4=m
CONFIG_NFT_FIB_IPV4=m
CONFIG_NF_TABLES_ARP=y
CONFIG_NF_FLOW_TABLE_IPV4=m
CONFIG_NF_DUP_IPV4=m
CONFIG_NF_LOG_ARP=m
CONFIG_NF_LOG_IPV4=m
CONFIG_NF_REJECT_IPV4=m
CONFIG_NF_NAT_SNMP_BASIC=m
CONFIG_NF_NAT_PPTP=m
CONFIG_NF_NAT_H323=m
CONFIG_IP_NF_IPTABLES=m
CONFIG_IP_NF_MATCH_AH=m
CONFIG_IP_NF_MATCH_ECN=m
CONFIG_IP_NF_MATCH_RPFILTER=m
CONFIG_IP_NF_MATCH_TTL=m
CONFIG_IP_NF_FILTER=m
CONFIG_IP_NF_TARGET_REJECT=m
CONFIG_IP_NF_TARGET_SYNPROXY=m
CONFIG_IP_NF_NAT=m
CONFIG_IP_NF_TARGET_MASQUERADE=m
CONFIG_IP_NF_TARGET_NETMAP=m
CONFIG_IP_NF_TARGET_REDIRECT=m
CONFIG_IP_NF_MANGLE=m
# CONFIG_IP_NF_TARGET_CLUSTERIP is not set
CONFIG_IP_NF_TARGET_ECN=m
CONFIG_IP_NF_TARGET_TTL=m
CONFIG_IP_NF_RAW=m
CONFIG_IP_NF_SECURITY=m
CONFIG_IP_NF_ARPTABLES=m
CONFIG_IP_NF_ARPFILTER=m
CONFIG_IP_NF_ARP_MANGLE=m
# end of IP: Netfilter Configuration

#
# IPv6: Netfilter Configuration
#
CONFIG_NF_SOCKET_IPV6=m
CONFIG_NF_TPROXY_IPV6=m
CONFIG_NF_TABLES_IPV6=y
CONFIG_NFT_REJECT_IPV6=m
CONFIG_NFT_DUP_IPV6=m
CONFIG_NFT_FIB_IPV6=m
CONFIG_NF_FLOW_TABLE_IPV6=m
CONFIG_NF_DUP_IPV6=m
CONFIG_NF_REJECT_IPV6=m
CONFIG_NF_LOG_IPV6=m
CONFIG_IP6_NF_IPTABLES=m
CONFIG_IP6_NF_MATCH_AH=m
CONFIG_IP6_NF_MATCH_EUI64=m
CONFIG_IP6_NF_MATCH_FRAG=m
CONFIG_IP6_NF_MATCH_OPTS=m
CONFIG_IP6_NF_MATCH_HL=m
CONFIG_IP6_NF_MATCH_IPV6HEADER=m
CONFIG_IP6_NF_MATCH_MH=m
CONFIG_IP6_NF_MATCH_RPFILTER=m
CONFIG_IP6_NF_MATCH_RT=m
# CONFIG_IP6_NF_MATCH_SRH is not set
# CONFIG_IP6_NF_TARGET_HL is not set
CONFIG_IP6_NF_FILTER=m
CONFIG_IP6_NF_TARGET_REJECT=m
CONFIG_IP6_NF_TARGET_SYNPROXY=m
CONFIG_IP6_NF_MANGLE=m
CONFIG_IP6_NF_RAW=m
CONFIG_IP6_NF_SECURITY=m
CONFIG_IP6_NF_NAT=m
CONFIG_IP6_NF_TARGET_MASQUERADE=m
CONFIG_IP6_NF_TARGET_NPT=m
# end of IPv6: Netfilter Configuration

CONFIG_NF_DEFRAG_IPV6=m
CONFIG_NF_TABLES_BRIDGE=m
# CONFIG_NFT_BRIDGE_META is not set
CONFIG_NFT_BRIDGE_REJECT=m
# CONFIG_NF_CONNTRACK_BRIDGE is not set
CONFIG_BRIDGE_NF_EBTABLES=m
CONFIG_BRIDGE_EBT_BROUTE=m
CONFIG_BRIDGE_EBT_T_FILTER=m
CONFIG_BRIDGE_EBT_T_NAT=m
CONFIG_BRIDGE_EBT_802_3=m
CONFIG_BRIDGE_EBT_AMONG=m
CONFIG_BRIDGE_EBT_ARP=m
CONFIG_BRIDGE_EBT_IP=m
CONFIG_BRIDGE_EBT_IP6=m
CONFIG_BRIDGE_EBT_LIMIT=m
CONFIG_BRIDGE_EBT_MARK=m
CONFIG_BRIDGE_EBT_PKTTYPE=m
CONFIG_BRIDGE_EBT_STP=m
CONFIG_BRIDGE_EBT_VLAN=m
CONFIG_BRIDGE_EBT_ARPREPLY=m
CONFIG_BRIDGE_EBT_DNAT=m
CONFIG_BRIDGE_EBT_MARK_T=m
CONFIG_BRIDGE_EBT_REDIRECT=m
CONFIG_BRIDGE_EBT_SNAT=m
CONFIG_BRIDGE_EBT_LOG=m
CONFIG_BRIDGE_EBT_NFLOG=m
# CONFIG_BPFILTER is not set
# CONFIG_IP_DCCP is not set
CONFIG_IP_SCTP=m
# CONFIG_SCTP_DBG_OBJCNT is not set
# CONFIG_SCTP_DEFAULT_COOKIE_HMAC_MD5 is not set
CONFIG_SCTP_DEFAULT_COOKIE_HMAC_SHA1=y
# CONFIG_SCTP_DEFAULT_COOKIE_HMAC_NONE is not set
CONFIG_SCTP_COOKIE_HMAC_MD5=y
CONFIG_SCTP_COOKIE_HMAC_SHA1=y
CONFIG_INET_SCTP_DIAG=m
# CONFIG_RDS is not set
CONFIG_TIPC=m
CONFIG_TIPC_MEDIA_UDP=y
CONFIG_TIPC_CRYPTO=y
CONFIG_TIPC_DIAG=m
CONFIG_ATM=m
CONFIG_ATM_CLIP=m
# CONFIG_ATM_CLIP_NO_ICMP is not set
CONFIG_ATM_LANE=m
# CONFIG_ATM_MPOA is not set
CONFIG_ATM_BR2684=m
# CONFIG_ATM_BR2684_IPFILTER is not set
CONFIG_L2TP=m
CONFIG_L2TP_DEBUGFS=m
CONFIG_L2TP_V3=y
CONFIG_L2TP_IP=m
CONFIG_L2TP_ETH=m
CONFIG_STP=y
CONFIG_GARP=y
CONFIG_MRP=y
CONFIG_BRIDGE=y
CONFIG_BRIDGE_IGMP_SNOOPING=y
CONFIG_BRIDGE_VLAN_FILTERING=y
# CONFIG_BRIDGE_MRP is not set
# CONFIG_BRIDGE_CFM is not set
# CONFIG_NET_DSA is not set
CONFIG_VLAN_8021Q=y
CONFIG_VLAN_8021Q_GVRP=y
CONFIG_VLAN_8021Q_MVRP=y
# CONFIG_DECNET is not set
CONFIG_LLC=y
# CONFIG_LLC2 is not set
# CONFIG_ATALK is not set
# CONFIG_X25 is not set
# CONFIG_LAPB is not set
# CONFIG_PHONET is not set
CONFIG_6LOWPAN=m
# CONFIG_6LOWPAN_DEBUGFS is not set
# CONFIG_6LOWPAN_NHC is not set
CONFIG_IEEE802154=m
# CONFIG_IEEE802154_NL802154_EXPERIMENTAL is not set
CONFIG_IEEE802154_SOCKET=m
CONFIG_IEEE802154_6LOWPAN=m
CONFIG_MAC802154=m
CONFIG_NET_SCHED=y

#
# Queueing/Scheduling
#
CONFIG_NET_SCH_CBQ=m
CONFIG_NET_SCH_HTB=m
CONFIG_NET_SCH_HFSC=m
CONFIG_NET_SCH_ATM=m
CONFIG_NET_SCH_PRIO=m
CONFIG_NET_SCH_MULTIQ=m
CONFIG_NET_SCH_RED=m
CONFIG_NET_SCH_SFB=m
CONFIG_NET_SCH_SFQ=m
CONFIG_NET_SCH_TEQL=m
CONFIG_NET_SCH_TBF=m
# CONFIG_NET_SCH_CBS is not set
CONFIG_NET_SCH_ETF=m
# CONFIG_NET_SCH_TAPRIO is not set
CONFIG_NET_SCH_GRED=m
CONFIG_NET_SCH_DSMARK=m
CONFIG_NET_SCH_NETEM=y
CONFIG_NET_SCH_DRR=m
CONFIG_NET_SCH_MQPRIO=m
# CONFIG_NET_SCH_SKBPRIO is not set
CONFIG_NET_SCH_CHOKE=m
CONFIG_NET_SCH_QFQ=m
CONFIG_NET_SCH_CODEL=m
CONFIG_NET_SCH_FQ_CODEL=y
# CONFIG_NET_SCH_CAKE is not set
CONFIG_NET_SCH_FQ=m
CONFIG_NET_SCH_HHF=m
CONFIG_NET_SCH_PIE=m
# CONFIG_NET_SCH_FQ_PIE is not set
CONFIG_NET_SCH_INGRESS=y
CONFIG_NET_SCH_PLUG=m
CONFIG_NET_SCH_ETS=m
CONFIG_NET_SCH_DEFAULT=y
# CONFIG_DEFAULT_FQ is not set
# CONFIG_DEFAULT_CODEL is not set
CONFIG_DEFAULT_FQ_CODEL=y
# CONFIG_DEFAULT_SFQ is not set
# CONFIG_DEFAULT_PFIFO_FAST is not set
CONFIG_DEFAULT_NET_SCH="fq_codel"

#
# Classification
#
CONFIG_NET_CLS=y
CONFIG_NET_CLS_BASIC=m
CONFIG_NET_CLS_TCINDEX=m
CONFIG_NET_CLS_ROUTE4=m
CONFIG_NET_CLS_FW=m
CONFIG_NET_CLS_U32=m
CONFIG_CLS_U32_PERF=y
CONFIG_CLS_U32_MARK=y
CONFIG_NET_CLS_RSVP=m
CONFIG_NET_CLS_RSVP6=m
CONFIG_NET_CLS_FLOW=m
CONFIG_NET_CLS_CGROUP=y
CONFIG_NET_CLS_BPF=m
CONFIG_NET_CLS_FLOWER=m
CONFIG_NET_CLS_MATCHALL=m
CONFIG_NET_EMATCH=y
CONFIG_NET_EMATCH_STACK=32
CONFIG_NET_EMATCH_CMP=m
CONFIG_NET_EMATCH_NBYTE=m
CONFIG_NET_EMATCH_U32=m
CONFIG_NET_EMATCH_META=m
CONFIG_NET_EMATCH_TEXT=m
CONFIG_NET_EMATCH_CANID=m
CONFIG_NET_EMATCH_IPSET=m
CONFIG_NET_EMATCH_IPT=m
CONFIG_NET_CLS_ACT=y
CONFIG_NET_ACT_POLICE=m
CONFIG_NET_ACT_GACT=m
CONFIG_GACT_PROB=y
CONFIG_NET_ACT_MIRRED=m
CONFIG_NET_ACT_SAMPLE=m
CONFIG_NET_ACT_IPT=m
CONFIG_NET_ACT_NAT=m
CONFIG_NET_ACT_PEDIT=m
CONFIG_NET_ACT_SIMP=m
CONFIG_NET_ACT_SKBEDIT=m
CONFIG_NET_ACT_CSUM=m
CONFIG_NET_ACT_MPLS=m
CONFIG_NET_ACT_VLAN=m
CONFIG_NET_ACT_BPF=m
CONFIG_NET_ACT_CONNMARK=m
CONFIG_NET_ACT_CTINFO=m
CONFIG_NET_ACT_SKBMOD=m
CONFIG_NET_ACT_IFE=m
CONFIG_NET_ACT_TUNNEL_KEY=m
CONFIG_NET_ACT_CT=m
# CONFIG_NET_ACT_GATE is not set
CONFIG_NET_IFE_SKBMARK=m
CONFIG_NET_IFE_SKBPRIO=m
CONFIG_NET_IFE_SKBTCINDEX=m
# CONFIG_NET_TC_SKB_EXT is not set
CONFIG_NET_SCH_FIFO=y
CONFIG_DCB=y
CONFIG_DNS_RESOLVER=m
# CONFIG_BATMAN_ADV is not set
CONFIG_OPENVSWITCH=m
CONFIG_OPENVSWITCH_GRE=m
CONFIG_OPENVSWITCH_VXLAN=m
CONFIG_OPENVSWITCH_GENEVE=m
CONFIG_VSOCKETS=m
CONFIG_VSOCKETS_DIAG=m
CONFIG_VSOCKETS_LOOPBACK=m
CONFIG_VMWARE_VMCI_VSOCKETS=m
CONFIG_VIRTIO_VSOCKETS=m
CONFIG_VIRTIO_VSOCKETS_COMMON=m
CONFIG_HYPERV_VSOCKETS=m
CONFIG_NETLINK_DIAG=m
CONFIG_MPLS=y
CONFIG_NET_MPLS_GSO=m
CONFIG_MPLS_ROUTING=m
CONFIG_MPLS_IPTUNNEL=m
CONFIG_NET_NSH=y
# CONFIG_HSR is not set
CONFIG_NET_SWITCHDEV=y
CONFIG_NET_L3_MASTER_DEV=y
# CONFIG_QRTR is not set
# CONFIG_NET_NCSI is not set
CONFIG_PCPU_DEV_REFCNT=y
CONFIG_RPS=y
CONFIG_RFS_ACCEL=y
CONFIG_SOCK_RX_QUEUE_MAPPING=y
CONFIG_XPS=y
CONFIG_CGROUP_NET_PRIO=y
CONFIG_CGROUP_NET_CLASSID=y
CONFIG_NET_RX_BUSY_POLL=y
CONFIG_BQL=y
CONFIG_BPF_STREAM_PARSER=y
CONFIG_NET_FLOW_LIMIT=y

#
# Network testing
#
CONFIG_NET_PKTGEN=m
CONFIG_NET_DROP_MONITOR=y
# end of Network testing
# end of Networking options

# CONFIG_HAMRADIO is not set
CONFIG_CAN=m
CONFIG_CAN_RAW=m
CONFIG_CAN_BCM=m
CONFIG_CAN_GW=m
# CONFIG_CAN_J1939 is not set
# CONFIG_CAN_ISOTP is not set

#
# CAN Device Drivers
#
CONFIG_CAN_VCAN=m
# CONFIG_CAN_VXCAN is not set
CONFIG_CAN_SLCAN=m
CONFIG_CAN_DEV=m
CONFIG_CAN_CALC_BITTIMING=y
# CONFIG_CAN_KVASER_PCIEFD is not set
CONFIG_CAN_C_CAN=m
CONFIG_CAN_C_CAN_PLATFORM=m
CONFIG_CAN_C_CAN_PCI=m
CONFIG_CAN_CC770=m
# CONFIG_CAN_CC770_ISA is not set
CONFIG_CAN_CC770_PLATFORM=m
# CONFIG_CAN_IFI_CANFD is not set
# CONFIG_CAN_M_CAN is not set
# CONFIG_CAN_PEAK_PCIEFD is not set
CONFIG_CAN_SJA1000=m
CONFIG_CAN_EMS_PCI=m
# CONFIG_CAN_F81601 is not set
CONFIG_CAN_KVASER_PCI=m
CONFIG_CAN_PEAK_PCI=m
CONFIG_CAN_PEAK_PCIEC=y
CONFIG_CAN_PLX_PCI=m
# CONFIG_CAN_SJA1000_ISA is not set
CONFIG_CAN_SJA1000_PLATFORM=m
CONFIG_CAN_SOFTING=m

#
# CAN SPI interfaces
#
# CONFIG_CAN_HI311X is not set
# CONFIG_CAN_MCP251X is not set
# CONFIG_CAN_MCP251XFD is not set
# end of CAN SPI interfaces

#
# CAN USB interfaces
#
# CONFIG_CAN_8DEV_USB is not set
# CONFIG_CAN_EMS_USB is not set
# CONFIG_CAN_ESD_USB2 is not set
# CONFIG_CAN_ETAS_ES58X is not set
# CONFIG_CAN_GS_USB is not set
# CONFIG_CAN_KVASER_USB is not set
# CONFIG_CAN_MCBA_USB is not set
# CONFIG_CAN_PEAK_USB is not set
# CONFIG_CAN_UCAN is not set
# end of CAN USB interfaces

# CONFIG_CAN_DEBUG_DEVICES is not set
# end of CAN Device Drivers

CONFIG_BT=m
CONFIG_BT_BREDR=y
CONFIG_BT_RFCOMM=m
CONFIG_BT_RFCOMM_TTY=y
CONFIG_BT_BNEP=m
CONFIG_BT_BNEP_MC_FILTER=y
CONFIG_BT_BNEP_PROTO_FILTER=y
CONFIG_BT_HIDP=m
CONFIG_BT_HS=y
CONFIG_BT_LE=y
# CONFIG_BT_6LOWPAN is not set
# CONFIG_BT_LEDS is not set
# CONFIG_BT_MSFTEXT is not set
# CONFIG_BT_AOSPEXT is not set
CONFIG_BT_DEBUGFS=y
# CONFIG_BT_SELFTEST is not set

#
# Bluetooth device drivers
#
# CONFIG_BT_HCIBTUSB is not set
# CONFIG_BT_HCIBTSDIO is not set
CONFIG_BT_HCIUART=m
CONFIG_BT_HCIUART_H4=y
CONFIG_BT_HCIUART_BCSP=y
CONFIG_BT_HCIUART_ATH3K=y
# CONFIG_BT_HCIUART_INTEL is not set
# CONFIG_BT_HCIUART_AG6XX is not set
# CONFIG_BT_HCIBCM203X is not set
# CONFIG_BT_HCIBPA10X is not set
# CONFIG_BT_HCIBFUSB is not set
CONFIG_BT_HCIVHCI=m
CONFIG_BT_MRVL=m
# CONFIG_BT_MRVL_SDIO is not set
# CONFIG_BT_MTKSDIO is not set
# CONFIG_BT_VIRTIO is not set
# end of Bluetooth device drivers

# CONFIG_AF_RXRPC is not set
# CONFIG_AF_KCM is not set
CONFIG_STREAM_PARSER=y
CONFIG_FIB_RULES=y
CONFIG_WIRELESS=y
CONFIG_CFG80211=m
# CONFIG_NL80211_TESTMODE is not set
# CONFIG_CFG80211_DEVELOPER_WARNINGS is not set
# CONFIG_CFG80211_CERTIFICATION_ONUS is not set
CONFIG_CFG80211_REQUIRE_SIGNED_REGDB=y
CONFIG_CFG80211_USE_KERNEL_REGDB_KEYS=y
CONFIG_CFG80211_DEFAULT_PS=y
# CONFIG_CFG80211_DEBUGFS is not set
CONFIG_CFG80211_CRDA_SUPPORT=y
# CONFIG_CFG80211_WEXT is not set
CONFIG_MAC80211=m
CONFIG_MAC80211_HAS_RC=y
CONFIG_MAC80211_RC_MINSTREL=y
CONFIG_MAC80211_RC_DEFAULT_MINSTREL=y
CONFIG_MAC80211_RC_DEFAULT="minstrel_ht"
# CONFIG_MAC80211_MESH is not set
CONFIG_MAC80211_LEDS=y
CONFIG_MAC80211_DEBUGFS=y
# CONFIG_MAC80211_MESSAGE_TRACING is not set
# CONFIG_MAC80211_DEBUG_MENU is not set
CONFIG_MAC80211_STA_HASH_MAX_SIZE=0
CONFIG_RFKILL=m
CONFIG_RFKILL_LEDS=y
CONFIG_RFKILL_INPUT=y
# CONFIG_RFKILL_GPIO is not set
CONFIG_NET_9P=y
CONFIG_NET_9P_VIRTIO=y
# CONFIG_NET_9P_XEN is not set
# CONFIG_NET_9P_DEBUG is not set
# CONFIG_CAIF is not set
CONFIG_CEPH_LIB=m
# CONFIG_CEPH_LIB_PRETTYDEBUG is not set
CONFIG_CEPH_LIB_USE_DNS_RESOLVER=y
# CONFIG_NFC is not set
CONFIG_PSAMPLE=m
CONFIG_NET_IFE=m
CONFIG_LWTUNNEL=y
CONFIG_LWTUNNEL_BPF=y
CONFIG_DST_CACHE=y
CONFIG_GRO_CELLS=y
CONFIG_SOCK_VALIDATE_XMIT=y
CONFIG_NET_SELFTESTS=y
CONFIG_NET_SOCK_MSG=y
CONFIG_NET_DEVLINK=y
CONFIG_PAGE_POOL=y
CONFIG_FAILOVER=m
CONFIG_ETHTOOL_NETLINK=y

#
# Device Drivers
#
CONFIG_HAVE_EISA=y
# CONFIG_EISA is not set
CONFIG_HAVE_PCI=y
CONFIG_PCI=y
CONFIG_PCI_DOMAINS=y
CONFIG_PCIEPORTBUS=y
CONFIG_HOTPLUG_PCI_PCIE=y
CONFIG_PCIEAER=y
CONFIG_PCIEAER_INJECT=m
CONFIG_PCIE_ECRC=y
CONFIG_PCIEASPM=y
CONFIG_PCIEASPM_DEFAULT=y
# CONFIG_PCIEASPM_POWERSAVE is not set
# CONFIG_PCIEASPM_POWER_SUPERSAVE is not set
# CONFIG_PCIEASPM_PERFORMANCE is not set
CONFIG_PCIE_PME=y
CONFIG_PCIE_DPC=y
# CONFIG_PCIE_PTM is not set
# CONFIG_PCIE_EDR is not set
CONFIG_PCI_MSI=y
CONFIG_PCI_MSI_IRQ_DOMAIN=y
CONFIG_PCI_QUIRKS=y
# CONFIG_PCI_DEBUG is not set
# CONFIG_PCI_REALLOC_ENABLE_AUTO is not set
CONFIG_PCI_STUB=y
CONFIG_PCI_PF_STUB=m
# CONFIG_XEN_PCIDEV_FRONTEND is not set
CONFIG_PCI_ATS=y
CONFIG_PCI_LOCKLESS_CONFIG=y
CONFIG_PCI_IOV=y
CONFIG_PCI_PRI=y
CONFIG_PCI_PASID=y
# CONFIG_PCI_P2PDMA is not set
CONFIG_PCI_LABEL=y
CONFIG_PCI_HYPERV=m
# CONFIG_PCIE_BUS_TUNE_OFF is not set
CONFIG_PCIE_BUS_DEFAULT=y
# CONFIG_PCIE_BUS_SAFE is not set
# CONFIG_PCIE_BUS_PERFORMANCE is not set
# CONFIG_PCIE_BUS_PEER2PEER is not set
CONFIG_HOTPLUG_PCI=y
CONFIG_HOTPLUG_PCI_ACPI=y
CONFIG_HOTPLUG_PCI_ACPI_IBM=m
# CONFIG_HOTPLUG_PCI_CPCI is not set
CONFIG_HOTPLUG_PCI_SHPC=y

#
# PCI controller drivers
#
CONFIG_VMD=y
CONFIG_PCI_HYPERV_INTERFACE=m

#
# DesignWare PCI Core Support
#
# CONFIG_PCIE_DW_PLAT_HOST is not set
# CONFIG_PCI_MESON is not set
# end of DesignWare PCI Core Support

#
# Mobiveil PCIe Core Support
#
# end of Mobiveil PCIe Core Support

#
# Cadence PCIe controllers support
#
# end of Cadence PCIe controllers support
# end of PCI controller drivers

#
# PCI Endpoint
#
# CONFIG_PCI_ENDPOINT is not set
# end of PCI Endpoint

#
# PCI switch controller drivers
#
# CONFIG_PCI_SW_SWITCHTEC is not set
# end of PCI switch controller drivers

# CONFIG_CXL_BUS is not set
# CONFIG_PCCARD is not set
# CONFIG_RAPIDIO is not set

#
# Generic Driver Options
#
# CONFIG_UEVENT_HELPER is not set
CONFIG_DEVTMPFS=y
CONFIG_DEVTMPFS_MOUNT=y
CONFIG_STANDALONE=y
CONFIG_PREVENT_FIRMWARE_BUILD=y

#
# Firmware loader
#
CONFIG_FW_LOADER=y
CONFIG_FW_LOADER_PAGED_BUF=y
CONFIG_EXTRA_FIRMWARE=""
CONFIG_FW_LOADER_USER_HELPER=y
# CONFIG_FW_LOADER_USER_HELPER_FALLBACK is not set
# CONFIG_FW_LOADER_COMPRESS is not set
CONFIG_FW_CACHE=y
# end of Firmware loader

CONFIG_ALLOW_DEV_COREDUMP=y
# CONFIG_DEBUG_DRIVER is not set
# CONFIG_DEBUG_DEVRES is not set
# CONFIG_DEBUG_TEST_DRIVER_REMOVE is not set
# CONFIG_TEST_ASYNC_DRIVER_PROBE is not set
CONFIG_SYS_HYPERVISOR=y
CONFIG_GENERIC_CPU_AUTOPROBE=y
CONFIG_GENERIC_CPU_VULNERABILITIES=y
CONFIG_REGMAP=y
CONFIG_REGMAP_I2C=m
CONFIG_REGMAP_SPI=m
CONFIG_DMA_SHARED_BUFFER=y
# CONFIG_DMA_FENCE_TRACE is not set
# end of Generic Driver Options

#
# Bus devices
#
# CONFIG_MHI_BUS is not set
# end of Bus devices

CONFIG_CONNECTOR=y
CONFIG_PROC_EVENTS=y
# CONFIG_GNSS is not set
# CONFIG_MTD is not set
# CONFIG_OF is not set
CONFIG_ARCH_MIGHT_HAVE_PC_PARPORT=y
CONFIG_PARPORT=m
CONFIG_PARPORT_PC=m
CONFIG_PARPORT_SERIAL=m
# CONFIG_PARPORT_PC_FIFO is not set
# CONFIG_PARPORT_PC_SUPERIO is not set
# CONFIG_PARPORT_AX88796 is not set
CONFIG_PARPORT_1284=y
CONFIG_PNP=y
# CONFIG_PNP_DEBUG_MESSAGES is not set

#
# Protocols
#
CONFIG_PNPACPI=y
CONFIG_BLK_DEV=y
CONFIG_BLK_DEV_NULL_BLK=m
# CONFIG_BLK_DEV_FD is not set
CONFIG_CDROM=m
# CONFIG_PARIDE is not set
# CONFIG_BLK_DEV_PCIESSD_MTIP32XX is not set
CONFIG_ZRAM=m
CONFIG_ZRAM_DEF_COMP_LZORLE=y
# CONFIG_ZRAM_DEF_COMP_LZO is not set
CONFIG_ZRAM_DEF_COMP="lzo-rle"
CONFIG_ZRAM_WRITEBACK=y
# CONFIG_ZRAM_MEMORY_TRACKING is not set
CONFIG_BLK_DEV_LOOP=m
CONFIG_BLK_DEV_LOOP_MIN_COUNT=0
# CONFIG_BLK_DEV_CRYPTOLOOP is not set
# CONFIG_BLK_DEV_DRBD is not set
CONFIG_BLK_DEV_NBD=m
# CONFIG_BLK_DEV_SX8 is not set
CONFIG_BLK_DEV_RAM=m
CONFIG_BLK_DEV_RAM_COUNT=16
CONFIG_BLK_DEV_RAM_SIZE=16384
CONFIG_CDROM_PKTCDVD=m
CONFIG_CDROM_PKTCDVD_BUFFERS=8
# CONFIG_CDROM_PKTCDVD_WCACHE is not set
# CONFIG_ATA_OVER_ETH is not set
CONFIG_XEN_BLKDEV_FRONTEND=m
CONFIG_VIRTIO_BLK=m
CONFIG_BLK_DEV_RBD=m
# CONFIG_BLK_DEV_RSXX is not set

#
# NVME Support
#
CONFIG_NVME_CORE=m
CONFIG_BLK_DEV_NVME=m
CONFIG_NVME_MULTIPATH=y
# CONFIG_NVME_HWMON is not set
CONFIG_NVME_FABRICS=m
CONFIG_NVME_FC=m
# CONFIG_NVME_TCP is not set
CONFIG_NVME_TARGET=m
# CONFIG_NVME_TARGET_PASSTHRU is not set
CONFIG_NVME_TARGET_LOOP=m
CONFIG_NVME_TARGET_FC=m
CONFIG_NVME_TARGET_FCLOOP=m
# CONFIG_NVME_TARGET_TCP is not set
# end of NVME Support

#
# Misc devices
#
CONFIG_SENSORS_LIS3LV02D=m
# CONFIG_AD525X_DPOT is not set
# CONFIG_DUMMY_IRQ is not set
# CONFIG_IBM_ASM is not set
# CONFIG_PHANTOM is not set
CONFIG_TIFM_CORE=m
CONFIG_TIFM_7XX1=m
# CONFIG_ICS932S401 is not set
CONFIG_ENCLOSURE_SERVICES=m
CONFIG_SGI_XP=m
CONFIG_HP_ILO=m
CONFIG_SGI_GRU=m
# CONFIG_SGI_GRU_DEBUG is not set
CONFIG_APDS9802ALS=m
CONFIG_ISL29003=m
CONFIG_ISL29020=m
CONFIG_SENSORS_TSL2550=m
CONFIG_SENSORS_BH1770=m
CONFIG_SENSORS_APDS990X=m
# CONFIG_HMC6352 is not set
# CONFIG_DS1682 is not set
CONFIG_VMWARE_BALLOON=m
# CONFIG_LATTICE_ECP3_CONFIG is not set
# CONFIG_SRAM is not set
# CONFIG_DW_XDATA_PCIE is not set
# CONFIG_PCI_ENDPOINT_TEST is not set
# CONFIG_XILINX_SDFEC is not set
CONFIG_MISC_RTSX=m
# CONFIG_C2PORT is not set

#
# EEPROM support
#
# CONFIG_EEPROM_AT24 is not set
# CONFIG_EEPROM_AT25 is not set
CONFIG_EEPROM_LEGACY=m
CONFIG_EEPROM_MAX6875=m
CONFIG_EEPROM_93CX6=m
# CONFIG_EEPROM_93XX46 is not set
# CONFIG_EEPROM_IDT_89HPESX is not set
# CONFIG_EEPROM_EE1004 is not set
# end of EEPROM support

CONFIG_CB710_CORE=m
# CONFIG_CB710_DEBUG is not set
CONFIG_CB710_DEBUG_ASSUMPTIONS=y

#
# Texas Instruments shared transport line discipline
#
# CONFIG_TI_ST is not set
# end of Texas Instruments shared transport line discipline

CONFIG_SENSORS_LIS3_I2C=m
CONFIG_ALTERA_STAPL=m
CONFIG_INTEL_MEI=m
CONFIG_INTEL_MEI_ME=m
# CONFIG_INTEL_MEI_TXE is not set
# CONFIG_INTEL_MEI_HDCP is not set
CONFIG_VMWARE_VMCI=m
# CONFIG_GENWQE is not set
# CONFIG_ECHO is not set
# CONFIG_BCM_VK is not set
# CONFIG_MISC_ALCOR_PCI is not set
CONFIG_MISC_RTSX_PCI=m
# CONFIG_MISC_RTSX_USB is not set
# CONFIG_HABANA_AI is not set
# CONFIG_UACCE is not set
CONFIG_PVPANIC=y
# CONFIG_PVPANIC_MMIO is not set
# CONFIG_PVPANIC_PCI is not set
# end of Misc devices

CONFIG_HAVE_IDE=y
# CONFIG_IDE is not set

#
# SCSI device support
#
CONFIG_SCSI_MOD=y
CONFIG_RAID_ATTRS=m
CONFIG_SCSI=y
CONFIG_SCSI_DMA=y
CONFIG_SCSI_NETLINK=y
CONFIG_SCSI_PROC_FS=y

#
# SCSI support type (disk, tape, CD-ROM)
#
CONFIG_BLK_DEV_SD=m
CONFIG_CHR_DEV_ST=m
CONFIG_BLK_DEV_SR=m
CONFIG_CHR_DEV_SG=m
CONFIG_CHR_DEV_SCH=m
CONFIG_SCSI_ENCLOSURE=m
CONFIG_SCSI_CONSTANTS=y
CONFIG_SCSI_LOGGING=y
CONFIG_SCSI_SCAN_ASYNC=y

#
# SCSI Transports
#
CONFIG_SCSI_SPI_ATTRS=m
CONFIG_SCSI_FC_ATTRS=m
CONFIG_SCSI_ISCSI_ATTRS=m
CONFIG_SCSI_SAS_ATTRS=m
CONFIG_SCSI_SAS_LIBSAS=m
CONFIG_SCSI_SAS_ATA=y
CONFIG_SCSI_SAS_HOST_SMP=y
CONFIG_SCSI_SRP_ATTRS=m
# end of SCSI Transports

CONFIG_SCSI_LOWLEVEL=y
# CONFIG_ISCSI_TCP is not set
# CONFIG_ISCSI_BOOT_SYSFS is not set
# CONFIG_SCSI_CXGB3_ISCSI is not set
# CONFIG_SCSI_CXGB4_ISCSI is not set
# CONFIG_SCSI_BNX2_ISCSI is not set
# CONFIG_BE2ISCSI is not set
# CONFIG_BLK_DEV_3W_XXXX_RAID is not set
# CONFIG_SCSI_HPSA is not set
# CONFIG_SCSI_3W_9XXX is not set
# CONFIG_SCSI_3W_SAS is not set
# CONFIG_SCSI_ACARD is not set
# CONFIG_SCSI_AACRAID is not set
# CONFIG_SCSI_AIC7XXX is not set
# CONFIG_SCSI_AIC79XX is not set
# CONFIG_SCSI_AIC94XX is not set
# CONFIG_SCSI_MVSAS is not set
# CONFIG_SCSI_MVUMI is not set
# CONFIG_SCSI_DPT_I2O is not set
# CONFIG_SCSI_ADVANSYS is not set
# CONFIG_SCSI_ARCMSR is not set
# CONFIG_SCSI_ESAS2R is not set
# CONFIG_MEGARAID_NEWGEN is not set
# CONFIG_MEGARAID_LEGACY is not set
# CONFIG_MEGARAID_SAS is not set
CONFIG_SCSI_MPT3SAS=m
CONFIG_SCSI_MPT2SAS_MAX_SGE=128
CONFIG_SCSI_MPT3SAS_MAX_SGE=128
# CONFIG_SCSI_MPT2SAS is not set
# CONFIG_SCSI_SMARTPQI is not set
# CONFIG_SCSI_UFSHCD is not set
# CONFIG_SCSI_HPTIOP is not set
# CONFIG_SCSI_BUSLOGIC is not set
# CONFIG_SCSI_MYRB is not set
# CONFIG_SCSI_MYRS is not set
# CONFIG_VMWARE_PVSCSI is not set
# CONFIG_XEN_SCSI_FRONTEND is not set
CONFIG_HYPERV_STORAGE=m
# CONFIG_LIBFC is not set
# CONFIG_SCSI_SNIC is not set
# CONFIG_SCSI_DMX3191D is not set
# CONFIG_SCSI_FDOMAIN_PCI is not set
CONFIG_SCSI_ISCI=m
# CONFIG_SCSI_IPS is not set
# CONFIG_SCSI_INITIO is not set
# CONFIG_SCSI_INIA100 is not set
# CONFIG_SCSI_PPA is not set
# CONFIG_SCSI_IMM is not set
# CONFIG_SCSI_STEX is not set
# CONFIG_SCSI_SYM53C8XX_2 is not set
# CONFIG_SCSI_IPR is not set
# CONFIG_SCSI_QLOGIC_1280 is not set
# CONFIG_SCSI_QLA_FC is not set
# CONFIG_SCSI_QLA_ISCSI is not set
# CONFIG_SCSI_LPFC is not set
# CONFIG_SCSI_DC395x is not set
# CONFIG_SCSI_AM53C974 is not set
# CONFIG_SCSI_WD719X is not set
# CONFIG_SCSI_DEBUG is not set
# CONFIG_SCSI_PMCRAID is not set
# CONFIG_SCSI_PM8001 is not set
# CONFIG_SCSI_BFA_FC is not set
# CONFIG_SCSI_VIRTIO is not set
# CONFIG_SCSI_CHELSIO_FCOE is not set
CONFIG_SCSI_DH=y
CONFIG_SCSI_DH_RDAC=y
CONFIG_SCSI_DH_HP_SW=y
CONFIG_SCSI_DH_EMC=y
CONFIG_SCSI_DH_ALUA=y
# end of SCSI device support

CONFIG_ATA=m
CONFIG_SATA_HOST=y
CONFIG_PATA_TIMINGS=y
CONFIG_ATA_VERBOSE_ERROR=y
CONFIG_ATA_FORCE=y
CONFIG_ATA_ACPI=y
# CONFIG_SATA_ZPODD is not set
CONFIG_SATA_PMP=y

#
# Controllers with non-SFF native interface
#
CONFIG_SATA_AHCI=m
CONFIG_SATA_MOBILE_LPM_POLICY=0
CONFIG_SATA_AHCI_PLATFORM=m
# CONFIG_SATA_INIC162X is not set
# CONFIG_SATA_ACARD_AHCI is not set
# CONFIG_SATA_SIL24 is not set
CONFIG_ATA_SFF=y

#
# SFF controllers with custom DMA interface
#
# CONFIG_PDC_ADMA is not set
# CONFIG_SATA_QSTOR is not set
# CONFIG_SATA_SX4 is not set
CONFIG_ATA_BMDMA=y

#
# SATA SFF controllers with BMDMA
#
CONFIG_ATA_PIIX=m
# CONFIG_SATA_DWC is not set
# CONFIG_SATA_MV is not set
# CONFIG_SATA_NV is not set
# CONFIG_SATA_PROMISE is not set
# CONFIG_SATA_SIL is not set
# CONFIG_SATA_SIS is not set
# CONFIG_SATA_SVW is not set
# CONFIG_SATA_ULI is not set
# CONFIG_SATA_VIA is not set
# CONFIG_SATA_VITESSE is not set

#
# PATA SFF controllers with BMDMA
#
# CONFIG_PATA_ALI is not set
# CONFIG_PATA_AMD is not set
# CONFIG_PATA_ARTOP is not set
# CONFIG_PATA_ATIIXP is not set
# CONFIG_PATA_ATP867X is not set
# CONFIG_PATA_CMD64X is not set
# CONFIG_PATA_CYPRESS is not set
# CONFIG_PATA_EFAR is not set
# CONFIG_PATA_HPT366 is not set
# CONFIG_PATA_HPT37X is not set
# CONFIG_PATA_HPT3X2N is not set
# CONFIG_PATA_HPT3X3 is not set
# CONFIG_PATA_IT8213 is not set
# CONFIG_PATA_IT821X is not set
# CONFIG_PATA_JMICRON is not set
# CONFIG_PATA_MARVELL is not set
# CONFIG_PATA_NETCELL is not set
# CONFIG_PATA_NINJA32 is not set
# CONFIG_PATA_NS87415 is not set
# CONFIG_PATA_OLDPIIX is not set
# CONFIG_PATA_OPTIDMA is not set
# CONFIG_PATA_PDC2027X is not set
# CONFIG_PATA_PDC_OLD is not set
# CONFIG_PATA_RADISYS is not set
# CONFIG_PATA_RDC is not set
# CONFIG_PATA_SCH is not set
# CONFIG_PATA_SERVERWORKS is not set
# CONFIG_PATA_SIL680 is not set
# CONFIG_PATA_SIS is not set
# CONFIG_PATA_TOSHIBA is not set
# CONFIG_PATA_TRIFLEX is not set
# CONFIG_PATA_VIA is not set
# CONFIG_PATA_WINBOND is not set

#
# PIO-only SFF controllers
#
# CONFIG_PATA_CMD640_PCI is not set
# CONFIG_PATA_MPIIX is not set
# CONFIG_PATA_NS87410 is not set
# CONFIG_PATA_OPTI is not set
# CONFIG_PATA_PLATFORM is not set
# CONFIG_PATA_RZ1000 is not set

#
# Generic fallback / legacy drivers
#
# CONFIG_PATA_ACPI is not set
CONFIG_ATA_GENERIC=m
# CONFIG_PATA_LEGACY is not set
CONFIG_MD=y
CONFIG_BLK_DEV_MD=y
CONFIG_MD_AUTODETECT=y
CONFIG_MD_LINEAR=m
CONFIG_MD_RAID0=m
CONFIG_MD_RAID1=m
CONFIG_MD_RAID10=m
CONFIG_MD_RAID456=m
# CONFIG_MD_MULTIPATH is not set
CONFIG_MD_FAULTY=m
CONFIG_MD_CLUSTER=m
# CONFIG_BCACHE is not set
CONFIG_BLK_DEV_DM_BUILTIN=y
CONFIG_BLK_DEV_DM=m
CONFIG_DM_DEBUG=y
CONFIG_DM_BUFIO=m
# CONFIG_DM_DEBUG_BLOCK_MANAGER_LOCKING is not set
CONFIG_DM_BIO_PRISON=m
CONFIG_DM_PERSISTENT_DATA=m
# CONFIG_DM_UNSTRIPED is not set
CONFIG_DM_CRYPT=m
CONFIG_DM_SNAPSHOT=m
CONFIG_DM_THIN_PROVISIONING=m
CONFIG_DM_CACHE=m
CONFIG_DM_CACHE_SMQ=m
CONFIG_DM_WRITECACHE=m
# CONFIG_DM_EBS is not set
CONFIG_DM_ERA=m
# CONFIG_DM_CLONE is not set
CONFIG_DM_MIRROR=m
CONFIG_DM_LOG_USERSPACE=m
CONFIG_DM_RAID=m
CONFIG_DM_ZERO=m
CONFIG_DM_MULTIPATH=m
CONFIG_DM_MULTIPATH_QL=m
CONFIG_DM_MULTIPATH_ST=m
# CONFIG_DM_MULTIPATH_HST is not set
# CONFIG_DM_MULTIPATH_IOA is not set
CONFIG_DM_DELAY=m
# CONFIG_DM_DUST is not set
CONFIG_DM_UEVENT=y
CONFIG_DM_FLAKEY=m
CONFIG_DM_VERITY=m
# CONFIG_DM_VERITY_VERIFY_ROOTHASH_SIG is not set
# CONFIG_DM_VERITY_FEC is not set
CONFIG_DM_SWITCH=m
CONFIG_DM_LOG_WRITES=m
CONFIG_DM_INTEGRITY=m
CONFIG_TARGET_CORE=m
CONFIG_TCM_IBLOCK=m
CONFIG_TCM_FILEIO=m
CONFIG_TCM_PSCSI=m
CONFIG_TCM_USER2=m
CONFIG_LOOPBACK_TARGET=m
CONFIG_ISCSI_TARGET=m
# CONFIG_SBP_TARGET is not set
# CONFIG_FUSION is not set

#
# IEEE 1394 (FireWire) support
#
CONFIG_FIREWIRE=m
CONFIG_FIREWIRE_OHCI=m
CONFIG_FIREWIRE_SBP2=m
CONFIG_FIREWIRE_NET=m
# CONFIG_FIREWIRE_NOSY is not set
# end of IEEE 1394 (FireWire) support

CONFIG_MACINTOSH_DRIVERS=y
CONFIG_MAC_EMUMOUSEBTN=y
CONFIG_NETDEVICES=y
CONFIG_MII=y
CONFIG_NET_CORE=y
# CONFIG_BONDING is not set
CONFIG_DUMMY=y
# CONFIG_WIREGUARD is not set
# CONFIG_EQUALIZER is not set
# CONFIG_NET_FC is not set
CONFIG_IFB=y
# CONFIG_NET_TEAM is not set
# CONFIG_MACVLAN is not set
# CONFIG_IPVLAN is not set
CONFIG_VXLAN=y
CONFIG_GENEVE=y
CONFIG_BAREUDP=m
# CONFIG_GTP is not set
CONFIG_MACSEC=y
CONFIG_NETCONSOLE=m
CONFIG_NETCONSOLE_DYNAMIC=y
CONFIG_NETPOLL=y
CONFIG_NET_POLL_CONTROLLER=y
CONFIG_TUN=m
# CONFIG_TUN_VNET_CROSS_LE is not set
CONFIG_VETH=y
CONFIG_VIRTIO_NET=m
# CONFIG_NLMON is not set
CONFIG_NET_VRF=y
# CONFIG_VSOCKMON is not set
# CONFIG_ARCNET is not set
CONFIG_ATM_DRIVERS=y
# CONFIG_ATM_DUMMY is not set
# CONFIG_ATM_TCP is not set
# CONFIG_ATM_LANAI is not set
# CONFIG_ATM_ENI is not set
# CONFIG_ATM_FIRESTREAM is not set
# CONFIG_ATM_ZATM is not set
# CONFIG_ATM_NICSTAR is not set
# CONFIG_ATM_IDT77252 is not set
# CONFIG_ATM_AMBASSADOR is not set
# CONFIG_ATM_HORIZON is not set
# CONFIG_ATM_IA is not set
# CONFIG_ATM_FORE200E is not set
# CONFIG_ATM_HE is not set
# CONFIG_ATM_SOLOS is not set
CONFIG_ETHERNET=y
CONFIG_MDIO=y
CONFIG_NET_VENDOR_3COM=y
# CONFIG_VORTEX is not set
# CONFIG_TYPHOON is not set
CONFIG_NET_VENDOR_ADAPTEC=y
# CONFIG_ADAPTEC_STARFIRE is not set
CONFIG_NET_VENDOR_AGERE=y
# CONFIG_ET131X is not set
CONFIG_NET_VENDOR_ALACRITECH=y
# CONFIG_SLICOSS is not set
CONFIG_NET_VENDOR_ALTEON=y
# CONFIG_ACENIC is not set
# CONFIG_ALTERA_TSE is not set
CONFIG_NET_VENDOR_AMAZON=y
# CONFIG_ENA_ETHERNET is not set
CONFIG_NET_VENDOR_AMD=y
# CONFIG_AMD8111_ETH is not set
# CONFIG_PCNET32 is not set
# CONFIG_AMD_XGBE is not set
CONFIG_NET_VENDOR_AQUANTIA=y
# CONFIG_AQTION is not set
CONFIG_NET_VENDOR_ARC=y
CONFIG_NET_VENDOR_ATHEROS=y
# CONFIG_ATL2 is not set
# CONFIG_ATL1 is not set
# CONFIG_ATL1E is not set
# CONFIG_ATL1C is not set
# CONFIG_ALX is not set
CONFIG_NET_VENDOR_BROADCOM=y
# CONFIG_B44 is not set
# CONFIG_BCMGENET is not set
# CONFIG_BNX2 is not set
# CONFIG_CNIC is not set
# CONFIG_TIGON3 is not set
# CONFIG_BNX2X is not set
# CONFIG_SYSTEMPORT is not set
# CONFIG_BNXT is not set
CONFIG_NET_VENDOR_BROCADE=y
# CONFIG_BNA is not set
CONFIG_NET_VENDOR_CADENCE=y
# CONFIG_MACB is not set
CONFIG_NET_VENDOR_CAVIUM=y
# CONFIG_THUNDER_NIC_PF is not set
# CONFIG_THUNDER_NIC_VF is not set
# CONFIG_THUNDER_NIC_BGX is not set
# CONFIG_THUNDER_NIC_RGX is not set
CONFIG_CAVIUM_PTP=y
# CONFIG_LIQUIDIO is not set
# CONFIG_LIQUIDIO_VF is not set
CONFIG_NET_VENDOR_CHELSIO=y
# CONFIG_CHELSIO_T1 is not set
# CONFIG_CHELSIO_T3 is not set
# CONFIG_CHELSIO_T4 is not set
# CONFIG_CHELSIO_T4VF is not set
CONFIG_NET_VENDOR_CISCO=y
# CONFIG_ENIC is not set
CONFIG_NET_VENDOR_CORTINA=y
# CONFIG_CX_ECAT is not set
# CONFIG_DNET is not set
CONFIG_NET_VENDOR_DEC=y
# CONFIG_NET_TULIP is not set
CONFIG_NET_VENDOR_DLINK=y
# CONFIG_DL2K is not set
# CONFIG_SUNDANCE is not set
CONFIG_NET_VENDOR_EMULEX=y
# CONFIG_BE2NET is not set
CONFIG_NET_VENDOR_EZCHIP=y
CONFIG_NET_VENDOR_GOOGLE=y
# CONFIG_GVE is not set
CONFIG_NET_VENDOR_HUAWEI=y
# CONFIG_HINIC is not set
CONFIG_NET_VENDOR_I825XX=y
CONFIG_NET_VENDOR_INTEL=y
# CONFIG_E100 is not set
CONFIG_E1000=y
CONFIG_E1000E=y
CONFIG_E1000E_HWTS=y
CONFIG_IGB=y
CONFIG_IGB_HWMON=y
# CONFIG_IGBVF is not set
# CONFIG_IXGB is not set
CONFIG_IXGBE=y
CONFIG_IXGBE_HWMON=y
# CONFIG_IXGBE_DCB is not set
CONFIG_IXGBE_IPSEC=y
# CONFIG_IXGBEVF is not set
CONFIG_I40E=y
# CONFIG_I40E_DCB is not set
# CONFIG_I40EVF is not set
# CONFIG_ICE is not set
# CONFIG_FM10K is not set
CONFIG_IGC=y
CONFIG_NET_VENDOR_MICROSOFT=y
# CONFIG_MICROSOFT_MANA is not set
# CONFIG_JME is not set
CONFIG_NET_VENDOR_MARVELL=y
# CONFIG_MVMDIO is not set
# CONFIG_SKGE is not set
# CONFIG_SKY2 is not set
# CONFIG_PRESTERA is not set
CONFIG_NET_VENDOR_MELLANOX=y
# CONFIG_MLX4_EN is not set
# CONFIG_MLX5_CORE is not set
# CONFIG_MLXSW_CORE is not set
# CONFIG_MLXFW is not set
CONFIG_NET_VENDOR_MICREL=y
# CONFIG_KS8842 is not set
# CONFIG_KS8851 is not set
# CONFIG_KS8851_MLL is not set
# CONFIG_KSZ884X_PCI is not set
CONFIG_NET_VENDOR_MICROCHIP=y
# CONFIG_ENC28J60 is not set
# CONFIG_ENCX24J600 is not set
# CONFIG_LAN743X is not set
CONFIG_NET_VENDOR_MICROSEMI=y
CONFIG_NET_VENDOR_MYRI=y
# CONFIG_MYRI10GE is not set
# CONFIG_FEALNX is not set
CONFIG_NET_VENDOR_NATSEMI=y
# CONFIG_NATSEMI is not set
# CONFIG_NS83820 is not set
CONFIG_NET_VENDOR_NETERION=y
# CONFIG_S2IO is not set
# CONFIG_VXGE is not set
CONFIG_NET_VENDOR_NETRONOME=y
# CONFIG_NFP is not set
CONFIG_NET_VENDOR_NI=y
# CONFIG_NI_XGE_MANAGEMENT_ENET is not set
CONFIG_NET_VENDOR_8390=y
# CONFIG_NE2K_PCI is not set
CONFIG_NET_VENDOR_NVIDIA=y
# CONFIG_FORCEDETH is not set
CONFIG_NET_VENDOR_OKI=y
# CONFIG_ETHOC is not set
CONFIG_NET_VENDOR_PACKET_ENGINES=y
# CONFIG_HAMACHI is not set
# CONFIG_YELLOWFIN is not set
CONFIG_NET_VENDOR_PENSANDO=y
# CONFIG_IONIC is not set
CONFIG_NET_VENDOR_QLOGIC=y
# CONFIG_QLA3XXX is not set
# CONFIG_QLCNIC is not set
# CONFIG_NETXEN_NIC is not set
# CONFIG_QED is not set
CONFIG_NET_VENDOR_QUALCOMM=y
# CONFIG_QCOM_EMAC is not set
# CONFIG_RMNET is not set
CONFIG_NET_VENDOR_RDC=y
# CONFIG_R6040 is not set
CONFIG_NET_VENDOR_REALTEK=y
# CONFIG_ATP is not set
# CONFIG_8139CP is not set
# CONFIG_8139TOO is not set
CONFIG_R8169=y
CONFIG_NET_VENDOR_RENESAS=y
CONFIG_NET_VENDOR_ROCKER=y
# CONFIG_ROCKER is not set
CONFIG_NET_VENDOR_SAMSUNG=y
# CONFIG_SXGBE_ETH is not set
CONFIG_NET_VENDOR_SEEQ=y
CONFIG_NET_VENDOR_SOLARFLARE=y
# CONFIG_SFC is not set
# CONFIG_SFC_FALCON is not set
CONFIG_NET_VENDOR_SILAN=y
# CONFIG_SC92031 is not set
CONFIG_NET_VENDOR_SIS=y
# CONFIG_SIS900 is not set
# CONFIG_SIS190 is not set
CONFIG_NET_VENDOR_SMSC=y
# CONFIG_EPIC100 is not set
# CONFIG_SMSC911X is not set
# CONFIG_SMSC9420 is not set
CONFIG_NET_VENDOR_SOCIONEXT=y
CONFIG_NET_VENDOR_STMICRO=y
# CONFIG_STMMAC_ETH is not set
CONFIG_NET_VENDOR_SUN=y
# CONFIG_HAPPYMEAL is not set
# CONFIG_SUNGEM is not set
# CONFIG_CASSINI is not set
# CONFIG_NIU is not set
CONFIG_NET_VENDOR_SYNOPSYS=y
# CONFIG_DWC_XLGMAC is not set
CONFIG_NET_VENDOR_TEHUTI=y
# CONFIG_TEHUTI is not set
CONFIG_NET_VENDOR_TI=y
# CONFIG_TI_CPSW_PHY_SEL is not set
# CONFIG_TLAN is not set
CONFIG_NET_VENDOR_VIA=y
# CONFIG_VIA_RHINE is not set
# CONFIG_VIA_VELOCITY is not set
CONFIG_NET_VENDOR_WIZNET=y
# CONFIG_WIZNET_W5100 is not set
# CONFIG_WIZNET_W5300 is not set
CONFIG_NET_VENDOR_XILINX=y
# CONFIG_XILINX_EMACLITE is not set
# CONFIG_XILINX_AXI_EMAC is not set
# CONFIG_XILINX_LL_TEMAC is not set
# CONFIG_FDDI is not set
# CONFIG_HIPPI is not set
# CONFIG_NET_SB1000 is not set
CONFIG_PHYLIB=y
# CONFIG_LED_TRIGGER_PHY is not set
# CONFIG_FIXED_PHY is not set

#
# MII PHY device drivers
#
# CONFIG_AMD_PHY is not set
# CONFIG_ADIN_PHY is not set
# CONFIG_AQUANTIA_PHY is not set
# CONFIG_AX88796B_PHY is not set
# CONFIG_BROADCOM_PHY is not set
# CONFIG_BCM54140_PHY is not set
# CONFIG_BCM7XXX_PHY is not set
# CONFIG_BCM84881_PHY is not set
# CONFIG_BCM87XX_PHY is not set
# CONFIG_CICADA_PHY is not set
# CONFIG_CORTINA_PHY is not set
# CONFIG_DAVICOM_PHY is not set
# CONFIG_ICPLUS_PHY is not set
# CONFIG_LXT_PHY is not set
# CONFIG_INTEL_XWAY_PHY is not set
# CONFIG_LSI_ET1011C_PHY is not set
# CONFIG_MARVELL_PHY is not set
# CONFIG_MARVELL_10G_PHY is not set
# CONFIG_MARVELL_88X2222_PHY is not set
# CONFIG_MEDIATEK_GE_PHY is not set
# CONFIG_MICREL_PHY is not set
# CONFIG_MICROCHIP_PHY is not set
# CONFIG_MICROCHIP_T1_PHY is not set
# CONFIG_MICROSEMI_PHY is not set
# CONFIG_MOTORCOMM_PHY is not set
# CONFIG_NATIONAL_PHY is not set
# CONFIG_NXP_C45_TJA11XX_PHY is not set
# CONFIG_NXP_TJA11XX_PHY is not set
# CONFIG_QSEMI_PHY is not set
CONFIG_REALTEK_PHY=y
# CONFIG_RENESAS_PHY is not set
# CONFIG_ROCKCHIP_PHY is not set
# CONFIG_SMSC_PHY is not set
# CONFIG_STE10XP is not set
# CONFIG_TERANETICS_PHY is not set
# CONFIG_DP83822_PHY is not set
# CONFIG_DP83TC811_PHY is not set
# CONFIG_DP83848_PHY is not set
# CONFIG_DP83867_PHY is not set
# CONFIG_DP83869_PHY is not set
# CONFIG_VITESSE_PHY is not set
# CONFIG_XILINX_GMII2RGMII is not set
# CONFIG_MICREL_KS8995MA is not set
CONFIG_MDIO_DEVICE=y
CONFIG_MDIO_BUS=y
CONFIG_MDIO_DEVRES=y
# CONFIG_MDIO_BITBANG is not set
# CONFIG_MDIO_BCM_UNIMAC is not set
# CONFIG_MDIO_MVUSB is not set
# CONFIG_MDIO_MSCC_MIIM is not set
# CONFIG_MDIO_THUNDER is not set

#
# MDIO Multiplexers
#

#
# PCS device drivers
#
# CONFIG_PCS_XPCS is not set
# end of PCS device drivers

# CONFIG_PLIP is not set
# CONFIG_PPP is not set
# CONFIG_SLIP is not set
CONFIG_USB_NET_DRIVERS=y
# CONFIG_USB_CATC is not set
# CONFIG_USB_KAWETH is not set
# CONFIG_USB_PEGASUS is not set
# CONFIG_USB_RTL8150 is not set
CONFIG_USB_RTL8152=y
# CONFIG_USB_LAN78XX is not set
CONFIG_USB_USBNET=y
CONFIG_USB_NET_AX8817X=y
CONFIG_USB_NET_AX88179_178A=y
# CONFIG_USB_NET_CDCETHER is not set
# CONFIG_USB_NET_CDC_EEM is not set
# CONFIG_USB_NET_CDC_NCM is not set
# CONFIG_USB_NET_HUAWEI_CDC_NCM is not set
# CONFIG_USB_NET_CDC_MBIM is not set
# CONFIG_USB_NET_DM9601 is not set
# CONFIG_USB_NET_SR9700 is not set
# CONFIG_USB_NET_SR9800 is not set
# CONFIG_USB_NET_SMSC75XX is not set
# CONFIG_USB_NET_SMSC95XX is not set
# CONFIG_USB_NET_GL620A is not set
# CONFIG_USB_NET_NET1080 is not set
# CONFIG_USB_NET_PLUSB is not set
# CONFIG_USB_NET_MCS7830 is not set
# CONFIG_USB_NET_RNDIS_HOST is not set
# CONFIG_USB_NET_CDC_SUBSET is not set
# CONFIG_USB_NET_ZAURUS is not set
# CONFIG_USB_NET_CX82310_ETH is not set
# CONFIG_USB_NET_KALMIA is not set
# CONFIG_USB_NET_QMI_WWAN is not set
# CONFIG_USB_HSO is not set
# CONFIG_USB_NET_INT51X1 is not set
# CONFIG_USB_IPHETH is not set
# CONFIG_USB_SIERRA_NET is not set
# CONFIG_USB_NET_CH9200 is not set
# CONFIG_USB_NET_AQC111 is not set
CONFIG_WLAN=y
CONFIG_WLAN_VENDOR_ADMTEK=y
# CONFIG_ADM8211 is not set
CONFIG_WLAN_VENDOR_ATH=y
# CONFIG_ATH_DEBUG is not set
# CONFIG_ATH5K is not set
# CONFIG_ATH5K_PCI is not set
# CONFIG_ATH9K is not set
# CONFIG_ATH9K_HTC is not set
# CONFIG_CARL9170 is not set
# CONFIG_ATH6KL is not set
# CONFIG_AR5523 is not set
# CONFIG_WIL6210 is not set
# CONFIG_ATH10K is not set
# CONFIG_WCN36XX is not set
# CONFIG_ATH11K is not set
CONFIG_WLAN_VENDOR_ATMEL=y
# CONFIG_ATMEL is not set
# CONFIG_AT76C50X_USB is not set
CONFIG_WLAN_VENDOR_BROADCOM=y
# CONFIG_B43 is not set
# CONFIG_B43LEGACY is not set
# CONFIG_BRCMSMAC is not set
# CONFIG_BRCMFMAC is not set
CONFIG_WLAN_VENDOR_CISCO=y
# CONFIG_AIRO is not set
CONFIG_WLAN_VENDOR_INTEL=y
# CONFIG_IPW2100 is not set
# CONFIG_IPW2200 is not set
# CONFIG_IWL4965 is not set
# CONFIG_IWL3945 is not set
# CONFIG_IWLWIFI is not set
CONFIG_WLAN_VENDOR_INTERSIL=y
# CONFIG_HOSTAP is not set
# CONFIG_HERMES is not set
# CONFIG_P54_COMMON is not set
# CONFIG_PRISM54 is not set
CONFIG_WLAN_VENDOR_MARVELL=y
# CONFIG_LIBERTAS is not set
# CONFIG_LIBERTAS_THINFIRM is not set
# CONFIG_MWIFIEX is not set
# CONFIG_MWL8K is not set
CONFIG_WLAN_VENDOR_MEDIATEK=y
# CONFIG_MT7601U is not set
# CONFIG_MT76x0U is not set
# CONFIG_MT76x0E is not set
# CONFIG_MT76x2E is not set
# CONFIG_MT76x2U is not set
# CONFIG_MT7603E is not set
# CONFIG_MT7615E is not set
# CONFIG_MT7663U is not set
# CONFIG_MT7663S is not set
# CONFIG_MT7915E is not set
# CONFIG_MT7921E is not set
CONFIG_WLAN_VENDOR_MICROCHIP=y
# CONFIG_WILC1000_SDIO is not set
# CONFIG_WILC1000_SPI is not set
CONFIG_WLAN_VENDOR_RALINK=y
# CONFIG_RT2X00 is not set
CONFIG_WLAN_VENDOR_REALTEK=y
# CONFIG_RTL8180 is not set
# CONFIG_RTL8187 is not set
CONFIG_RTL_CARDS=m
# CONFIG_RTL8192CE is not set
# CONFIG_RTL8192SE is not set
# CONFIG_RTL8192DE is not set
# CONFIG_RTL8723AE is not set
# CONFIG_RTL8723BE is not set
# CONFIG_RTL8188EE is not set
# CONFIG_RTL8192EE is not set
# CONFIG_RTL8821AE is not set
# CONFIG_RTL8192CU is not set
# CONFIG_RTL8XXXU is not set
# CONFIG_RTW88 is not set
CONFIG_WLAN_VENDOR_RSI=y
# CONFIG_RSI_91X is not set
CONFIG_WLAN_VENDOR_ST=y
# CONFIG_CW1200 is not set
CONFIG_WLAN_VENDOR_TI=y
# CONFIG_WL1251 is not set
# CONFIG_WL12XX is not set
# CONFIG_WL18XX is not set
# CONFIG_WLCORE is not set
CONFIG_WLAN_VENDOR_ZYDAS=y
# CONFIG_USB_ZD1201 is not set
# CONFIG_ZD1211RW is not set
CONFIG_WLAN_VENDOR_QUANTENNA=y
# CONFIG_QTNFMAC_PCIE is not set
# CONFIG_MAC80211_HWSIM is not set
# CONFIG_USB_NET_RNDIS_WLAN is not set
# CONFIG_VIRT_WIFI is not set
# CONFIG_WAN is not set
CONFIG_IEEE802154_DRIVERS=m
# CONFIG_IEEE802154_FAKELB is not set
# CONFIG_IEEE802154_AT86RF230 is not set
# CONFIG_IEEE802154_MRF24J40 is not set
# CONFIG_IEEE802154_CC2520 is not set
# CONFIG_IEEE802154_ATUSB is not set
# CONFIG_IEEE802154_ADF7242 is not set
# CONFIG_IEEE802154_CA8210 is not set
# CONFIG_IEEE802154_MCR20A is not set
# CONFIG_IEEE802154_HWSIM is not set
# CONFIG_WWAN is not set
CONFIG_XEN_NETDEV_FRONTEND=y
# CONFIG_VMXNET3 is not set
# CONFIG_FUJITSU_ES is not set
# CONFIG_HYPERV_NET is not set
CONFIG_NETDEVSIM=m
CONFIG_NET_FAILOVER=m
# CONFIG_ISDN is not set
# CONFIG_NVM is not set

#
# Input device support
#
CONFIG_INPUT=y
CONFIG_INPUT_LEDS=y
CONFIG_INPUT_FF_MEMLESS=m
CONFIG_INPUT_SPARSEKMAP=m
# CONFIG_INPUT_MATRIXKMAP is not set

#
# Userland interfaces
#
CONFIG_INPUT_MOUSEDEV=y
# CONFIG_INPUT_MOUSEDEV_PSAUX is not set
CONFIG_INPUT_MOUSEDEV_SCREEN_X=1024
CONFIG_INPUT_MOUSEDEV_SCREEN_Y=768
CONFIG_INPUT_JOYDEV=m
CONFIG_INPUT_EVDEV=y
# CONFIG_INPUT_EVBUG is not set

#
# Input Device Drivers
#
CONFIG_INPUT_KEYBOARD=y
# CONFIG_KEYBOARD_ADP5588 is not set
# CONFIG_KEYBOARD_ADP5589 is not set
# CONFIG_KEYBOARD_APPLESPI is not set
CONFIG_KEYBOARD_ATKBD=y
# CONFIG_KEYBOARD_QT1050 is not set
# CONFIG_KEYBOARD_QT1070 is not set
# CONFIG_KEYBOARD_QT2160 is not set
# CONFIG_KEYBOARD_DLINK_DIR685 is not set
# CONFIG_KEYBOARD_LKKBD is not set
# CONFIG_KEYBOARD_GPIO is not set
# CONFIG_KEYBOARD_GPIO_POLLED is not set
# CONFIG_KEYBOARD_TCA6416 is not set
# CONFIG_KEYBOARD_TCA8418 is not set
# CONFIG_KEYBOARD_MATRIX is not set
# CONFIG_KEYBOARD_LM8323 is not set
# CONFIG_KEYBOARD_LM8333 is not set
# CONFIG_KEYBOARD_MAX7359 is not set
# CONFIG_KEYBOARD_MCS is not set
# CONFIG_KEYBOARD_MPR121 is not set
# CONFIG_KEYBOARD_NEWTON is not set
# CONFIG_KEYBOARD_OPENCORES is not set
# CONFIG_KEYBOARD_SAMSUNG is not set
# CONFIG_KEYBOARD_STOWAWAY is not set
# CONFIG_KEYBOARD_SUNKBD is not set
# CONFIG_KEYBOARD_TM2_TOUCHKEY is not set
# CONFIG_KEYBOARD_XTKBD is not set
CONFIG_INPUT_MOUSE=y
CONFIG_MOUSE_PS2=y
CONFIG_MOUSE_PS2_ALPS=y
CONFIG_MOUSE_PS2_BYD=y
CONFIG_MOUSE_PS2_LOGIPS2PP=y
CONFIG_MOUSE_PS2_SYNAPTICS=y
CONFIG_MOUSE_PS2_SYNAPTICS_SMBUS=y
CONFIG_MOUSE_PS2_CYPRESS=y
CONFIG_MOUSE_PS2_LIFEBOOK=y
CONFIG_MOUSE_PS2_TRACKPOINT=y
CONFIG_MOUSE_PS2_ELANTECH=y
CONFIG_MOUSE_PS2_ELANTECH_SMBUS=y
CONFIG_MOUSE_PS2_SENTELIC=y
# CONFIG_MOUSE_PS2_TOUCHKIT is not set
CONFIG_MOUSE_PS2_FOCALTECH=y
CONFIG_MOUSE_PS2_VMMOUSE=y
CONFIG_MOUSE_PS2_SMBUS=y
CONFIG_MOUSE_SERIAL=m
# CONFIG_MOUSE_APPLETOUCH is not set
# CONFIG_MOUSE_BCM5974 is not set
CONFIG_MOUSE_CYAPA=m
CONFIG_MOUSE_ELAN_I2C=m
CONFIG_MOUSE_ELAN_I2C_I2C=y
CONFIG_MOUSE_ELAN_I2C_SMBUS=y
CONFIG_MOUSE_VSXXXAA=m
# CONFIG_MOUSE_GPIO is not set
CONFIG_MOUSE_SYNAPTICS_I2C=m
# CONFIG_MOUSE_SYNAPTICS_USB is not set
# CONFIG_INPUT_JOYSTICK is not set
# CONFIG_INPUT_TABLET is not set
# CONFIG_INPUT_TOUCHSCREEN is not set
# CONFIG_INPUT_MISC is not set
CONFIG_RMI4_CORE=m
CONFIG_RMI4_I2C=m
CONFIG_RMI4_SPI=m
CONFIG_RMI4_SMB=m
CONFIG_RMI4_F03=y
CONFIG_RMI4_F03_SERIO=m
CONFIG_RMI4_2D_SENSOR=y
CONFIG_RMI4_F11=y
CONFIG_RMI4_F12=y
CONFIG_RMI4_F30=y
CONFIG_RMI4_F34=y
# CONFIG_RMI4_F3A is not set
# CONFIG_RMI4_F54 is not set
CONFIG_RMI4_F55=y

#
# Hardware I/O ports
#
CONFIG_SERIO=y
CONFIG_ARCH_MIGHT_HAVE_PC_SERIO=y
CONFIG_SERIO_I8042=y
CONFIG_SERIO_SERPORT=y
# CONFIG_SERIO_CT82C710 is not set
# CONFIG_SERIO_PARKBD is not set
# CONFIG_SERIO_PCIPS2 is not set
CONFIG_SERIO_LIBPS2=y
CONFIG_SERIO_RAW=m
CONFIG_SERIO_ALTERA_PS2=m
# CONFIG_SERIO_PS2MULT is not set
CONFIG_SERIO_ARC_PS2=m
CONFIG_HYPERV_KEYBOARD=m
# CONFIG_SERIO_GPIO_PS2 is not set
# CONFIG_USERIO is not set
# CONFIG_GAMEPORT is not set
# end of Hardware I/O ports
# end of Input device support

#
# Character devices
#
CONFIG_TTY=y
CONFIG_VT=y
CONFIG_CONSOLE_TRANSLATIONS=y
CONFIG_VT_CONSOLE=y
CONFIG_VT_CONSOLE_SLEEP=y
CONFIG_HW_CONSOLE=y
CONFIG_VT_HW_CONSOLE_BINDING=y
CONFIG_UNIX98_PTYS=y
# CONFIG_LEGACY_PTYS is not set
CONFIG_LDISC_AUTOLOAD=y

#
# Serial drivers
#
CONFIG_SERIAL_EARLYCON=y
CONFIG_SERIAL_8250=y
# CONFIG_SERIAL_8250_DEPRECATED_OPTIONS is not set
CONFIG_SERIAL_8250_PNP=y
# CONFIG_SERIAL_8250_16550A_VARIANTS is not set
# CONFIG_SERIAL_8250_FINTEK is not set
CONFIG_SERIAL_8250_CONSOLE=y
CONFIG_SERIAL_8250_DMA=y
CONFIG_SERIAL_8250_PCI=y
CONFIG_SERIAL_8250_EXAR=y
CONFIG_SERIAL_8250_NR_UARTS=64
CONFIG_SERIAL_8250_RUNTIME_UARTS=4
CONFIG_SERIAL_8250_EXTENDED=y
CONFIG_SERIAL_8250_MANY_PORTS=y
CONFIG_SERIAL_8250_SHARE_IRQ=y
# CONFIG_SERIAL_8250_DETECT_IRQ is not set
CONFIG_SERIAL_8250_RSA=y
CONFIG_SERIAL_8250_DWLIB=y
CONFIG_SERIAL_8250_DW=y
# CONFIG_SERIAL_8250_RT288X is not set
CONFIG_SERIAL_8250_LPSS=y
CONFIG_SERIAL_8250_MID=y

#
# Non-8250 serial port support
#
# CONFIG_SERIAL_MAX3100 is not set
# CONFIG_SERIAL_MAX310X is not set
# CONFIG_SERIAL_UARTLITE is not set
CONFIG_SERIAL_CORE=y
CONFIG_SERIAL_CORE_CONSOLE=y
CONFIG_SERIAL_JSM=m
# CONFIG_SERIAL_LANTIQ is not set
# CONFIG_SERIAL_SCCNXP is not set
# CONFIG_SERIAL_SC16IS7XX is not set
# CONFIG_SERIAL_BCM63XX is not set
# CONFIG_SERIAL_ALTERA_JTAGUART is not set
# CONFIG_SERIAL_ALTERA_UART is not set
CONFIG_SERIAL_ARC=m
CONFIG_SERIAL_ARC_NR_PORTS=1
# CONFIG_SERIAL_RP2 is not set
# CONFIG_SERIAL_FSL_LPUART is not set
# CONFIG_SERIAL_FSL_LINFLEXUART is not set
# CONFIG_SERIAL_SPRD is not set
# end of Serial drivers

CONFIG_SERIAL_MCTRL_GPIO=y
CONFIG_SERIAL_NONSTANDARD=y
# CONFIG_MOXA_INTELLIO is not set
# CONFIG_MOXA_SMARTIO is not set
CONFIG_SYNCLINK_GT=m
CONFIG_N_HDLC=m
CONFIG_N_GSM=m
CONFIG_NOZOMI=m
# CONFIG_NULL_TTY is not set
CONFIG_HVC_DRIVER=y
CONFIG_HVC_IRQ=y
CONFIG_HVC_XEN=y
CONFIG_HVC_XEN_FRONTEND=y
# CONFIG_SERIAL_DEV_BUS is not set
# CONFIG_TTY_PRINTK is not set
CONFIG_PRINTER=m
# CONFIG_LP_CONSOLE is not set
CONFIG_PPDEV=m
CONFIG_VIRTIO_CONSOLE=m
CONFIG_IPMI_HANDLER=m
CONFIG_IPMI_DMI_DECODE=y
CONFIG_IPMI_PLAT_DATA=y
CONFIG_IPMI_PANIC_EVENT=y
CONFIG_IPMI_PANIC_STRING=y
CONFIG_IPMI_DEVICE_INTERFACE=m
CONFIG_IPMI_SI=m
CONFIG_IPMI_SSIF=m
CONFIG_IPMI_WATCHDOG=m
CONFIG_IPMI_POWEROFF=m
CONFIG_HW_RANDOM=y
CONFIG_HW_RANDOM_TIMERIOMEM=m
CONFIG_HW_RANDOM_INTEL=m
CONFIG_HW_RANDOM_AMD=m
# CONFIG_HW_RANDOM_BA431 is not set
CONFIG_HW_RANDOM_VIA=m
CONFIG_HW_RANDOM_VIRTIO=y
# CONFIG_HW_RANDOM_XIPHERA is not set
# CONFIG_APPLICOM is not set
# CONFIG_MWAVE is not set
CONFIG_DEVMEM=y
CONFIG_NVRAM=y
CONFIG_RAW_DRIVER=y
CONFIG_MAX_RAW_DEVS=8192
CONFIG_DEVPORT=y
CONFIG_HPET=y
CONFIG_HPET_MMAP=y
# CONFIG_HPET_MMAP_DEFAULT is not set
CONFIG_HANGCHECK_TIMER=m
CONFIG_UV_MMTIMER=m
CONFIG_TCG_TPM=y
CONFIG_HW_RANDOM_TPM=y
CONFIG_TCG_TIS_CORE=y
CONFIG_TCG_TIS=y
# CONFIG_TCG_TIS_SPI is not set
# CONFIG_TCG_TIS_I2C_CR50 is not set
CONFIG_TCG_TIS_I2C_ATMEL=m
CONFIG_TCG_TIS_I2C_INFINEON=m
CONFIG_TCG_TIS_I2C_NUVOTON=m
CONFIG_TCG_NSC=m
CONFIG_TCG_ATMEL=m
CONFIG_TCG_INFINEON=m
# CONFIG_TCG_XEN is not set
CONFIG_TCG_CRB=y
# CONFIG_TCG_VTPM_PROXY is not set
CONFIG_TCG_TIS_ST33ZP24=m
CONFIG_TCG_TIS_ST33ZP24_I2C=m
# CONFIG_TCG_TIS_ST33ZP24_SPI is not set
CONFIG_TELCLOCK=m
# CONFIG_XILLYBUS is not set
# end of Character devices

# CONFIG_RANDOM_TRUST_CPU is not set
# CONFIG_RANDOM_TRUST_BOOTLOADER is not set

#
# I2C support
#
CONFIG_I2C=y
CONFIG_ACPI_I2C_OPREGION=y
CONFIG_I2C_BOARDINFO=y
CONFIG_I2C_COMPAT=y
CONFIG_I2C_CHARDEV=m
CONFIG_I2C_MUX=m

#
# Multiplexer I2C Chip support
#
# CONFIG_I2C_MUX_GPIO is not set
# CONFIG_I2C_MUX_LTC4306 is not set
# CONFIG_I2C_MUX_PCA9541 is not set
# CONFIG_I2C_MUX_PCA954x is not set
# CONFIG_I2C_MUX_REG is not set
CONFIG_I2C_MUX_MLXCPLD=m
# end of Multiplexer I2C Chip support

CONFIG_I2C_HELPER_AUTO=y
CONFIG_I2C_SMBUS=m
CONFIG_I2C_ALGOBIT=y
CONFIG_I2C_ALGOPCA=m

#
# I2C Hardware Bus support
#

#
# PC SMBus host controller drivers
#
# CONFIG_I2C_ALI1535 is not set
# CONFIG_I2C_ALI1563 is not set
# CONFIG_I2C_ALI15X3 is not set
CONFIG_I2C_AMD756=m
CONFIG_I2C_AMD756_S4882=m
CONFIG_I2C_AMD8111=m
# CONFIG_I2C_AMD_MP2 is not set
CONFIG_I2C_I801=m
CONFIG_I2C_ISCH=m
CONFIG_I2C_ISMT=m
CONFIG_I2C_PIIX4=m
CONFIG_I2C_NFORCE2=m
CONFIG_I2C_NFORCE2_S4985=m
# CONFIG_I2C_NVIDIA_GPU is not set
# CONFIG_I2C_SIS5595 is not set
# CONFIG_I2C_SIS630 is not set
CONFIG_I2C_SIS96X=m
CONFIG_I2C_VIA=m
CONFIG_I2C_VIAPRO=m

#
# ACPI drivers
#
CONFIG_I2C_SCMI=m

#
# I2C system bus drivers (mostly embedded / system-on-chip)
#
# CONFIG_I2C_CBUS_GPIO is not set
CONFIG_I2C_DESIGNWARE_CORE=m
# CONFIG_I2C_DESIGNWARE_SLAVE is not set
CONFIG_I2C_DESIGNWARE_PLATFORM=m
CONFIG_I2C_DESIGNWARE_BAYTRAIL=y
# CONFIG_I2C_DESIGNWARE_PCI is not set
# CONFIG_I2C_EMEV2 is not set
# CONFIG_I2C_GPIO is not set
# CONFIG_I2C_OCORES is not set
CONFIG_I2C_PCA_PLATFORM=m
CONFIG_I2C_SIMTEC=m
# CONFIG_I2C_XILINX is not set

#
# External I2C/SMBus adapter drivers
#
# CONFIG_I2C_DIOLAN_U2C is not set
# CONFIG_I2C_CP2615 is not set
CONFIG_I2C_PARPORT=m
# CONFIG_I2C_ROBOTFUZZ_OSIF is not set
# CONFIG_I2C_TAOS_EVM is not set
# CONFIG_I2C_TINY_USB is not set

#
# Other I2C/SMBus bus drivers
#
CONFIG_I2C_MLXCPLD=m
# end of I2C Hardware Bus support

CONFIG_I2C_STUB=m
# CONFIG_I2C_SLAVE is not set
# CONFIG_I2C_DEBUG_CORE is not set
# CONFIG_I2C_DEBUG_ALGO is not set
# CONFIG_I2C_DEBUG_BUS is not set
# end of I2C support

# CONFIG_I3C is not set
CONFIG_SPI=y
# CONFIG_SPI_DEBUG is not set
CONFIG_SPI_MASTER=y
# CONFIG_SPI_MEM is not set

#
# SPI Master Controller Drivers
#
# CONFIG_SPI_ALTERA is not set
# CONFIG_SPI_AXI_SPI_ENGINE is not set
# CONFIG_SPI_BITBANG is not set
# CONFIG_SPI_BUTTERFLY is not set
# CONFIG_SPI_CADENCE is not set
# CONFIG_SPI_DESIGNWARE is not set
# CONFIG_SPI_NXP_FLEXSPI is not set
# CONFIG_SPI_GPIO is not set
# CONFIG_SPI_LM70_LLP is not set
# CONFIG_SPI_LANTIQ_SSC is not set
# CONFIG_SPI_OC_TINY is not set
# CONFIG_SPI_PXA2XX is not set
# CONFIG_SPI_ROCKCHIP is not set
# CONFIG_SPI_SC18IS602 is not set
# CONFIG_SPI_SIFIVE is not set
# CONFIG_SPI_MXIC is not set
# CONFIG_SPI_XCOMM is not set
# CONFIG_SPI_XILINX is not set
# CONFIG_SPI_ZYNQMP_GQSPI is not set
# CONFIG_SPI_AMD is not set

#
# SPI Multiplexer support
#
# CONFIG_SPI_MUX is not set

#
# SPI Protocol Masters
#
# CONFIG_SPI_SPIDEV is not set
# CONFIG_SPI_LOOPBACK_TEST is not set
# CONFIG_SPI_TLE62X0 is not set
# CONFIG_SPI_SLAVE is not set
CONFIG_SPI_DYNAMIC=y
# CONFIG_SPMI is not set
# CONFIG_HSI is not set
CONFIG_PPS=y
# CONFIG_PPS_DEBUG is not set

#
# PPS clients support
#
# CONFIG_PPS_CLIENT_KTIMER is not set
CONFIG_PPS_CLIENT_LDISC=m
CONFIG_PPS_CLIENT_PARPORT=m
CONFIG_PPS_CLIENT_GPIO=m

#
# PPS generators support
#

#
# PTP clock support
#
CONFIG_PTP_1588_CLOCK=y
# CONFIG_DP83640_PHY is not set
# CONFIG_PTP_1588_CLOCK_INES is not set
CONFIG_PTP_1588_CLOCK_KVM=m
# CONFIG_PTP_1588_CLOCK_IDT82P33 is not set
# CONFIG_PTP_1588_CLOCK_IDTCM is not set
# CONFIG_PTP_1588_CLOCK_VMW is not set
# CONFIG_PTP_1588_CLOCK_OCP is not set
# end of PTP clock support

CONFIG_PINCTRL=y
CONFIG_PINMUX=y
CONFIG_PINCONF=y
CONFIG_GENERIC_PINCONF=y
# CONFIG_DEBUG_PINCTRL is not set
CONFIG_PINCTRL_AMD=m
# CONFIG_PINCTRL_MCP23S08 is not set
# CONFIG_PINCTRL_SX150X is not set
CONFIG_PINCTRL_BAYTRAIL=y
# CONFIG_PINCTRL_CHERRYVIEW is not set
# CONFIG_PINCTRL_LYNXPOINT is not set
CONFIG_PINCTRL_INTEL=y
# CONFIG_PINCTRL_ALDERLAKE is not set
CONFIG_PINCTRL_BROXTON=m
CONFIG_PINCTRL_CANNONLAKE=m
CONFIG_PINCTRL_CEDARFORK=m
CONFIG_PINCTRL_DENVERTON=m
# CONFIG_PINCTRL_ELKHARTLAKE is not set
# CONFIG_PINCTRL_EMMITSBURG is not set
CONFIG_PINCTRL_GEMINILAKE=m
# CONFIG_PINCTRL_ICELAKE is not set
# CONFIG_PINCTRL_JASPERLAKE is not set
# CONFIG_PINCTRL_LAKEFIELD is not set
CONFIG_PINCTRL_LEWISBURG=m
CONFIG_PINCTRL_SUNRISEPOINT=m
# CONFIG_PINCTRL_TIGERLAKE is not set

#
# Renesas pinctrl drivers
#
# end of Renesas pinctrl drivers

CONFIG_GPIOLIB=y
CONFIG_GPIOLIB_FASTPATH_LIMIT=512
CONFIG_GPIO_ACPI=y
CONFIG_GPIOLIB_IRQCHIP=y
# CONFIG_DEBUG_GPIO is not set
CONFIG_GPIO_SYSFS=y
CONFIG_GPIO_CDEV=y
CONFIG_GPIO_CDEV_V1=y
CONFIG_GPIO_GENERIC=m

#
# Memory mapped GPIO drivers
#
CONFIG_GPIO_AMDPT=m
# CONFIG_GPIO_DWAPB is not set
# CONFIG_GPIO_EXAR is not set
# CONFIG_GPIO_GENERIC_PLATFORM is not set
CONFIG_GPIO_ICH=m
# CONFIG_GPIO_MB86S7X is not set
# CONFIG_GPIO_VX855 is not set
# CONFIG_GPIO_AMD_FCH is not set
# end of Memory mapped GPIO drivers

#
# Port-mapped I/O GPIO drivers
#
# CONFIG_GPIO_F7188X is not set
# CONFIG_GPIO_IT87 is not set
# CONFIG_GPIO_SCH is not set
# CONFIG_GPIO_SCH311X is not set
# CONFIG_GPIO_WINBOND is not set
# CONFIG_GPIO_WS16C48 is not set
# end of Port-mapped I/O GPIO drivers

#
# I2C GPIO expanders
#
# CONFIG_GPIO_ADP5588 is not set
# CONFIG_GPIO_MAX7300 is not set
# CONFIG_GPIO_MAX732X is not set
# CONFIG_GPIO_PCA953X is not set
# CONFIG_GPIO_PCA9570 is not set
# CONFIG_GPIO_PCF857X is not set
# CONFIG_GPIO_TPIC2810 is not set
# end of I2C GPIO expanders

#
# MFD GPIO expanders
#
# end of MFD GPIO expanders

#
# PCI GPIO expanders
#
# CONFIG_GPIO_AMD8111 is not set
# CONFIG_GPIO_BT8XX is not set
# CONFIG_GPIO_ML_IOH is not set
# CONFIG_GPIO_PCI_IDIO_16 is not set
# CONFIG_GPIO_PCIE_IDIO_24 is not set
# CONFIG_GPIO_RDC321X is not set
# end of PCI GPIO expanders

#
# SPI GPIO expanders
#
# CONFIG_GPIO_MAX3191X is not set
# CONFIG_GPIO_MAX7301 is not set
# CONFIG_GPIO_MC33880 is not set
# CONFIG_GPIO_PISOSR is not set
# CONFIG_GPIO_XRA1403 is not set
# end of SPI GPIO expanders

#
# USB GPIO expanders
#
# end of USB GPIO expanders

#
# Virtual GPIO drivers
#
# CONFIG_GPIO_AGGREGATOR is not set
CONFIG_GPIO_MOCKUP=m
# end of Virtual GPIO drivers

# CONFIG_W1 is not set
CONFIG_POWER_RESET=y
# CONFIG_POWER_RESET_RESTART is not set
CONFIG_POWER_SUPPLY=y
# CONFIG_POWER_SUPPLY_DEBUG is not set
CONFIG_POWER_SUPPLY_HWMON=y
# CONFIG_PDA_POWER is not set
# CONFIG_TEST_POWER is not set
# CONFIG_CHARGER_ADP5061 is not set
# CONFIG_BATTERY_CW2015 is not set
# CONFIG_BATTERY_DS2780 is not set
# CONFIG_BATTERY_DS2781 is not set
# CONFIG_BATTERY_DS2782 is not set
# CONFIG_BATTERY_SBS is not set
# CONFIG_CHARGER_SBS is not set
# CONFIG_MANAGER_SBS is not set
# CONFIG_BATTERY_BQ27XXX is not set
# CONFIG_BATTERY_MAX17040 is not set
# CONFIG_BATTERY_MAX17042 is not set
# CONFIG_CHARGER_MAX8903 is not set
# CONFIG_CHARGER_LP8727 is not set
# CONFIG_CHARGER_GPIO is not set
# CONFIG_CHARGER_LT3651 is not set
# CONFIG_CHARGER_LTC4162L is not set
# CONFIG_CHARGER_BQ2415X is not set
# CONFIG_CHARGER_BQ24257 is not set
# CONFIG_CHARGER_BQ24735 is not set
# CONFIG_CHARGER_BQ2515X is not set
# CONFIG_CHARGER_BQ25890 is not set
# CONFIG_CHARGER_BQ25980 is not set
# CONFIG_CHARGER_BQ256XX is not set
CONFIG_CHARGER_SMB347=m
# CONFIG_BATTERY_GAUGE_LTC2941 is not set
# CONFIG_BATTERY_GOLDFISH is not set
# CONFIG_CHARGER_RT9455 is not set
# CONFIG_CHARGER_BD99954 is not set
CONFIG_HWMON=y
CONFIG_HWMON_VID=m
# CONFIG_HWMON_DEBUG_CHIP is not set

#
# Native drivers
#
CONFIG_SENSORS_ABITUGURU=m
CONFIG_SENSORS_ABITUGURU3=m
# CONFIG_SENSORS_AD7314 is not set
CONFIG_SENSORS_AD7414=m
CONFIG_SENSORS_AD7418=m
CONFIG_SENSORS_ADM1021=m
CONFIG_SENSORS_ADM1025=m
CONFIG_SENSORS_ADM1026=m
CONFIG_SENSORS_ADM1029=m
CONFIG_SENSORS_ADM1031=m
# CONFIG_SENSORS_ADM1177 is not set
CONFIG_SENSORS_ADM9240=m
CONFIG_SENSORS_ADT7X10=m
# CONFIG_SENSORS_ADT7310 is not set
CONFIG_SENSORS_ADT7410=m
CONFIG_SENSORS_ADT7411=m
CONFIG_SENSORS_ADT7462=m
CONFIG_SENSORS_ADT7470=m
CONFIG_SENSORS_ADT7475=m
# CONFIG_SENSORS_AHT10 is not set
# CONFIG_SENSORS_AS370 is not set
CONFIG_SENSORS_ASC7621=m
# CONFIG_SENSORS_AXI_FAN_CONTROL is not set
CONFIG_SENSORS_K8TEMP=m
CONFIG_SENSORS_K10TEMP=m
CONFIG_SENSORS_FAM15H_POWER=m
CONFIG_SENSORS_APPLESMC=m
CONFIG_SENSORS_ASB100=m
# CONFIG_SENSORS_ASPEED is not set
CONFIG_SENSORS_ATXP1=m
# CONFIG_SENSORS_CORSAIR_CPRO is not set
# CONFIG_SENSORS_CORSAIR_PSU is not set
# CONFIG_SENSORS_DRIVETEMP is not set
CONFIG_SENSORS_DS620=m
CONFIG_SENSORS_DS1621=m
CONFIG_SENSORS_DELL_SMM=m
CONFIG_SENSORS_I5K_AMB=m
CONFIG_SENSORS_F71805F=m
CONFIG_SENSORS_F71882FG=m
CONFIG_SENSORS_F75375S=m
CONFIG_SENSORS_FSCHMD=m
# CONFIG_SENSORS_FTSTEUTATES is not set
CONFIG_SENSORS_GL518SM=m
CONFIG_SENSORS_GL520SM=m
CONFIG_SENSORS_G760A=m
# CONFIG_SENSORS_G762 is not set
# CONFIG_SENSORS_HIH6130 is not set
CONFIG_SENSORS_IBMAEM=m
CONFIG_SENSORS_IBMPEX=m
CONFIG_SENSORS_I5500=m
CONFIG_SENSORS_CORETEMP=m
CONFIG_SENSORS_IT87=m
CONFIG_SENSORS_JC42=m
# CONFIG_SENSORS_POWR1220 is not set
CONFIG_SENSORS_LINEAGE=m
# CONFIG_SENSORS_LTC2945 is not set
# CONFIG_SENSORS_LTC2947_I2C is not set
# CONFIG_SENSORS_LTC2947_SPI is not set
# CONFIG_SENSORS_LTC2990 is not set
# CONFIG_SENSORS_LTC2992 is not set
CONFIG_SENSORS_LTC4151=m
CONFIG_SENSORS_LTC4215=m
# CONFIG_SENSORS_LTC4222 is not set
CONFIG_SENSORS_LTC4245=m
# CONFIG_SENSORS_LTC4260 is not set
CONFIG_SENSORS_LTC4261=m
# CONFIG_SENSORS_MAX1111 is not set
# CONFIG_SENSORS_MAX127 is not set
CONFIG_SENSORS_MAX16065=m
CONFIG_SENSORS_MAX1619=m
CONFIG_SENSORS_MAX1668=m
CONFIG_SENSORS_MAX197=m
# CONFIG_SENSORS_MAX31722 is not set
# CONFIG_SENSORS_MAX31730 is not set
# CONFIG_SENSORS_MAX6621 is not set
CONFIG_SENSORS_MAX6639=m
CONFIG_SENSORS_MAX6642=m
CONFIG_SENSORS_MAX6650=m
CONFIG_SENSORS_MAX6697=m
# CONFIG_SENSORS_MAX31790 is not set
CONFIG_SENSORS_MCP3021=m
# CONFIG_SENSORS_MLXREG_FAN is not set
# CONFIG_SENSORS_TC654 is not set
# CONFIG_SENSORS_TPS23861 is not set
# CONFIG_SENSORS_MR75203 is not set
# CONFIG_SENSORS_ADCXX is not set
CONFIG_SENSORS_LM63=m
# CONFIG_SENSORS_LM70 is not set
CONFIG_SENSORS_LM73=m
CONFIG_SENSORS_LM75=m
CONFIG_SENSORS_LM77=m
CONFIG_SENSORS_LM78=m
CONFIG_SENSORS_LM80=m
CONFIG_SENSORS_LM83=m
CONFIG_SENSORS_LM85=m
CONFIG_SENSORS_LM87=m
CONFIG_SENSORS_LM90=m
CONFIG_SENSORS_LM92=m
CONFIG_SENSORS_LM93=m
CONFIG_SENSORS_LM95234=m
CONFIG_SENSORS_LM95241=m
CONFIG_SENSORS_LM95245=m
CONFIG_SENSORS_PC87360=m
CONFIG_SENSORS_PC87427=m
CONFIG_SENSORS_NTC_THERMISTOR=m
# CONFIG_SENSORS_NCT6683 is not set
CONFIG_SENSORS_NCT6775=m
# CONFIG_SENSORS_NCT7802 is not set
# CONFIG_SENSORS_NCT7904 is not set
# CONFIG_SENSORS_NPCM7XX is not set
# CONFIG_SENSORS_NZXT_KRAKEN2 is not set
CONFIG_SENSORS_PCF8591=m
CONFIG_PMBUS=m
CONFIG_SENSORS_PMBUS=m
# CONFIG_SENSORS_ADM1266 is not set
CONFIG_SENSORS_ADM1275=m
# CONFIG_SENSORS_BEL_PFE is not set
# CONFIG_SENSORS_BPA_RS600 is not set
# CONFIG_SENSORS_FSP_3Y is not set
# CONFIG_SENSORS_IBM_CFFPS is not set
# CONFIG_SENSORS_INSPUR_IPSPS is not set
# CONFIG_SENSORS_IR35221 is not set
# CONFIG_SENSORS_IR36021 is not set
# CONFIG_SENSORS_IR38064 is not set
# CONFIG_SENSORS_IRPS5401 is not set
# CONFIG_SENSORS_ISL68137 is not set
CONFIG_SENSORS_LM25066=m
CONFIG_SENSORS_LTC2978=m
# CONFIG_SENSORS_LTC3815 is not set
# CONFIG_SENSORS_MAX15301 is not set
CONFIG_SENSORS_MAX16064=m
# CONFIG_SENSORS_MAX16601 is not set
# CONFIG_SENSORS_MAX20730 is not set
# CONFIG_SENSORS_MAX20751 is not set
# CONFIG_SENSORS_MAX31785 is not set
CONFIG_SENSORS_MAX34440=m
CONFIG_SENSORS_MAX8688=m
# CONFIG_SENSORS_MP2975 is not set
# CONFIG_SENSORS_PM6764TR is not set
# CONFIG_SENSORS_PXE1610 is not set
# CONFIG_SENSORS_Q54SJ108A2 is not set
# CONFIG_SENSORS_STPDDC60 is not set
# CONFIG_SENSORS_TPS40422 is not set
# CONFIG_SENSORS_TPS53679 is not set
CONFIG_SENSORS_UCD9000=m
CONFIG_SENSORS_UCD9200=m
# CONFIG_SENSORS_XDPE122 is not set
CONFIG_SENSORS_ZL6100=m
# CONFIG_SENSORS_SBTSI is not set
CONFIG_SENSORS_SHT15=m
CONFIG_SENSORS_SHT21=m
# CONFIG_SENSORS_SHT3x is not set
# CONFIG_SENSORS_SHTC1 is not set
CONFIG_SENSORS_SIS5595=m
CONFIG_SENSORS_DME1737=m
CONFIG_SENSORS_EMC1403=m
# CONFIG_SENSORS_EMC2103 is not set
CONFIG_SENSORS_EMC6W201=m
CONFIG_SENSORS_SMSC47M1=m
CONFIG_SENSORS_SMSC47M192=m
CONFIG_SENSORS_SMSC47B397=m
CONFIG_SENSORS_SCH56XX_COMMON=m
CONFIG_SENSORS_SCH5627=m
CONFIG_SENSORS_SCH5636=m
# CONFIG_SENSORS_STTS751 is not set
# CONFIG_SENSORS_SMM665 is not set
# CONFIG_SENSORS_ADC128D818 is not set
CONFIG_SENSORS_ADS7828=m
# CONFIG_SENSORS_ADS7871 is not set
CONFIG_SENSORS_AMC6821=m
CONFIG_SENSORS_INA209=m
CONFIG_SENSORS_INA2XX=m
# CONFIG_SENSORS_INA3221 is not set
# CONFIG_SENSORS_TC74 is not set
CONFIG_SENSORS_THMC50=m
CONFIG_SENSORS_TMP102=m
# CONFIG_SENSORS_TMP103 is not set
# CONFIG_SENSORS_TMP108 is not set
CONFIG_SENSORS_TMP401=m
CONFIG_SENSORS_TMP421=m
# CONFIG_SENSORS_TMP513 is not set
CONFIG_SENSORS_VIA_CPUTEMP=m
CONFIG_SENSORS_VIA686A=m
CONFIG_SENSORS_VT1211=m
CONFIG_SENSORS_VT8231=m
# CONFIG_SENSORS_W83773G is not set
CONFIG_SENSORS_W83781D=m
CONFIG_SENSORS_W83791D=m
CONFIG_SENSORS_W83792D=m
CONFIG_SENSORS_W83793=m
CONFIG_SENSORS_W83795=m
# CONFIG_SENSORS_W83795_FANCTRL is not set
CONFIG_SENSORS_W83L785TS=m
CONFIG_SENSORS_W83L786NG=m
CONFIG_SENSORS_W83627HF=m
CONFIG_SENSORS_W83627EHF=m
# CONFIG_SENSORS_XGENE is not set

#
# ACPI drivers
#
CONFIG_SENSORS_ACPI_POWER=m
CONFIG_SENSORS_ATK0110=m
CONFIG_THERMAL=y
# CONFIG_THERMAL_NETLINK is not set
# CONFIG_THERMAL_STATISTICS is not set
CONFIG_THERMAL_EMERGENCY_POWEROFF_DELAY_MS=0
CONFIG_THERMAL_HWMON=y
CONFIG_THERMAL_WRITABLE_TRIPS=y
CONFIG_THERMAL_DEFAULT_GOV_STEP_WISE=y
# CONFIG_THERMAL_DEFAULT_GOV_FAIR_SHARE is not set
# CONFIG_THERMAL_DEFAULT_GOV_USER_SPACE is not set
CONFIG_THERMAL_GOV_FAIR_SHARE=y
CONFIG_THERMAL_GOV_STEP_WISE=y
CONFIG_THERMAL_GOV_BANG_BANG=y
CONFIG_THERMAL_GOV_USER_SPACE=y
# CONFIG_THERMAL_EMULATION is not set

#
# Intel thermal drivers
#
CONFIG_INTEL_POWERCLAMP=m
CONFIG_X86_THERMAL_VECTOR=y
CONFIG_X86_PKG_TEMP_THERMAL=m
CONFIG_INTEL_SOC_DTS_IOSF_CORE=m
# CONFIG_INTEL_SOC_DTS_THERMAL is not set

#
# ACPI INT340X thermal drivers
#
CONFIG_INT340X_THERMAL=m
CONFIG_ACPI_THERMAL_REL=m
# CONFIG_INT3406_THERMAL is not set
CONFIG_PROC_THERMAL_MMIO_RAPL=m
# end of ACPI INT340X thermal drivers

CONFIG_INTEL_PCH_THERMAL=m
# CONFIG_INTEL_TCC_COOLING is not set
# end of Intel thermal drivers

CONFIG_WATCHDOG=y
CONFIG_WATCHDOG_CORE=y
# CONFIG_WATCHDOG_NOWAYOUT is not set
CONFIG_WATCHDOG_HANDLE_BOOT_ENABLED=y
CONFIG_WATCHDOG_OPEN_TIMEOUT=0
CONFIG_WATCHDOG_SYSFS=y

#
# Watchdog Pretimeout Governors
#
# CONFIG_WATCHDOG_PRETIMEOUT_GOV is not set

#
# Watchdog Device Drivers
#
CONFIG_SOFT_WATCHDOG=m
CONFIG_WDAT_WDT=m
# CONFIG_XILINX_WATCHDOG is not set
# CONFIG_ZIIRAVE_WATCHDOG is not set
# CONFIG_MLX_WDT is not set
# CONFIG_CADENCE_WATCHDOG is not set
# CONFIG_DW_WATCHDOG is not set
# CONFIG_MAX63XX_WATCHDOG is not set
# CONFIG_ACQUIRE_WDT is not set
# CONFIG_ADVANTECH_WDT is not set
CONFIG_ALIM1535_WDT=m
CONFIG_ALIM7101_WDT=m
# CONFIG_EBC_C384_WDT is not set
CONFIG_F71808E_WDT=m
CONFIG_SP5100_TCO=m
CONFIG_SBC_FITPC2_WATCHDOG=m
# CONFIG_EUROTECH_WDT is not set
CONFIG_IB700_WDT=m
CONFIG_IBMASR=m
# CONFIG_WAFER_WDT is not set
CONFIG_I6300ESB_WDT=y
CONFIG_IE6XX_WDT=m
CONFIG_ITCO_WDT=y
CONFIG_ITCO_VENDOR_SUPPORT=y
CONFIG_IT8712F_WDT=m
CONFIG_IT87_WDT=m
CONFIG_HP_WATCHDOG=m
CONFIG_HPWDT_NMI_DECODING=y
# CONFIG_SC1200_WDT is not set
# CONFIG_PC87413_WDT is not set
CONFIG_NV_TCO=m
# CONFIG_60XX_WDT is not set
# CONFIG_CPU5_WDT is not set
CONFIG_SMSC_SCH311X_WDT=m
# CONFIG_SMSC37B787_WDT is not set
# CONFIG_TQMX86_WDT is not set
CONFIG_VIA_WDT=m
CONFIG_W83627HF_WDT=m
CONFIG_W83877F_WDT=m
CONFIG_W83977F_WDT=m
CONFIG_MACHZ_WDT=m
# CONFIG_SBC_EPX_C3_WATCHDOG is not set
CONFIG_INTEL_MEI_WDT=m
# CONFIG_NI903X_WDT is not set
# CONFIG_NIC7018_WDT is not set
# CONFIG_MEN_A21_WDT is not set
CONFIG_XEN_WDT=m

#
# PCI-based Watchdog Cards
#
CONFIG_PCIPCWATCHDOG=m
CONFIG_WDTPCI=m

#
# USB-based Watchdog Cards
#
# CONFIG_USBPCWATCHDOG is not set
CONFIG_SSB_POSSIBLE=y
# CONFIG_SSB is not set
CONFIG_BCMA_POSSIBLE=y
CONFIG_BCMA=m
CONFIG_BCMA_HOST_PCI_POSSIBLE=y
CONFIG_BCMA_HOST_PCI=y
# CONFIG_BCMA_HOST_SOC is not set
CONFIG_BCMA_DRIVER_PCI=y
CONFIG_BCMA_DRIVER_GMAC_CMN=y
CONFIG_BCMA_DRIVER_GPIO=y
# CONFIG_BCMA_DEBUG is not set

#
# Multifunction device drivers
#
CONFIG_MFD_CORE=y
# CONFIG_MFD_AS3711 is not set
# CONFIG_PMIC_ADP5520 is not set
# CONFIG_MFD_AAT2870_CORE is not set
# CONFIG_MFD_BCM590XX is not set
# CONFIG_MFD_BD9571MWV is not set
# CONFIG_MFD_AXP20X_I2C is not set
# CONFIG_MFD_MADERA is not set
# CONFIG_PMIC_DA903X is not set
# CONFIG_MFD_DA9052_SPI is not set
# CONFIG_MFD_DA9052_I2C is not set
# CONFIG_MFD_DA9055 is not set
# CONFIG_MFD_DA9062 is not set
# CONFIG_MFD_DA9063 is not set
# CONFIG_MFD_DA9150 is not set
# CONFIG_MFD_DLN2 is not set
# CONFIG_MFD_MC13XXX_SPI is not set
# CONFIG_MFD_MC13XXX_I2C is not set
# CONFIG_MFD_MP2629 is not set
# CONFIG_HTC_PASIC3 is not set
# CONFIG_HTC_I2CPLD is not set
# CONFIG_MFD_INTEL_QUARK_I2C_GPIO is not set
CONFIG_LPC_ICH=m
CONFIG_LPC_SCH=m
# CONFIG_INTEL_SOC_PMIC_CHTDC_TI is not set
CONFIG_MFD_INTEL_LPSS=y
CONFIG_MFD_INTEL_LPSS_ACPI=y
CONFIG_MFD_INTEL_LPSS_PCI=y
# CONFIG_MFD_INTEL_PMC_BXT is not set
# CONFIG_MFD_INTEL_PMT is not set
# CONFIG_MFD_IQS62X is not set
# CONFIG_MFD_JANZ_CMODIO is not set
# CONFIG_MFD_KEMPLD is not set
# CONFIG_MFD_88PM800 is not set
# CONFIG_MFD_88PM805 is not set
# CONFIG_MFD_88PM860X is not set
# CONFIG_MFD_MAX14577 is not set
# CONFIG_MFD_MAX77693 is not set
# CONFIG_MFD_MAX77843 is not set
# CONFIG_MFD_MAX8907 is not set
# CONFIG_MFD_MAX8925 is not set
# CONFIG_MFD_MAX8997 is not set
# CONFIG_MFD_MAX8998 is not set
# CONFIG_MFD_MT6360 is not set
# CONFIG_MFD_MT6397 is not set
# CONFIG_MFD_MENF21BMC is not set
# CONFIG_EZX_PCAP is not set
# CONFIG_MFD_VIPERBOARD is not set
# CONFIG_MFD_RETU is not set
# CONFIG_MFD_PCF50633 is not set
# CONFIG_MFD_RDC321X is not set
# CONFIG_MFD_RT5033 is not set
# CONFIG_MFD_RC5T583 is not set
# CONFIG_MFD_SEC_CORE is not set
# CONFIG_MFD_SI476X_CORE is not set
CONFIG_MFD_SM501=m
CONFIG_MFD_SM501_GPIO=y
# CONFIG_MFD_SKY81452 is not set
# CONFIG_MFD_SYSCON is not set
# CONFIG_MFD_TI_AM335X_TSCADC is not set
# CONFIG_MFD_LP3943 is not set
# CONFIG_MFD_LP8788 is not set
# CONFIG_MFD_TI_LMU is not set
# CONFIG_MFD_PALMAS is not set
# CONFIG_TPS6105X is not set
# CONFIG_TPS65010 is not set
# CONFIG_TPS6507X is not set
# CONFIG_MFD_TPS65086 is not set
# CONFIG_MFD_TPS65090 is not set
# CONFIG_MFD_TI_LP873X is not set
# CONFIG_MFD_TPS6586X is not set
# CONFIG_MFD_TPS65910 is not set
# CONFIG_MFD_TPS65912_I2C is not set
# CONFIG_MFD_TPS65912_SPI is not set
# CONFIG_MFD_TPS80031 is not set
# CONFIG_TWL4030_CORE is not set
# CONFIG_TWL6040_CORE is not set
# CONFIG_MFD_WL1273_CORE is not set
# CONFIG_MFD_LM3533 is not set
# CONFIG_MFD_TQMX86 is not set
CONFIG_MFD_VX855=m
# CONFIG_MFD_ARIZONA_I2C is not set
# CONFIG_MFD_ARIZONA_SPI is not set
# CONFIG_MFD_WM8400 is not set
# CONFIG_MFD_WM831X_I2C is not set
# CONFIG_MFD_WM831X_SPI is not set
# CONFIG_MFD_WM8350_I2C is not set
# CONFIG_MFD_WM8994 is not set
# CONFIG_MFD_ATC260X_I2C is not set
# CONFIG_MFD_INTEL_M10_BMC is not set
# end of Multifunction device drivers

# CONFIG_REGULATOR is not set
CONFIG_RC_CORE=m
CONFIG_RC_MAP=m
CONFIG_LIRC=y
CONFIG_RC_DECODERS=y
CONFIG_IR_NEC_DECODER=m
CONFIG_IR_RC5_DECODER=m
CONFIG_IR_RC6_DECODER=m
CONFIG_IR_JVC_DECODER=m
CONFIG_IR_SONY_DECODER=m
CONFIG_IR_SANYO_DECODER=m
CONFIG_IR_SHARP_DECODER=m
CONFIG_IR_MCE_KBD_DECODER=m
# CONFIG_IR_XMP_DECODER is not set
CONFIG_IR_IMON_DECODER=m
# CONFIG_IR_RCMM_DECODER is not set
CONFIG_RC_DEVICES=y
# CONFIG_RC_ATI_REMOTE is not set
CONFIG_IR_ENE=m
# CONFIG_IR_IMON is not set
# CONFIG_IR_IMON_RAW is not set
# CONFIG_IR_MCEUSB is not set
CONFIG_IR_ITE_CIR=m
CONFIG_IR_FINTEK=m
CONFIG_IR_NUVOTON=m
# CONFIG_IR_REDRAT3 is not set
# CONFIG_IR_STREAMZAP is not set
CONFIG_IR_WINBOND_CIR=m
# CONFIG_IR_IGORPLUGUSB is not set
# CONFIG_IR_IGUANA is not set
# CONFIG_IR_TTUSBIR is not set
CONFIG_RC_LOOPBACK=m
CONFIG_IR_SERIAL=m
CONFIG_IR_SERIAL_TRANSMITTER=y
CONFIG_IR_SIR=m
# CONFIG_RC_XBOX_DVD is not set
# CONFIG_IR_TOY is not set
CONFIG_MEDIA_CEC_SUPPORT=y
# CONFIG_CEC_CH7322 is not set
# CONFIG_CEC_GPIO is not set
# CONFIG_CEC_SECO is not set
# CONFIG_USB_PULSE8_CEC is not set
# CONFIG_USB_RAINSHADOW_CEC is not set
CONFIG_MEDIA_SUPPORT=m
# CONFIG_MEDIA_SUPPORT_FILTER is not set
# CONFIG_MEDIA_SUBDRV_AUTOSELECT is not set

#
# Media device types
#
CONFIG_MEDIA_CAMERA_SUPPORT=y
CONFIG_MEDIA_ANALOG_TV_SUPPORT=y
CONFIG_MEDIA_DIGITAL_TV_SUPPORT=y
CONFIG_MEDIA_RADIO_SUPPORT=y
CONFIG_MEDIA_SDR_SUPPORT=y
CONFIG_MEDIA_PLATFORM_SUPPORT=y
CONFIG_MEDIA_TEST_SUPPORT=y
# end of Media device types

#
# Media core support
#
CONFIG_VIDEO_DEV=m
CONFIG_MEDIA_CONTROLLER=y
CONFIG_DVB_CORE=m
# end of Media core support

#
# Video4Linux options
#
CONFIG_VIDEO_V4L2=m
CONFIG_VIDEO_V4L2_I2C=y
CONFIG_VIDEO_V4L2_SUBDEV_API=y
# CONFIG_VIDEO_ADV_DEBUG is not set
# CONFIG_VIDEO_FIXED_MINOR_RANGES is not set
# end of Video4Linux options

#
# Media controller options
#
# CONFIG_MEDIA_CONTROLLER_DVB is not set
# end of Media controller options

#
# Digital TV options
#
# CONFIG_DVB_MMAP is not set
CONFIG_DVB_NET=y
CONFIG_DVB_MAX_ADAPTERS=16
CONFIG_DVB_DYNAMIC_MINORS=y
# CONFIG_DVB_DEMUX_SECTION_LOSS_LOG is not set
# CONFIG_DVB_ULE_DEBUG is not set
# end of Digital TV options

#
# Media drivers
#
# CONFIG_MEDIA_USB_SUPPORT is not set
# CONFIG_MEDIA_PCI_SUPPORT is not set
CONFIG_RADIO_ADAPTERS=y
# CONFIG_RADIO_SI470X is not set
# CONFIG_RADIO_SI4713 is not set
# CONFIG_USB_MR800 is not set
# CONFIG_USB_DSBR is not set
# CONFIG_RADIO_MAXIRADIO is not set
# CONFIG_RADIO_SHARK is not set
# CONFIG_RADIO_SHARK2 is not set
# CONFIG_USB_KEENE is not set
# CONFIG_USB_RAREMONO is not set
# CONFIG_USB_MA901 is not set
# CONFIG_RADIO_TEA5764 is not set
# CONFIG_RADIO_SAA7706H is not set
# CONFIG_RADIO_TEF6862 is not set
# CONFIG_RADIO_WL1273 is not set
CONFIG_VIDEOBUF2_CORE=m
CONFIG_VIDEOBUF2_V4L2=m
CONFIG_VIDEOBUF2_MEMOPS=m
CONFIG_VIDEOBUF2_VMALLOC=m
# CONFIG_V4L_PLATFORM_DRIVERS is not set
# CONFIG_V4L_MEM2MEM_DRIVERS is not set
# CONFIG_DVB_PLATFORM_DRIVERS is not set
# CONFIG_SDR_PLATFORM_DRIVERS is not set

#
# MMC/SDIO DVB adapters
#
# CONFIG_SMS_SDIO_DRV is not set
# CONFIG_V4L_TEST_DRIVERS is not set
# CONFIG_DVB_TEST_DRIVERS is not set

#
# FireWire (IEEE 1394) Adapters
#
# CONFIG_DVB_FIREDTV is not set
# end of Media drivers

#
# Media ancillary drivers
#
CONFIG_MEDIA_ATTACH=y
CONFIG_VIDEO_IR_I2C=m

#
# Audio decoders, processors and mixers
#
# CONFIG_VIDEO_TVAUDIO is not set
# CONFIG_VIDEO_TDA7432 is not set
# CONFIG_VIDEO_TDA9840 is not set
# CONFIG_VIDEO_TEA6415C is not set
# CONFIG_VIDEO_TEA6420 is not set
# CONFIG_VIDEO_MSP3400 is not set
# CONFIG_VIDEO_CS3308 is not set
# CONFIG_VIDEO_CS5345 is not set
# CONFIG_VIDEO_CS53L32A is not set
# CONFIG_VIDEO_TLV320AIC23B is not set
# CONFIG_VIDEO_UDA1342 is not set
# CONFIG_VIDEO_WM8775 is not set
# CONFIG_VIDEO_WM8739 is not set
# CONFIG_VIDEO_VP27SMPX is not set
# CONFIG_VIDEO_SONY_BTF_MPX is not set
# end of Audio decoders, processors and mixers

#
# RDS decoders
#
# CONFIG_VIDEO_SAA6588 is not set
# end of RDS decoders

#
# Video decoders
#
# CONFIG_VIDEO_ADV7180 is not set
# CONFIG_VIDEO_ADV7183 is not set
# CONFIG_VIDEO_ADV7604 is not set
# CONFIG_VIDEO_ADV7842 is not set
# CONFIG_VIDEO_BT819 is not set
# CONFIG_VIDEO_BT856 is not set
# CONFIG_VIDEO_BT866 is not set
# CONFIG_VIDEO_KS0127 is not set
# CONFIG_VIDEO_ML86V7667 is not set
# CONFIG_VIDEO_SAA7110 is not set
# CONFIG_VIDEO_SAA711X is not set
# CONFIG_VIDEO_TC358743 is not set
# CONFIG_VIDEO_TVP514X is not set
# CONFIG_VIDEO_TVP5150 is not set
# CONFIG_VIDEO_TVP7002 is not set
# CONFIG_VIDEO_TW2804 is not set
# CONFIG_VIDEO_TW9903 is not set
# CONFIG_VIDEO_TW9906 is not set
# CONFIG_VIDEO_TW9910 is not set
# CONFIG_VIDEO_VPX3220 is not set

#
# Video and audio decoders
#
# CONFIG_VIDEO_SAA717X is not set
# CONFIG_VIDEO_CX25840 is not set
# end of Video decoders

#
# Video encoders
#
# CONFIG_VIDEO_SAA7127 is not set
# CONFIG_VIDEO_SAA7185 is not set
# CONFIG_VIDEO_ADV7170 is not set
# CONFIG_VIDEO_ADV7175 is not set
# CONFIG_VIDEO_ADV7343 is not set
# CONFIG_VIDEO_ADV7393 is not set
# CONFIG_VIDEO_ADV7511 is not set
# CONFIG_VIDEO_AD9389B is not set
# CONFIG_VIDEO_AK881X is not set
# CONFIG_VIDEO_THS8200 is not set
# end of Video encoders

#
# Video improvement chips
#
# CONFIG_VIDEO_UPD64031A is not set
# CONFIG_VIDEO_UPD64083 is not set
# end of Video improvement chips

#
# Audio/Video compression chips
#
# CONFIG_VIDEO_SAA6752HS is not set
# end of Audio/Video compression chips

#
# SDR tuner chips
#
# CONFIG_SDR_MAX2175 is not set
# end of SDR tuner chips

#
# Miscellaneous helper chips
#
# CONFIG_VIDEO_THS7303 is not set
# CONFIG_VIDEO_M52790 is not set
# CONFIG_VIDEO_I2C is not set
# CONFIG_VIDEO_ST_MIPID02 is not set
# end of Miscellaneous helper chips

#
# Camera sensor devices
#
# CONFIG_VIDEO_HI556 is not set
# CONFIG_VIDEO_IMX214 is not set
# CONFIG_VIDEO_IMX219 is not set
# CONFIG_VIDEO_IMX258 is not set
# CONFIG_VIDEO_IMX274 is not set
# CONFIG_VIDEO_IMX290 is not set
# CONFIG_VIDEO_IMX319 is not set
# CONFIG_VIDEO_IMX355 is not set
# CONFIG_VIDEO_OV02A10 is not set
# CONFIG_VIDEO_OV2640 is not set
# CONFIG_VIDEO_OV2659 is not set
# CONFIG_VIDEO_OV2680 is not set
# CONFIG_VIDEO_OV2685 is not set
# CONFIG_VIDEO_OV2740 is not set
# CONFIG_VIDEO_OV5647 is not set
# CONFIG_VIDEO_OV5648 is not set
# CONFIG_VIDEO_OV6650 is not set
# CONFIG_VIDEO_OV5670 is not set
# CONFIG_VIDEO_OV5675 is not set
# CONFIG_VIDEO_OV5695 is not set
# CONFIG_VIDEO_OV7251 is not set
# CONFIG_VIDEO_OV772X is not set
# CONFIG_VIDEO_OV7640 is not set
# CONFIG_VIDEO_OV7670 is not set
# CONFIG_VIDEO_OV7740 is not set
# CONFIG_VIDEO_OV8856 is not set
# CONFIG_VIDEO_OV8865 is not set
# CONFIG_VIDEO_OV9640 is not set
# CONFIG_VIDEO_OV9650 is not set
# CONFIG_VIDEO_OV9734 is not set
# CONFIG_VIDEO_OV13858 is not set
# CONFIG_VIDEO_VS6624 is not set
# CONFIG_VIDEO_MT9M001 is not set
# CONFIG_VIDEO_MT9M032 is not set
# CONFIG_VIDEO_MT9M111 is not set
# CONFIG_VIDEO_MT9P031 is not set
# CONFIG_VIDEO_MT9T001 is not set
# CONFIG_VIDEO_MT9T112 is not set
# CONFIG_VIDEO_MT9V011 is not set
# CONFIG_VIDEO_MT9V032 is not set
# CONFIG_VIDEO_MT9V111 is not set
# CONFIG_VIDEO_SR030PC30 is not set
# CONFIG_VIDEO_NOON010PC30 is not set
# CONFIG_VIDEO_M5MOLS is not set
# CONFIG_VIDEO_RDACM20 is not set
# CONFIG_VIDEO_RDACM21 is not set
# CONFIG_VIDEO_RJ54N1 is not set
# CONFIG_VIDEO_S5K6AA is not set
# CONFIG_VIDEO_S5K6A3 is not set
# CONFIG_VIDEO_S5K4ECGX is not set
# CONFIG_VIDEO_S5K5BAF is not set
# CONFIG_VIDEO_CCS is not set
# CONFIG_VIDEO_ET8EK8 is not set
# CONFIG_VIDEO_S5C73M3 is not set
# end of Camera sensor devices

#
# Lens drivers
#
# CONFIG_VIDEO_AD5820 is not set
# CONFIG_VIDEO_AK7375 is not set
# CONFIG_VIDEO_DW9714 is not set
# CONFIG_VIDEO_DW9768 is not set
# CONFIG_VIDEO_DW9807_VCM is not set
# end of Lens drivers

#
# Flash devices
#
# CONFIG_VIDEO_ADP1653 is not set
# CONFIG_VIDEO_LM3560 is not set
# CONFIG_VIDEO_LM3646 is not set
# end of Flash devices

#
# SPI helper chips
#
# CONFIG_VIDEO_GS1662 is not set
# end of SPI helper chips

#
# Media SPI Adapters
#
CONFIG_CXD2880_SPI_DRV=m
# end of Media SPI Adapters

CONFIG_MEDIA_TUNER=m

#
# Customize TV tuners
#
CONFIG_MEDIA_TUNER_SIMPLE=m
CONFIG_MEDIA_TUNER_TDA18250=m
CONFIG_MEDIA_TUNER_TDA8290=m
CONFIG_MEDIA_TUNER_TDA827X=m
CONFIG_MEDIA_TUNER_TDA18271=m
CONFIG_MEDIA_TUNER_TDA9887=m
CONFIG_MEDIA_TUNER_TEA5761=m
CONFIG_MEDIA_TUNER_TEA5767=m
CONFIG_MEDIA_TUNER_MSI001=m
CONFIG_MEDIA_TUNER_MT20XX=m
CONFIG_MEDIA_TUNER_MT2060=m
CONFIG_MEDIA_TUNER_MT2063=m
CONFIG_MEDIA_TUNER_MT2266=m
CONFIG_MEDIA_TUNER_MT2131=m
CONFIG_MEDIA_TUNER_QT1010=m
CONFIG_MEDIA_TUNER_XC2028=m
CONFIG_MEDIA_TUNER_XC5000=m
CONFIG_MEDIA_TUNER_XC4000=m
CONFIG_MEDIA_TUNER_MXL5005S=m
CONFIG_MEDIA_TUNER_MXL5007T=m
CONFIG_MEDIA_TUNER_MC44S803=m
CONFIG_MEDIA_TUNER_MAX2165=m
CONFIG_MEDIA_TUNER_TDA18218=m
CONFIG_MEDIA_TUNER_FC0011=m
CONFIG_MEDIA_TUNER_FC0012=m
CONFIG_MEDIA_TUNER_FC0013=m
CONFIG_MEDIA_TUNER_TDA18212=m
CONFIG_MEDIA_TUNER_E4000=m
CONFIG_MEDIA_TUNER_FC2580=m
CONFIG_MEDIA_TUNER_M88RS6000T=m
CONFIG_MEDIA_TUNER_TUA9001=m
CONFIG_MEDIA_TUNER_SI2157=m
CONFIG_MEDIA_TUNER_IT913X=m
CONFIG_MEDIA_TUNER_R820T=m
CONFIG_MEDIA_TUNER_MXL301RF=m
CONFIG_MEDIA_TUNER_QM1D1C0042=m
CONFIG_MEDIA_TUNER_QM1D1B0004=m
# end of Customize TV tuners

#
# Customise DVB Frontends
#

#
# Multistandard (satellite) frontends
#
CONFIG_DVB_STB0899=m
CONFIG_DVB_STB6100=m
CONFIG_DVB_STV090x=m
CONFIG_DVB_STV0910=m
CONFIG_DVB_STV6110x=m
CONFIG_DVB_STV6111=m
CONFIG_DVB_MXL5XX=m
CONFIG_DVB_M88DS3103=m

#
# Multistandard (cable + terrestrial) frontends
#
CONFIG_DVB_DRXK=m
CONFIG_DVB_TDA18271C2DD=m
CONFIG_DVB_SI2165=m
CONFIG_DVB_MN88472=m
CONFIG_DVB_MN88473=m

#
# DVB-S (satellite) frontends
#
CONFIG_DVB_CX24110=m
CONFIG_DVB_CX24123=m
CONFIG_DVB_MT312=m
CONFIG_DVB_ZL10036=m
CONFIG_DVB_ZL10039=m
CONFIG_DVB_S5H1420=m
CONFIG_DVB_STV0288=m
CONFIG_DVB_STB6000=m
CONFIG_DVB_STV0299=m
CONFIG_DVB_STV6110=m
CONFIG_DVB_STV0900=m
CONFIG_DVB_TDA8083=m
CONFIG_DVB_TDA10086=m
CONFIG_DVB_TDA8261=m
CONFIG_DVB_VES1X93=m
CONFIG_DVB_TUNER_ITD1000=m
CONFIG_DVB_TUNER_CX24113=m
CONFIG_DVB_TDA826X=m
CONFIG_DVB_TUA6100=m
CONFIG_DVB_CX24116=m
CONFIG_DVB_CX24117=m
CONFIG_DVB_CX24120=m
CONFIG_DVB_SI21XX=m
CONFIG_DVB_TS2020=m
CONFIG_DVB_DS3000=m
CONFIG_DVB_MB86A16=m
CONFIG_DVB_TDA10071=m

#
# DVB-T (terrestrial) frontends
#
CONFIG_DVB_SP8870=m
CONFIG_DVB_SP887X=m
CONFIG_DVB_CX22700=m
CONFIG_DVB_CX22702=m
CONFIG_DVB_S5H1432=m
CONFIG_DVB_DRXD=m
CONFIG_DVB_L64781=m
CONFIG_DVB_TDA1004X=m
CONFIG_DVB_NXT6000=m
CONFIG_DVB_MT352=m
CONFIG_DVB_ZL10353=m
CONFIG_DVB_DIB3000MB=m
CONFIG_DVB_DIB3000MC=m
CONFIG_DVB_DIB7000M=m
CONFIG_DVB_DIB7000P=m
CONFIG_DVB_DIB9000=m
CONFIG_DVB_TDA10048=m
CONFIG_DVB_AF9013=m
CONFIG_DVB_EC100=m
CONFIG_DVB_STV0367=m
CONFIG_DVB_CXD2820R=m
CONFIG_DVB_CXD2841ER=m
CONFIG_DVB_RTL2830=m
CONFIG_DVB_RTL2832=m
CONFIG_DVB_RTL2832_SDR=m
CONFIG_DVB_SI2168=m
CONFIG_DVB_ZD1301_DEMOD=m
CONFIG_DVB_CXD2880=m

#
# DVB-C (cable) frontends
#
CONFIG_DVB_VES1820=m
CONFIG_DVB_TDA10021=m
CONFIG_DVB_TDA10023=m
CONFIG_DVB_STV0297=m

#
# ATSC (North American/Korean Terrestrial/Cable DTV) frontends
#
CONFIG_DVB_NXT200X=m
CONFIG_DVB_OR51211=m
CONFIG_DVB_OR51132=m
CONFIG_DVB_BCM3510=m
CONFIG_DVB_LGDT330X=m
CONFIG_DVB_LGDT3305=m
CONFIG_DVB_LGDT3306A=m
CONFIG_DVB_LG2160=m
CONFIG_DVB_S5H1409=m
CONFIG_DVB_AU8522=m
CONFIG_DVB_AU8522_DTV=m
CONFIG_DVB_AU8522_V4L=m
CONFIG_DVB_S5H1411=m
CONFIG_DVB_MXL692=m

#
# ISDB-T (terrestrial) frontends
#
CONFIG_DVB_S921=m
CONFIG_DVB_DIB8000=m
CONFIG_DVB_MB86A20S=m

#
# ISDB-S (satellite) & ISDB-T (terrestrial) frontends
#
CONFIG_DVB_TC90522=m
CONFIG_DVB_MN88443X=m

#
# Digital terrestrial only tuners/PLL
#
CONFIG_DVB_PLL=m
CONFIG_DVB_TUNER_DIB0070=m
CONFIG_DVB_TUNER_DIB0090=m

#
# SEC control devices for DVB-S
#
CONFIG_DVB_DRX39XYJ=m
CONFIG_DVB_LNBH25=m
CONFIG_DVB_LNBH29=m
CONFIG_DVB_LNBP21=m
CONFIG_DVB_LNBP22=m
CONFIG_DVB_ISL6405=m
CONFIG_DVB_ISL6421=m
CONFIG_DVB_ISL6423=m
CONFIG_DVB_A8293=m
CONFIG_DVB_LGS8GL5=m
CONFIG_DVB_LGS8GXX=m
CONFIG_DVB_ATBM8830=m
CONFIG_DVB_TDA665x=m
CONFIG_DVB_IX2505V=m
CONFIG_DVB_M88RS2000=m
CONFIG_DVB_AF9033=m
CONFIG_DVB_HORUS3A=m
CONFIG_DVB_ASCOT2E=m
CONFIG_DVB_HELENE=m

#
# Common Interface (EN50221) controller drivers
#
CONFIG_DVB_CXD2099=m
CONFIG_DVB_SP2=m
# end of Customise DVB Frontends

#
# Tools to develop new frontends
#
# CONFIG_DVB_DUMMY_FE is not set
# end of Media ancillary drivers

#
# Graphics support
#
# CONFIG_AGP is not set
CONFIG_INTEL_GTT=m
CONFIG_VGA_ARB=y
CONFIG_VGA_ARB_MAX_GPUS=64
CONFIG_VGA_SWITCHEROO=y
CONFIG_DRM=y
CONFIG_DRM_MIPI_DSI=y
CONFIG_DRM_DP_AUX_CHARDEV=y
# CONFIG_DRM_DEBUG_MM is not set
CONFIG_DRM_DEBUG_SELFTEST=m
CONFIG_DRM_KMS_HELPER=y
CONFIG_DRM_KMS_FB_HELPER=y
# CONFIG_DRM_DEBUG_DP_MST_TOPOLOGY_REFS is not set
CONFIG_DRM_FBDEV_EMULATION=y
CONFIG_DRM_FBDEV_OVERALLOC=100
# CONFIG_DRM_FBDEV_LEAK_PHYS_SMEM is not set
CONFIG_DRM_LOAD_EDID_FIRMWARE=y
# CONFIG_DRM_DP_CEC is not set
CONFIG_DRM_TTM=m
CONFIG_DRM_VRAM_HELPER=m
CONFIG_DRM_TTM_HELPER=m
CONFIG_DRM_GEM_SHMEM_HELPER=y

#
# I2C encoder or helper chips
#
CONFIG_DRM_I2C_CH7006=m
CONFIG_DRM_I2C_SIL164=m
# CONFIG_DRM_I2C_NXP_TDA998X is not set
# CONFIG_DRM_I2C_NXP_TDA9950 is not set
# end of I2C encoder or helper chips

#
# ARM devices
#
# end of ARM devices

# CONFIG_DRM_RADEON is not set
# CONFIG_DRM_AMDGPU is not set
# CONFIG_DRM_NOUVEAU is not set
CONFIG_DRM_I915=m
CONFIG_DRM_I915_FORCE_PROBE=""
CONFIG_DRM_I915_CAPTURE_ERROR=y
CONFIG_DRM_I915_COMPRESS_ERROR=y
CONFIG_DRM_I915_USERPTR=y
CONFIG_DRM_I915_GVT=y
CONFIG_DRM_I915_GVT_KVMGT=m

#
# drm/i915 Debugging
#
# CONFIG_DRM_I915_WERROR is not set
# CONFIG_DRM_I915_DEBUG is not set
# CONFIG_DRM_I915_DEBUG_MMIO is not set
# CONFIG_DRM_I915_SW_FENCE_DEBUG_OBJECTS is not set
# CONFIG_DRM_I915_SW_FENCE_CHECK_DAG is not set
# CONFIG_DRM_I915_DEBUG_GUC is not set
# CONFIG_DRM_I915_SELFTEST is not set
# CONFIG_DRM_I915_LOW_LEVEL_TRACEPOINTS is not set
# CONFIG_DRM_I915_DEBUG_VBLANK_EVADE is not set
# CONFIG_DRM_I915_DEBUG_RUNTIME_PM is not set
# end of drm/i915 Debugging

#
# drm/i915 Profile Guided Optimisation
#
CONFIG_DRM_I915_REQUEST_TIMEOUT=20000
CONFIG_DRM_I915_FENCE_TIMEOUT=10000
CONFIG_DRM_I915_USERFAULT_AUTOSUSPEND=250
CONFIG_DRM_I915_HEARTBEAT_INTERVAL=2500
CONFIG_DRM_I915_PREEMPT_TIMEOUT=640
CONFIG_DRM_I915_MAX_REQUEST_BUSYWAIT=8000
CONFIG_DRM_I915_STOP_TIMEOUT=100
CONFIG_DRM_I915_TIMESLICE_DURATION=1
# end of drm/i915 Profile Guided Optimisation

CONFIG_DRM_VGEM=y
# CONFIG_DRM_VKMS is not set
# CONFIG_DRM_VMWGFX is not set
CONFIG_DRM_GMA500=m
# CONFIG_DRM_UDL is not set
CONFIG_DRM_AST=m
CONFIG_DRM_MGAG200=m
CONFIG_DRM_QXL=m
CONFIG_DRM_BOCHS=m
CONFIG_DRM_VIRTIO_GPU=m
CONFIG_DRM_PANEL=y

#
# Display Panels
#
# CONFIG_DRM_PANEL_RASPBERRYPI_TOUCHSCREEN is not set
# end of Display Panels

CONFIG_DRM_BRIDGE=y
CONFIG_DRM_PANEL_BRIDGE=y

#
# Display Interface Bridges
#
# CONFIG_DRM_ANALOGIX_ANX78XX is not set
# end of Display Interface Bridges

# CONFIG_DRM_ETNAVIV is not set
CONFIG_DRM_CIRRUS_QEMU=m
# CONFIG_DRM_GM12U320 is not set
# CONFIG_TINYDRM_HX8357D is not set
# CONFIG_TINYDRM_ILI9225 is not set
# CONFIG_TINYDRM_ILI9341 is not set
# CONFIG_TINYDRM_ILI9486 is not set
# CONFIG_TINYDRM_MI0283QT is not set
# CONFIG_TINYDRM_REPAPER is not set
# CONFIG_TINYDRM_ST7586 is not set
# CONFIG_TINYDRM_ST7735R is not set
# CONFIG_DRM_XEN_FRONTEND is not set
# CONFIG_DRM_VBOXVIDEO is not set
# CONFIG_DRM_GUD is not set
# CONFIG_DRM_LEGACY is not set
CONFIG_DRM_EXPORT_FOR_TESTS=y
CONFIG_DRM_PANEL_ORIENTATION_QUIRKS=y
CONFIG_DRM_LIB_RANDOM=y

#
# Frame buffer Devices
#
CONFIG_FB_CMDLINE=y
CONFIG_FB_NOTIFY=y
CONFIG_FB=y
# CONFIG_FIRMWARE_EDID is not set
CONFIG_FB_BOOT_VESA_SUPPORT=y
CONFIG_FB_CFB_FILLRECT=y
CONFIG_FB_CFB_COPYAREA=y
CONFIG_FB_CFB_IMAGEBLIT=y
CONFIG_FB_SYS_FILLRECT=y
CONFIG_FB_SYS_COPYAREA=y
CONFIG_FB_SYS_IMAGEBLIT=y
# CONFIG_FB_FOREIGN_ENDIAN is not set
CONFIG_FB_SYS_FOPS=y
CONFIG_FB_DEFERRED_IO=y
# CONFIG_FB_MODE_HELPERS is not set
CONFIG_FB_TILEBLITTING=y

#
# Frame buffer hardware drivers
#
# CONFIG_FB_CIRRUS is not set
# CONFIG_FB_PM2 is not set
# CONFIG_FB_CYBER2000 is not set
# CONFIG_FB_ARC is not set
# CONFIG_FB_ASILIANT is not set
# CONFIG_FB_IMSTT is not set
# CONFIG_FB_VGA16 is not set
# CONFIG_FB_UVESA is not set
CONFIG_FB_VESA=y
CONFIG_FB_EFI=y
# CONFIG_FB_N411 is not set
# CONFIG_FB_HGA is not set
# CONFIG_FB_OPENCORES is not set
# CONFIG_FB_S1D13XXX is not set
# CONFIG_FB_NVIDIA is not set
# CONFIG_FB_RIVA is not set
# CONFIG_FB_I740 is not set
# CONFIG_FB_LE80578 is not set
# CONFIG_FB_MATROX is not set
# CONFIG_FB_RADEON is not set
# CONFIG_FB_ATY128 is not set
# CONFIG_FB_ATY is not set
# CONFIG_FB_S3 is not set
# CONFIG_FB_SAVAGE is not set
# CONFIG_FB_SIS is not set
# CONFIG_FB_VIA is not set
# CONFIG_FB_NEOMAGIC is not set
# CONFIG_FB_KYRO is not set
# CONFIG_FB_3DFX is not set
# CONFIG_FB_VOODOO1 is not set
# CONFIG_FB_VT8623 is not set
# CONFIG_FB_TRIDENT is not set
# CONFIG_FB_ARK is not set
# CONFIG_FB_PM3 is not set
# CONFIG_FB_CARMINE is not set
# CONFIG_FB_SM501 is not set
# CONFIG_FB_SMSCUFX is not set
# CONFIG_FB_UDL is not set
# CONFIG_FB_IBM_GXT4500 is not set
# CONFIG_FB_VIRTUAL is not set
# CONFIG_XEN_FBDEV_FRONTEND is not set
# CONFIG_FB_METRONOME is not set
# CONFIG_FB_MB862XX is not set
CONFIG_FB_HYPERV=m
# CONFIG_FB_SIMPLE is not set
# CONFIG_FB_SM712 is not set
# end of Frame buffer Devices

#
# Backlight & LCD device support
#
CONFIG_LCD_CLASS_DEVICE=m
# CONFIG_LCD_L4F00242T03 is not set
# CONFIG_LCD_LMS283GF05 is not set
# CONFIG_LCD_LTV350QV is not set
# CONFIG_LCD_ILI922X is not set
# CONFIG_LCD_ILI9320 is not set
# CONFIG_LCD_TDO24M is not set
# CONFIG_LCD_VGG2432A4 is not set
CONFIG_LCD_PLATFORM=m
# CONFIG_LCD_AMS369FG06 is not set
# CONFIG_LCD_LMS501KF03 is not set
# CONFIG_LCD_HX8357 is not set
# CONFIG_LCD_OTM3225A is not set
CONFIG_BACKLIGHT_CLASS_DEVICE=y
# CONFIG_BACKLIGHT_KTD253 is not set
# CONFIG_BACKLIGHT_PWM is not set
CONFIG_BACKLIGHT_APPLE=m
# CONFIG_BACKLIGHT_QCOM_WLED is not set
# CONFIG_BACKLIGHT_SAHARA is not set
# CONFIG_BACKLIGHT_ADP8860 is not set
# CONFIG_BACKLIGHT_ADP8870 is not set
# CONFIG_BACKLIGHT_LM3630A is not set
# CONFIG_BACKLIGHT_LM3639 is not set
CONFIG_BACKLIGHT_LP855X=m
# CONFIG_BACKLIGHT_GPIO is not set
# CONFIG_BACKLIGHT_LV5207LP is not set
# CONFIG_BACKLIGHT_BD6107 is not set
# CONFIG_BACKLIGHT_ARCXCNN is not set
# end of Backlight & LCD device support

CONFIG_HDMI=y

#
# Console display driver support
#
CONFIG_VGA_CONSOLE=y
CONFIG_DUMMY_CONSOLE=y
CONFIG_DUMMY_CONSOLE_COLUMNS=80
CONFIG_DUMMY_CONSOLE_ROWS=25
CONFIG_FRAMEBUFFER_CONSOLE=y
CONFIG_FRAMEBUFFER_CONSOLE_DETECT_PRIMARY=y
CONFIG_FRAMEBUFFER_CONSOLE_ROTATION=y
# CONFIG_FRAMEBUFFER_CONSOLE_DEFERRED_TAKEOVER is not set
# end of Console display driver support

CONFIG_LOGO=y
# CONFIG_LOGO_LINUX_MONO is not set
# CONFIG_LOGO_LINUX_VGA16 is not set
CONFIG_LOGO_LINUX_CLUT224=y
# end of Graphics support

# CONFIG_SOUND is not set

#
# HID support
#
CONFIG_HID=y
CONFIG_HID_BATTERY_STRENGTH=y
CONFIG_HIDRAW=y
CONFIG_UHID=m
CONFIG_HID_GENERIC=y

#
# Special HID drivers
#
CONFIG_HID_A4TECH=m
# CONFIG_HID_ACCUTOUCH is not set
CONFIG_HID_ACRUX=m
# CONFIG_HID_ACRUX_FF is not set
CONFIG_HID_APPLE=m
# CONFIG_HID_APPLEIR is not set
CONFIG_HID_ASUS=m
CONFIG_HID_AUREAL=m
CONFIG_HID_BELKIN=m
# CONFIG_HID_BETOP_FF is not set
# CONFIG_HID_BIGBEN_FF is not set
CONFIG_HID_CHERRY=m
CONFIG_HID_CHICONY=m
# CONFIG_HID_CORSAIR is not set
# CONFIG_HID_COUGAR is not set
# CONFIG_HID_MACALLY is not set
CONFIG_HID_CMEDIA=m
# CONFIG_HID_CP2112 is not set
# CONFIG_HID_CREATIVE_SB0540 is not set
CONFIG_HID_CYPRESS=m
CONFIG_HID_DRAGONRISE=m
# CONFIG_DRAGONRISE_FF is not set
# CONFIG_HID_EMS_FF is not set
# CONFIG_HID_ELAN is not set
CONFIG_HID_ELECOM=m
# CONFIG_HID_ELO is not set
CONFIG_HID_EZKEY=m
# CONFIG_HID_FT260 is not set
CONFIG_HID_GEMBIRD=m
CONFIG_HID_GFRM=m
# CONFIG_HID_GLORIOUS is not set
# CONFIG_HID_HOLTEK is not set
# CONFIG_HID_VIVALDI is not set
# CONFIG_HID_GT683R is not set
CONFIG_HID_KEYTOUCH=m
CONFIG_HID_KYE=m
# CONFIG_HID_UCLOGIC is not set
CONFIG_HID_WALTOP=m
# CONFIG_HID_VIEWSONIC is not set
CONFIG_HID_GYRATION=m
CONFIG_HID_ICADE=m
CONFIG_HID_ITE=m
CONFIG_HID_JABRA=m
CONFIG_HID_TWINHAN=m
CONFIG_HID_KENSINGTON=m
CONFIG_HID_LCPOWER=m
CONFIG_HID_LED=m
CONFIG_HID_LENOVO=m
CONFIG_HID_LOGITECH=m
CONFIG_HID_LOGITECH_DJ=m
CONFIG_HID_LOGITECH_HIDPP=m
# CONFIG_LOGITECH_FF is not set
# CONFIG_LOGIRUMBLEPAD2_FF is not set
# CONFIG_LOGIG940_FF is not set
# CONFIG_LOGIWHEELS_FF is not set
CONFIG_HID_MAGICMOUSE=y
# CONFIG_HID_MALTRON is not set
# CONFIG_HID_MAYFLASH is not set
# CONFIG_HID_REDRAGON is not set
CONFIG_HID_MICROSOFT=m
CONFIG_HID_MONTEREY=m
CONFIG_HID_MULTITOUCH=m
CONFIG_HID_NTI=m
# CONFIG_HID_NTRIG is not set
CONFIG_HID_ORTEK=m
CONFIG_HID_PANTHERLORD=m
# CONFIG_PANTHERLORD_FF is not set
# CONFIG_HID_PENMOUNT is not set
CONFIG_HID_PETALYNX=m
CONFIG_HID_PICOLCD=m
CONFIG_HID_PICOLCD_FB=y
CONFIG_HID_PICOLCD_BACKLIGHT=y
CONFIG_HID_PICOLCD_LCD=y
CONFIG_HID_PICOLCD_LEDS=y
CONFIG_HID_PICOLCD_CIR=y
CONFIG_HID_PLANTRONICS=m
# CONFIG_HID_PLAYSTATION is not set
CONFIG_HID_PRIMAX=m
# CONFIG_HID_RETRODE is not set
# CONFIG_HID_ROCCAT is not set
CONFIG_HID_SAITEK=m
CONFIG_HID_SAMSUNG=m
# CONFIG_HID_SONY is not set
CONFIG_HID_SPEEDLINK=m
# CONFIG_HID_STEAM is not set
CONFIG_HID_STEELSERIES=m
CONFIG_HID_SUNPLUS=m
CONFIG_HID_RMI=m
CONFIG_HID_GREENASIA=m
# CONFIG_GREENASIA_FF is not set
CONFIG_HID_HYPERV_MOUSE=m
CONFIG_HID_SMARTJOYPLUS=m
# CONFIG_SMARTJOYPLUS_FF is not set
CONFIG_HID_TIVO=m
CONFIG_HID_TOPSEED=m
CONFIG_HID_THINGM=m
CONFIG_HID_THRUSTMASTER=m
# CONFIG_THRUSTMASTER_FF is not set
# CONFIG_HID_UDRAW_PS3 is not set
# CONFIG_HID_U2FZERO is not set
# CONFIG_HID_WACOM is not set
CONFIG_HID_WIIMOTE=m
CONFIG_HID_XINMO=m
CONFIG_HID_ZEROPLUS=m
# CONFIG_ZEROPLUS_FF is not set
CONFIG_HID_ZYDACRON=m
CONFIG_HID_SENSOR_HUB=y
CONFIG_HID_SENSOR_CUSTOM_SENSOR=m
CONFIG_HID_ALPS=m
# CONFIG_HID_MCP2221 is not set
# end of Special HID drivers

#
# USB HID support
#
CONFIG_USB_HID=y
# CONFIG_HID_PID is not set
# CONFIG_USB_HIDDEV is not set
# end of USB HID support

#
# I2C HID support
#
# CONFIG_I2C_HID_ACPI is not set
# end of I2C HID support

#
# Intel ISH HID support
#
CONFIG_INTEL_ISH_HID=m
# CONFIG_INTEL_ISH_FIRMWARE_DOWNLOADER is not set
# end of Intel ISH HID support

#
# AMD SFH HID Support
#
# CONFIG_AMD_SFH_HID is not set
# end of AMD SFH HID Support
# end of HID support

CONFIG_USB_OHCI_LITTLE_ENDIAN=y
CONFIG_USB_SUPPORT=y
CONFIG_USB_COMMON=y
# CONFIG_USB_LED_TRIG is not set
# CONFIG_USB_ULPI_BUS is not set
# CONFIG_USB_CONN_GPIO is not set
CONFIG_USB_ARCH_HAS_HCD=y
CONFIG_USB=y
CONFIG_USB_PCI=y
CONFIG_USB_ANNOUNCE_NEW_DEVICES=y

#
# Miscellaneous USB options
#
CONFIG_USB_DEFAULT_PERSIST=y
# CONFIG_USB_FEW_INIT_RETRIES is not set
# CONFIG_USB_DYNAMIC_MINORS is not set
# CONFIG_USB_OTG is not set
# CONFIG_USB_OTG_PRODUCTLIST is not set
# CONFIG_USB_OTG_DISABLE_EXTERNAL_HUB is not set
CONFIG_USB_LEDS_TRIGGER_USBPORT=y
CONFIG_USB_AUTOSUSPEND_DELAY=2
CONFIG_USB_MON=y

#
# USB Host Controller Drivers
#
# CONFIG_USB_C67X00_HCD is not set
CONFIG_USB_XHCI_HCD=y
# CONFIG_USB_XHCI_DBGCAP is not set
CONFIG_USB_XHCI_PCI=y
# CONFIG_USB_XHCI_PCI_RENESAS is not set
# CONFIG_USB_XHCI_PLATFORM is not set
CONFIG_USB_EHCI_HCD=y
CONFIG_USB_EHCI_ROOT_HUB_TT=y
CONFIG_USB_EHCI_TT_NEWSCHED=y
CONFIG_USB_EHCI_PCI=y
# CONFIG_USB_EHCI_FSL is not set
# CONFIG_USB_EHCI_HCD_PLATFORM is not set
# CONFIG_USB_OXU210HP_HCD is not set
# CONFIG_USB_ISP116X_HCD is not set
# CONFIG_USB_FOTG210_HCD is not set
# CONFIG_USB_MAX3421_HCD is not set
CONFIG_USB_OHCI_HCD=y
CONFIG_USB_OHCI_HCD_PCI=y
# CONFIG_USB_OHCI_HCD_PLATFORM is not set
CONFIG_USB_UHCI_HCD=y
# CONFIG_USB_SL811_HCD is not set
# CONFIG_USB_R8A66597_HCD is not set
# CONFIG_USB_HCD_BCMA is not set
# CONFIG_USB_HCD_TEST_MODE is not set

#
# USB Device Class drivers
#
# CONFIG_USB_ACM is not set
# CONFIG_USB_PRINTER is not set
# CONFIG_USB_WDM is not set
# CONFIG_USB_TMC is not set

#
# NOTE: USB_STORAGE depends on SCSI but BLK_DEV_SD may
#

#
# also be needed; see USB_STORAGE Help for more info
#
CONFIG_USB_STORAGE=m
# CONFIG_USB_STORAGE_DEBUG is not set
# CONFIG_USB_STORAGE_REALTEK is not set
# CONFIG_USB_STORAGE_DATAFAB is not set
# CONFIG_USB_STORAGE_FREECOM is not set
# CONFIG_USB_STORAGE_ISD200 is not set
# CONFIG_USB_STORAGE_USBAT is not set
# CONFIG_USB_STORAGE_SDDR09 is not set
# CONFIG_USB_STORAGE_SDDR55 is not set
# CONFIG_USB_STORAGE_JUMPSHOT is not set
# CONFIG_USB_STORAGE_ALAUDA is not set
# CONFIG_USB_STORAGE_ONETOUCH is not set
# CONFIG_USB_STORAGE_KARMA is not set
# CONFIG_USB_STORAGE_CYPRESS_ATACB is not set
# CONFIG_USB_STORAGE_ENE_UB6250 is not set
# CONFIG_USB_UAS is not set

#
# USB Imaging devices
#
# CONFIG_USB_MDC800 is not set
# CONFIG_USB_MICROTEK is not set
# CONFIG_USBIP_CORE is not set
# CONFIG_USB_CDNS_SUPPORT is not set
# CONFIG_USB_MUSB_HDRC is not set
# CONFIG_USB_DWC3 is not set
# CONFIG_USB_DWC2 is not set
# CONFIG_USB_CHIPIDEA is not set
# CONFIG_USB_ISP1760 is not set

#
# USB port drivers
#
# CONFIG_USB_USS720 is not set
CONFIG_USB_SERIAL=m
CONFIG_USB_SERIAL_GENERIC=y
# CONFIG_USB_SERIAL_SIMPLE is not set
# CONFIG_USB_SERIAL_AIRCABLE is not set
# CONFIG_USB_SERIAL_ARK3116 is not set
# CONFIG_USB_SERIAL_BELKIN is not set
# CONFIG_USB_SERIAL_CH341 is not set
# CONFIG_USB_SERIAL_WHITEHEAT is not set
# CONFIG_USB_SERIAL_DIGI_ACCELEPORT is not set
# CONFIG_USB_SERIAL_CP210X is not set
# CONFIG_USB_SERIAL_CYPRESS_M8 is not set
# CONFIG_USB_SERIAL_EMPEG is not set
# CONFIG_USB_SERIAL_FTDI_SIO is not set
# CONFIG_USB_SERIAL_VISOR is not set
# CONFIG_USB_SERIAL_IPAQ is not set
# CONFIG_USB_SERIAL_IR is not set
# CONFIG_USB_SERIAL_EDGEPORT is not set
# CONFIG_USB_SERIAL_EDGEPORT_TI is not set
# CONFIG_USB_SERIAL_F81232 is not set
# CONFIG_USB_SERIAL_F8153X is not set
# CONFIG_USB_SERIAL_GARMIN is not set
# CONFIG_USB_SERIAL_IPW is not set
# CONFIG_USB_SERIAL_IUU is not set
# CONFIG_USB_SERIAL_KEYSPAN_PDA is not set
# CONFIG_USB_SERIAL_KEYSPAN is not set
# CONFIG_USB_SERIAL_KLSI is not set
# CONFIG_USB_SERIAL_KOBIL_SCT is not set
# CONFIG_USB_SERIAL_MCT_U232 is not set
# CONFIG_USB_SERIAL_METRO is not set
# CONFIG_USB_SERIAL_MOS7720 is not set
# CONFIG_USB_SERIAL_MOS7840 is not set
# CONFIG_USB_SERIAL_MXUPORT is not set
# CONFIG_USB_SERIAL_NAVMAN is not set
# CONFIG_USB_SERIAL_PL2303 is not set
# CONFIG_USB_SERIAL_OTI6858 is not set
# CONFIG_USB_SERIAL_QCAUX is not set
# CONFIG_USB_SERIAL_QUALCOMM is not set
# CONFIG_USB_SERIAL_SPCP8X5 is not set
# CONFIG_USB_SERIAL_SAFE is not set
# CONFIG_USB_SERIAL_SIERRAWIRELESS is not set
# CONFIG_USB_SERIAL_SYMBOL is not set
# CONFIG_USB_SERIAL_TI is not set
# CONFIG_USB_SERIAL_CYBERJACK is not set
# CONFIG_USB_SERIAL_OPTION is not set
# CONFIG_USB_SERIAL_OMNINET is not set
# CONFIG_USB_SERIAL_OPTICON is not set
# CONFIG_USB_SERIAL_XSENS_MT is not set
# CONFIG_USB_SERIAL_WISHBONE is not set
# CONFIG_USB_SERIAL_SSU100 is not set
# CONFIG_USB_SERIAL_QT2 is not set
# CONFIG_USB_SERIAL_UPD78F0730 is not set
# CONFIG_USB_SERIAL_XR is not set
CONFIG_USB_SERIAL_DEBUG=m

#
# USB Miscellaneous drivers
#
# CONFIG_USB_EMI62 is not set
# CONFIG_USB_EMI26 is not set
# CONFIG_USB_ADUTUX is not set
# CONFIG_USB_SEVSEG is not set
# CONFIG_USB_LEGOTOWER is not set
# CONFIG_USB_LCD is not set
# CONFIG_USB_CYPRESS_CY7C63 is not set
# CONFIG_USB_CYTHERM is not set
# CONFIG_USB_IDMOUSE is not set
# CONFIG_USB_FTDI_ELAN is not set
# CONFIG_USB_APPLEDISPLAY is not set
# CONFIG_APPLE_MFI_FASTCHARGE is not set
# CONFIG_USB_SISUSBVGA is not set
# CONFIG_USB_LD is not set
# CONFIG_USB_TRANCEVIBRATOR is not set
# CONFIG_USB_IOWARRIOR is not set
# CONFIG_USB_TEST is not set
# CONFIG_USB_EHSET_TEST_FIXTURE is not set
# CONFIG_USB_ISIGHTFW is not set
# CONFIG_USB_YUREX is not set
# CONFIG_USB_EZUSB_FX2 is not set
# CONFIG_USB_HUB_USB251XB is not set
# CONFIG_USB_HSIC_USB3503 is not set
# CONFIG_USB_HSIC_USB4604 is not set
# CONFIG_USB_LINK_LAYER_TEST is not set
# CONFIG_USB_CHAOSKEY is not set
# CONFIG_USB_ATM is not set

#
# USB Physical Layer drivers
#
# CONFIG_NOP_USB_XCEIV is not set
# CONFIG_USB_GPIO_VBUS is not set
# CONFIG_USB_ISP1301 is not set
# end of USB Physical Layer drivers

# CONFIG_USB_GADGET is not set
CONFIG_TYPEC=y
# CONFIG_TYPEC_TCPM is not set
CONFIG_TYPEC_UCSI=y
# CONFIG_UCSI_CCG is not set
CONFIG_UCSI_ACPI=y
# CONFIG_TYPEC_TPS6598X is not set
# CONFIG_TYPEC_STUSB160X is not set

#
# USB Type-C Multiplexer/DeMultiplexer Switch support
#
# CONFIG_TYPEC_MUX_PI3USB30532 is not set
# end of USB Type-C Multiplexer/DeMultiplexer Switch support

#
# USB Type-C Alternate Mode drivers
#
# CONFIG_TYPEC_DP_ALTMODE is not set
# end of USB Type-C Alternate Mode drivers

# CONFIG_USB_ROLE_SWITCH is not set
CONFIG_MMC=m
CONFIG_MMC_BLOCK=m
CONFIG_MMC_BLOCK_MINORS=8
CONFIG_SDIO_UART=m
# CONFIG_MMC_TEST is not set

#
# MMC/SD/SDIO Host Controller Drivers
#
# CONFIG_MMC_DEBUG is not set
CONFIG_MMC_SDHCI=m
CONFIG_MMC_SDHCI_IO_ACCESSORS=y
CONFIG_MMC_SDHCI_PCI=m
CONFIG_MMC_RICOH_MMC=y
CONFIG_MMC_SDHCI_ACPI=m
CONFIG_MMC_SDHCI_PLTFM=m
# CONFIG_MMC_SDHCI_F_SDH30 is not set
# CONFIG_MMC_WBSD is not set
# CONFIG_MMC_TIFM_SD is not set
# CONFIG_MMC_SPI is not set
# CONFIG_MMC_CB710 is not set
# CONFIG_MMC_VIA_SDMMC is not set
# CONFIG_MMC_VUB300 is not set
# CONFIG_MMC_USHC is not set
# CONFIG_MMC_USDHI6ROL0 is not set
# CONFIG_MMC_REALTEK_PCI is not set
CONFIG_MMC_CQHCI=m
# CONFIG_MMC_HSQ is not set
# CONFIG_MMC_TOSHIBA_PCI is not set
# CONFIG_MMC_MTK is not set
# CONFIG_MMC_SDHCI_XENON is not set
# CONFIG_MEMSTICK is not set
CONFIG_NEW_LEDS=y
CONFIG_LEDS_CLASS=y
# CONFIG_LEDS_CLASS_FLASH is not set
# CONFIG_LEDS_CLASS_MULTICOLOR is not set
# CONFIG_LEDS_BRIGHTNESS_HW_CHANGED is not set

#
# LED drivers
#
# CONFIG_LEDS_APU is not set
CONFIG_LEDS_LM3530=m
# CONFIG_LEDS_LM3532 is not set
# CONFIG_LEDS_LM3642 is not set
# CONFIG_LEDS_PCA9532 is not set
# CONFIG_LEDS_GPIO is not set
CONFIG_LEDS_LP3944=m
# CONFIG_LEDS_LP3952 is not set
# CONFIG_LEDS_LP50XX is not set
CONFIG_LEDS_CLEVO_MAIL=m
# CONFIG_LEDS_PCA955X is not set
# CONFIG_LEDS_PCA963X is not set
# CONFIG_LEDS_DAC124S085 is not set
# CONFIG_LEDS_PWM is not set
# CONFIG_LEDS_BD2802 is not set
CONFIG_LEDS_INTEL_SS4200=m
# CONFIG_LEDS_TCA6507 is not set
# CONFIG_LEDS_TLC591XX is not set
# CONFIG_LEDS_LM355x is not set

#
# LED driver for blink(1) USB RGB LED is under Special HID drivers (HID_THINGM)
#
CONFIG_LEDS_BLINKM=m
CONFIG_LEDS_MLXCPLD=m
# CONFIG_LEDS_MLXREG is not set
# CONFIG_LEDS_USER is not set
# CONFIG_LEDS_NIC78BX is not set
# CONFIG_LEDS_TI_LMU_COMMON is not set

#
# Flash and Torch LED drivers
#

#
# LED Triggers
#
CONFIG_LEDS_TRIGGERS=y
CONFIG_LEDS_TRIGGER_TIMER=m
CONFIG_LEDS_TRIGGER_ONESHOT=m
# CONFIG_LEDS_TRIGGER_DISK is not set
CONFIG_LEDS_TRIGGER_HEARTBEAT=m
CONFIG_LEDS_TRIGGER_BACKLIGHT=m
# CONFIG_LEDS_TRIGGER_CPU is not set
# CONFIG_LEDS_TRIGGER_ACTIVITY is not set
CONFIG_LEDS_TRIGGER_GPIO=m
CONFIG_LEDS_TRIGGER_DEFAULT_ON=m

#
# iptables trigger is under Netfilter config (LED target)
#
CONFIG_LEDS_TRIGGER_TRANSIENT=m
CONFIG_LEDS_TRIGGER_CAMERA=m
# CONFIG_LEDS_TRIGGER_PANIC is not set
# CONFIG_LEDS_TRIGGER_NETDEV is not set
# CONFIG_LEDS_TRIGGER_PATTERN is not set
CONFIG_LEDS_TRIGGER_AUDIO=m
# CONFIG_LEDS_TRIGGER_TTY is not set
# CONFIG_ACCESSIBILITY is not set
# CONFIG_INFINIBAND is not set
CONFIG_EDAC_ATOMIC_SCRUB=y
CONFIG_EDAC_SUPPORT=y
CONFIG_EDAC=y
CONFIG_EDAC_LEGACY_SYSFS=y
# CONFIG_EDAC_DEBUG is not set
CONFIG_EDAC_DECODE_MCE=m
CONFIG_EDAC_GHES=y
CONFIG_EDAC_AMD64=m
CONFIG_EDAC_E752X=m
CONFIG_EDAC_I82975X=m
CONFIG_EDAC_I3000=m
CONFIG_EDAC_I3200=m
CONFIG_EDAC_IE31200=m
CONFIG_EDAC_X38=m
CONFIG_EDAC_I5400=m
CONFIG_EDAC_I7CORE=m
CONFIG_EDAC_I5000=m
CONFIG_EDAC_I5100=m
CONFIG_EDAC_I7300=m
CONFIG_EDAC_SBRIDGE=m
CONFIG_EDAC_SKX=m
# CONFIG_EDAC_I10NM is not set
CONFIG_EDAC_PND2=m
# CONFIG_EDAC_IGEN6 is not set
CONFIG_RTC_LIB=y
CONFIG_RTC_MC146818_LIB=y
CONFIG_RTC_CLASS=y
CONFIG_RTC_HCTOSYS=y
CONFIG_RTC_HCTOSYS_DEVICE="rtc0"
# CONFIG_RTC_SYSTOHC is not set
# CONFIG_RTC_DEBUG is not set
CONFIG_RTC_NVMEM=y

#
# RTC interfaces
#
CONFIG_RTC_INTF_SYSFS=y
CONFIG_RTC_INTF_PROC=y
CONFIG_RTC_INTF_DEV=y
# CONFIG_RTC_INTF_DEV_UIE_EMUL is not set
# CONFIG_RTC_DRV_TEST is not set

#
# I2C RTC drivers
#
# CONFIG_RTC_DRV_ABB5ZES3 is not set
# CONFIG_RTC_DRV_ABEOZ9 is not set
# CONFIG_RTC_DRV_ABX80X is not set
CONFIG_RTC_DRV_DS1307=m
# CONFIG_RTC_DRV_DS1307_CENTURY is not set
CONFIG_RTC_DRV_DS1374=m
# CONFIG_RTC_DRV_DS1374_WDT is not set
CONFIG_RTC_DRV_DS1672=m
CONFIG_RTC_DRV_MAX6900=m
CONFIG_RTC_DRV_RS5C372=m
CONFIG_RTC_DRV_ISL1208=m
CONFIG_RTC_DRV_ISL12022=m
CONFIG_RTC_DRV_X1205=m
CONFIG_RTC_DRV_PCF8523=m
# CONFIG_RTC_DRV_PCF85063 is not set
# CONFIG_RTC_DRV_PCF85363 is not set
CONFIG_RTC_DRV_PCF8563=m
CONFIG_RTC_DRV_PCF8583=m
CONFIG_RTC_DRV_M41T80=m
CONFIG_RTC_DRV_M41T80_WDT=y
CONFIG_RTC_DRV_BQ32K=m
# CONFIG_RTC_DRV_S35390A is not set
CONFIG_RTC_DRV_FM3130=m
# CONFIG_RTC_DRV_RX8010 is not set
CONFIG_RTC_DRV_RX8581=m
CONFIG_RTC_DRV_RX8025=m
CONFIG_RTC_DRV_EM3027=m
# CONFIG_RTC_DRV_RV3028 is not set
# CONFIG_RTC_DRV_RV3032 is not set
# CONFIG_RTC_DRV_RV8803 is not set
# CONFIG_RTC_DRV_SD3078 is not set

#
# SPI RTC drivers
#
# CONFIG_RTC_DRV_M41T93 is not set
# CONFIG_RTC_DRV_M41T94 is not set
# CONFIG_RTC_DRV_DS1302 is not set
# CONFIG_RTC_DRV_DS1305 is not set
# CONFIG_RTC_DRV_DS1343 is not set
# CONFIG_RTC_DRV_DS1347 is not set
# CONFIG_RTC_DRV_DS1390 is not set
# CONFIG_RTC_DRV_MAX6916 is not set
# CONFIG_RTC_DRV_R9701 is not set
CONFIG_RTC_DRV_RX4581=m
# CONFIG_RTC_DRV_RS5C348 is not set
# CONFIG_RTC_DRV_MAX6902 is not set
# CONFIG_RTC_DRV_PCF2123 is not set
# CONFIG_RTC_DRV_MCP795 is not set
CONFIG_RTC_I2C_AND_SPI=y

#
# SPI and I2C RTC drivers
#
CONFIG_RTC_DRV_DS3232=m
CONFIG_RTC_DRV_DS3232_HWMON=y
# CONFIG_RTC_DRV_PCF2127 is not set
CONFIG_RTC_DRV_RV3029C2=m
# CONFIG_RTC_DRV_RV3029_HWMON is not set
# CONFIG_RTC_DRV_RX6110 is not set

#
# Platform RTC drivers
#
CONFIG_RTC_DRV_CMOS=y
CONFIG_RTC_DRV_DS1286=m
CONFIG_RTC_DRV_DS1511=m
CONFIG_RTC_DRV_DS1553=m
# CONFIG_RTC_DRV_DS1685_FAMILY is not set
CONFIG_RTC_DRV_DS1742=m
CONFIG_RTC_DRV_DS2404=m
CONFIG_RTC_DRV_STK17TA8=m
# CONFIG_RTC_DRV_M48T86 is not set
CONFIG_RTC_DRV_M48T35=m
CONFIG_RTC_DRV_M48T59=m
CONFIG_RTC_DRV_MSM6242=m
CONFIG_RTC_DRV_BQ4802=m
CONFIG_RTC_DRV_RP5C01=m
CONFIG_RTC_DRV_V3020=m

#
# on-CPU RTC drivers
#
# CONFIG_RTC_DRV_FTRTC010 is not set

#
# HID Sensor RTC drivers
#
# CONFIG_RTC_DRV_GOLDFISH is not set
CONFIG_DMADEVICES=y
# CONFIG_DMADEVICES_DEBUG is not set

#
# DMA Devices
#
CONFIG_DMA_ENGINE=y
CONFIG_DMA_VIRTUAL_CHANNELS=y
CONFIG_DMA_ACPI=y
# CONFIG_ALTERA_MSGDMA is not set
CONFIG_INTEL_IDMA64=m
# CONFIG_INTEL_IDXD is not set
CONFIG_INTEL_IOATDMA=m
# CONFIG_PLX_DMA is not set
# CONFIG_XILINX_ZYNQMP_DPDMA is not set
# CONFIG_QCOM_HIDMA_MGMT is not set
# CONFIG_QCOM_HIDMA is not set
CONFIG_DW_DMAC_CORE=y
CONFIG_DW_DMAC=m
CONFIG_DW_DMAC_PCI=y
# CONFIG_DW_EDMA is not set
# CONFIG_DW_EDMA_PCIE is not set
CONFIG_HSU_DMA=y
# CONFIG_SF_PDMA is not set
# CONFIG_INTEL_LDMA is not set

#
# DMA Clients
#
CONFIG_ASYNC_TX_DMA=y
CONFIG_DMATEST=m
CONFIG_DMA_ENGINE_RAID=y

#
# DMABUF options
#
CONFIG_SYNC_FILE=y
CONFIG_SW_SYNC=y
# CONFIG_UDMABUF is not set
# CONFIG_DMABUF_MOVE_NOTIFY is not set
# CONFIG_DMABUF_DEBUG is not set
# CONFIG_DMABUF_SELFTESTS is not set
# CONFIG_DMABUF_HEAPS is not set
# end of DMABUF options

CONFIG_DCA=m
# CONFIG_AUXDISPLAY is not set
# CONFIG_PANEL is not set
CONFIG_UIO=m
CONFIG_UIO_CIF=m
CONFIG_UIO_PDRV_GENIRQ=m
# CONFIG_UIO_DMEM_GENIRQ is not set
CONFIG_UIO_AEC=m
CONFIG_UIO_SERCOS3=m
CONFIG_UIO_PCI_GENERIC=m
# CONFIG_UIO_NETX is not set
# CONFIG_UIO_PRUSS is not set
# CONFIG_UIO_MF624 is not set
CONFIG_UIO_HV_GENERIC=m
CONFIG_VFIO_IOMMU_TYPE1=m
CONFIG_VFIO_VIRQFD=m
CONFIG_VFIO=m
CONFIG_VFIO_NOIOMMU=y
CONFIG_VFIO_PCI=m
# CONFIG_VFIO_PCI_VGA is not set
CONFIG_VFIO_PCI_MMAP=y
CONFIG_VFIO_PCI_INTX=y
# CONFIG_VFIO_PCI_IGD is not set
CONFIG_VFIO_MDEV=m
CONFIG_VFIO_MDEV_DEVICE=m
CONFIG_IRQ_BYPASS_MANAGER=y
# CONFIG_VIRT_DRIVERS is not set
CONFIG_VIRTIO=y
CONFIG_ARCH_HAS_RESTRICTED_VIRTIO_MEMORY_ACCESS=y
CONFIG_VIRTIO_PCI_LIB=y
CONFIG_VIRTIO_MENU=y
CONFIG_VIRTIO_PCI=y
CONFIG_VIRTIO_PCI_LEGACY=y
# CONFIG_VIRTIO_PMEM is not set
CONFIG_VIRTIO_BALLOON=m
CONFIG_VIRTIO_MEM=m
CONFIG_VIRTIO_INPUT=m
# CONFIG_VIRTIO_MMIO is not set
CONFIG_VIRTIO_DMA_SHARED_BUFFER=m
# CONFIG_VDPA is not set
CONFIG_VHOST_IOTLB=m
CONFIG_VHOST=m
CONFIG_VHOST_MENU=y
CONFIG_VHOST_NET=m
# CONFIG_VHOST_SCSI is not set
CONFIG_VHOST_VSOCK=m
# CONFIG_VHOST_CROSS_ENDIAN_LEGACY is not set

#
# Microsoft Hyper-V guest support
#
CONFIG_HYPERV=m
CONFIG_HYPERV_TIMER=y
CONFIG_HYPERV_UTILS=m
CONFIG_HYPERV_BALLOON=m
# end of Microsoft Hyper-V guest support

#
# Xen driver support
#
# CONFIG_XEN_BALLOON is not set
CONFIG_XEN_DEV_EVTCHN=m
# CONFIG_XEN_BACKEND is not set
CONFIG_XENFS=m
CONFIG_XEN_COMPAT_XENFS=y
CONFIG_XEN_SYS_HYPERVISOR=y
CONFIG_XEN_XENBUS_FRONTEND=y
# CONFIG_XEN_GNTDEV is not set
# CONFIG_XEN_GRANT_DEV_ALLOC is not set
# CONFIG_XEN_GRANT_DMA_ALLOC is not set
CONFIG_SWIOTLB_XEN=y
# CONFIG_XEN_PVCALLS_FRONTEND is not set
CONFIG_XEN_PRIVCMD=m
CONFIG_XEN_EFI=y
CONFIG_XEN_AUTO_XLATE=y
CONFIG_XEN_ACPI=y
# CONFIG_XEN_UNPOPULATED_ALLOC is not set
# end of Xen driver support

# CONFIG_GREYBUS is not set
# CONFIG_COMEDI is not set
CONFIG_STAGING=y
# CONFIG_PRISM2_USB is not set
# CONFIG_RTL8192U is not set
# CONFIG_RTLLIB is not set
# CONFIG_RTL8723BS is not set
# CONFIG_R8712U is not set
# CONFIG_R8188EU is not set
# CONFIG_RTS5208 is not set
# CONFIG_VT6655 is not set
# CONFIG_VT6656 is not set
# CONFIG_FB_SM750 is not set
# CONFIG_STAGING_MEDIA is not set

#
# Android
#
# CONFIG_ASHMEM is not set
# end of Android

# CONFIG_LTE_GDM724X is not set
# CONFIG_FIREWIRE_SERIAL is not set
# CONFIG_GS_FPGABOOT is not set
# CONFIG_UNISYSSPAR is not set
# CONFIG_FB_TFT is not set
# CONFIG_KS7010 is not set
# CONFIG_PI433 is not set
# CONFIG_FIELDBUS_DEV is not set
# CONFIG_KPC2000 is not set
# CONFIG_QLGE is not set
# CONFIG_WFX is not set
CONFIG_X86_PLATFORM_DEVICES=y
CONFIG_ACPI_WMI=m
CONFIG_WMI_BMOF=m
# CONFIG_HUAWEI_WMI is not set
# CONFIG_UV_SYSFS is not set
# CONFIG_INTEL_WMI_SBL_FW_UPDATE is not set
CONFIG_INTEL_WMI_THUNDERBOLT=m
CONFIG_MXM_WMI=m
# CONFIG_PEAQ_WMI is not set
# CONFIG_XIAOMI_WMI is not set
# CONFIG_GIGABYTE_WMI is not set
CONFIG_ACERHDF=m
# CONFIG_ACER_WIRELESS is not set
CONFIG_ACER_WMI=m
# CONFIG_AMD_PMC is not set
# CONFIG_ADV_SWBUTTON is not set
CONFIG_APPLE_GMUX=m
CONFIG_ASUS_LAPTOP=m
# CONFIG_ASUS_WIRELESS is not set
CONFIG_ASUS_WMI=m
CONFIG_ASUS_NB_WMI=m
CONFIG_EEEPC_LAPTOP=m
CONFIG_EEEPC_WMI=m
# CONFIG_X86_PLATFORM_DRIVERS_DELL is not set
CONFIG_AMILO_RFKILL=m
CONFIG_FUJITSU_LAPTOP=m
CONFIG_FUJITSU_TABLET=m
# CONFIG_GPD_POCKET_FAN is not set
CONFIG_HP_ACCEL=m
CONFIG_HP_WIRELESS=m
CONFIG_HP_WMI=m
# CONFIG_IBM_RTL is not set
CONFIG_IDEAPAD_LAPTOP=m
CONFIG_SENSORS_HDAPS=m
CONFIG_THINKPAD_ACPI=m
# CONFIG_THINKPAD_ACPI_DEBUGFACILITIES is not set
# CONFIG_THINKPAD_ACPI_DEBUG is not set
# CONFIG_THINKPAD_ACPI_UNSAFE_LEDS is not set
CONFIG_THINKPAD_ACPI_VIDEO=y
CONFIG_THINKPAD_ACPI_HOTKEY_POLL=y
# CONFIG_INTEL_ATOMISP2_PM is not set
CONFIG_INTEL_HID_EVENT=m
# CONFIG_INTEL_INT0002_VGPIO is not set
# CONFIG_INTEL_MENLOW is not set
CONFIG_INTEL_OAKTRAIL=m
CONFIG_INTEL_VBTN=m
CONFIG_MSI_LAPTOP=m
CONFIG_MSI_WMI=m
# CONFIG_PCENGINES_APU2 is not set
CONFIG_SAMSUNG_LAPTOP=m
CONFIG_SAMSUNG_Q10=m
CONFIG_TOSHIBA_BT_RFKILL=m
# CONFIG_TOSHIBA_HAPS is not set
# CONFIG_TOSHIBA_WMI is not set
CONFIG_ACPI_CMPC=m
CONFIG_COMPAL_LAPTOP=m
# CONFIG_LG_LAPTOP is not set
CONFIG_PANASONIC_LAPTOP=m
CONFIG_SONY_LAPTOP=m
CONFIG_SONYPI_COMPAT=y
# CONFIG_SYSTEM76_ACPI is not set
CONFIG_TOPSTAR_LAPTOP=m
# CONFIG_I2C_MULTI_INSTANTIATE is not set
CONFIG_MLX_PLATFORM=m
CONFIG_INTEL_IPS=m
CONFIG_INTEL_RST=m
# CONFIG_INTEL_SMARTCONNECT is not set

#
# Intel Speed Select Technology interface support
#
# CONFIG_INTEL_SPEED_SELECT_INTERFACE is not set
# end of Intel Speed Select Technology interface support

CONFIG_INTEL_TURBO_MAX_3=y
# CONFIG_INTEL_UNCORE_FREQ_CONTROL is not set
CONFIG_INTEL_PMC_CORE=m
# CONFIG_INTEL_PUNIT_IPC is not set
# CONFIG_INTEL_SCU_PCI is not set
# CONFIG_INTEL_SCU_PLATFORM is not set
CONFIG_PMC_ATOM=y
# CONFIG_CHROME_PLATFORMS is not set
CONFIG_MELLANOX_PLATFORM=y
CONFIG_MLXREG_HOTPLUG=m
# CONFIG_MLXREG_IO is not set
CONFIG_SURFACE_PLATFORMS=y
# CONFIG_SURFACE3_WMI is not set
# CONFIG_SURFACE_3_POWER_OPREGION is not set
# CONFIG_SURFACE_GPE is not set
# CONFIG_SURFACE_HOTPLUG is not set
# CONFIG_SURFACE_PRO3_BUTTON is not set
CONFIG_HAVE_CLK=y
CONFIG_CLKDEV_LOOKUP=y
CONFIG_HAVE_CLK_PREPARE=y
CONFIG_COMMON_CLK=y
# CONFIG_COMMON_CLK_MAX9485 is not set
# CONFIG_COMMON_CLK_SI5341 is not set
# CONFIG_COMMON_CLK_SI5351 is not set
# CONFIG_COMMON_CLK_SI544 is not set
# CONFIG_COMMON_CLK_CDCE706 is not set
# CONFIG_COMMON_CLK_CS2000_CP is not set
# CONFIG_COMMON_CLK_PWM is not set
# CONFIG_XILINX_VCU is not set
CONFIG_HWSPINLOCK=y

#
# Clock Source drivers
#
CONFIG_CLKEVT_I8253=y
CONFIG_I8253_LOCK=y
CONFIG_CLKBLD_I8253=y
# end of Clock Source drivers

CONFIG_MAILBOX=y
CONFIG_PCC=y
# CONFIG_ALTERA_MBOX is not set
CONFIG_IOMMU_IOVA=y
CONFIG_IOASID=y
CONFIG_IOMMU_API=y
CONFIG_IOMMU_SUPPORT=y

#
# Generic IOMMU Pagetable Support
#
CONFIG_IOMMU_IO_PGTABLE=y
# end of Generic IOMMU Pagetable Support

# CONFIG_IOMMU_DEBUGFS is not set
# CONFIG_IOMMU_DEFAULT_PASSTHROUGH is not set
CONFIG_IOMMU_DMA=y
CONFIG_AMD_IOMMU=y
CONFIG_AMD_IOMMU_V2=m
CONFIG_DMAR_TABLE=y
CONFIG_INTEL_IOMMU=y
# CONFIG_INTEL_IOMMU_SVM is not set
# CONFIG_INTEL_IOMMU_DEFAULT_ON is not set
CONFIG_INTEL_IOMMU_FLOPPY_WA=y
# CONFIG_INTEL_IOMMU_SCALABLE_MODE_DEFAULT_ON is not set
CONFIG_IRQ_REMAP=y
CONFIG_HYPERV_IOMMU=y

#
# Remoteproc drivers
#
# CONFIG_REMOTEPROC is not set
# end of Remoteproc drivers

#
# Rpmsg drivers
#
# CONFIG_RPMSG_QCOM_GLINK_RPM is not set
# CONFIG_RPMSG_VIRTIO is not set
# end of Rpmsg drivers

# CONFIG_SOUNDWIRE is not set

#
# SOC (System On Chip) specific Drivers
#

#
# Amlogic SoC drivers
#
# end of Amlogic SoC drivers

#
# Broadcom SoC drivers
#
# end of Broadcom SoC drivers

#
# NXP/Freescale QorIQ SoC drivers
#
# end of NXP/Freescale QorIQ SoC drivers

#
# i.MX SoC drivers
#
# end of i.MX SoC drivers

#
# Enable LiteX SoC Builder specific drivers
#
# end of Enable LiteX SoC Builder specific drivers

#
# Qualcomm SoC drivers
#
# end of Qualcomm SoC drivers

# CONFIG_SOC_TI is not set

#
# Xilinx SoC drivers
#
# end of Xilinx SoC drivers
# end of SOC (System On Chip) specific Drivers

# CONFIG_PM_DEVFREQ is not set
# CONFIG_EXTCON is not set
# CONFIG_MEMORY is not set
# CONFIG_IIO is not set
CONFIG_NTB=m
# CONFIG_NTB_MSI is not set
# CONFIG_NTB_AMD is not set
# CONFIG_NTB_IDT is not set
# CONFIG_NTB_INTEL is not set
# CONFIG_NTB_EPF is not set
# CONFIG_NTB_SWITCHTEC is not set
# CONFIG_NTB_PINGPONG is not set
# CONFIG_NTB_TOOL is not set
# CONFIG_NTB_PERF is not set
# CONFIG_NTB_TRANSPORT is not set
# CONFIG_VME_BUS is not set
CONFIG_PWM=y
CONFIG_PWM_SYSFS=y
# CONFIG_PWM_DEBUG is not set
# CONFIG_PWM_DWC is not set
CONFIG_PWM_LPSS=m
CONFIG_PWM_LPSS_PCI=m
CONFIG_PWM_LPSS_PLATFORM=m
# CONFIG_PWM_PCA9685 is not set

#
# IRQ chip support
#
# end of IRQ chip support

# CONFIG_IPACK_BUS is not set
# CONFIG_RESET_CONTROLLER is not set

#
# PHY Subsystem
#
# CONFIG_GENERIC_PHY is not set
# CONFIG_USB_LGM_PHY is not set
# CONFIG_BCM_KONA_USB2_PHY is not set
# CONFIG_PHY_PXA_28NM_HSIC is not set
# CONFIG_PHY_PXA_28NM_USB2 is not set
# CONFIG_PHY_INTEL_LGM_EMMC is not set
# end of PHY Subsystem

CONFIG_POWERCAP=y
CONFIG_INTEL_RAPL_CORE=m
CONFIG_INTEL_RAPL=m
# CONFIG_IDLE_INJECT is not set
# CONFIG_DTPM is not set
# CONFIG_MCB is not set

#
# Performance monitor support
#
# end of Performance monitor support

CONFIG_RAS=y
# CONFIG_RAS_CEC is not set
# CONFIG_USB4 is not set

#
# Android
#
CONFIG_ANDROID=y
# CONFIG_ANDROID_BINDER_IPC is not set
# end of Android

CONFIG_LIBNVDIMM=m
CONFIG_BLK_DEV_PMEM=m
CONFIG_ND_BLK=m
CONFIG_ND_CLAIM=y
CONFIG_ND_BTT=m
CONFIG_BTT=y
CONFIG_ND_PFN=m
CONFIG_NVDIMM_PFN=y
CONFIG_NVDIMM_DAX=y
CONFIG_NVDIMM_KEYS=y
CONFIG_DAX_DRIVER=y
CONFIG_DAX=y
CONFIG_DEV_DAX=m
CONFIG_DEV_DAX_PMEM=m
CONFIG_DEV_DAX_KMEM=m
CONFIG_DEV_DAX_PMEM_COMPAT=m
CONFIG_NVMEM=y
CONFIG_NVMEM_SYSFS=y
# CONFIG_NVMEM_RMEM is not set

#
# HW tracing support
#
CONFIG_STM=m
# CONFIG_STM_PROTO_BASIC is not set
# CONFIG_STM_PROTO_SYS_T is not set
CONFIG_STM_DUMMY=m
CONFIG_STM_SOURCE_CONSOLE=m
CONFIG_STM_SOURCE_HEARTBEAT=m
CONFIG_STM_SOURCE_FTRACE=m
CONFIG_INTEL_TH=m
CONFIG_INTEL_TH_PCI=m
CONFIG_INTEL_TH_ACPI=m
CONFIG_INTEL_TH_GTH=m
CONFIG_INTEL_TH_STH=m
CONFIG_INTEL_TH_MSU=m
CONFIG_INTEL_TH_PTI=m
# CONFIG_INTEL_TH_DEBUG is not set
# end of HW tracing support

# CONFIG_FPGA is not set
# CONFIG_TEE is not set
# CONFIG_UNISYS_VISORBUS is not set
# CONFIG_SIOX is not set
# CONFIG_SLIMBUS is not set
# CONFIG_INTERCONNECT is not set
# CONFIG_COUNTER is not set
# CONFIG_MOST is not set
# end of Device Drivers

#
# File systems
#
CONFIG_DCACHE_WORD_ACCESS=y
# CONFIG_VALIDATE_FS_PARSER is not set
CONFIG_FS_IOMAP=y
# CONFIG_EXT2_FS is not set
# CONFIG_EXT3_FS is not set
CONFIG_EXT4_FS=y
CONFIG_EXT4_USE_FOR_EXT2=y
CONFIG_EXT4_FS_POSIX_ACL=y
CONFIG_EXT4_FS_SECURITY=y
# CONFIG_EXT4_DEBUG is not set
CONFIG_JBD2=y
# CONFIG_JBD2_DEBUG is not set
CONFIG_FS_MBCACHE=y
# CONFIG_REISERFS_FS is not set
# CONFIG_JFS_FS is not set
CONFIG_XFS_FS=m
CONFIG_XFS_SUPPORT_V4=y
CONFIG_XFS_QUOTA=y
CONFIG_XFS_POSIX_ACL=y
CONFIG_XFS_RT=y
CONFIG_XFS_ONLINE_SCRUB=y
# CONFIG_XFS_ONLINE_REPAIR is not set
CONFIG_XFS_DEBUG=y
CONFIG_XFS_ASSERT_FATAL=y
CONFIG_GFS2_FS=m
CONFIG_GFS2_FS_LOCKING_DLM=y
CONFIG_OCFS2_FS=m
CONFIG_OCFS2_FS_O2CB=m
CONFIG_OCFS2_FS_USERSPACE_CLUSTER=m
CONFIG_OCFS2_FS_STATS=y
CONFIG_OCFS2_DEBUG_MASKLOG=y
# CONFIG_OCFS2_DEBUG_FS is not set
CONFIG_BTRFS_FS=m
CONFIG_BTRFS_FS_POSIX_ACL=y
# CONFIG_BTRFS_FS_CHECK_INTEGRITY is not set
# CONFIG_BTRFS_FS_RUN_SANITY_TESTS is not set
# CONFIG_BTRFS_DEBUG is not set
# CONFIG_BTRFS_ASSERT is not set
# CONFIG_BTRFS_FS_REF_VERIFY is not set
# CONFIG_NILFS2_FS is not set
CONFIG_F2FS_FS=m
CONFIG_F2FS_STAT_FS=y
CONFIG_F2FS_FS_XATTR=y
CONFIG_F2FS_FS_POSIX_ACL=y
# CONFIG_F2FS_FS_SECURITY is not set
# CONFIG_F2FS_CHECK_FS is not set
# CONFIG_F2FS_FAULT_INJECTION is not set
# CONFIG_F2FS_FS_COMPRESSION is not set
CONFIG_FS_DAX=y
CONFIG_FS_DAX_PMD=y
CONFIG_FS_POSIX_ACL=y
CONFIG_EXPORTFS=y
CONFIG_EXPORTFS_BLOCK_OPS=y
CONFIG_FILE_LOCKING=y
CONFIG_MANDATORY_FILE_LOCKING=y
CONFIG_FS_ENCRYPTION=y
CONFIG_FS_ENCRYPTION_ALGS=y
# CONFIG_FS_VERITY is not set
CONFIG_FSNOTIFY=y
CONFIG_DNOTIFY=y
CONFIG_INOTIFY_USER=y
CONFIG_FANOTIFY=y
CONFIG_FANOTIFY_ACCESS_PERMISSIONS=y
CONFIG_QUOTA=y
CONFIG_QUOTA_NETLINK_INTERFACE=y
CONFIG_PRINT_QUOTA_WARNING=y
# CONFIG_QUOTA_DEBUG is not set
CONFIG_QUOTA_TREE=y
# CONFIG_QFMT_V1 is not set
CONFIG_QFMT_V2=y
CONFIG_QUOTACTL=y
CONFIG_AUTOFS4_FS=y
CONFIG_AUTOFS_FS=y
CONFIG_FUSE_FS=m
CONFIG_CUSE=m
# CONFIG_VIRTIO_FS is not set
CONFIG_OVERLAY_FS=m
# CONFIG_OVERLAY_FS_REDIRECT_DIR is not set
# CONFIG_OVERLAY_FS_REDIRECT_ALWAYS_FOLLOW is not set
# CONFIG_OVERLAY_FS_INDEX is not set
# CONFIG_OVERLAY_FS_XINO_AUTO is not set
# CONFIG_OVERLAY_FS_METACOPY is not set

#
# Caches
#
CONFIG_NETFS_SUPPORT=m
# CONFIG_NETFS_STATS is not set
CONFIG_FSCACHE=m
CONFIG_FSCACHE_STATS=y
# CONFIG_FSCACHE_HISTOGRAM is not set
# CONFIG_FSCACHE_DEBUG is not set
# CONFIG_FSCACHE_OBJECT_LIST is not set
CONFIG_CACHEFILES=m
# CONFIG_CACHEFILES_DEBUG is not set
# CONFIG_CACHEFILES_HISTOGRAM is not set
# end of Caches

#
# CD-ROM/DVD Filesystems
#
CONFIG_ISO9660_FS=m
CONFIG_JOLIET=y
CONFIG_ZISOFS=y
CONFIG_UDF_FS=m
# end of CD-ROM/DVD Filesystems

#
# DOS/FAT/EXFAT/NT Filesystems
#
CONFIG_FAT_FS=m
CONFIG_MSDOS_FS=m
CONFIG_VFAT_FS=m
CONFIG_FAT_DEFAULT_CODEPAGE=437
CONFIG_FAT_DEFAULT_IOCHARSET="ascii"
# CONFIG_FAT_DEFAULT_UTF8 is not set
# CONFIG_EXFAT_FS is not set
# CONFIG_NTFS_FS is not set
# end of DOS/FAT/EXFAT/NT Filesystems

#
# Pseudo filesystems
#
CONFIG_PROC_FS=y
CONFIG_PROC_KCORE=y
CONFIG_PROC_VMCORE=y
CONFIG_PROC_VMCORE_DEVICE_DUMP=y
CONFIG_PROC_SYSCTL=y
CONFIG_PROC_PAGE_MONITOR=y
CONFIG_PROC_CHILDREN=y
CONFIG_PROC_PID_ARCH_STATUS=y
CONFIG_PROC_CPU_RESCTRL=y
CONFIG_KERNFS=y
CONFIG_SYSFS=y
CONFIG_TMPFS=y
CONFIG_TMPFS_POSIX_ACL=y
CONFIG_TMPFS_XATTR=y
# CONFIG_TMPFS_INODE64 is not set
CONFIG_HUGETLBFS=y
CONFIG_HUGETLB_PAGE=y
CONFIG_MEMFD_CREATE=y
CONFIG_ARCH_HAS_GIGANTIC_PAGE=y
CONFIG_CONFIGFS_FS=y
CONFIG_EFIVAR_FS=y
# end of Pseudo filesystems

CONFIG_MISC_FILESYSTEMS=y
# CONFIG_ORANGEFS_FS is not set
# CONFIG_ADFS_FS is not set
# CONFIG_AFFS_FS is not set
# CONFIG_ECRYPT_FS is not set
# CONFIG_HFS_FS is not set
# CONFIG_HFSPLUS_FS is not set
# CONFIG_BEFS_FS is not set
# CONFIG_BFS_FS is not set
# CONFIG_EFS_FS is not set
CONFIG_CRAMFS=m
CONFIG_CRAMFS_BLOCKDEV=y
CONFIG_SQUASHFS=m
# CONFIG_SQUASHFS_FILE_CACHE is not set
CONFIG_SQUASHFS_FILE_DIRECT=y
# CONFIG_SQUASHFS_DECOMP_SINGLE is not set
# CONFIG_SQUASHFS_DECOMP_MULTI is not set
CONFIG_SQUASHFS_DECOMP_MULTI_PERCPU=y
CONFIG_SQUASHFS_XATTR=y
CONFIG_SQUASHFS_ZLIB=y
# CONFIG_SQUASHFS_LZ4 is not set
CONFIG_SQUASHFS_LZO=y
CONFIG_SQUASHFS_XZ=y
# CONFIG_SQUASHFS_ZSTD is not set
# CONFIG_SQUASHFS_4K_DEVBLK_SIZE is not set
# CONFIG_SQUASHFS_EMBEDDED is not set
CONFIG_SQUASHFS_FRAGMENT_CACHE_SIZE=3
# CONFIG_VXFS_FS is not set
# CONFIG_MINIX_FS is not set
# CONFIG_OMFS_FS is not set
# CONFIG_HPFS_FS is not set
# CONFIG_QNX4FS_FS is not set
# CONFIG_QNX6FS_FS is not set
# CONFIG_ROMFS_FS is not set
CONFIG_PSTORE=y
CONFIG_PSTORE_DEFAULT_KMSG_BYTES=10240
CONFIG_PSTORE_DEFLATE_COMPRESS=y
# CONFIG_PSTORE_LZO_COMPRESS is not set
# CONFIG_PSTORE_LZ4_COMPRESS is not set
# CONFIG_PSTORE_LZ4HC_COMPRESS is not set
# CONFIG_PSTORE_842_COMPRESS is not set
# CONFIG_PSTORE_ZSTD_COMPRESS is not set
CONFIG_PSTORE_COMPRESS=y
CONFIG_PSTORE_DEFLATE_COMPRESS_DEFAULT=y
CONFIG_PSTORE_COMPRESS_DEFAULT="deflate"
CONFIG_PSTORE_CONSOLE=y
CONFIG_PSTORE_PMSG=y
# CONFIG_PSTORE_FTRACE is not set
CONFIG_PSTORE_RAM=m
# CONFIG_PSTORE_BLK is not set
# CONFIG_SYSV_FS is not set
# CONFIG_UFS_FS is not set
# CONFIG_EROFS_FS is not set
CONFIG_NETWORK_FILESYSTEMS=y
CONFIG_NFS_FS=y
# CONFIG_NFS_V2 is not set
CONFIG_NFS_V3=y
CONFIG_NFS_V3_ACL=y
CONFIG_NFS_V4=m
# CONFIG_NFS_SWAP is not set
CONFIG_NFS_V4_1=y
CONFIG_NFS_V4_2=y
CONFIG_PNFS_FILE_LAYOUT=m
CONFIG_PNFS_BLOCK=m
CONFIG_PNFS_FLEXFILE_LAYOUT=m
CONFIG_NFS_V4_1_IMPLEMENTATION_ID_DOMAIN="kernel.org"
# CONFIG_NFS_V4_1_MIGRATION is not set
CONFIG_NFS_V4_SECURITY_LABEL=y
CONFIG_ROOT_NFS=y
# CONFIG_NFS_USE_LEGACY_DNS is not set
CONFIG_NFS_USE_KERNEL_DNS=y
CONFIG_NFS_DEBUG=y
CONFIG_NFS_DISABLE_UDP_SUPPORT=y
# CONFIG_NFS_V4_2_READ_PLUS is not set
CONFIG_NFSD=m
CONFIG_NFSD_V2_ACL=y
CONFIG_NFSD_V3=y
CONFIG_NFSD_V3_ACL=y
CONFIG_NFSD_V4=y
CONFIG_NFSD_PNFS=y
# CONFIG_NFSD_BLOCKLAYOUT is not set
CONFIG_NFSD_SCSILAYOUT=y
# CONFIG_NFSD_FLEXFILELAYOUT is not set
# CONFIG_NFSD_V4_2_INTER_SSC is not set
CONFIG_NFSD_V4_SECURITY_LABEL=y
CONFIG_GRACE_PERIOD=y
CONFIG_LOCKD=y
CONFIG_LOCKD_V4=y
CONFIG_NFS_ACL_SUPPORT=y
CONFIG_NFS_COMMON=y
CONFIG_NFS_V4_2_SSC_HELPER=y
CONFIG_SUNRPC=y
CONFIG_SUNRPC_GSS=m
CONFIG_SUNRPC_BACKCHANNEL=y
CONFIG_RPCSEC_GSS_KRB5=m
# CONFIG_SUNRPC_DISABLE_INSECURE_ENCTYPES is not set
CONFIG_SUNRPC_DEBUG=y
CONFIG_CEPH_FS=m
# CONFIG_CEPH_FSCACHE is not set
CONFIG_CEPH_FS_POSIX_ACL=y
# CONFIG_CEPH_FS_SECURITY_LABEL is not set
CONFIG_CIFS=m
# CONFIG_CIFS_STATS2 is not set
CONFIG_CIFS_ALLOW_INSECURE_LEGACY=y
CONFIG_CIFS_WEAK_PW_HASH=y
CONFIG_CIFS_UPCALL=y
CONFIG_CIFS_XATTR=y
CONFIG_CIFS_POSIX=y
CONFIG_CIFS_DEBUG=y
# CONFIG_CIFS_DEBUG2 is not set
# CONFIG_CIFS_DEBUG_DUMP_KEYS is not set
CONFIG_CIFS_DFS_UPCALL=y
# CONFIG_CIFS_SWN_UPCALL is not set
# CONFIG_CIFS_FSCACHE is not set
# CONFIG_CODA_FS is not set
# CONFIG_AFS_FS is not set
# CONFIG_9P_FS is not set
CONFIG_NLS=y
CONFIG_NLS_DEFAULT="utf8"
CONFIG_NLS_CODEPAGE_437=y
CONFIG_NLS_CODEPAGE_737=m
CONFIG_NLS_CODEPAGE_775=m
CONFIG_NLS_CODEPAGE_850=m
CONFIG_NLS_CODEPAGE_852=m
CONFIG_NLS_CODEPAGE_855=m
CONFIG_NLS_CODEPAGE_857=m
CONFIG_NLS_CODEPAGE_860=m
CONFIG_NLS_CODEPAGE_861=m
CONFIG_NLS_CODEPAGE_862=m
CONFIG_NLS_CODEPAGE_863=m
CONFIG_NLS_CODEPAGE_864=m
CONFIG_NLS_CODEPAGE_865=m
CONFIG_NLS_CODEPAGE_866=m
CONFIG_NLS_CODEPAGE_869=m
CONFIG_NLS_CODEPAGE_936=m
CONFIG_NLS_CODEPAGE_950=m
CONFIG_NLS_CODEPAGE_932=m
CONFIG_NLS_CODEPAGE_949=m
CONFIG_NLS_CODEPAGE_874=m
CONFIG_NLS_ISO8859_8=m
CONFIG_NLS_CODEPAGE_1250=m
CONFIG_NLS_CODEPAGE_1251=m
CONFIG_NLS_ASCII=y
CONFIG_NLS_ISO8859_1=m
CONFIG_NLS_ISO8859_2=m
CONFIG_NLS_ISO8859_3=m
CONFIG_NLS_ISO8859_4=m
CONFIG_NLS_ISO8859_5=m
CONFIG_NLS_ISO8859_6=m
CONFIG_NLS_ISO8859_7=m
CONFIG_NLS_ISO8859_9=m
CONFIG_NLS_ISO8859_13=m
CONFIG_NLS_ISO8859_14=m
CONFIG_NLS_ISO8859_15=m
CONFIG_NLS_KOI8_R=m
CONFIG_NLS_KOI8_U=m
CONFIG_NLS_MAC_ROMAN=m
CONFIG_NLS_MAC_CELTIC=m
CONFIG_NLS_MAC_CENTEURO=m
CONFIG_NLS_MAC_CROATIAN=m
CONFIG_NLS_MAC_CYRILLIC=m
CONFIG_NLS_MAC_GAELIC=m
CONFIG_NLS_MAC_GREEK=m
CONFIG_NLS_MAC_ICELAND=m
CONFIG_NLS_MAC_INUIT=m
CONFIG_NLS_MAC_ROMANIAN=m
CONFIG_NLS_MAC_TURKISH=m
CONFIG_NLS_UTF8=m
CONFIG_DLM=m
CONFIG_DLM_DEBUG=y
# CONFIG_UNICODE is not set
CONFIG_IO_WQ=y
# end of File systems

#
# Security options
#
CONFIG_KEYS=y
# CONFIG_KEYS_REQUEST_CACHE is not set
CONFIG_PERSISTENT_KEYRINGS=y
CONFIG_TRUSTED_KEYS=y
CONFIG_ENCRYPTED_KEYS=y
# CONFIG_KEY_DH_OPERATIONS is not set
# CONFIG_SECURITY_DMESG_RESTRICT is not set
CONFIG_SECURITY=y
CONFIG_SECURITY_WRITABLE_HOOKS=y
CONFIG_SECURITYFS=y
CONFIG_SECURITY_NETWORK=y
CONFIG_PAGE_TABLE_ISOLATION=y
CONFIG_SECURITY_NETWORK_XFRM=y
# CONFIG_SECURITY_PATH is not set
CONFIG_INTEL_TXT=y
CONFIG_LSM_MMAP_MIN_ADDR=65535
CONFIG_HAVE_HARDENED_USERCOPY_ALLOCATOR=y
CONFIG_HARDENED_USERCOPY=y
CONFIG_HARDENED_USERCOPY_FALLBACK=y
# CONFIG_HARDENED_USERCOPY_PAGESPAN is not set
CONFIG_FORTIFY_SOURCE=y
# CONFIG_STATIC_USERMODEHELPER is not set
CONFIG_SECURITY_SELINUX=y
CONFIG_SECURITY_SELINUX_BOOTPARAM=y
CONFIG_SECURITY_SELINUX_DISABLE=y
CONFIG_SECURITY_SELINUX_DEVELOP=y
CONFIG_SECURITY_SELINUX_AVC_STATS=y
CONFIG_SECURITY_SELINUX_CHECKREQPROT_VALUE=1
CONFIG_SECURITY_SELINUX_SIDTAB_HASH_BITS=9
CONFIG_SECURITY_SELINUX_SID2STR_CACHE_SIZE=256
# CONFIG_SECURITY_SMACK is not set
# CONFIG_SECURITY_TOMOYO is not set
# CONFIG_SECURITY_APPARMOR is not set
# CONFIG_SECURITY_LOADPIN is not set
CONFIG_SECURITY_YAMA=y
# CONFIG_SECURITY_SAFESETID is not set
# CONFIG_SECURITY_LOCKDOWN_LSM is not set
# CONFIG_SECURITY_LANDLOCK is not set
CONFIG_INTEGRITY=y
CONFIG_INTEGRITY_SIGNATURE=y
CONFIG_INTEGRITY_ASYMMETRIC_KEYS=y
CONFIG_INTEGRITY_TRUSTED_KEYRING=y
# CONFIG_INTEGRITY_PLATFORM_KEYRING is not set
CONFIG_INTEGRITY_AUDIT=y
CONFIG_IMA=y
CONFIG_IMA_MEASURE_PCR_IDX=10
CONFIG_IMA_LSM_RULES=y
# CONFIG_IMA_TEMPLATE is not set
CONFIG_IMA_NG_TEMPLATE=y
# CONFIG_IMA_SIG_TEMPLATE is not set
CONFIG_IMA_DEFAULT_TEMPLATE="ima-ng"
CONFIG_IMA_DEFAULT_HASH_SHA1=y
# CONFIG_IMA_DEFAULT_HASH_SHA256 is not set
CONFIG_IMA_DEFAULT_HASH="sha1"
CONFIG_IMA_WRITE_POLICY=y
CONFIG_IMA_READ_POLICY=y
CONFIG_IMA_APPRAISE=y
CONFIG_IMA_ARCH_POLICY=y
# CONFIG_IMA_APPRAISE_BUILD_POLICY is not set
CONFIG_IMA_APPRAISE_BOOTPARAM=y
# CONFIG_IMA_APPRAISE_MODSIG is not set
CONFIG_IMA_TRUSTED_KEYRING=y
# CONFIG_IMA_BLACKLIST_KEYRING is not set
# CONFIG_IMA_LOAD_X509 is not set
CONFIG_IMA_MEASURE_ASYMMETRIC_KEYS=y
CONFIG_IMA_QUEUE_EARLY_BOOT_KEYS=y
CONFIG_IMA_SECURE_AND_OR_TRUSTED_BOOT=y
CONFIG_EVM=y
CONFIG_EVM_ATTR_FSUUID=y
# CONFIG_EVM_ADD_XATTRS is not set
# CONFIG_EVM_LOAD_X509 is not set
CONFIG_DEFAULT_SECURITY_SELINUX=y
# CONFIG_DEFAULT_SECURITY_DAC is not set
CONFIG_LSM="landlock,lockdown,yama,loadpin,safesetid,integrity,selinux,smack,tomoyo,apparmor,bpf"

#
# Kernel hardening options
#

#
# Memory initialization
#
CONFIG_INIT_STACK_NONE=y
# CONFIG_INIT_ON_ALLOC_DEFAULT_ON is not set
# CONFIG_INIT_ON_FREE_DEFAULT_ON is not set
# end of Memory initialization
# end of Kernel hardening options
# end of Security options

CONFIG_XOR_BLOCKS=m
CONFIG_ASYNC_CORE=m
CONFIG_ASYNC_MEMCPY=m
CONFIG_ASYNC_XOR=m
CONFIG_ASYNC_PQ=m
CONFIG_ASYNC_RAID6_RECOV=m
CONFIG_CRYPTO=y

#
# Crypto core or helper
#
CONFIG_CRYPTO_ALGAPI=y
CONFIG_CRYPTO_ALGAPI2=y
CONFIG_CRYPTO_AEAD=y
CONFIG_CRYPTO_AEAD2=y
CONFIG_CRYPTO_SKCIPHER=y
CONFIG_CRYPTO_SKCIPHER2=y
CONFIG_CRYPTO_HASH=y
CONFIG_CRYPTO_HASH2=y
CONFIG_CRYPTO_RNG=y
CONFIG_CRYPTO_RNG2=y
CONFIG_CRYPTO_RNG_DEFAULT=y
CONFIG_CRYPTO_AKCIPHER2=y
CONFIG_CRYPTO_AKCIPHER=y
CONFIG_CRYPTO_KPP2=y
CONFIG_CRYPTO_KPP=m
CONFIG_CRYPTO_ACOMP2=y
CONFIG_CRYPTO_MANAGER=y
CONFIG_CRYPTO_MANAGER2=y
CONFIG_CRYPTO_USER=m
CONFIG_CRYPTO_MANAGER_DISABLE_TESTS=y
CONFIG_CRYPTO_GF128MUL=y
CONFIG_CRYPTO_NULL=y
CONFIG_CRYPTO_NULL2=y
CONFIG_CRYPTO_PCRYPT=m
CONFIG_CRYPTO_CRYPTD=y
CONFIG_CRYPTO_AUTHENC=m
CONFIG_CRYPTO_TEST=m
CONFIG_CRYPTO_SIMD=y

#
# Public-key cryptography
#
CONFIG_CRYPTO_RSA=y
CONFIG_CRYPTO_DH=m
CONFIG_CRYPTO_ECC=m
CONFIG_CRYPTO_ECDH=m
# CONFIG_CRYPTO_ECDSA is not set
# CONFIG_CRYPTO_ECRDSA is not set
# CONFIG_CRYPTO_SM2 is not set
# CONFIG_CRYPTO_CURVE25519 is not set
# CONFIG_CRYPTO_CURVE25519_X86 is not set

#
# Authenticated Encryption with Associated Data
#
CONFIG_CRYPTO_CCM=m
CONFIG_CRYPTO_GCM=y
CONFIG_CRYPTO_CHACHA20POLY1305=m
# CONFIG_CRYPTO_AEGIS128 is not set
# CONFIG_CRYPTO_AEGIS128_AESNI_SSE2 is not set
CONFIG_CRYPTO_SEQIV=y
CONFIG_CRYPTO_ECHAINIV=m

#
# Block modes
#
CONFIG_CRYPTO_CBC=y
CONFIG_CRYPTO_CFB=y
CONFIG_CRYPTO_CTR=y
CONFIG_CRYPTO_CTS=m
CONFIG_CRYPTO_ECB=y
CONFIG_CRYPTO_LRW=m
# CONFIG_CRYPTO_OFB is not set
CONFIG_CRYPTO_PCBC=m
CONFIG_CRYPTO_XTS=m
# CONFIG_CRYPTO_KEYWRAP is not set
# CONFIG_CRYPTO_NHPOLY1305_SSE2 is not set
# CONFIG_CRYPTO_NHPOLY1305_AVX2 is not set
# CONFIG_CRYPTO_ADIANTUM is not set
CONFIG_CRYPTO_ESSIV=m

#
# Hash modes
#
CONFIG_CRYPTO_CMAC=m
CONFIG_CRYPTO_HMAC=y
CONFIG_CRYPTO_XCBC=m
CONFIG_CRYPTO_VMAC=m

#
# Digest
#
CONFIG_CRYPTO_CRC32C=y
CONFIG_CRYPTO_CRC32C_INTEL=m
CONFIG_CRYPTO_CRC32=m
CONFIG_CRYPTO_CRC32_PCLMUL=m
CONFIG_CRYPTO_XXHASH=m
CONFIG_CRYPTO_BLAKE2B=m
# CONFIG_CRYPTO_BLAKE2S is not set
# CONFIG_CRYPTO_BLAKE2S_X86 is not set
CONFIG_CRYPTO_CRCT10DIF=y
CONFIG_CRYPTO_CRCT10DIF_PCLMUL=m
CONFIG_CRYPTO_GHASH=y
CONFIG_CRYPTO_POLY1305=m
CONFIG_CRYPTO_POLY1305_X86_64=m
CONFIG_CRYPTO_MD4=m
CONFIG_CRYPTO_MD5=y
CONFIG_CRYPTO_MICHAEL_MIC=m
CONFIG_CRYPTO_RMD160=m
CONFIG_CRYPTO_SHA1=y
CONFIG_CRYPTO_SHA1_SSSE3=y
CONFIG_CRYPTO_SHA256_SSSE3=y
CONFIG_CRYPTO_SHA512_SSSE3=m
CONFIG_CRYPTO_SHA256=y
CONFIG_CRYPTO_SHA512=m
CONFIG_CRYPTO_SHA3=m
# CONFIG_CRYPTO_SM3 is not set
# CONFIG_CRYPTO_STREEBOG is not set
CONFIG_CRYPTO_WP512=m
CONFIG_CRYPTO_GHASH_CLMUL_NI_INTEL=m

#
# Ciphers
#
CONFIG_CRYPTO_AES=y
# CONFIG_CRYPTO_AES_TI is not set
CONFIG_CRYPTO_AES_NI_INTEL=y
CONFIG_CRYPTO_ANUBIS=m
CONFIG_CRYPTO_ARC4=m
CONFIG_CRYPTO_BLOWFISH=m
CONFIG_CRYPTO_BLOWFISH_COMMON=m
CONFIG_CRYPTO_BLOWFISH_X86_64=m
CONFIG_CRYPTO_CAMELLIA=m
CONFIG_CRYPTO_CAMELLIA_X86_64=m
CONFIG_CRYPTO_CAMELLIA_AESNI_AVX_X86_64=m
CONFIG_CRYPTO_CAMELLIA_AESNI_AVX2_X86_64=m
CONFIG_CRYPTO_CAST_COMMON=m
CONFIG_CRYPTO_CAST5=m
CONFIG_CRYPTO_CAST5_AVX_X86_64=m
CONFIG_CRYPTO_CAST6=m
CONFIG_CRYPTO_CAST6_AVX_X86_64=m
CONFIG_CRYPTO_DES=m
CONFIG_CRYPTO_DES3_EDE_X86_64=m
CONFIG_CRYPTO_FCRYPT=m
CONFIG_CRYPTO_KHAZAD=m
CONFIG_CRYPTO_CHACHA20=m
CONFIG_CRYPTO_CHACHA20_X86_64=m
CONFIG_CRYPTO_SEED=m
CONFIG_CRYPTO_SERPENT=m
CONFIG_CRYPTO_SERPENT_SSE2_X86_64=m
CONFIG_CRYPTO_SERPENT_AVX_X86_64=m
CONFIG_CRYPTO_SERPENT_AVX2_X86_64=m
# CONFIG_CRYPTO_SM4 is not set
CONFIG_CRYPTO_TEA=m
CONFIG_CRYPTO_TWOFISH=m
CONFIG_CRYPTO_TWOFISH_COMMON=m
CONFIG_CRYPTO_TWOFISH_X86_64=m
CONFIG_CRYPTO_TWOFISH_X86_64_3WAY=m
CONFIG_CRYPTO_TWOFISH_AVX_X86_64=m

#
# Compression
#
CONFIG_CRYPTO_DEFLATE=y
CONFIG_CRYPTO_LZO=y
# CONFIG_CRYPTO_842 is not set
# CONFIG_CRYPTO_LZ4 is not set
# CONFIG_CRYPTO_LZ4HC is not set
# CONFIG_CRYPTO_ZSTD is not set

#
# Random Number Generation
#
CONFIG_CRYPTO_ANSI_CPRNG=m
CONFIG_CRYPTO_DRBG_MENU=y
CONFIG_CRYPTO_DRBG_HMAC=y
CONFIG_CRYPTO_DRBG_HASH=y
CONFIG_CRYPTO_DRBG_CTR=y
CONFIG_CRYPTO_DRBG=y
CONFIG_CRYPTO_JITTERENTROPY=y
CONFIG_CRYPTO_USER_API=y
CONFIG_CRYPTO_USER_API_HASH=y
CONFIG_CRYPTO_USER_API_SKCIPHER=y
CONFIG_CRYPTO_USER_API_RNG=y
# CONFIG_CRYPTO_USER_API_RNG_CAVP is not set
CONFIG_CRYPTO_USER_API_AEAD=y
CONFIG_CRYPTO_USER_API_ENABLE_OBSOLETE=y
# CONFIG_CRYPTO_STATS is not set
CONFIG_CRYPTO_HASH_INFO=y

#
# Crypto library routines
#
CONFIG_CRYPTO_LIB_AES=y
CONFIG_CRYPTO_LIB_ARC4=m
# CONFIG_CRYPTO_LIB_BLAKE2S is not set
CONFIG_CRYPTO_ARCH_HAVE_LIB_CHACHA=m
CONFIG_CRYPTO_LIB_CHACHA_GENERIC=m
# CONFIG_CRYPTO_LIB_CHACHA is not set
# CONFIG_CRYPTO_LIB_CURVE25519 is not set
CONFIG_CRYPTO_LIB_DES=m
CONFIG_CRYPTO_LIB_POLY1305_RSIZE=11
CONFIG_CRYPTO_ARCH_HAVE_LIB_POLY1305=m
CONFIG_CRYPTO_LIB_POLY1305_GENERIC=m
# CONFIG_CRYPTO_LIB_POLY1305 is not set
# CONFIG_CRYPTO_LIB_CHACHA20POLY1305 is not set
CONFIG_CRYPTO_LIB_SHA256=y
CONFIG_CRYPTO_HW=y
CONFIG_CRYPTO_DEV_PADLOCK=m
CONFIG_CRYPTO_DEV_PADLOCK_AES=m
CONFIG_CRYPTO_DEV_PADLOCK_SHA=m
# CONFIG_CRYPTO_DEV_ATMEL_ECC is not set
# CONFIG_CRYPTO_DEV_ATMEL_SHA204A is not set
CONFIG_CRYPTO_DEV_CCP=y
CONFIG_CRYPTO_DEV_CCP_DD=m
CONFIG_CRYPTO_DEV_SP_CCP=y
CONFIG_CRYPTO_DEV_CCP_CRYPTO=m
CONFIG_CRYPTO_DEV_SP_PSP=y
# CONFIG_CRYPTO_DEV_CCP_DEBUGFS is not set
CONFIG_CRYPTO_DEV_QAT=m
CONFIG_CRYPTO_DEV_QAT_DH895xCC=m
CONFIG_CRYPTO_DEV_QAT_C3XXX=m
CONFIG_CRYPTO_DEV_QAT_C62X=m
# CONFIG_CRYPTO_DEV_QAT_4XXX is not set
CONFIG_CRYPTO_DEV_QAT_DH895xCCVF=m
CONFIG_CRYPTO_DEV_QAT_C3XXXVF=m
CONFIG_CRYPTO_DEV_QAT_C62XVF=m
CONFIG_CRYPTO_DEV_NITROX=m
CONFIG_CRYPTO_DEV_NITROX_CNN55XX=m
# CONFIG_CRYPTO_DEV_VIRTIO is not set
# CONFIG_CRYPTO_DEV_SAFEXCEL is not set
# CONFIG_CRYPTO_DEV_AMLOGIC_GXL is not set
CONFIG_ASYMMETRIC_KEY_TYPE=y
CONFIG_ASYMMETRIC_PUBLIC_KEY_SUBTYPE=y
# CONFIG_ASYMMETRIC_TPM_KEY_SUBTYPE is not set
CONFIG_X509_CERTIFICATE_PARSER=y
# CONFIG_PKCS8_PRIVATE_KEY_PARSER is not set
CONFIG_PKCS7_MESSAGE_PARSER=y
# CONFIG_PKCS7_TEST_KEY is not set
CONFIG_SIGNED_PE_FILE_VERIFICATION=y

#
# Certificates for signature checking
#
CONFIG_MODULE_SIG_KEY="certs/signing_key.pem"
CONFIG_SYSTEM_TRUSTED_KEYRING=y
CONFIG_SYSTEM_TRUSTED_KEYS=""
# CONFIG_SYSTEM_EXTRA_CERTIFICATE is not set
# CONFIG_SECONDARY_TRUSTED_KEYRING is not set
CONFIG_SYSTEM_BLACKLIST_KEYRING=y
CONFIG_SYSTEM_BLACKLIST_HASH_LIST=""
# CONFIG_SYSTEM_REVOCATION_LIST is not set
# end of Certificates for signature checking

CONFIG_BINARY_PRINTF=y

#
# Library routines
#
CONFIG_RAID6_PQ=m
CONFIG_RAID6_PQ_BENCHMARK=y
# CONFIG_PACKING is not set
CONFIG_BITREVERSE=y
CONFIG_GENERIC_STRNCPY_FROM_USER=y
CONFIG_GENERIC_STRNLEN_USER=y
CONFIG_GENERIC_NET_UTILS=y
CONFIG_GENERIC_FIND_FIRST_BIT=y
CONFIG_CORDIC=m
CONFIG_PRIME_NUMBERS=m
CONFIG_RATIONAL=y
CONFIG_GENERIC_PCI_IOMAP=y
CONFIG_GENERIC_IOMAP=y
CONFIG_ARCH_USE_CMPXCHG_LOCKREF=y
CONFIG_ARCH_HAS_FAST_MULTIPLIER=y
CONFIG_ARCH_USE_SYM_ANNOTATIONS=y
CONFIG_CRC_CCITT=y
CONFIG_CRC16=y
CONFIG_CRC_T10DIF=y
CONFIG_CRC_ITU_T=m
CONFIG_CRC32=y
# CONFIG_CRC32_SELFTEST is not set
CONFIG_CRC32_SLICEBY8=y
# CONFIG_CRC32_SLICEBY4 is not set
# CONFIG_CRC32_SARWATE is not set
# CONFIG_CRC32_BIT is not set
# CONFIG_CRC64 is not set
# CONFIG_CRC4 is not set
CONFIG_CRC7=m
CONFIG_LIBCRC32C=m
CONFIG_CRC8=m
CONFIG_XXHASH=y
# CONFIG_RANDOM32_SELFTEST is not set
CONFIG_ZLIB_INFLATE=y
CONFIG_ZLIB_DEFLATE=y
CONFIG_LZO_COMPRESS=y
CONFIG_LZO_DECOMPRESS=y
CONFIG_LZ4_DECOMPRESS=y
CONFIG_ZSTD_COMPRESS=m
CONFIG_ZSTD_DECOMPRESS=y
CONFIG_XZ_DEC=y
CONFIG_XZ_DEC_X86=y
CONFIG_XZ_DEC_POWERPC=y
CONFIG_XZ_DEC_IA64=y
CONFIG_XZ_DEC_ARM=y
CONFIG_XZ_DEC_ARMTHUMB=y
CONFIG_XZ_DEC_SPARC=y
CONFIG_XZ_DEC_BCJ=y
# CONFIG_XZ_DEC_TEST is not set
CONFIG_DECOMPRESS_GZIP=y
CONFIG_DECOMPRESS_BZIP2=y
CONFIG_DECOMPRESS_LZMA=y
CONFIG_DECOMPRESS_XZ=y
CONFIG_DECOMPRESS_LZO=y
CONFIG_DECOMPRESS_LZ4=y
CONFIG_DECOMPRESS_ZSTD=y
CONFIG_GENERIC_ALLOCATOR=y
CONFIG_REED_SOLOMON=m
CONFIG_REED_SOLOMON_ENC8=y
CONFIG_REED_SOLOMON_DEC8=y
CONFIG_TEXTSEARCH=y
CONFIG_TEXTSEARCH_KMP=m
CONFIG_TEXTSEARCH_BM=m
CONFIG_TEXTSEARCH_FSM=m
CONFIG_INTERVAL_TREE=y
CONFIG_XARRAY_MULTI=y
CONFIG_ASSOCIATIVE_ARRAY=y
CONFIG_HAS_IOMEM=y
CONFIG_HAS_IOPORT_MAP=y
CONFIG_HAS_DMA=y
CONFIG_DMA_OPS=y
CONFIG_NEED_SG_DMA_LENGTH=y
CONFIG_NEED_DMA_MAP_STATE=y
CONFIG_ARCH_DMA_ADDR_T_64BIT=y
CONFIG_ARCH_HAS_FORCE_DMA_UNENCRYPTED=y
CONFIG_SWIOTLB=y
CONFIG_DMA_COHERENT_POOL=y
# CONFIG_DMA_API_DEBUG is not set
CONFIG_DMA_MAP_BENCHMARK=y
CONFIG_SGL_ALLOC=y
CONFIG_CHECK_SIGNATURE=y
CONFIG_CPUMASK_OFFSTACK=y
CONFIG_CPU_RMAP=y
CONFIG_DQL=y
CONFIG_GLOB=y
# CONFIG_GLOB_SELFTEST is not set
CONFIG_NLATTR=y
CONFIG_CLZ_TAB=y
CONFIG_IRQ_POLL=y
CONFIG_MPILIB=y
CONFIG_SIGNATURE=y
CONFIG_OID_REGISTRY=y
CONFIG_UCS2_STRING=y
CONFIG_HAVE_GENERIC_VDSO=y
CONFIG_GENERIC_GETTIMEOFDAY=y
CONFIG_GENERIC_VDSO_TIME_NS=y
CONFIG_FONT_SUPPORT=y
# CONFIG_FONTS is not set
CONFIG_FONT_8x8=y
CONFIG_FONT_8x16=y
CONFIG_SG_POOL=y
CONFIG_ARCH_HAS_PMEM_API=y
CONFIG_MEMREGION=y
CONFIG_ARCH_HAS_UACCESS_FLUSHCACHE=y
CONFIG_ARCH_HAS_COPY_MC=y
CONFIG_ARCH_STACKWALK=y
CONFIG_SBITMAP=y
# CONFIG_STRING_SELFTEST is not set
# end of Library routines

CONFIG_ASN1_ENCODER=y

#
# Kernel hacking
#

#
# printk and dmesg options
#
CONFIG_PRINTK_TIME=y
# CONFIG_PRINTK_CALLER is not set
CONFIG_CONSOLE_LOGLEVEL_DEFAULT=7
CONFIG_CONSOLE_LOGLEVEL_QUIET=4
CONFIG_MESSAGE_LOGLEVEL_DEFAULT=4
CONFIG_BOOT_PRINTK_DELAY=y
CONFIG_DYNAMIC_DEBUG=y
CONFIG_DYNAMIC_DEBUG_CORE=y
CONFIG_SYMBOLIC_ERRNAME=y
CONFIG_DEBUG_BUGVERBOSE=y
# end of printk and dmesg options

#
# Compile-time checks and compiler options
#
CONFIG_DEBUG_INFO=y
# CONFIG_DEBUG_INFO_REDUCED is not set
# CONFIG_DEBUG_INFO_COMPRESSED is not set
# CONFIG_DEBUG_INFO_SPLIT is not set
# CONFIG_DEBUG_INFO_DWARF_TOOLCHAIN_DEFAULT is not set
CONFIG_DEBUG_INFO_DWARF4=y
CONFIG_DEBUG_INFO_BTF=y
CONFIG_PAHOLE_HAS_SPLIT_BTF=y
CONFIG_DEBUG_INFO_BTF_MODULES=y
# CONFIG_GDB_SCRIPTS is not set
CONFIG_FRAME_WARN=2048
CONFIG_STRIP_ASM_SYMS=y
# CONFIG_READABLE_ASM is not set
# CONFIG_HEADERS_INSTALL is not set
CONFIG_DEBUG_SECTION_MISMATCH=y
CONFIG_SECTION_MISMATCH_WARN_ONLY=y
# CONFIG_DEBUG_FORCE_FUNCTION_ALIGN_32B is not set
CONFIG_STACK_VALIDATION=y
# CONFIG_VMLINUX_MAP is not set
# CONFIG_DEBUG_FORCE_WEAK_PER_CPU is not set
# end of Compile-time checks and compiler options

#
# Generic Kernel Debugging Instruments
#
CONFIG_MAGIC_SYSRQ=y
CONFIG_MAGIC_SYSRQ_DEFAULT_ENABLE=0x1
CONFIG_MAGIC_SYSRQ_SERIAL=y
CONFIG_MAGIC_SYSRQ_SERIAL_SEQUENCE=""
CONFIG_DEBUG_FS=y
CONFIG_DEBUG_FS_ALLOW_ALL=y
# CONFIG_DEBUG_FS_DISALLOW_MOUNT is not set
# CONFIG_DEBUG_FS_ALLOW_NONE is not set
CONFIG_HAVE_ARCH_KGDB=y
# CONFIG_KGDB is not set
CONFIG_ARCH_HAS_UBSAN_SANITIZE_ALL=y
# CONFIG_UBSAN is not set
CONFIG_HAVE_ARCH_KCSAN=y
# end of Generic Kernel Debugging Instruments

CONFIG_DEBUG_KERNEL=y
CONFIG_DEBUG_MISC=y

#
# Memory Debugging
#
# CONFIG_PAGE_EXTENSION is not set
# CONFIG_DEBUG_PAGEALLOC is not set
# CONFIG_PAGE_OWNER is not set
# CONFIG_PAGE_POISONING is not set
# CONFIG_DEBUG_PAGE_REF is not set
# CONFIG_DEBUG_RODATA_TEST is not set
CONFIG_ARCH_HAS_DEBUG_WX=y
# CONFIG_DEBUG_WX is not set
CONFIG_GENERIC_PTDUMP=y
# CONFIG_PTDUMP_DEBUGFS is not set
# CONFIG_DEBUG_OBJECTS is not set
# CONFIG_SLUB_DEBUG_ON is not set
# CONFIG_SLUB_STATS is not set
CONFIG_HAVE_DEBUG_KMEMLEAK=y
# CONFIG_DEBUG_KMEMLEAK is not set
# CONFIG_DEBUG_STACK_USAGE is not set
# CONFIG_SCHED_STACK_END_CHECK is not set
CONFIG_ARCH_HAS_DEBUG_VM_PGTABLE=y
# CONFIG_DEBUG_VM is not set
# CONFIG_DEBUG_VM_PGTABLE is not set
CONFIG_ARCH_HAS_DEBUG_VIRTUAL=y
# CONFIG_DEBUG_VIRTUAL is not set
CONFIG_DEBUG_MEMORY_INIT=y
CONFIG_MEMORY_NOTIFIER_ERROR_INJECT=m
# CONFIG_DEBUG_PER_CPU_MAPS is not set
CONFIG_HAVE_ARCH_KASAN=y
CONFIG_HAVE_ARCH_KASAN_VMALLOC=y
CONFIG_CC_HAS_KASAN_GENERIC=y
CONFIG_CC_HAS_WORKING_NOSANITIZE_ADDRESS=y
# CONFIG_KASAN is not set
CONFIG_HAVE_ARCH_KFENCE=y
# CONFIG_KFENCE is not set
# end of Memory Debugging

CONFIG_DEBUG_SHIRQ=y

#
# Debug Oops, Lockups and Hangs
#
CONFIG_PANIC_ON_OOPS=y
CONFIG_PANIC_ON_OOPS_VALUE=1
CONFIG_PANIC_TIMEOUT=0
CONFIG_LOCKUP_DETECTOR=y
CONFIG_SOFTLOCKUP_DETECTOR=y
# CONFIG_BOOTPARAM_SOFTLOCKUP_PANIC is not set
CONFIG_BOOTPARAM_SOFTLOCKUP_PANIC_VALUE=0
CONFIG_HARDLOCKUP_DETECTOR_PERF=y
CONFIG_HARDLOCKUP_CHECK_TIMESTAMP=y
CONFIG_HARDLOCKUP_DETECTOR=y
CONFIG_BOOTPARAM_HARDLOCKUP_PANIC=y
CONFIG_BOOTPARAM_HARDLOCKUP_PANIC_VALUE=1
# CONFIG_DETECT_HUNG_TASK is not set
# CONFIG_WQ_WATCHDOG is not set
# CONFIG_TEST_LOCKUP is not set
# end of Debug Oops, Lockups and Hangs

#
# Scheduler Debugging
#
CONFIG_SCHED_DEBUG=y
CONFIG_SCHED_INFO=y
CONFIG_SCHEDSTATS=y
# end of Scheduler Debugging

# CONFIG_DEBUG_TIMEKEEPING is not set
CONFIG_DEBUG_PREEMPT=y

#
# Lock Debugging (spinlocks, mutexes, etc...)
#
CONFIG_LOCK_DEBUGGING_SUPPORT=y
CONFIG_PROVE_LOCKING=y
# CONFIG_PROVE_RAW_LOCK_NESTING is not set
# CONFIG_LOCK_STAT is not set
CONFIG_DEBUG_RT_MUTEXES=y
CONFIG_DEBUG_SPINLOCK=y
CONFIG_DEBUG_MUTEXES=y
CONFIG_DEBUG_WW_MUTEX_SLOWPATH=y
CONFIG_DEBUG_RWSEMS=y
CONFIG_DEBUG_LOCK_ALLOC=y
CONFIG_LOCKDEP=y
CONFIG_LOCKDEP_BITS=15
CONFIG_LOCKDEP_CHAINS_BITS=16
CONFIG_LOCKDEP_STACK_TRACE_BITS=19
CONFIG_LOCKDEP_STACK_TRACE_HASH_BITS=14
CONFIG_LOCKDEP_CIRCULAR_QUEUE_BITS=12
# CONFIG_DEBUG_LOCKDEP is not set
CONFIG_DEBUG_ATOMIC_SLEEP=y
# CONFIG_DEBUG_LOCKING_API_SELFTESTS is not set
# CONFIG_LOCK_TORTURE_TEST is not set
CONFIG_WW_MUTEX_SELFTEST=m
# CONFIG_SCF_TORTURE_TEST is not set
# CONFIG_CSD_LOCK_WAIT_DEBUG is not set
# end of Lock Debugging (spinlocks, mutexes, etc...)

CONFIG_TRACE_IRQFLAGS=y
CONFIG_TRACE_IRQFLAGS_NMI=y
# CONFIG_DEBUG_IRQFLAGS is not set
CONFIG_STACKTRACE=y
# CONFIG_WARN_ALL_UNSEEDED_RANDOM is not set
# CONFIG_DEBUG_KOBJECT is not set

#
# Debug kernel data structures
#
CONFIG_DEBUG_LIST=y
CONFIG_DEBUG_PLIST=y
# CONFIG_DEBUG_SG is not set
# CONFIG_DEBUG_NOTIFIERS is not set
CONFIG_BUG_ON_DATA_CORRUPTION=y
# end of Debug kernel data structures

# CONFIG_DEBUG_CREDENTIALS is not set

#
# RCU Debugging
#
CONFIG_PROVE_RCU=y
# CONFIG_RCU_SCALE_TEST is not set
# CONFIG_RCU_TORTURE_TEST is not set
# CONFIG_RCU_REF_SCALE_TEST is not set
CONFIG_RCU_CPU_STALL_TIMEOUT=60
# CONFIG_RCU_TRACE is not set
# CONFIG_RCU_EQS_DEBUG is not set
# end of RCU Debugging

# CONFIG_DEBUG_WQ_FORCE_RR_CPU is not set
# CONFIG_DEBUG_BLOCK_EXT_DEVT is not set
# CONFIG_CPU_HOTPLUG_STATE_CONTROL is not set
CONFIG_LATENCYTOP=y
CONFIG_USER_STACKTRACE_SUPPORT=y
CONFIG_NOP_TRACER=y
CONFIG_HAVE_FUNCTION_TRACER=y
CONFIG_HAVE_FUNCTION_GRAPH_TRACER=y
CONFIG_HAVE_DYNAMIC_FTRACE=y
CONFIG_HAVE_DYNAMIC_FTRACE_WITH_REGS=y
CONFIG_HAVE_DYNAMIC_FTRACE_WITH_DIRECT_CALLS=y
CONFIG_HAVE_DYNAMIC_FTRACE_WITH_ARGS=y
CONFIG_HAVE_FTRACE_MCOUNT_RECORD=y
CONFIG_HAVE_SYSCALL_TRACEPOINTS=y
CONFIG_HAVE_FENTRY=y
CONFIG_HAVE_OBJTOOL_MCOUNT=y
CONFIG_HAVE_C_RECORDMCOUNT=y
CONFIG_TRACER_MAX_TRACE=y
CONFIG_TRACE_CLOCK=y
CONFIG_RING_BUFFER=y
CONFIG_EVENT_TRACING=y
CONFIG_CONTEXT_SWITCH_TRACER=y
CONFIG_RING_BUFFER_ALLOW_SWAP=y
CONFIG_PREEMPTIRQ_TRACEPOINTS=y
CONFIG_TRACING=y
CONFIG_GENERIC_TRACER=y
CONFIG_TRACING_SUPPORT=y
CONFIG_FTRACE=y
# CONFIG_BOOTTIME_TRACING is not set
CONFIG_FUNCTION_TRACER=y
CONFIG_FUNCTION_GRAPH_TRACER=y
CONFIG_DYNAMIC_FTRACE=y
CONFIG_DYNAMIC_FTRACE_WITH_REGS=y
CONFIG_DYNAMIC_FTRACE_WITH_DIRECT_CALLS=y
CONFIG_FUNCTION_PROFILER=y
CONFIG_STACK_TRACER=y
CONFIG_TRACE_PREEMPT_TOGGLE=y
CONFIG_IRQSOFF_TRACER=y
CONFIG_PREEMPT_TRACER=y
CONFIG_SCHED_TRACER=y
CONFIG_HWLAT_TRACER=y
# CONFIG_MMIOTRACE is not set
CONFIG_FTRACE_SYSCALLS=y
CONFIG_TRACER_SNAPSHOT=y
CONFIG_TRACER_SNAPSHOT_PER_CPU_SWAP=y
CONFIG_BRANCH_PROFILE_NONE=y
# CONFIG_PROFILE_ANNOTATED_BRANCHES is not set
CONFIG_BLK_DEV_IO_TRACE=y
CONFIG_KPROBE_EVENTS=y
# CONFIG_KPROBE_EVENTS_ON_NOTRACE is not set
CONFIG_UPROBE_EVENTS=y
CONFIG_BPF_EVENTS=y
CONFIG_DYNAMIC_EVENTS=y
CONFIG_PROBE_EVENTS=y
# CONFIG_BPF_KPROBE_OVERRIDE is not set
CONFIG_FTRACE_MCOUNT_RECORD=y
CONFIG_FTRACE_MCOUNT_USE_CC=y
CONFIG_TRACING_MAP=y
CONFIG_SYNTH_EVENTS=y
CONFIG_HIST_TRIGGERS=y
# CONFIG_TRACE_EVENT_INJECT is not set
# CONFIG_TRACEPOINT_BENCHMARK is not set
CONFIG_RING_BUFFER_BENCHMARK=m
# CONFIG_TRACE_EVAL_MAP_FILE is not set
# CONFIG_FTRACE_RECORD_RECURSION is not set
# CONFIG_FTRACE_STARTUP_TEST is not set
# CONFIG_RING_BUFFER_STARTUP_TEST is not set
# CONFIG_RING_BUFFER_VALIDATE_TIME_DELTAS is not set
CONFIG_PREEMPTIRQ_DELAY_TEST=m
# CONFIG_SYNTH_EVENT_GEN_TEST is not set
# CONFIG_KPROBE_EVENT_GEN_TEST is not set
# CONFIG_HIST_TRIGGERS_DEBUG is not set
CONFIG_PROVIDE_OHCI1394_DMA_INIT=y
CONFIG_SAMPLES=y
# CONFIG_SAMPLE_AUXDISPLAY is not set
# CONFIG_SAMPLE_TRACE_EVENTS is not set
CONFIG_SAMPLE_TRACE_PRINTK=m
CONFIG_SAMPLE_FTRACE_DIRECT=m
# CONFIG_SAMPLE_TRACE_ARRAY is not set
# CONFIG_SAMPLE_KOBJECT is not set
# CONFIG_SAMPLE_KPROBES is not set
# CONFIG_SAMPLE_HW_BREAKPOINT is not set
# CONFIG_SAMPLE_KFIFO is not set
# CONFIG_SAMPLE_LIVEPATCH is not set
# CONFIG_SAMPLE_CONFIGFS is not set
# CONFIG_SAMPLE_VFIO_MDEV_MTTY is not set
# CONFIG_SAMPLE_VFIO_MDEV_MDPY is not set
# CONFIG_SAMPLE_VFIO_MDEV_MDPY_FB is not set
# CONFIG_SAMPLE_VFIO_MDEV_MBOCHS is not set
# CONFIG_SAMPLE_WATCHDOG is not set
CONFIG_ARCH_HAS_DEVMEM_IS_ALLOWED=y
CONFIG_STRICT_DEVMEM=y
# CONFIG_IO_STRICT_DEVMEM is not set

#
# x86 Debugging
#
CONFIG_TRACE_IRQFLAGS_SUPPORT=y
CONFIG_TRACE_IRQFLAGS_NMI_SUPPORT=y
CONFIG_EARLY_PRINTK_USB=y
CONFIG_X86_VERBOSE_BOOTUP=y
CONFIG_EARLY_PRINTK=y
CONFIG_EARLY_PRINTK_DBGP=y
CONFIG_EARLY_PRINTK_USB_XDBC=y
# CONFIG_EFI_PGT_DUMP is not set
# CONFIG_DEBUG_TLBFLUSH is not set
CONFIG_HAVE_MMIOTRACE_SUPPORT=y
CONFIG_X86_DECODER_SELFTEST=y
CONFIG_IO_DELAY_0X80=y
# CONFIG_IO_DELAY_0XED is not set
# CONFIG_IO_DELAY_UDELAY is not set
# CONFIG_IO_DELAY_NONE is not set
CONFIG_DEBUG_BOOT_PARAMS=y
# CONFIG_CPA_DEBUG is not set
# CONFIG_DEBUG_ENTRY is not set
# CONFIG_DEBUG_NMI_SELFTEST is not set
# CONFIG_X86_DEBUG_FPU is not set
# CONFIG_PUNIT_ATOM_DEBUG is not set
CONFIG_UNWINDER_ORC=y
# CONFIG_UNWINDER_FRAME_POINTER is not set
# CONFIG_UNWINDER_GUESS is not set
# end of x86 Debugging

#
# Kernel Testing and Coverage
#
# CONFIG_KUNIT is not set
CONFIG_NOTIFIER_ERROR_INJECTION=y
CONFIG_PM_NOTIFIER_ERROR_INJECT=m
# CONFIG_NETDEV_NOTIFIER_ERROR_INJECT is not set
CONFIG_FUNCTION_ERROR_INJECTION=y
# CONFIG_FAULT_INJECTION is not set
CONFIG_ARCH_HAS_KCOV=y
CONFIG_CC_HAS_SANCOV_TRACE_PC=y
# CONFIG_KCOV is not set
CONFIG_RUNTIME_TESTING_MENU=y
CONFIG_LKDTM=y
# CONFIG_TEST_LIST_SORT is not set
# CONFIG_TEST_MIN_HEAP is not set
# CONFIG_TEST_SORT is not set
# CONFIG_TEST_DIV64 is not set
# CONFIG_KPROBES_SANITY_TEST is not set
# CONFIG_BACKTRACE_SELF_TEST is not set
# CONFIG_RBTREE_TEST is not set
# CONFIG_REED_SOLOMON_TEST is not set
# CONFIG_INTERVAL_TREE_TEST is not set
# CONFIG_PERCPU_TEST is not set
CONFIG_ATOMIC64_SELFTEST=y
# CONFIG_ASYNC_RAID6_TEST is not set
# CONFIG_TEST_HEXDUMP is not set
# CONFIG_TEST_STRING_HELPERS is not set
CONFIG_TEST_STRSCPY=m
# CONFIG_TEST_KSTRTOX is not set
CONFIG_TEST_PRINTF=m
CONFIG_TEST_BITMAP=m
# CONFIG_TEST_UUID is not set
# CONFIG_TEST_XARRAY is not set
# CONFIG_TEST_OVERFLOW is not set
# CONFIG_TEST_RHASHTABLE is not set
# CONFIG_TEST_HASH is not set
# CONFIG_TEST_IDA is not set
CONFIG_TEST_LKM=m
CONFIG_TEST_BITOPS=m
CONFIG_TEST_VMALLOC=m
CONFIG_TEST_USER_COPY=m
CONFIG_TEST_BPF=m
CONFIG_TEST_BLACKHOLE_DEV=m
# CONFIG_FIND_BIT_BENCHMARK is not set
CONFIG_TEST_FIRMWARE=m
CONFIG_TEST_SYSCTL=y
# CONFIG_TEST_UDELAY is not set
CONFIG_TEST_STATIC_KEYS=m
CONFIG_TEST_KMOD=m
# CONFIG_TEST_MEMCAT_P is not set
CONFIG_TEST_LIVEPATCH=m
# CONFIG_TEST_STACKINIT is not set
# CONFIG_TEST_MEMINIT is not set
CONFIG_TEST_HMM=m
# CONFIG_TEST_FREE_PAGES is not set
# CONFIG_TEST_FPU is not set
CONFIG_ARCH_USE_MEMTEST=y
# CONFIG_MEMTEST is not set
# CONFIG_HYPERV_TESTING is not set
# end of Kernel Testing and Coverage
# end of Kernel hacking

--BOKacYhQ+x31HxR3
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename=job-script

#!/bin/sh

export_top_env()
{
	export suite='kernel-selftests'
	export testcase='kernel-selftests'
	export category='functional'
	export kconfig='x86_64-rhel-8.3-kselftests'
	export need_memory='3G'
	export need_cpu=2
	export kernel_cmdline='sysctl.debug.test_sysctl.boot_int=1'
	export job_origin='kernel-selftests.yaml'
	export queue_cmdline_keys='branch
commit
queue_at_least_once'
	export queue='validate'
	export testbox='lkp-skl-d05'
	export tbox_group='lkp-skl-d05'
	export submit_id='60b8d0e9eac7207393b8cdee'
	export job_file='/lkp/jobs/scheduled/lkp-skl-d05/kernel-selftests-mptcp-ucode=0xe2-debian-10.4-x86_64-20200603.cgz-a0aa657b74904f1ffff77eeb194591f99311e33f-20210603-29587-1kag9v3-5.yaml'
	export id='5945fd78d88f31be358ec7cf1799df4abc15097d'
	export queuer_version='/lkp-src'
	export model='Skylake'
	export nr_cpu=4
	export memory='32G'
	export nr_ssd_partitions=1
	export nr_hdd_partitions=4
	export hdd_partitions='/dev/disk/by-id/wwn-0x5000c50091e544de-part*'
	export ssd_partitions='/dev/disk/by-id/wwn-0x55cd2e4151977e28-part2'
	export rootfs_partition='/dev/disk/by-id/wwn-0x55cd2e4151977e28-part1'
	export brand='Intel(R) Core(TM) i5-6500 CPU @ 3.20GHz'
	export commit='a0aa657b74904f1ffff77eeb194591f99311e33f'
	export need_kconfig_hw='CONFIG_E1000E=y
CONFIG_SATA_AHCI
CONFIG_DRM_I915'
	export ucode='0xe2'
	export need_linux_headers=true
	export need_linux_selftests=true
	export need_kselftests=true
	export need_kconfig='CONFIG_BLOCK=y
CONFIG_BTRFS_FS=m
CONFIG_EFI=y
CONFIG_EFIVAR_FS
CONFIG_FTRACE=y
CONFIG_IP_ADVANCED_ROUTER=y
CONFIG_IP_MULTIPLE_TABLES=y
CONFIG_MEMORY_HOTPLUG_SPARSE=y
CONFIG_MEMORY_NOTIFIER_ERROR_INJECT
CONFIG_NOTIFIER_ERROR_INJECTION
CONFIG_RC_CORE=m ~ ">= v4.14-rc1"
CONFIG_RC_DECODERS=y
CONFIG_RC_DEVICES=y
CONFIG_RUNTIME_TESTING_MENU=y
CONFIG_STAGING=y
CONFIG_SYNC_FILE=y
CONFIG_TEST_FIRMWARE
CONFIG_TEST_KMOD=m
CONFIG_TEST_LKM=m
CONFIG_TEST_USER_COPY
CONFIG_TUN=m
CONFIG_XFS_FS=m'
	export enqueue_time='2021-06-03 20:54:02 +0800'
	export _id='60b8d0efeac7207393b8cdf2'
	export _rt='/result/kernel-selftests/mptcp-ucode=0xe2/lkp-skl-d05/debian-10.4-x86_64-20200603.cgz/x86_64-rhel-8.3-kselftests/gcc-9/a0aa657b74904f1ffff77eeb194591f99311e33f'
	export user='lkp'
	export compiler='gcc-9'
	export LKP_SERVER='internal-lkp-server'
	export head_commit='6fd63bbec78825af75a5a63bbff79bde8e27cba8'
	export base_commit='8124c8a6b35386f73523d27eacb71b5364a68c4c'
	export branch='linux-review/Florian-Westphal/netfilter-new-hook-nfnl-subsystem/20210602-002351'
	export rootfs='debian-10.4-x86_64-20200603.cgz'
	export result_root='/result/kernel-selftests/mptcp-ucode=0xe2/lkp-skl-d05/debian-10.4-x86_64-20200603.cgz/x86_64-rhel-8.3-kselftests/gcc-9/a0aa657b74904f1ffff77eeb194591f99311e33f/3'
	export scheduler_version='/lkp/lkp/.src-20210602-232607'
	export arch='x86_64'
	export max_uptime=2100
	export initrd='/osimage/debian/debian-10.4-x86_64-20200603.cgz'
	export bootloader_append='root=/dev/ram0
user=lkp
job=/lkp/jobs/scheduled/lkp-skl-d05/kernel-selftests-mptcp-ucode=0xe2-debian-10.4-x86_64-20200603.cgz-a0aa657b74904f1ffff77eeb194591f99311e33f-20210603-29587-1kag9v3-5.yaml
ARCH=x86_64
kconfig=x86_64-rhel-8.3-kselftests
branch=linux-review/Florian-Westphal/netfilter-new-hook-nfnl-subsystem/20210602-002351
commit=a0aa657b74904f1ffff77eeb194591f99311e33f
BOOT_IMAGE=/pkg/linux/x86_64-rhel-8.3-kselftests/gcc-9/a0aa657b74904f1ffff77eeb194591f99311e33f/vmlinuz-5.13.0-rc3-00737-ga0aa657b7490
sysctl.debug.test_sysctl.boot_int=1
max_uptime=2100
RESULT_ROOT=/result/kernel-selftests/mptcp-ucode=0xe2/lkp-skl-d05/debian-10.4-x86_64-20200603.cgz/x86_64-rhel-8.3-kselftests/gcc-9/a0aa657b74904f1ffff77eeb194591f99311e33f/3
LKP_SERVER=internal-lkp-server
nokaslr
selinux=0
debug
apic=debug
sysrq_always_enabled
rcupdate.rcu_cpu_stall_timeout=100
net.ifnames=0
printk.devkmsg=on
panic=-1
softlockup_panic=1
nmi_watchdog=panic
oops=panic
load_ramdisk=2
prompt_ramdisk=0
drbd.minor_count=8
systemd.log_level=err
ignore_loglevel
console=tty0
earlyprintk=ttyS0,115200
console=ttyS0,115200
vga=normal
rw'
	export modules_initrd='/pkg/linux/x86_64-rhel-8.3-kselftests/gcc-9/a0aa657b74904f1ffff77eeb194591f99311e33f/modules.cgz'
	export linux_headers_initrd='/pkg/linux/x86_64-rhel-8.3-kselftests/gcc-9/a0aa657b74904f1ffff77eeb194591f99311e33f/linux-headers.cgz'
	export linux_selftests_initrd='/pkg/linux/x86_64-rhel-8.3-kselftests/gcc-9/a0aa657b74904f1ffff77eeb194591f99311e33f/linux-selftests.cgz'
	export kselftests_initrd='/pkg/linux/x86_64-rhel-8.3-kselftests/gcc-9/a0aa657b74904f1ffff77eeb194591f99311e33f/kselftests.cgz'
	export bm_initrd='/osimage/deps/debian-10.4-x86_64-20200603.cgz/run-ipconfig_20200608.cgz,/osimage/deps/debian-10.4-x86_64-20200603.cgz/lkp_20201211.cgz,/osimage/deps/debian-10.4-x86_64-20200603.cgz/rsync-rootfs_20200608.cgz,/osimage/deps/debian-10.4-x86_64-20200603.cgz/kernel-selftests_20210507.cgz,/osimage/pkg/debian-10.4-x86_64-20200603.cgz/kernel-selftests-x86_64-0d95472a-1_20210507.cgz,/osimage/deps/debian-10.4-x86_64-20200603.cgz/hw_20200715.cgz'
	export ucode_initrd='/osimage/ucode/intel-ucode-20210222.cgz'
	export lkp_initrd='/osimage/user/lkp/lkp-x86_64.cgz'
	export site='inn'
	export LKP_CGI_PORT=80
	export LKP_CIFS_PORT=139
	export last_kernel='5.13.0-rc4-03555-g6fd63bbec788'
	export repeat_to=6
	export queue_at_least_once=1
	export kernel='/pkg/linux/x86_64-rhel-8.3-kselftests/gcc-9/a0aa657b74904f1ffff77eeb194591f99311e33f/vmlinuz-5.13.0-rc3-00737-ga0aa657b7490'
	export dequeue_time='2021-06-03 21:13:58 +0800'
	export job_initrd='/lkp/jobs/scheduled/lkp-skl-d05/kernel-selftests-mptcp-ucode=0xe2-debian-10.4-x86_64-20200603.cgz-a0aa657b74904f1ffff77eeb194591f99311e33f-20210603-29587-1kag9v3-5.cgz'

	[ -n "$LKP_SRC" ] ||
	export LKP_SRC=/lkp/${user:-lkp}/src
}

run_job()
{
	echo $$ > $TMP/run-job.pid

	. $LKP_SRC/lib/http.sh
	. $LKP_SRC/lib/job.sh
	. $LKP_SRC/lib/env.sh

	export_top_env

	run_monitor $LKP_SRC/monitors/wrapper kmsg
	run_monitor $LKP_SRC/monitors/wrapper heartbeat
	run_monitor $LKP_SRC/monitors/wrapper meminfo
	run_monitor $LKP_SRC/monitors/wrapper oom-killer
	run_monitor $LKP_SRC/monitors/plain/watchdog

	run_test group='mptcp' $LKP_SRC/tests/wrapper kernel-selftests
}

extract_stats()
{
	export stats_part_begin=
	export stats_part_end=

	env group='mptcp' $LKP_SRC/stats/wrapper kernel-selftests
	$LKP_SRC/stats/wrapper kmsg
	$LKP_SRC/stats/wrapper meminfo

	$LKP_SRC/stats/wrapper time kernel-selftests.time
	$LKP_SRC/stats/wrapper dmesg
	$LKP_SRC/stats/wrapper kmsg
	$LKP_SRC/stats/wrapper last_state
	$LKP_SRC/stats/wrapper stderr
	$LKP_SRC/stats/wrapper time
}

"$@"

--BOKacYhQ+x31HxR3
Content-Type: application/x-xz
Content-Disposition: attachment; filename="dmesg.xz"
Content-Transfer-Encoding: base64

/Td6WFoAAATm1rRGAgAhARYAAAB0L+Wj4nvtcChdACIZSGcigsEOvS5SJPSSiEZN91kUwkoE
oc4Cr7bBXWVIIW1d8ua7xL90VOjS12pSkksYKGnr3QZkrpcjQY85mvAb7yj9lWdQr5WS2URV
5y7Dfi2JAH4x3h5XJDyK6woIAQ/XmJbpXa0Gl18uSaUd1I3NSmY9Njbl4tRSrh/1k+ATbbpl
x5yituL9NMWXbPGdsksByL55WaRFeck02Ms5qPTbNIqUxtW4MD32IXeI8ed8sXvZFzZyEx1i
slkRTkdqhBJTborKuFYVwZJaVwovsyIzLbvgHR39Rtj+vF4xidsO0qbRfD+oAWex2HilBKei
nM7kRS+kG0rNc66iaULNQ2zuEJyQ2z1nOcASd+mQ9md0iNrb8atzEE0fyCDEZXYtlxKh4CDM
p4xrvOkhbuDbhEFqIoVRB8Htrp5IUmMrqAngVkic0DqRFWMoAlJ1ckQOCIb2f3/ZVZgDzOoE
dxd3QwP8Bh3Ao1ot+thcpNXuWycEphCmjua16oX2HTtN4oA3Q35wLntJHZkqh5n7uo/RWbif
kv61Gsk6g3wfkq5UjDO9XjkJJpHjVTNpKQKw2lR6DEjqAR0LwwmwyCF6EbA2xTMhCc1MFmDX
fpPIM5v5j3mgmUceIEOnv0ycZrYZTxEHW9sR7ytPpX1fad2TSZNL71y92C6xNQXeLlbTSZVy
v5gQKD6DoWGZEbFobIlhzd7qmsLmDVsykvWd+XWj5btVa13nJtV6CmH4lDsnh4q9OvjaLPJl
dosz3RTH88htuea4UXVp9qT/j+FuJnA8EfuT/ftqtrGzb3DZT0LB+QeS+AOwGo+SX45InJAQ
0+tPLVuAUp/fsvUNdN99OajVs7EluEIT7RU5s9l3pBjMYd6F2EZpdvgnh4SGtNbODYlio/uG
mnGPmv5eqZwCbhFo1WQ0ftpoUYcchEzr47tpLqtgnHuQAovT1zlIgT0H+64kB3UtWTolDjkX
LUf6Lhq1A+BP15Xoscrv3btYjRUcIt6J4j2NaGYyeUhIbrGZ5TSTJqXSR1qbMbfeBJmSQwGj
rO5cGTiNyhvNLiRbBjqdT159QCdG4mF5zm3ZTVL8mAssiu42QzTQkPSfKcqDzthU2YvYizWX
/asYqeeWiHK9VDbwPeD5jm6GzMfw9eXUBqZZJi+Kgtm5OhPv4wY9pwPi5+w4cjphuRBRnKXv
+13hFuJIvr6GII+dzl2c+3pqjQHfaRMsW9vIFDZAMoVntsMom406kcLx+gVNgJFWOjK4aDaM
YsMALG6J1XV4CZmadwhXU5Hbp5JmsBkaDUCrdz08+N/xQLl7n67zwnF47lF7ZqeIG8NYKMfH
2pKXRqfqiA6QbUu8gqcZ9GPiWG4fj6iSAz5C0bezYg5L3STWtz/hjbzUvi/hC/0adgKgmt8O
Xkp8xG+7e8qhz9VKDZcqfXzje8Ha4sWEJn2Q/F8J9iOqcFxlPZG2QrTC/r+YuHc68/M3nQrN
qBHrAH/lC32djiKid9uUHPtIuz6hZCZzuBIOscL/eQdJyhmXE1AbK5qQvjUcN08N+VvVasOt
D8h24EfxmQbkFKqodJhp89Rx/QCeEtH+CmT9i4UHVXGgBh4tQhh9sTKKvGboxt8665tToN5O
lA7/HbGjCdsfjjqTN06c+0i6ruTiDVjjyoZ/cq0Tpjzj5C/VOapXE22Q1nz7MhvEGXAgFHE/
89ktS+BA13e3VGi8MXIwlWPgRtg/pCFIVTeKh752JQd9XWrcclPfLKWEic2ICyNDY4HJNKtp
02+0CWX8d+xdjhe4ShyoBDlqrGQQA4g9+Vw+PLGbYHwVqXW7smcjPf8uqm9yBaqLnTAV1H52
bUa2wnA/8j+vX/P6DWbhqLSfNnxCfxt86bbVlsdpVS17eWIWOcnu6/WhCX4ULzSn6vhOlXNY
34pQH6pYkTbv0xGC8U+pE1uTxIkIOyp2OrBlE0uSTwrOkjCDodOuAtL+5mCDIn5AZ2200Yzk
Yh9nuTo5bT1bW5uxw1cFQPpj7DnT9SOx6b2okKHIfD1MW4lPzX/57U2mhQXoMGF+Htci1yJf
jgOHbwY975Le3NnqVImvJH2+gXAkVGl/YoK0yBXfleEc3oqbnc21ayF5UecXa/3V26LU7nkN
ejrPqWl8nXiw3eAzZaYCg7Fy+FiESNsX3+zlAJTkFkk8NCA2F0KIrfbNREZgChNjDm69oAq9
IIhDvlRXCRzokTmLBPmnRl0m5A1bB08tSZB7QPfkqb2cMJuHPyhnkJwnRd8TAWcfA190/g1L
3q2b5B1Nn/rVa4pdOgK85dj3AhE/jCnnN7AilkmUWHVktBwFakZdIC/MFyPI2Sxphyt0X2kU
b+2+PuOYBRK5QZHWlZznEx4+BgZejSlJo62gH9vp9jPV3iD/RlSbqfoOS1KPO4hCw/ZGYX5x
G3zzCvThZeKiv7dvhL5dQD25qTg5RzMSJHAM75v7kgiA14bTQoxn5WmMcsuD9XGxAu4n1GIA
sE8VSY+kvXGI235CW3nGUcgUOpL6f5iSHBvKh5F3BHfl8tci74wCy5OXVL6iIz/8+D1A5pfO
cwf2lVaDiblgVMjfk92miZ9SPtOtelwJjPuZErKPYDH+d2b85bOZaPx1Y2BOp3uyoaCdY1Jf
6O2qUh1PcrKD0unn3s97IGLXDDP8Uyxj6SrAy1tJ3EwQ7kILUbAtcfaKEwu3nSJY2e7wW8kt
TYjM27f5wfwiKtzKIfBWeqp3YR/dIrIXKZFfvDXsAFxd7nOkig+Zcpiujo1bdZsTFI20yQTj
x2Ld+l2SQbDV/AZw4MdMw8so5qKDpUpwxut8rmaXHJ6R/KkHXChoe5XUR2Ed35N0CrfMWzK0
2JBn4ecWwhhV4f5rsP73ukY5OtImr0xPXYVcf1TRFIUnErrpqQjYX82fYD+/RfafPCl4Wvvx
iPtUuzmXUjYh+pP7PXxc+w+7Ko+7sQ8ixN/QHq/PAK0LDjZrMNogBNErXyf1G5vsDJ8qaSWE
7B9AickNdeJED6ZRxUzvFU8xF7VyEZjYXEvOeV0nGQ4e2o7OmsHARKzCf4zmbJ+/iIupAnU6
reiEdrM51krW0skRLpn5OUxbpXlGS+S9JWkyO91bg6GIz7sWD8dWie2OyWvmxZpZ23kVg6rQ
FpzNCE5ke/ECud+h/GVPAwaL9qnUCMD+4mwVEtn9sKyzjOi5ZNydxuv2mzcnU5l4EvWzcmrc
rNEZPUsK4ek6EMEMHAdgSuOwRLBdxJZb1Ufaio74+ZnOPYGTanmJDztMmVHai3E0mEPeJ/yu
KA7gTUxshuX3srppZymwYwwnMnD4hNKqtdKP84ykDeK2Qerq6rDRw+z3tA3EFRGqUDf7RBj5
0Rsfx2O8LjOsQS5fbDdlS+4wQjx8+uol4n279VUsLNdwvWap7fxnkhGH4I+ztwgiAH4dLQq0
fOmYDv3IV4A/ZUfsd9OduxEnXuq/efRawmcQp7ySt7+zXWnsXbQ8nvfZmTWHsmeV/nODB2UM
LgkkQJ+eVQYuknUAmUgLb338Skwx9VNdr5nTdLxmkg73SgGirwpqVxhf7wkZW6v9xZdMhQ+B
vbZerQYI4qHi4/FYMIFugFvgizVfk/UN/HIGBLrdaFgcGFtnAXBBj/Q1t8OxEAkVcob+8DSB
yEejbIsOI+pSppjPB/2f25NeU6zL6SRfaunC4qnvGL5CcMyCfZYwMDlh3ABTxmMddEXfLQRu
mdnCcMneFSKpEstZ0TkghtrzXrOHcaPccGIcKCNx25FZOrFJ7WSQJnQ9jOQgACZZe/v17CDm
PsONf23Gi3l+N2J4s8bsWTWE8+V7OA0fDsJL8/nXV1m9q1rKQYw7GvKpp2giWARSat7qvzcI
iLgWLcnyR6pqD6shF8qDDtK9+KXAk46/ThuPHWQauEGhb88shwMsRon7nMZw+GYuHmHAoyHZ
XeeoM69IJ2m00Anb0sN/BN+T9vidnVUAgGROPy4cqwA8RnyW90NE9U84dHNW92YIC4uZvW+2
5KUh3O+H4qPGgyUYZ3UXcSZx0fgiOFLP31b8ZWR51zGLDyWegw6Nr5Jddq1ABUi9MIAcC6Db
ruW8wn2KkKjTP8u66HofYajZKbu0wVU5xAjkpNvkVW0q2mk2hyNty6qYAW+uFSRnbLK2Ner7
M9K8shHnYVu+UKtBAvv0gxAm7OvYwdgW1Tz1l60NooZo/wh6Fcvc/47MdCxGrPg5lH5z4EHi
Qk6g/e7azqBfeDkIh37DEvxIkBcnd9h6KuDwksFaVlCIva9FhhQ1TEpxlLZ/t3QnGkUNuynQ
fGGs+U5Cb5JU5AhFaVdPrsrrWSmafH3AgHeublPvik1m1ckawuTr8RgCjEearUk1yPvdaIdb
0QvafWdZUmIC4OMTmRhp9duU6++2MBXetIh1UpFThsxIzwxfvVQzeDEA62f/I9GoDjigNdVK
FhcWvUrPPL5BY2xO4++frIfZkMBJEIpTKRS5cBriGfO86OJmOfJDFyJchTQF6HRUoQP4Jsxr
QHgOFct3CmU7w+r91IDHwX7k1WjzF9zs5o1rt4rOplaFZz4LWIAOhvHKCkFH+pprpXwX8U8/
nhvrDEQYCJsxTLRY9YxscAAs5ds7wclWdkFmJ4TJwbO4qRxANVS8g7AKGu5oapTwK0ItZ+6g
p5u8pgTJ2gkOwWJYHpZRH00l5uMufNVtx4/rXwon1KYVqsukGME0cOFdSGph8zQDYIe+QxY1
YRiqFTePSpsaWgw889mBecwQ6ZAttu/oHG6dKp/h2SV8my2ac68DL4AsNlsHiu9UJQP1jiSX
AzYT/OpASrM/Pn50M/PPwy7C5g8Hz4vgt5BzAfUbsPtLh75sjISOyNr4w05PlffbO/S6FhNf
pN4aPP5Fbc/47z7VhotxfjihjTpWZjYKZKgE+p+lj5ByuykdLUT0cjSNH0CX1akgc2hXnlzv
uU8hibU/3ajGB1qgN2fzBpuTke99o9qgB/y8B07Ubsc+Rhs6qEMLCGf6LTJRqJtS6LTZcBWS
zGcJZYv5m/xgyR51KVqbPN0VTPyia9m1rDYXwoEpvDWUo7G93OA39b94OeI+XRBBuClQs8Vr
JIT3lxKX4Qr0116v37xooJhxmPIP37uUeHMlSoNJBGwPCIVf0UoJuc0iQFHLy+kFLMyB3aKa
QaaeAEh3996oBQSSGBMe/zkxhFVtd6rGW4Ma7BeC1uQNPknwJ9SebMIYT/FwapjulujLgsWt
vWUtp7zYqo1/aJl10/f1GJkFyJjoy7WvFQqIrFfi/LdPOBPoklXMiYYqsYzmXg2BIVGwvEeI
rqTgx8f3TCTtESa0isUfVshvA1B4/cPVQxfIzdKSKGRL8rtMp9IH+54jtSRjBO1KZmJx+UDH
1+27eDjgNzQ5M/bkPpLEeuC6TsalN+x48wxcfNf2KHk5De1srFGwH0iwvSf0hNpudahY8ol7
DKOdiCcITrpkg83xcDcmvEtjJ3hBGmxkt1naBbkSnoxOCTstgpQNeRokyN+IRejVCFitmNaI
aQqdmkfqupbhyZ2ti5M/vhlz9VMuvpq/0gPD9KQ60BHgSRSlsZD1hHgvfSMXIxn8Gug2WarV
mMTF/l6qjaCdENbv3gG5ZwHm3ZYBoADfaBqhcvMPJcQWLp//NANXgbN9kC0zOeOSfs0nFXho
1woKBCGvo/vGehrAx533jZjUiFh7yUo0kg807YSvNFWJchXzqpCktEios64DTbbGLNs7UVwY
cp0ddLZCUum+2z+9C0SJf07TUADdx2BggRcpN9/krxxAQAgT/uP7xywxnykqJuqw+D43F9QS
HUWb//M76SF+i/a/8vJq9ymt8RxTlZl6T8avnCTs+QzE2Q3txIJp3IdeUsASfKkYlUc1TcFs
6sg6cDdQf3LVw2DsGiDmmZubhnYiIiCK68n8f4AEuGxD6SUKjU1kyWW18d+lESoWVWbbvriW
K5aTo01Nxi7Cfr5T/3i4R8BEVbSWvkaxfWmR4bnkj5HM6Deu8+dX8iB6i2AXAB+vF0F4TlZq
Ns6/oDyzzq2/YtBIh/qp5AJjPhpDPO7I8Tog6DD2ltYZRGF5XHPahU3oEl8kJfmOHcYgf/Ag
mfXAtgTUEVrYCveAK/5/U/eKoaU+A/Yh6qaDkp93/rKIUbzc1S7dckvVQuTDfj/dsjEgAp5a
dL9cxF6n0RcA6zYHTtxCvheUCzYlftIGgsonH/xwhu7Z/JcMXIhPhMuz0bN++9JtK9wfQ0+N
2ktBRvVmOrRA+Rhv6z4dRZb+DhqrZgHu7yvEPy6N6VBgsGj3YqVrpMP1sphVIPIxjlD/OXS7
WAXyufg1X0eLKvXqBm8lfwCq/HdSFZq7U+a8jB6g+NZfp2r/DE70AKhgnvi3ynh0kIlXGiDJ
kgiGKjQNeeupY4uk5s+AN6zGSGS1ExE3DsLzOxBATde7dUZnxasn0obfO0wgpBFG+iUzTzO+
O9047q5jHWgEubZ5IbmQmIKF86YKnbS0DnVir32f45YMPINl1ySNcfc//phnyaPO3ORVbz6S
Jy8e0viHTFngdyuRQwFzYoHV5Tk+gI1knPv3rJ3RItE6rBxIni6YNzKzY27VA2HxZcX7NSNs
uyzsMLEOWC9D2ctIGxYdfRuJqp2J75wmI6jJKI88Z0f0r7KKQu+xeKVGhoDl0iwunFwg8fS6
T+U25dapb9hieo7GZ56p1RxaSovJY/15OgYrt0igCedcKHHDeD25OozEzRGE0ghtd9rx4UOM
ecj5hu2AqRK5ycktKvJv4YCPZUytZF/RWXyDlW8OchhICae9NTQFV97/lIaOWcGyggj6MoKc
2e2gKZl4V7UVlGj7R4Y8ZjbIccKV2MBPx+E9uYSt03wYclWaJkNeQq9/Pa9MMOGNU6dnTqOT
8s44iE9Nt4e7ktpZadB9LGmYWTsxuJPrGfyQBEsAVFHDwjisNzWa+s7GqlYeL3F+snrCF0ag
hTNxeXlezytztdcV3C9hakP1CbqVPwiflfHLm9X3svej88ut6Gxh3qKbdY/ezrIJp9YxNvGV
pti3JA+aKG6+lbGjKQKfWwthQvMTRQLCw3QV0TuJeYTNGRhmqqNIkHiYND8SUH46i9jeAuHL
sl7d9DW+4bxskLOgy6bgHbcjKoK7TbIaM9TLr+r1RkmYl/cFX3V0QKReCsHEtjqvpUwGI5ym
p9toRgeC0b3Cz7yGYYqztmBe+t3hQ4wPGsWP7Uql5bzMNonnBqpZRMgrq4g549nfR1uT+T1v
KhnO+AR2RyL2tKNfCxk+bvppDMg5/1dnmDIuvTi3tAfQR5iwYkH8s5ZCCXB0qWxAFQJlEIrM
lzqvoLWUSMw0V5nHi4vlabOJO0ChhnVMWkKwwLlkLctrhea1NCGCNvQ7f55y38tHqH2t/Lqk
SIk7kIkWkKecZ9mtdBWfn05G6RBi2lfT1uo7U4WgAFdg9atp3kn+W8D/DcKWaTinrlf8CO/X
n7v/1Zm0HUHqnOF+ZbNNEgSrS32sP6XVqdkP4D+EuXbcFrP2YessMyn+UGfTzkJW+hg5WVon
Pw5gIDMidOmJFZT7U/oXFzmt9Nu16wFQWDzoBcYG7zXe66PfsM+WJw6wch+Vg9Rqp285toJ2
xS4N/ITxT2KgnRRzv1uq7BQci31a3JUL7XYqD2lOXCzBejH2MINTMCOY3nkJV/KCdPQpLSkE
ufomRtUZbE2x55ukGMlvunbk4uK5X01k6ybB5aVNkHjV/mg9uWunuYPjwagjZt/Mp9Km25wY
x2C25BnyuMolYVeEO1gC40hOD6QZPRfO/KZFgBnpLnOUheGUjezHr/fW/e3bLkvTBVruP2lK
r6Zt9JAn+4LzqpCzA54szlsD/cJ5D8isuMuYw0uwHyNOZgi5euyhxy/A2pZs/NI2GjgFp2nt
9LLRWUgMQtM/b5okfOd8sAUDaqH9OK+ngLn3MGZvh5UUqRyGIjE3wY3pfZF2GF8malPhJqLH
XAdmWUkpVmZNRR+vnbtdVzQgutBsApx0ZkLMailCrxAiXC51ES+8Ssfpds46hNKmfbZ74l1n
PgujnJ6c+0udL6ccI49HkGuVZdGNfwxHu+464ZA37Krkmcuj1POyFF0C9Zvm/Fp+Bk+88/MC
/+wQlXXaBWPhdDfQrq2UXUwdZf0ccDHhRi8SeXhoF1KZIMyXBYPERG29/kmop2EkHfMIb+LZ
DUIjEeXw6VJ0dTASRl/I3DxmHtJEKTbJXABN/cVmTAdhvLqaI8FwJ1z7TdSu99m6njkkB/Io
U6HzilBhfT98HIuxreZDUwvZZlubeYvpAgV2rzB5pyWc4OXi5W6t4zG7Toh/TW9eSC9X2JZm
EBlBN8/L4AbMkalWzyGHLEiSzm46+kQJW+/IOtCr2XYXjFHUKlD2Rb9bf2cvy86esSddLJl3
es5Rp+hx1g87azqTkklPFaT1fAHVho8YI9Q881bHJzo+k6amIcp2ToXqxOCeK/nfdvMKzPUA
sT5fpcE2svXXS96g+3wx0eSwMJuLmtM1k8sUQz3d2eYiQEk8R0vT3bzoQVVqCcaILiITkSDa
9tyA6d5+bs/jGz/q3a8C/7IbFILrxBQFhJl2ZlFltCuBXpQEZqhQ7Ro0zFS2wlkFaXixRjh9
y72VsmZFf9JKPk0L1JLo6V5nwnPkgdA7iSpg9FirwCtuQkyMDrwyNd9vdAwCj5pNLceMOkaJ
ZrDdK77vHesucEVICXCmnTQ1wiFza4pHE8FAKHaqDhnAKnii1jMcFskqm7AZ8Y7bdbVadYzj
cQdNJsKSIkuPjpUk5sb5C2DR7xtCnbRa5EH88vBECM/m2RXyBtYs+9pITnqSMlR/la09EcNr
eRipXmPfbLdo1qVSQgB/xd+KQbPv4bHUXS+bkmaRW9Z1XQy5noVXbgEooh89DdrxEtCT0eBL
iYwJGLgSQe1dp+RxmsxLzFyj5UZTjOX7W9Pu4C288pmEh5LBNoEDqbL2Xp6GSFuZo13qNMfM
TWu0ynhSivxqgOcJRpIHKymRMi0jjP/RW/NdCX3rJyulCgZyrl/kccXlcww6WbACphoZLVkp
kQpE6+MX6eBaG/32FurxzSqKhET/DvmPmeeLWsO47gRIiQZxsDBy5J+Pv9QqDMchEvb2xCqm
ca+uVPQAHjIFnMf86WS5elixH/jrhqGDCVOIUC3AME+RiYIqHRArpNkS2bgdx1ve8mjD/JBL
K+w3uYdRX5w6T+lcgML5BpJZUfoFb1S19ESX7GbbvJqR1po33zAqDvpKTeLUKM+MuX4bhIsd
TjANW+FeOPqWo9XBgXrXOx3o0jB2Nl1BssowaRMywQ+hFqOgETjwsvJuXxsTLyZe9zRPoXou
xIAAMzZ+e8+fHHq1xg9CMyFw4Aa27CcH00DN30JgnPuHcd03wpZbVxvVuhh/R8luQvjgZinH
PkcsSCmldZDsLNvliJncfOlnjPCsEpTFWyogoKEbMEdlyb7Z0ytubIIdP0w7aA10AJr0g3V3
hlfDA74LlA69ZQ6hKUZx2hrlEqQpuOwx6dOUtzSGmS2nrut230wVaJw4Jdirrn+ubMvt/CRw
tvcOxsCKrXNfHCdk6UEAzq1rHxznNCoHwe41gBWZ5D01uy+0vUQCI7mEWSxwmkTw0GK5vjgo
tZSamBvCTJCYQ2KWe0Dj3RZCqrn3wC9Zguih6Z+RbrwrbexcqxyxMzQopnZ2LtGoiLtbTSli
wFH+oPL9rZHqBCHgUFSjvVfAzmukRPsWKfTold0E/NbvQjC4Vsd3OR9InfdLteCyYKBRejvv
qOkcd2/wFvqHeC8G3YfBx8zF5nvE0CPxxeynkwSq7Kyxg2TG1X2WWRBb8sAo0zrrstdWIMk8
zHeMfKVmQ4xYtRDP7uhtNaaBTwaY+uLJrls5aaSu10gfaXOXvwLa0JlOFcQjKrSn3BbnXz3p
1YQrLd+ZlhlVnVkATfCIFBesW3eikLqF0MNYO4CpXQO55/K/dubjc7X7h2yM/cv2nUqHbkQC
sCHcKw0HTdIjtdkX4YYmZnUcDTshxhDCW5X7MSZRU4VCrbMqJLmZFdsnqDulByZg9kXUEv2R
ea0e6KkHBzE0a5SoVrkERLR08cUEJ0AgFCuFEYOV4wEPZppjCeDky74s9yiYyBhN53mOPMCG
fisFg07zKd3QUydOT24J6z1ZUMdKJ0YMkDl5wWkTqeDY4v6I276whjtwvsm52ZoaNgKtWwdA
BD8eNRiWnHIR7lRzHTjFCQ//Xatit5gPp870anTSAn32vTlJr9nmMnufv0XFLJtNpSyPnmNO
ebXsJnW5FA9rgZhf2a/U21ZAcoI0iBfiu0TX/NEmkrL9qKld5W5KMuhbBqLDwwOFPx3weG8O
NWDijvktUIMyEn0rjEg0tQzhPFJZu7KPH/lJcvuHQBw9pPFx3mlgF4/gUoTgupv2fVQRtl3C
8KsPwNmRBsYpHHVdyWSrWw4XPnktCVyVhZb+WHaLp+klwEY9LM9J6AC+5wYkMiNVM5Khzry3
bakJmpDYsji10Asq5IJlRb6uRn/2oL/UpeeoaeKtV9TSGlFD1Djl+L2r3qperHqCPQkBH+gA
7LNwHs9dtHzl9sFLolXajThJf4BE2zkMpomtZu75JK1B4gGf1xVSkw9KcMLRzDIZUP3sXSe4
9UJ+L4LofowrJAh+agATOQzG4/jQQIGqf7AXquqFLIEoqBCWXrfmliIoAJy5eQjFAgWJdgp5
XclRq78Qx9bOwKKHj+kVurDLMiEPAyUrQZNYLW0YFB4JRLAYZaw2hcMLkqvYx6yvcAMIa3F7
KWPs4zM5Bqiwc5Z5gnEsyAfYdFWW7RMzpakgucflP4Jl0c89z5F6CXeVYpqsyVRaCkaA86UR
TkFURJybporjoT0V0kJ0xsmftbvd8Bt8xEMicd8IOV9O2DdILzE9iHju9oB/ZGMSz7Rp8Uej
NxUVfaHHhNt6EfxJqWQqL7nimTX8FsdTPsYzfR19ifS28rV4ly0FGgeqJ3nB9dvPxiDcpMGJ
IVoqae/p7kBQ83X/7gw01TmP29oACBuhVb/AwdSvJ0wZ8rCy7YGW6sw88dtjR09P9Wkkl3mT
QfzIaAS7AXzhFfHP2ylPoitXMaDWOnK3je3Je+XLX6AONSpZyKCqsDlqLvSRpMhZx67l4CDb
j9Env2xmMmpOoQ7qIkgjYax74grWCfxpsygl/c6XmDu5vWldMyeI6bP/QRCPRimP/d4sCFHQ
2a2i3odHUqOkj4h3PRqfg99UsVyEithE00uSEkTgcTd2nfjGRbK1x0wlFrptTXv+SxpaOAPw
5Qa6qo7d3nL/bLmJ1Hmu6jKT0UPib6Uox+sID0DMa2IX8YBLFPIL73PpbAKcRsanEKfbj3kR
Mq9XGP2OUkQWAQ7OyMp6+zR4D+TRT+W9xDA8mpU5VPv2djrjvrTrlWh2vY0pKIONmxjQ6aIU
2k8Vb8xaIlW6LBunAsuxrvpKMCdzKR1nKqNkFZfGLMvK9Mqek27NRjTtKfvxQmH5zB2J0qe5
xhojZhjh86aSMhG2BdEFr8JBZpv3tRQxR74fPa+QC1KGD+7Gl/R2nLs54s7ipenuHt/uVZAZ
mkvKwtmGBA7QHCzRIkCQ+Ojen1CiUN5xAIiYMfHvc6iMn14Ilo227Eyje6xQKxNErDbtoE4x
zGJC55K7ERJfuyBjbvZOSTzGCg9A4INZq4lEoAuegf4h3bRoeuzeGoG776Izt5YwwF1qPhDe
T0zGm403oRpqscJAAfpmkjwE/2khPemZwfQx4FJMCIewpH+hJpBzRS5G7bRA7+eBWwvhgaw3
QjsQTa8M4V82EF4FLJe/45s+Zp8w/0lSVuy9tURyDgSS8IfxtnL5Oq2XsBU/lhNK1EQzSEeh
YInOps0f+y2/ry7m0iyBnXFuO8feVHUvUF75n4+zr7/RU9TgMwHPxi5yBwPWvX3Rf6FehM7S
MKKmoB99BUaCqaNIukva/goPkKzw2y2xzPNhHCFAiglO06fYhQkfCBaLaXfak71ZkkVotTpN
ZWv9+cwgjC9QwqVaTih6ca+snc0Ym3EROQuxaMfMKycVyk3q+tQLStLGPQxJgVkP3rGSvZs+
YJ1OUO52VATLE7nEVZEKBA8+pL8JQ4XNvrC3wSr7j/3YjL0jVoDkob+SLDk6vHoCldKnW2NK
gQBf0Ss2yY73kEvaWpUbwErfF3lzp5nnG8Qsdw9s9YHVjzTcPa4UXEmbITZ7AllCUhBWnry+
rzWIEp6jqy/XLspARb5CCH3UGHaRLv+CASarwbyTRD9lxKUIeFju1AnooGf9W8GnNxbZRR6V
fGqyAurqPR3fdXEHfXUVlXVfjUfKHP5ycH4sMAPdPE3DKJ2tXTP9vJe+Zgw7A/uLmAD+Dmwm
NpoNld4in1WXG7r2P+nVMDRMiAqPoA9ZbhIIReKvwBb0Fnma7tKODKzWpkAvnYPgJ1e6YLTA
WZ0qDYZTH818Ny7ASZHe4U/IvpwAjUY/wF0Bi5vmnh52k+uEyTRyuMIQiiALm9+ZlkDJ1ocD
ryvHOc13sQgoUPIYPh+Qz4wLVcY0QyKXEf/TwxSd/TAGWUexus09qZXwMlyEAYdJqftKTABN
jqm1YMcHmKa80fXmmFdsSjPlzhYAKi1NeKfpJSYGDbK8obradwODybkqlwTK5bH7iOaeIkVI
n1Zarhah9Hwa2sZKjClvgBU3v+uVU98QjSKQqRLxbAuaY8UEVicIatpcvtKxJ8i9gW1qTIvY
Wd5qSmSVXdUN31j+H8Z1oF+BiQg164LlDinAuLXpumn0r4jDJvGARDM/rnMHuZ3x6r9hkuDv
+Y76Sldu/kVqJmJEC9RSrkA+C+6IYEZ5TkLRwiq97XPfhAUqMeKoqfPh+9yjsveP+/e14yPz
xkoebLH9WD/fyJkASfDGedwHoh0n9l4yjWphylFbo1v4YQOQGvPNgc/RKFd7GRFiYGeZGWXW
3f+dw+R/78mfw3rBq3ZmIw1J7LrwgxcVDKBiZvtmwS/lqprsS5JYwZmsRu9lTh6JQ6WJ/5q6
GD+401puhwLHOdlLkK670CIg9xM56h16dZtTdUYdzEwAGmx4ms+ICPpnhDVJhMFtTSHV4tVT
UYXjjTjfzJIReN0sUFcAk3gLCUK9buSdJbLz2IUKHxayBj4W+J/4HtCvHGW7MGgz1gvFkMTV
PVgGumSf3Ob9JGbfpjQv71k9G5voywijCJUXX82Mt/gtOGGTGo+QnuT0ibxxnRqfJ5Acoa7W
MtI62Btkxjo66IU7BegZjMP6i73FcXSDD8bJEl2ZgbMB3g7x8Yipd8gz3AJu5oQ/Wl6tTko5
u4j+yWhO+i824fQA1fXMH1dBbY8hPRtQviSypPyRIlmFZ8kIt0X+IOuJxGQyeBJ8/Q9ZrfB+
3QK2H/HSA9aShtucaym1bcmwLHQ2uddZqKJgNdV7O4OuQjU3dhYLmcWLJIm3wZRJRaL7E6Lw
LttySlZcar0dUnp3wju1IkyKjDAlLVXGEdIPpZrm0E3PAKMc36M/Y+pdGePR8FIoMSqRpTe9
pfKMagZN2pPxk0or+WUjMTmwSpMlUNz3E+RPQu7KrqTCVI9BJefZHOXnBrqPKy9//sq8IAT0
baaNTZOwJekGDFwKjud74GLdKy2d04nt7XUW3Y6z1vI94SRi2xTMamC384xv78kJ4wD5weTv
GU46P8XgKS/AoU9R82uAbd5LcTTK0BVC5q+0tNIRj9dsNuZN3AQXhrEk0OYIkW2hPm7v6l97
jd26OjTnkRaY5opq50r7LEynABbDSPzeKt7/odM0qddJbU2BURAtNwExEFmy7kTBOXHjb6a4
DW5mU3juOdnYhQygEiDqJ0JHs6GJdgS5F7j9+jiaTo7ZKHNQhcExql+V5eeebw5uYDeG5q0i
Q9g0aNEE5EI5lbY8UDeZ1almqCZWCr/CHph9jQyHa91ALW5gccNX6uxxAy1S6aBrtxDIeUO1
7LmGlnqN5VjPsDhAefRBe1oieLFKP98QcF/QkG1WEnwC8p3jB7hy7QRy/y5h6sepsRkd6eAv
S6o0DUBWSLXQ1NljskApUA7H0lOOlmt/O8Z07yF2iq26RrOIGTwYFoE8U1eiywbMPxo0DmJ6
WqzLNb6CoFRArO0b2oUCv+rAgKwLXPfXXwmkSXUPhJWZMpwVEFn7HNMOImcWtGkqor3B4Rzz
PIU8tGFKy1L+j4kcxyU2yk7g70/8p5e/hHbEqtAvbZEONbKJyN4dsx2NCaG3n5Y/xx5TrYHT
GIXXMAvybrzkczsGkEm7wMGhRXmlFTqoE/r1MIFX41MFMP0T4BmGfwYXfd+qLacbA0PRs0fB
qPrB673ylCcc77MaUr52FzmuaugBrHdlGz/0ldDRjP4rh2ymOL9ks67PaEVO5L8QpThJ4W0/
SBST9oKPChsyGi4A8gvk+xVpyV+tPEwAO6oVOV0jolNqlcaBNVRmJKxFEuqN4Qg5kFW9GpSs
IweGeNcScnGbBxb8i1XHhWeES1MQHbWQf/iTZRztG3NYWDMm9psERWRNopESW/esFF46POWB
1c8M7cg0aLyoyaVQvnubE086upNVy3kcpPj3j51YKbsLqnwkl27g0mqCfr1hcSXvTmbv/ZtI
9Ru8LMOH0ANv05ymOkHGsvrdB2bsKrJWq9v+ouiJ3+9gqV2L4A7fSZgYhdsihVItxhfk7i0C
83lpwe6gc+nLi9R2hDvNeVR3jCzOSRy4RNWdiTEqNtVu1Ddg8JzDrPg78Qh/pHYoBG+ARBLi
eewlj6WfxvcRhf1z/BcTIynmSEZvesBSjxvdKLTUHHDUnx/DXj44KhuTpe798unj1S4c2tZj
21GDMxLIn9CfSC9tFRoU1uUpoBiVKja67MrqjgRQQr7JiM+XpQRIHedB3BCgQDtUgEq2o2nM
K69DhNwJlATqXWdnY8o/7/OOC0vPJtL3T7EPK4BeAqGz/SnE7vWgEL1ZqehD9+Quue0F0GHf
PBC7xG3wno4XdB0xuc1XOamk+yqcgt+3k7HgKXS+mrAO51hTmjvFB44T0iA+KDU1kooYDLGR
jqHqjv/A8rkCUypsWdKtpSeFMTskCPUMqL/BI794KzuxdeDTXdF7WgAf58iXyfodsXLSb1bp
7/cQVqACchEGlv3byn6sheX23yMDstnIvT0qHzoHzecLwojwjs61Zc83JUh4ZlUApy4VKi1I
RTN3wF9418XUtnkMzRxiAb2VkrMjgVB2BCjdoLBKe2cBHoFX3v5nz5Po+aSmtgI6chQUFaGH
LCYLWAElylZLqCAZfiaRioG0MOCAlJvhgWsXF5prLpIDYusw7JHDDw5hFTOdyR8LxNJlcN8o
wNN2QDh7JAI8HW6HUbtoQZ8cXHTVh75y4utGVDM0qEM027LvS1gBOES0ksKtcGc2usCOah+k
J+5XmhyNtnBqSfEGQ+sf1esdMvHynb2nUVNKUMx8Oabe1FHQjrIaXafm4tJwHS8CDRKD1SRV
NPZnEBmmV4NHYxRTNn+uAj9/fV/9KOIsGL7bfZ3f4Q1rExZtqoxFyu0ZksvlycllArbtZETB
sZkFYGt7BmgPsLgw69j0HBG/vppUqDE4r6fMick3bUIlu7+UA9jTrJotwuEJf0RXINguRy5X
VIwjOcCOGy4SkNE4kZ0G9Mr/ZBJFJ7xd48eEXJlXNc+n0Ph55RG8CchUs0RvG+5+JOlL9Xpl
oeVZAMXm7GM+/HahYIFt8ZqezZCKucUR+p1w2gTVWAMcYhnBIFqdm7qSdZT19lrfh720U/d5
pHNxWaDfMeZKmgElJTtyrcPJiHtrCAw7auvI6YWv35HA4hu0WPn2XBxCcYxKHnHZ//RKOFGR
UvQVRnQ8mWZdtg2BfYQ8KJ0VX7eQ0CMF+sZvslnwTbg69Kll8DpO2U+iemAvywrcVfxGrOqN
t19CgnkAIM6sP50oRF4s47tSVhylCG2jEAbHlMzIR5zaHMGx3HFXHrOcIO88K5ch2UeoB2L+
LxF8+QU+16q6Ro0MC4GO19FA4FPcM795NIinhLFq+Y0IPw+GOBUgp6XV9h5vLcFRZFa3wQH9
6rQ9qZclKRIkGmjRE5894GE0km0YWnQK7VG1CcDRervAt6v8FyTfDdgCksVoYALODsY/6JkD
wnZOyf+xhK60uusjb6rNR0522R6T+bLMZGtbHMSHfXUwfXkPvD5M7a3MovqjUkSWQH7gXu3A
OGCbzO0mB3dyY9VbR3n/LbNv/bXs2NTbV5GZ9QD7gGNf0PNw4NcCk7OeQQXiedtn9h15MSp2
Lo5oJE9AW088cXQa9H/hPUOvhZHBEh/WUb52ywTKh9DlGbzd4fvcJcPSsCEnRpLX4Ys2NEmg
XwZXBvZSqoGTIGxY0zQERLBhBLI6426CXPjcwcp5CjciKP+zvah4l1E/dB3GYKh1Cox6Hy11
7wMleihPqHq74uk1cdaV08n2t3+tiBPF8Wg5ENq01KFwcEvd4Ec/tmyIPtVydL13c4BeXute
yq+UBvf0uw2I67+5jXp1eC3ZVrvr6Hn2jFIAkPhq72GC93RbwW0dVih+h9SRkQNJLLL4W+OA
I9tEyMqKe2/oW5/hD7iTCFKNWpSRI90BhtBb3qRBWDqnN0bDgYfigEdv30qiU6u3xMh2RENU
i7MHhNgOa9UqypfTS4qAqs5lyXsXrCvfe5Jnhot9c8jWDVSmlTDElKehMoeB8AGVRAPkCOHj
tL3fOLkJSA0x/aH8vlSBRirk/fCrPaewrtTj4X0TmOUsztTC88MElbjs7UDjAbpAIqoPIw+T
GGi18twlhsN41AtVh6+SJBjb9CP9y5qdr4Z1t5EztDQLiG28y39l4Wci6p0g5tOCSrxPoUmr
buj2/5TeA4t8luO6ZVCRbRR8E/pVawH2WXM5tDpKIxZt1onEfBf9mpoTR0mglgxhRFayTbZy
2JydkXHP9ux3iILTrX5eeI5GpxqV0Xr66HBasN1/L+o4S4xYOAD4qMjyxoW/LgcttUgOj3b1
p/9CxHVQ4K2HgSvn5hLFgMLovfu9zan1Tu5GeXYSieKrcKw3Cjzzsdd6rrpCHhaT2bG9MxFV
eQIT4B37qShhNi1oqj0N9YhfvEWJbHQxOZnb5DhcC3LS9OqEBOCT49/TzKuGrSakejTfXBbA
F2Z9AGUlBHIYk8GD4B2p0gKzn8x02bcJklKPPrXucX7Z48fT9I/6hlsaCNiQyOUZb5MM+wy6
SjxQCJ7G31rkzwp2jwHjDVQpC23uLBABqj3s007wiA4A2a4Psi7qxhWIAnDDpiwifypcSRWW
q1S7WJaVbTYtO9mGC2M9LRjl1GH5eU76WgC0W117wezsw/Iaa9f+c4FDlfF8Xib1ymFsnIsU
BHFNfWiDkM+wIGNiR4Rsvc/7CL6P0lcvNo/5Yz37NsVMV3d5qrB2NHlEZrxjSlVASPjtvjjK
t3X2BLQwzCJJ5le2IpWjvau7KxE+8VtM3KMd4biZcLou4tJZmnwSmp9sLp1A77az+lai6NZp
zvV9oAuTXSrqmBGpHTWFbKE6u0cZtir/pZ2/lcZ3gUcI7g36ft4ra4DuWlgX/MgSeR9Q7I+n
YE8hUczsBPOa1gjGeg4LsK6C6DjVGtetK2iX0pDNYz3R/u0iJZGz5oxmzPvDAZrbsjgy1XuZ
nUtT4LVIfQ4/7niLEJjaU3ATA5o8Ov9LgZDYrhHOoPWrqUBmbKs5zSH2HMP8Ke4f21g6+MID
lqUtyofnuAHPNpzJkScyMLXRwAP5eSfp641GK+gmILCE0DVrQcIVNzDhNrwu1Nhc+CM3rTe+
bPKmCHX4E5ir7vuVe9M0SrfbbNlCezgVsTV6dO3pF53GEIwRbHKClBMxPTjQb0yqeJjjb1Kb
6sbmDCx+85XA9Lw8+SiyJRXIVRXpSzmyyq3DpBEOJAAEqzmDTjqUd0f2CJ8udlpemxnYYcYt
Qv1/qaVYDRn8RhCKQCxihxcv05LJWtWsbGlqgOs+uSQwR/gG0mPXgS3OL5ihRH51N7zJJR+7
h+ZUUez5XA74kyjosBS0ywBvmpdHfYIdMYlSpRQoSW3kcEA2YtvbFFbfanvVrOJhGHYq33v3
wNS9SMkLV3okzDybBTJk8vNwBvAzlmLzu5yoFBKIUetA49jlgzP6/k8nPoVUtbbMcN1x99Ul
CQT1R3nPLL3O9Df+9pXPg1/O8lMxb5mLUEzDWP/2rnGrEckak72RE99JiarYiVWUwRU66w1z
KI/AUa10UCAausrvXlqEUegvU8H5np9Pmh5yC4BLks5U5acpuUoqePVr6dmOL6UWX8AV1d1x
K1+hS8LH+Smww+TM3/lKvkls/DZckNOHMA6YZab+Q9w65GciJXskHX/tkokAzR//mqcD880B
aYJgjfrWpaVkAuXNrMhxnZjghTJmMmIQWtZWFyn1X2LhTt4o5VvmI+U8O9QThzKQ+UYW2nMv
AOshtIxuw35RoHUOmwK8q1XujQrCl7Vx1J7OfMq7RkwRSRSii9hPkzbw8JgrEigopvUuXa21
Uk17LI8smp7bTC9UD4nN181tqDBvhknacg08Q4Evzn1dGfz9tHzFHjo8VhzIBUyxS0+GlZh4
JuszzjHsF6GBhVxpIdPswOt2+kdHYuZgwWx5dc8+jlRPYmommMvGQIx4XKy1YdXlAr7DPT3u
x4OOGoVnFPTO46WT9XuFTVd8ur9aXXK4Ew+KPgE45hwRPSfkl5w4KYPY5GI7J9nqsgn5GeAi
IYqyS2X82tmgmVOp1adm8xMLcz7DS3VPeEcU5IkdHqxQU/DoNLieJKSwL6AxDEr5e4kTGUA5
w+esnS/nlIVAaRv34hFjdQyh+GTkb8i323OMXb0jole71K+dmkp7Vc6Ut+Jjqdi1RXlCnTpF
eM8yLtJIREwDzDvO8NBdxsRVLwCjHAobBwQHZVh+P1JI7t2rek7NbL7fW5sL3JcTQl5xYVda
E15nHLVw93W8UrfZnLlE0Ijxa9L3xRUFgLTgUqZtKtmQ2xY92rNhaMlX7vOU8xn18/KyCfjV
IpKBwT1FgIJD5aODjQJywI3MRT+8n1MAvU+bOQce7SaOyU5iFvyLveuubuoeDqo4r1P77U0B
mwHnvPNHsTKXxa+/LVjs1VGrOiuRVHHZ5to4ziUgoeCzRETA8Uunvsn09KkeXBTtIjc/kk0Y
isqhiJNhYevjg7ADpq7OUGn9aBlQsjpVxKDVOcFYd/kgyz/L71Uh3skOn1gVmYjgrIMqTPI6
i4G5uGDgEo3SsegOXBid5HElN2qGltSlwrdkvtAsNDdEn0NcgP3eG2mHaobN1DqxmEdSbfk3
FKW6E+CDniBIzqxVGrSNqnStw98q55OorQZElvl2NHqvkA0pV31MiyqxEv33u8F/BmRFOjxa
q2DnFfyFbLB92Cd7LCb4iQj7KNlVjLcJBqD6xoC6YUDafht9ATN0XSUOvfd5aigz1YLgYmkQ
YNLK46PwFoYTi/cEsDZ85EBNNS9Hc+22MMwXErwou/eZQA2+hDlZSI1YjMDq+kB0okAYbaIr
6EffdSIaAqyo9HKGEHlhWfm8VoL8/eMe5WbafE7eyJXeutXF3ay2KsRA2Fdamtuf6l2+lwkN
eAdiZkUBW11uTP/Hjb5hCoH2dbkMe//JPDgmJ0g2L4y7viWVfXkk9AE6bTt1mlwrlMWGgZE9
ZJVvg4tZ14PmUwrghv96D/anMNGryCum7V36OOcPa6MuyYitko0+S2IUJOHjRwCh1xQccOC+
IrJDbR5UizAZtdc/jX1S1A9Z4+vmkdIgp7tQkFS1JOi2553hbhzb80kKoB1uLpk02/5/iduq
rHme8gJr3JtS1k0pysqL15ff0xQFwUWK3wqIwdJ4YuqG4mQyiOhqdRTSclSQDjsFc6mndTO4
CXeZbL3/KVzGEsT+3A37JAbEIQWPWIHTA/Ss38kzhmpg4mZEuJYCBUx0rSp4jWETnt0eV2vq
Cpj8cpNEZ3JQq2dZxpXtf8kRzoR8CQTE3VMOFpLq7EogAFjImBz0YDaXO68Z2KVwQumxbumt
trkSzLAWoEHXorZavVAq4zFg166+6wMRRP0JPNA5G4uyHcvNGkmf/TkXp2nzxlzIq3LGAfAh
q3Ajo3iCBC/GgMeTATNP9Fyp1UkNjFRnPhvjyZH5uSjfif9DjunL7ogYNkg8mRmc4PcO9gAW
vlTCR2rVdy+cJINda4hGvhJDuIM5gRNK8xUTLs7eGVKbaap4AIKFQkWs7ciMj5AiL8v/GWjk
FjmpNMSXSNwxc9yjiVejCM5ABOjH1eyyPPeooBTCaN3mLOeJ/DIKKecsK3d/W4pKG4k+95tF
DxyxFydwewniAAkNsAK6TcvAw+bbu9cQdw9hERmKN4BkNHJRoCe0dFlJVQnugFZ/601lVRWs
ymIPftWcRXhEQ1R+fE3ocT9GELAAGyZ9fQQDCCpLejBunpQINZMCAX9ZrWi/rgxIM/Ril/V8
3XCSKhMmecVnl6/ZpPWTdaC2S6SReq//xMmJAREydruE8gHDhTSZmpQdojhiB0lMUlhQArra
YHWmWPrbTfUEZxgPQh/Ybwb77k4lSfs8D8/6V/O96F27NGDe+JNtpoFU3tPxf/JM7cjtAs2b
SI1GFc73J/bYr6r60H6FW8DOjfZLcL66VvJljlm43myHu6Ldor/n1Lj2RfdzDr+fhsCOnj6G
wMO7XSpEVNjqArk9v36auBNDBM6EMlIb4+gFVown2rqWcM925a5vBqiz8Rb0keTB6tMi/jo5
n5Us7UB7zGjByEQRkC9/Fzn+1zej2JwuZs3kPq4UGGE+PuAYR5uDOPWzaFepgvmBQfPlWBD2
gr39FKWo3KFLbWQYv+E9ZP73ZqfbalFQs0utAnbPXQ4uJ5A1ukzeSkPdnVDFLVTY2AW8hWm2
6MOMUT96AprlYN98KKdBtPgRxVcIQi69RLCHnitLGZpuN6o7Wmj+nOtW6oR46KM+J6n19ViD
flQr1VXQ1rnNsVp00Rt94xsoTMiuFIk3eBKHw6P85MP9/rJeiANt/VaB8GvGcJ7MA8ZfIsno
snr5HjiQSfqkBTmP0enxD7m+bc8USnbxJg45q4EcE1SGQkN7jlaTBlkRqb6QHV8Xf43xkhpD
Ya0BUMs6j4rBg8vVs+8vcqGNl+7yQxYwHS1ouMEpgNeXp31YH/6T5QuxoMSPmTA6yeH8DDo2
jhaecuWs87aS1YEKvGAgEBOCp92Y2GHLwocpnAoWfNwr824kXfusxWR99FxOP7SecJ4nyIgU
S+yRHUT1/e6q7ljxMt5wkDNogHU4oY88tJHqAT8lHjgY/PgJLKwLNX2F8dJOjihnBcBqiKIG
fkRqfIT0UwCZnU9czWidZNtUPrC3cMn1ibaQexHed7zxhVzBWhOyqjYtNDmZWqnzts7/CEV+
HqcMd2xcZeepQJVATYW3wT0Oa3Y5lqNq0ETUx51XMuWzh5y+sYXXFanuLnaL7xOGoOerY+gl
kbEr3HwL50YCEvCdyOtMX1ipr63vlrIT4s0iKOjWUKWCrJWtTzuWN9GNyPuLqHsSuaHDy6BZ
pW5KGvt5iDyd8Y2EnGGab6KFLwiTOqt7LFokHZGwXeVBAN/iSO5C0k4Cdm5SAlJImiagYMA0
3YaEcGYc1Hu1XemLlmk5NsDtYLRf8WVim6OnUHFQEMtGUeCiorBoan6NipR7ucO00QlQrPv3
cZVrD6cMrZr7AN9Oe1bnF7+0jQT4RiCl3SItGCiVOB8EOowUkZQLVQ6uA90j2rrK+4SYGH5N
hKISl6lozIiY4NJHolVl0fcp5lPFcP1pVYNjVbxhGcIAY5HOQ26JKn2DFT9pb5o9OeyFB3UB
T9Q6pqZObH0zipwflJR1Pa7+0xchoVepwgGx78xZUcE8aCApe2yXZJFFJXHhhzriYVrlscf2
WLHMa07cUUmEyj5GMyM+cChKYPlVPf74KyCoPEOXz/wM+juDa6ybsFAhzNj4fMU3kD6yEfmG
V8xMYCv/LVLlJzRkN2f6vGkrY807hvWXvDoWZS0QG38qUVw0QwQRDBnQA6QEb1EmQTKRo7Rb
KganUxiWSsYv3l6gQUEJL09C6SnSAo7vCWuWbPLTZhoqOI9esWyudEug3FnZjtS3xW+7JF6x
RAOZ6NoxDSxbdTM1UwGfTpw7BbMmveMID6CaOefduOf3n45bKABzjYXjT+YWNQsZTxlq/97A
HznxsA+bEXB0VM6zFyjpiFSaBTPe0Q+hFgZ1Wg1818XVRByYwif7eOMQA6kE6QZ6cZWXS1UJ
DdaH9spUQkvQIcg36/JUl5zM3Ppe7mxPJmHIszjUkcA0OkrCbjhe1UQ1Nq9pZVQGgiFhastD
VYIcrYTSLxyhwkTlnLPIl162pWhNmNsi5u45urkn5s55PTF1lEDMz3t6k6rzWlEzT3uwiGJ+
j1SLzWVdnHvfsWg357WDwI1tk/XPzJmfm67swwk7YCy3owl+kKO+2vPRY9EiwszQGfuCw9IU
VyvhL8XOqJpUpNLsMrxa6vhzLBnkZj0g0K1vEE5nCdDjiAUxkmYMNakc/R6XEJjwUZvJ21H1
7TgvSnV5u5gaH+Ncwh6NL4oDCT9smWEwArF8NjGzA9syh3BM0UwlbeM6VbyVsMd9k1zpf1OA
12uT+tB+4hlMGQT688RH8JU91BoWJn2fREEuCyJ/2A4nXcyKV5v8BH0Bi0Uu5mIp5dFYNKtb
sOjctxPwLWuhZ4dudrnY6DtTBMq1Pr/JdqAisdqUFRTuoZHeyNG0LxJVyd3g7tKAEVDbruNh
hmMlnQqbBlZAslYThpQmfTo2l912Jd1WkspGAU8KZW+kE8Jw0opvfNSHjT/oe0vQ1AxLG2T8
+oeG1H9Ceobfe58ZQq46uxhcc5zWq+bpA41byg2KJc7Dn25Ml/15Fi30HxHQ68VnX1NNTxsY
J9inl506H7C4iiHKOK3JmtJ8SB+Ijs2E4lBL05ZHRBCgakNaW+t6j07ACMNEf3jFaQpekFqx
22WWLZMNtIhp5/zRuf48RqQygCW8WYvE7j8qvztiq1RDcgBydp27l9QCiCYSwko1qgJZDQjW
A37kqYJun8ka60mXlTj4tRLNGQyu0yZEKV2x3wmO9grWvaRFhU2ws7BpbGmcs8aCakHTXcOl
u8bNVskBiCg58BgbCZB5jeOXyx6JjHxJiKIim6EiaXKiabLVKWmOKSLltavgwOIxVFRU0Qlc
0fH/swMaL23LYpEMtgwbv2dkqfNsstne/smLSRW/xjV1L3Ku0x8c4pvqEgf0n6WiUSrQeGRY
o2KmftxEtKnEoLzyIrReI92k7+43nxpIa9D1r2/6kuBo7Mc83WJtl5LWJGIWphxw7N1y+vV0
qHYkdIba3HoEMy9SOSHSRBcnng2F0TBoh6dWJzCEYqk6WQd+wmgoRjTWTOr+evQlufypGcdU
yDdJmGk4dhp83Tz+ECNWQ356PC1HMCsGs48nhYl3T3s2cExhw8uZ+qxx8LsB+lBo6w2W1Uja
pSjraipcal6J4e7HRfN6taXYqMOuTRga4jwj6oOJTx1cgz3mLyBeujocsuZT3ekOpoihcr8b
A45qql1g3Ci3+hbo+PPmnEkxYR1twvieAQa6wEnxWyECOSFq0MsoUGqCCr2iXi/rs39lTmFP
fCivqWxRJJOpj2QKaZt+9sFZY500f12NuxYt77RsTVDBRWiZ9fsOLsM7wPx3hYCyYMwMaDCf
JvawfuVmkP5F8AXYLcIobESgFos9dHsDjIXRENZCR/HCe8LNUYRGlYU/FVWGw1LfQnI6q8ff
GzTAsPgpFqq92oJKqm1BHXS+v8NaNBAm2Wf8NcAimF9X54a7ds84392KbNKtIsezZfq+gqkJ
3Qdrwq7BivI5WBjJ3IeevyMsbr4bsl94X74UDF0+oJNcokUEbKvpApM3rhJsQPQiZ2hmrlUS
H40dVgMWiEPkhDmcilNYPWanjGPWbwd3uJ+0dkdM8S0Hv9epBrdpqLbGISP+DLL3OfVHzOgu
7ED1WTw+bWs7XJp4ZkHDrQCL8RXDggWtZxwgVEQuDgLGK8y268Wq9hhje0jDWs6Xp32vUiet
t+afU1PE6wvirXjVPmtImUkpZi2SGVoUpJIyJ7vMYL0C9+P0O8thIWfbjlOvghNqdgk1djjg
Bo4aBk5coAPfIlc7NENGped5QigrhQR6rS7ykshIFv6H2ZfqIU/T0K2JWmKYXPV9iSzHviI+
68uUO0RltwBchWzmpd0gKnpfjr2qpZjiLB75Vo5ljA+Qze/t37Z5+TlbCvEunfUNXvwkp1qx
SBsNGoN0Uhkq2BC6SoAUF6EhucBuDIheSYM7zfKhcebk9IqVKeHbtg99eaXKDjNvvtPJpjuj
P0/CgF7WZ6mv00v9PaHXsjd6KegntIyNkNS95kPKaG0jcupFgw5wqZV4fpC7xEy1AKXeCzf4
eSo+secsvyrE/LPl0hsb8675hxtgMJYRPQOVqM79hvJ+XfqCO4/RXeR3t2F9WdUHKWxeaKLT
wM7GvjhPVALPLgc+jmfQdTqWPLWZGRprvJhpc38OsR1yXtlGHEAWVhSr0PiZ2bce/5d4a1k8
cEsbZZKCYgClu36WeUTtiHf+o9SDk84R6d1tYwXP6s0ECZyT3+PkylHzCssYO9ANYbkVdptM
+sRzD9Ynk3rCKwvQZGu8zdNsbrx3CMMmqw/gxK5pJDvemW+/2sqKeH/sWSkZNsVYLWeJGu94
D5jA1Hay+sm9F3XQGfmIHBy5gThg7Q4Mct/4kvcu5eaBK4kWLORqlsZWTTvZzvvT97jaY+zp
W5SV2u1qeQFNwFdvcG/oi9kyDc3J6BtEy4f+fdtaC0UUuRMk5vaQxMy6uK+oycowhD67LnIT
ApsaTGzoK+CnHHNEZtA2gmPJoWVhZzVG/i2eOKysaQO2YXCD5esv9OLIW47k6fKvmunrGCxA
QimwyiPI6+gla5GQeMFMka9tmb9Hazn/y2Y7T83IfUE0lIc8Q2yiNDt1OOSLGajvRWYEnFXe
nDz0C7Ncw7URWR1nSSol9ic2GHweYEdEtuXePTFnaC8ortrbm2lH9jQ6cdxUnzkWcG6i02wi
ozjHtdc3XYRi0GZ4p4F9hYf3zCgCabCKUIjr0grHboU/KUu7HWP/mO2UqXgmm1Sz1RH2jbQK
O/5HSR8SDONCbaPOuGjHZj6Yi+/AftEVPgczt+kCJzrlDraIIwXJURMZ2ikbUnB7pQBIfJBW
d6l5pGh7QyWFE8fFHDr6vdLrHyXjTwtyo6sK7ZKLW87jc4lZUn6QGR63u7p6DToZ+1ZVId/H
rSjX1I6JiX4vg2YqInWUYuc93oYvLry4EQyyyMyogICaYFDA96cf0xeqx8iWvOhXWhORSQKo
xIfLpyLCLCAqzXMJ8DpQ+7clew+qMgSmlg9zXx7eVU9JZ+Xyz0ip9GqTS3sxbnygWx+kiEoD
TkWnnLVOvUPEVOXMa6FR4t2F2d3Px2hbk+gkdQYxYnV5gQ1YyXY35QESJsOYGEhLfgzwu3gN
jZ5G5APIKw3x8srcRhW6epuYwjks+CucRaKSNXz50cu8DaRQTMqeBjk2OGc5W2yDm958CQT1
9KYU+OAM2XkSN6klo+OApO9OazUmVDlmGL91V5EYST0d8Mrxxu+DNs7f60SujByY9Qqt0kpW
xVhRH+MaHEEz1R435MxzLGmF21ae14FfMTicf0Io4Hni4/iTAYcNhTGb58WFDtCe7MAtRJMA
r1IUClTQoyIuapczkKHPl8+jJAzYvZKwmM63ek3BhclY631wq/u0FPKkNevN9YImbMKjwC+V
fcpR/o7CkSBPKi5Jd8CoRrdsV3OaUHvfTkvfHs+ZIKkteCJvQh29/rYz4kbXMD+fxPH/WTba
sFMg3UlNh0Dbnwp89OuoTNXN5iZwYyyM+ARCVY2MDIbZ9ut2fxR5rlX1Vf29OVWEqRWl90Jp
0ibQ6j00qY0VBOIi3BV4AQv0RqKqYQNfgUQgcmGwI8FJdnveakxpj9Br8mfNR7F0+TjvHZ5A
c+0/V9vjNiooqN2bJspDCU+9lBeExdlACQN2ehIWPlDPuxxd8CPWE1DSLzFP48BSIDdWV9uc
DzYPvdsk/wb9nMHkAxcrr5G4nlnN2wHohX9mQ3XK6BJT8h+G8YF7bcOn5ochaGQHNKgojHeS
ImPIN1tjNdWep9Ecj7FKKX0hNjkGOk0ogh3prSdqN/MaecTU99YShOLjt7TWleSwoN+Qkwmf
tT8qllninpDFqIt3PsywL+lwme5WE4ops+0lNxc7lN+pBiFaC8TocJyyE+2t1CKl+Ppgtphf
oS4heSZSCqjLsErMNJ5Y0ejadrrVHdrROUxZzXSLoUP1eGQ3oXPdsgs3ZjFgsKGjtvbZzw3F
KiP/p3odWe+qPKbj69+zO3llzP//LWeWvnuEvTW0KTopOIt3Pze31cAMuRXmujQgCmmYJkHZ
JjWuQLhwuFRrVr0pTrYB0cyAZHKLSN+TBeFP5Mli8u89NCJa/9rBNSIfp50+Kq+1hRSttpi7
AXh3f+ceyRMfE2BpolgCRVXM3Oi+a8TxnMtJv+D+7VXaLwhjBpix56WQf3lpxgJdN2e15Qp0
wLa7o861GC1XCfdCsbLFv6+MNiWNQML173Zcf2DffnkyRiUFuPHmG+A2NDHQNwbY3RI3Wrxf
5lgFxX0x1emYLy3EcVOGYZaMfR1OpZ40m2vZBayW8UBc+9Hu27RXeD4T9MYvGKh3xAPEmFWJ
SSXqvjCR/Fp6AZJMtvUFL80SQ7idrurPLJphuZysxhjpZ2gUmApGBtoZn5K8Bwyu3WIcpzZu
1bWAPDVWAytkRItAhqkhd0DcZM4tXpP9Uq3r/jsZWeeM0LELeggKz7VG33gKcn2z+hzKqF07
EE6zZi+kz+GJ2SY+e+kitSEGBqz+90QS6ye98Y87h3NRVGY74CvR1QM76jjmwcW4QQimDV++
pOtkruOhpeRRD7eANcqg4vxuFZWiC4hU0us42L9Fuif7MyNJUj/oM6FYqe7PHmaX7PHIR3kU
2C5FdW5GnjE/GjnBP13zLKPKyPyEF3z/T7ie6urdYaZprJP9BgZYAjIPRHNahbaOASKA2+sn
5xQ0PKBczpjcSOfRr97GxyAU6/CUuel8i3CA6vOiNP8PLUHYFReglHF01q2ARDI/yR/QMunr
aj/JIaWdzc+LNu8X/GdxqY5uz7U0NK51iSqpVSj/AeTmcWqkUaAMuJYmbvQjnbGcqnLtIxxd
Et6HOxaRqn05tRRPkago+MIWqDWy+DWY8HnGNavVFLTAhTxUqHK+9jfyuMZPCP9KG16iw/AN
3eg7rMeUtvowfKAlFo4I8z3lQlftWlwJJxzVK1ggSsG72DgUrz1shvDFmNSAimzJTTKnFhCc
NdLYEb0Hby2i+yG71fmUzwBRuk8PiqzsvkZgl0U1+LVFPu5Ia0RdW+aVWx90OUQJj+jlk6/6
zeHCcdOj9dRqEMzeHyAsNYAyGA8VfCBKNWBuE4qko2kXpWjkx49ctRlaMTCFfHlwYTqfiFcR
6b4/E6XrBhJpb88LdoJjP6OqPBZjTBXexGYrpUTxs5qt3vopLMUG09UfhxcxlmUJHWTDbrHV
nuQjzBygo/OUJVs5CCZpS+scP0pElbJHJ6wg7RxazQWzbm/r104B1O2zwl4BNs1mdjIor4Ca
/XUChUrQJ4BJehCHNu/NXurs1YHTsM8YACQWIw/7oAuq9Kp51QqChiHvME+8NIa2063aWEpp
5/UhgaH0hd/leiy6S2aeIF1iuSHv7K08khCDgCbS+8Cgo8guFfMzmcfxfOCv456OaJebtVKX
aUFMMRffbk9EGseEFnWQsIq0i8jVot3SqlMW04TbIbQEXLJIunB92fJFMhnrQXC7C9TnNqtl
u9dLs2v7SyjQeouOoSfF06VZMBbBDvx5kVGwhbSUmIk/Y/Xi8FSD2MyCUkf3kvJ9GgqdPiUb
/o9pgJt6xkOqOrSuPvitAPR+sxcoym5WqwN/dYKZ89zlzGEVvLCTOIS0uTq+UPIWbXQm8d3P
tNcFY3Rv+IqvSqJpQ1e6JI+zmSUA0IeJE9J+3J15VdOxMq7edxzQITMTguOlGBMJP0/CTCAe
43gHcN5RtYmb3016ox0ulAebaPVE27X35s2Oz0P9XtpLr9RjtgIx8FfyFRFuVD8eeqY3pkc2
/NBFmrHVMNS7ZshFFPV35nTNsU0IkkGjNTf8U0DTUAUqKrCP7tSdb5ncuz0zCPqBGGM+g/5n
PlFJZEtuqO4PKzKs6joatfhbX/hJMZV+O8LImyQTTH4TwqDYJqgkf59EvZR2kuX49sdVugqA
3Gkb5z7Wla4TJju3qhvYp1z36qPzoUKi8ndH/uzeCPiTWL6lnXEt23BAOe0+aJJGUVlA+Z9Q
WZ3vATNgLGA4r4fdphQpldCYwrW0xyvxIhl7shGLfo0lvk4Xt2Xys0at61Epc4eOdSAt7Q6s
7eUI8YY2w/AB0WKMrIzz6ipydveVpb8a8F2oPHTk/wqkHIMoolJcE2q3TYGFXgz1/7ipCaSe
Q1ciWrLQeQ0acksC4vrFHnCuB4077/ch/Ai+JVzwR5p5tsXcTBBSHbYqzaOPKL6FqhVdKG09
DEJqbqy4HT7Z6mkYA+bBzUw6oDD9Ju5u+77Pj0wZaJ7euS5fTmsyY70MmFRNdchMUcyZsJtq
Z9U8E4ueUFBrmNzN3+kQe79BBq7DlgQD1EdcrCvbsmOBhUMu2G+F2hcc7XA1wNF8z5xg/swS
TP+R1zC/wJvX0oklBbs27nq8Pyqoeoo8Wsh2ljZIekk/IPXiObQIiRRL3ZM6W6uqE8KExLE5
/EDtnuKLhqkMe8CgO6rlOKVFCCm2TV44d9w8VXHxmQnJjuj6Uu+Glj6OojV6nlFhc6/m+iaK
9V3fzwssjUsItyTMna25GCqdYflYqIm/zdMHvdr//cGBuNMjJkNShRpiVhobcjrqDcTcBmtt
1hsyC0QLE5pYeOyfFaajCK1ignqK9H8Z1cFUtO902n5drZvBGe2gZk96gmk94HZhd5vxmzKx
u3ZcT8rdl8+ikOVf1EazoTPhlQj3Yu/pHjWot44/t3pPFy/sVEL+5LpV8XxwbnzYkd0ikPwj
+iw/jTKtRh33W4KHoJvhV5Pw6nZyyMX2owozYS2eX2YAl482qm6iVh1ysCOvV+wC2JKZAQnv
sxsjjDR7pCJMuhwrC8u8dRGmb4bJbw3AjoEdcAPpVPCU+tXZrbZWkUnJ8MPiAKuXa6LMPfYT
lUU7ICug31I9RO3UsFrcNCmL4SJOJE9hqiklK4FRlzN5X2IU2zsRzrGRaNEwSueftUcBx5nG
CQvD/pk1lVPj5IGgdqwpZhf1a8xtOwLFtmpgE7mvCvO3ep9HC3C7+iSqKdBi+y0bQFJf4d1t
RWf11dil0ciE8EMOe6RALvq62oi2Nh3bLBNGyQ+iapGl14vhJUJZKo7DAIlm2G71n14usLIq
I+9LspTLu3Ri/tti8NYcHOCdjaMivDYjW12rHy+mv3QOKgSmRDHz0Vs9RYLpA40UCtOdajhj
mUnEwIQVeWAXZSs3/hswpINtkWPGQilNCu0Ux7OGGV3fkKQArY+U5zGqVIS53FlKalW6pSNM
ZaNKZR8pcvGfep0lFDD7yKYiwACKXk+L3e2eyjzvwgwZpmYlAtI4z+m5fqPLp5DOZn4FEm9N
Yl/iXHH0/3xpG3bpgfOWk0BhdUwBzjlFLcWKegLfE625gbHDyqknpC/k1L2Wv1aiw6oVo8bo
MF0U+8d8RXvg1uEynkhEtd/xDcOOPDjI6vvfo9xknWcOlMzy9/X2Hsjh63wp4SYMlY4J4sCw
sKhxwmeFeJU9PVXShO9KxufvET7RwrJsbz1o8A+1t+NO+6tqgIRarrkVH5Ai70ZMs10DaPNk
WGsLoyBIGzLxZ8TYx4cqNYI55Z755Yv6tjkGJofprvIoVkyn2tAZ7x/s176B+tMdOLhPLbkC
m3Hn2CMhnBA1AV6Ade2WHQ6xPD7jnnZ6gtfaOWi9dh6+E5a5ODHBvVh2xo6zRJpxC8XgkXdh
IzUInppg5mwc9b2DCzm80yZq3K5OhJ3qgzOriwcUHFXv0OqZpHv7k2Lj1voek4TYsb8AzYnb
ozeRdJ3pDFf8VlkQcbmXG//KGoijfZgbckRNJ56ekTlne4y+XnhGcMm/e57KnD9dJWkQoSaA
lJ6TH8WH2rxLVaTWqRRnFd6pDbmhoEMOxrmzwzbkbMeRVhB0cC9gtUCi2zsQ9x2kEc+ohAoZ
7+m1DSPJS4shLdj2AEAcM5oJkNqCmCLv3SZDk+Sh0j8fGqFJriU3SHYYgkgWMA5loY3OpQvd
S2aiyysSWd6Xv5ly66cxfwhX6Li0cwbtZU/2BVwF7V4jXa4rDi81Spu0UJrfHURGFGRnUT5w
Z8bDnJbTvX+eUTNug8AS1MEqWxOH4uI+7yDfi7dccpReIKjCbRR1AjHf4CkLCIcbEhfGJSoq
woSAVLPl25nhjM3nnxp2zmBuA0ys3/FI98jESaE1CWwQysfnDHEkfIQ9cpWkwGHH7ToZlEjK
tINlvENHqYAP6BxZxNJjnoVJEoBVfYAoA+ugSPrWml8tNhyOYKCMKICc3Sf6TNicZE+MPeRG
ZM9PB7v2I8x700noRy1Gsa1Mq3Qnlply+BNeAsdejK4LvyC8KAeCCItOQ/oOOdEBE1OlwJrc
Pn0gryg92PlxNNrLp3f1DYU0SSsROBMPqJuGwLT0x5RAdyIjAe2pD28xFXTzuWqhpCjc/QkF
ctZtLMbujwYxeFmXhaOOu7dFTX3OOqwqAcfjo7IjMlxfsPpDui3lsB31VpdatB4mbzHjDhjA
YeS5LHe66xsTK4WFZNq+T9JgOI0yApTYMBmv0JDJhRZhrfzzztg1Y1hShpU7aku8TXOQmBZL
xoXqz+B80V6XMhlKsZXOwn9wZhIklzBxrKe4CRQ/Ke9lP27AnbUHDQ7oWtPQbOdANnsFKZ8B
Y36//0A6gKeSV3U//5QoTwVBFyqy5R/oprmwTdWQ8BZP7x6yX3m+Q5Ejz/MixQNmdPUWquZp
k6RlWM2ixezvWoLMI6MIaUGlEQO39bpJ6QDeRq3JxSy4WjcsONngpm/FhNN5yBd0TgTyBl0L
Tl9ggkkC1oHeuV6b3BzPaSDn8C6c+PUvXUwtnkAlYNoibKOECP+dLudMMyOLWMqB2gzRIHEt
mHXw+cqEDE8fyzLhLdyyIHC9lz533D3HeJgtChbkoS5NpnIXCYR6ehM9HFBuS2ydo0Kt9Cg4
4NEX2jqseM51QOzrkqn+6R65llaj0VMSYoga+bMlsxV79jyiUPXaMLMUTxYiTRSPj/ZYGEUI
O0UZemyNlN7JD5fcLYD9h2PDgV93zZ6BTb6XjMKsAEc+EV0HWxofhnHkQM547lSmp2B403vm
pF0JayDr4DvEBiBACg4Wwk/9biFZxWYasLv2rRGTYzP+WxuYtvVdO532UaWdIGX68E3VKPFM
e2brEt8rz9CID9Gwsd4QSs+Q+6yUXUww7BWBGAqH4QXF8C8PgrTShM/aBDAVaIbQ82NQoHVU
XhiRFFiql+lz0LR0l5y60Mdrv+2K/JBN7KRsOnc2cODQcCMAwkmGjKdLxguH11x0BnETjqHW
+nCcRwOFyDQkGmOysh9JHG5R6F/ZpQ4K1o182fSdL5S2oBYb3GUQQIoQyHUqmbZsJTWp5j92
+yW+cSkOUHrVFIT9qP5EO8kEn2U4hluzg4Fo7Lz8wk2HAwF31O4eUYlvH7kVWqBKDncknGwY
LxRwfDylDmdOwyPHbK4Ld99we7mCTe1WNNWwjm9/BPFn6d4sXduqsgJqVM0ObJs85yh2atu4
IoQzlae0z2U71kXh/UhS/9/XCiLW0sRfkjIwoyNgpvZzonAr2x1m/idXijg8wvKjWt26ig5H
ynyWcb71i6FU4W8RunDXXy/nh2k3azcAOKR1NU+8GtnGax1J1qb+b4B9Hm2lBNKBozsqkGxa
RpZdHv1+iG0aD6TcjIwT7GgejjklXHlRo/hUpNoVhUNg2UU/C0XiMZqt8Wmb1rxE9MJywgzZ
e+ZURGOBD41c7AyeNEaTATyjK6LHnc2JqTBwKfjqr6PyQPDP0VPF2MTa8zIgWbbiAP2j5DV7
eV96laGsT06S4urVXqn+MpUi4x1qeeh9axrmvu26m0RMRYyKeyJJcDzYPDsjfQt/26+v9etG
tCsOWbO9ueqaeE/G3zaHYYFe+A48UPUQXFngqSXzdyynQUqAz1RL7HV1eTOkbM8vuhT3F0he
dE8ic8b7EOwWB1/J3dnaeFWxiXfA2sVQWg9oxkbINzgPFLvc7OBPiSzaS6cH5hymV/LTiyEw
u1TZRSrSmReeJik70SxzFz6lvSWQTRQLm6lv/gZrHZa/ghNcnaH8QUuEXO5eQ5Zlu5aJ9iaS
vu3gQgt9noO6HB5BGjxazjM530+IeIHaZbKbnSOE+1LlCFLH+MIlw1mhWpTigpbGsJE3sfjo
Qe1fOTQipNTdNIfi0S9RxTgdOqdId4eSY+1pNVjNTLe76BGt+KzuyIbK2tArnKmYAT+nJ0yj
0kOvLzcxeN0jSrkOuI5Bizf1Pdn+bGvNtMmIlFrzT5AfumV0CbdEhaVcCR7lQ+BjCFWVvVQk
DBGjkN2vyweyP79bC0Pz4xhviT+P/2RSlpgxOiOQl2EnByBvRNv5Brnn9NDHv5Tb4IydcF7o
Cq545odlIK1O8vbnaXdAlfi+3psQ0OcHejSkP394rvEpNw37PKaCDMkHoA5BT14XdWCfngj9
AUwV9hMq+Xhbukm4VSkvnS47LJwH/JigsyAGKnKLCv5bcWQ7HAslzelSZkwibxu8AFUmFb9S
SRT0Vp9ZUfP84jEhXW+xOmyzzAZWR1MQVFNopHT3N4rflgv8Vvtw/4A/h3e7Of1QSIIsG4cZ
w2tY6CzRAhWiurVgIU+PQP05L9zUd+sNqPARLi5x2rHDrSK7bzW/M2p9qAYdH17TgQ2Xa5qE
djYnKX4pc6XZqtfZ7M0XOY1PxL5gCLNWGTCg6tfIPBpYYQX+DnOX9D4T7A/QPBRZVYDPbSXR
/VJ4VNZQroG71UxAqe/pEAsfHxt4bPvfxSPoLwSvGbMPmboE/wUBUEaVZrrc95zwJ0+dBuWc
iY2mA9dPWwp1jffHi01iBxHnOEW6pKnvFCI/bTBblIW/zV+EtKLEDzwfR/qF0G0bEeaqznDb
33YP2rjSlknuxFUI6DeXjPtvr9cp+GHIKfp4sGNZp3ulGU2aS5mo6V3kWeCcgwDQ25h0uoCE
kYLKLRm49JVnfrkHyUiqD22aN+ES2A/GYWwVizN5Ym8cRIrBTxI32DwByyEPrHY3SbGyZ0Fq
JcfUCKfgiLBqzRXd2n1LwZ/I6xtIhNTTkYc4UCe2xERryuckA1hJOpGRdjPqWA0/zFwbD7Le
v4M2W+rzXrv+E9sMsAREOZy2WoUfoB4/M8uu4ZnTgT8uYWEc7eFnzUCvls2ijN/0+34nTjWq
Hfj4FytJeLI5+Q5xlIYmVHm45fyXH5FreUvqqitwQUk3amvlpGJxKHs5zmSxeumZYmijCGHa
B4m49AwPoCPaDpWiyvOLBv7A0Mwb8J238plgetHCRYly2aKQkybWJv/QsBqZj3G6AkMwCPWP
dBYnfHI2wisbmJIO527pym1DjNpJWPemQQPqWfgBp/+zOPOzTYgWGIunq7MDw6rqR40KrGps
TCzXe6y/rda/dzUlsE3+lCm91DHsdR3ncaKiUG9GpQXvcHv70BYi3NGIDFD6bk5ipofJTAw9
VGju4CiT6+YP2VL18Fwu68P+hrpkJd9JZmmABIBRT2d0vN4hsDl9DVwayfELbfRTu3+P1vek
QJhB4BkyLxNTCokS1ixWAlbWFauTGqshrZMaXHK36G9xJmOtROb4V+tVEHN6DyxLifCceq3l
27sxYcNtCENaEjeybHmQ57A9F/I9K+BiK7EOh1Ij3ZWGvFf7p+czvqWPri2F+sTwXeqhNl9r
4seTu5AGDJi+VghTLJTEwFGvdYWwAGNOymZuCcVbeKr2sUynwzOmnzZVCh2TwoA3Ha42SQvC
1RS3c5yRedHbPsufk8lfk0P9w+cqPjK7TN7kXy4gpIHseLeg7MXdIauIAc0BoeLfOLz1p6Lz
k2AZ1B+5ZW3/wA1qLs2SYR3vJlNdXGpql4eWM6AS45JVSyZg5AOq8vxQEtP9PyrZEd6wAj/e
cycErO1Y08dHWt9YsWOoSlaGh8XQSVoPNs9Zw5UTaPtLbTygJ+ww620BiKMuNKWDBTjpUlVS
gMFbwWjvaRHOLt4YVR7ApHTxuDP3jVBfni7cmAGDZMMgVpfVN29Jc98a14RIk24MCv3nGurz
VNDkebVp0FHwVqozdmzPVDOrpsdkLuNYsywZa+8MK4wns+VO1LBxtqKGAWWACqikoUz76eZP
ze7zx383I+WHSpgi5zeWFJca+TM7tHSKgdTVwQJ5ZRJ/s3gGiNH5j0ay8bB8zhB7py6c/wnd
8vT5I7CDCwrrWxV070GldETbu19/L9IuWCR1pEU44Piwy4fUusDd+umXUvlVxGjMA2YuK9YQ
gKiAYng7atgD+IuvlgatfJoYyybBozPcV6KaBBzjeIaD11roY7BFN51yoYpXILujZoN99T47
RR5yROyl93aoRmppWehfoGcfaTzp6gFSyy4lKyAsy0dHVedSEh3thyNx3Qnn3RXOwgoHBmQx
kBjLdwZX/4SgDKieDqVA6/3fRrwetAIzGsmInlnUwpjmKaALh3+GqGnJnYibaLT1H1DVhsoo
pmOBegdcKQL1MDq1JTes4P28e3RMi5CZuDY5tmfRxgPjobW9FtoGumhLDoIW9dhRXtR9Gr7+
6z0EIIn07bqqEuld0ZayOhJ11iA/fqufzl6q2hAsBwF6QCdhNQHMYJNRaZd3P0VTsi12NIhf
5xt+kFk8wMxW8WzzS0OE6VMp+Ic+TRX+6Gl5vyT/2Ya9d1Ocpjy8npb01xOGcXkyS3dnpyCs
Aq53Kwqzy3YzLjH39evRMNz3yGvtsiksX3x29ovqgcwBjzjHKaZDvvHEeJjs7QFjM7GcEnY4
Q8GopZ4Sbm0PTdv6SrEZGMes6lQTSWvqYxDSFR2x1SIVl6F0ORBdG+cr22Qzudacs073laPc
5zXE1PHF6hnCsSYNnxUN60/r5VamJJTYb4ku9tm8+kGrkDBM37BMooqZsxW9A0cA4KqEdTBs
EiCC+O1DAvn0+akEPTLpHAMA/IiKcmpqWCHS8Sjdr1l+CFSwUr2a5LU3ip+fDAnSfwf6Npki
/Euwj28xT02zFTqhcTU3LxvGLl9s5SnpfR1r3F/uuVe3r7Uf9WNc02LrfSaFS3qUw2TssgHk
WNoPs9Q3233FZxiKxHMR/YsjPaK6lPtw2uTA1s8SbVHOhirfhDo7HyzC9kIIbascCWA6EdCP
AeFswRmXknX5pAnpa/4wiH1g40FyTnnEspIqIzRc+45asQV1Js4UHZoxJS+VwEQM5VXO4sA0
43RFM9woSC+4ChAwohmZoGxyoKlJK67QVkzVM2f/ssEHvcOiUo9Ip7+gLvdnFYuCMuxXyUp4
xjVwxSQR65bmPfF3AIAJ+nweGYBkp2+D5pbnkm1dJ1Jl7s/F40uhYE/nGZgzCd0PyxmCiy+K
D5+gCsWUnnNSTw166kNgl6xjl8wyVH+u6NGLsk92vI45T31MBkl+QcPJTrDeI9NX+Fr67e9F
LDF3ZnjAkCFETaUcJCfhS1wDGN9HlZxv3YlHRVW1HjHiuHkP9pLzEP8/XceaOKagvtlXq9lp
VI3pcTFnm5MiJDH5Yd+EUsonCvm9wpp1W2O/cGeBIAyDDN3RlhYNsTDGK5aNt7gjuze5Bt39
j814FLjGofsKXztXcpeAOHSdIiP1wQnIUIn5IpSrNgtaNPUrT5pU0+HH2Bv75pURA44Af70N
p++lGKEKobU9TEJC0+Mu4iM2JxwgkLIxCFZAqdlKS+Biy0wunUPUitFvVe5k5oexwL6xMIp8
T3mVdyDK++UjU2DVHEN52ExPO895zUuOwpgYOPnmXoQS/Z5V65+fUtIdTUtoesVvJsaEAE18
Lu9uaQezZnCdRrRoOABxLIX4v35SOX50pw8WoKxXGyV8W4hJcSZyg6S/VPxrMzYrgtMhp9Bo
E0lIucUwNhK2gU/qP9+UqHLF6XbiI0ma+YbaXoK1634PzUKLT6RJhkoU+Jbp1O3esFbm+bsS
Myf1ADNu6RRX2Cfv/oqBTg4476f/afBGB5lrffv/KDCv9dpyWQIQ2KjFMpYurgqTdHjAeKzy
dmkIumxNlAe80RJ5ATQTlZISk+DMMyqEPS/MVvsCWAVdoG+k8Cj2ORC/bbAnIDIQg8RZW55n
nwUBhpmOYrjmWRJM8YF1IAMlGac/MgSRFq27SE6IguqT/r9eru9umsiYbFBuAVRhqD693c4e
OTsokMgSZh0mRQWSBV9vqEQkI/cF5Oa0oZ2asCrZYfKN/1R2bNs/t6KJ1yFcsWkVQS0NAjvv
zMCdqksifBYqaE80biWf++4hOUK3/rF49eSIgeCUCjRiX1ry3hy0tMWSdFVwby+L2Q8DXc/w
M+eIGLWbzDBzprGEcWkSkEnRwkjbUbBGuhz7XdqEDB0Z+UsHaw4GLwzJMnWcBfy0QkJDJz3l
lUhqNr5Tr9/gRdUnUAPb7jrq4kmPB8j36CH15A/DriWtVwJZTBfOHfyUzxFMZxVBiZSs++7u
PBYSaKS5hLfQFQU5YjEa9daIe94DKz1djuqmsfwjsktmfQ8GsHV+s42V7OkbPSTVPwmwVGXv
s1mFBa0kzmg/aeiVsIp2kHXS8BBFd55acTulQ0is1Alr4MPm3azK1wkZbyCDt5iFfB+iKEfI
7434NY2GyZqrqneK/+pRhHpmAhm3auePzYjzeVzjHwrq88fD9LvOxKTx9PWbcbcBLgMjab+l
lZ6zTxpGSTbwijt2T1ncAQh/1YqqEOQuYiI5mAOC2+lq8eqHvOg/uQjSadhh1YlnlClVs++2
QjWuSOawFDhuvcKlJu8EC/s9Qzz9Y6i1bww26lBos9aKgMdEeZvhw9SSuKuYBjjP9e1IBCgN
UP+DiAHo0+K+OnqOYvcyUp2Wo81COORQlycPtBVAes8iC0njuuz2ULg3apM0qdYqi5ytij00
f+W60FhB8/2eqYPjRVVjfv5/MEqdn/v2wQHzjHziahTTRd6fT9fvj/y/gJNLmyEg5BtJGNis
mrxnfzSaKnF/qaBj8WE7ZJkOVhFbWTs8c3Lje5TjPsnOjF8xy1ZIOZ7FdM7Q7lVK5GA44Tn2
cfjoBad8/si1QKhA+hhzwRUgBtZuXM0JjYL9owbLt/L0bdA9lihB258r0HFg7jieDO30YzV8
jLbtHvLPOH71uoq5OivNKi9jBQMRJodaJmgcls7ZdFjDj8VGZdI9L9I7tCh0zKQy/LK+zFBu
f8cmX0UzcZ3UdZKf+JkfLutYcEKd6hWWbkLPmbzYbJrCzxR/0E9pIrlQ0WSmUMq6CF0GOwYj
EPCT/YyN0fwVz65vDKYWNo7o9RAOnUr4y5dgqomDkzcqneIK6bV1lUHiL8Jxuu4iJ5xFTvYI
m0btMUlxZtsfzxW/zqwiObmpVa7GQLVxUpu389HsEWqADoMrzLOWwo2CoaLJj3GnsNRhU3iw
Ugzr5UvSzBg618iudLTvvvGqzlMaZ6gvmzbI3OWVDBTXKH4vXq5W+m0R8YO+azEY/nyAAeda
MEFUdadlCxKrw2gsxx/uF68/KIu73vVDVWCKWdwoxXlxXAv+ipHCSiLIBsW5kAE6WklbuPz7
b5RjSl4q4DySrLRtdCLEr3J1xmHmua9FyEB3Fnqwt1GXZSJSrnrrfG/GpQwHy8gg2OVUQ6Qx
Xx/J+aArCA1dKLuPfUEpH8QI/I0mspgLTYRh+TBXsp3Sx/qjCY/HLNObBx+OqiKSujoyIaUK
8/mvHSHb1Ic7MjfvFLx8QvElvTU1BKbrlkyw0tCS/plwypvKqoknLkkdheY/XHo2znUV4Xut
vaLEmGJwrWBeEzTn1OQmd8z5uOST5FRjhvFJOgWVaUeWm1MVoIHEG//YlG8ZZ7p1k0KyxjoH
ueanCH7xezZyV/BP+8cHO5MgIwsCTpgBavsh/M+WZaukWaD+8rSLxzCrA844AKsrd8agNuUo
1wXiZaw0NW12ZNFw/fjmJc0vhfGBHUHJoI813ccNW3dW+IdUAbgIrFYTAwCb1cFa2Drrf551
/65UxFYxtSJuprBvTr8XoHDInO5vsbNiit3NGN/ur4JlNP03hHjZd0WGRNugujU5ju0JzzcF
P0nx5UiPh0yE6SI0Q2Z8AHXoqLqbZ7q3AAHE4AHu9wmxGhlYscRn+wIAAAAABFla

--BOKacYhQ+x31HxR3
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename=kernel-selftests

KERNEL SELFTESTS: linux_headers_dir is /usr/src/linux-headers-x86_64-rhel-8.3-kselftests-a0aa657b74904f1ffff77eeb194591f99311e33f
2021-06-03 13:15:12 ln -sf /usr/bin/clang
2021-06-03 13:15:12 ln -sf /usr/bin/llc
2021-06-03 13:15:12 sed -i s/default_timeout=45/default_timeout=300/ kselftest/runner.sh
2021-06-03 13:15:12 sed -i s/default_timeout=45/default_timeout=300/ /kselftests/kselftest/runner.sh
source /lkp/lkp/src/lib/tests/kernel-selftests-ext.sh
2021-06-03 13:15:12 /kselftests/run_kselftest.sh -c net/mptcp
TAP version 13
1..6
# selftests: net/mptcp: mptcp_connect.sh
# INFO: set ns3-60b8d5e0-vW4bi8 dev ns3eth2: ethtool -K  gro off
# INFO: set ns4-60b8d5e0-vW4bi8 dev ns4eth3: ethtool -K  gro off
# Created /tmp/tmp.MZihAkuxIV (size 3921948	/tmp/tmp.MZihAkuxIV) containing data sent by client
# Created /tmp/tmp.uoehaNIVCu (size 851996	/tmp/tmp.uoehaNIVCu) containing data sent by server
# New MPTCP socket can be blocked via sysctl		[ OK ]
# setsockopt(..., TCP_ULP, "mptcp", ...) blocked	[ OK ]
# INFO: validating network environment with pings
# INFO: Using loss of 0.43% delay 19 ms reorder 96% 8% with delay 4ms on ns3eth4
# ns1 MPTCP -> ns1 (10.0.1.1:10000      ) MPTCP	(duration    69ms) [ OK ]
# ns1 MPTCP -> ns1 (10.0.1.1:10001      ) TCP  	(duration    28ms) [ OK ]
# ns1 TCP   -> ns1 (10.0.1.1:10002      ) MPTCP	(duration    28ms) [ OK ]
# ns1 MPTCP -> ns1 (dead:beef:1::1:10003) MPTCP	(duration    70ms) [ OK ]
# ns1 MPTCP -> ns1 (dead:beef:1::1:10004) TCP  	(duration    28ms) [ OK ]
# ns1 TCP   -> ns1 (dead:beef:1::1:10005) MPTCP	(duration    29ms) [ OK ]
# ns1 MPTCP -> ns2 (10.0.1.2:10006      ) MPTCP	(duration    81ms) [ OK ]
# ns1 MPTCP -> ns2 (dead:beef:1::2:10007) MPTCP	(duration    48ms) [ OK ]
# ns1 MPTCP -> ns2 (10.0.2.1:10008      ) MPTCP	(duration    40ms) [ OK ]
# ns1 MPTCP -> ns2 (dead:beef:2::1:10009) MPTCP	(duration    47ms) [ OK ]
# ns1 MPTCP -> ns3 (10.0.2.2:10010      ) MPTCP	(duration   267ms) [ OK ]
# ns1 MPTCP -> ns3 (dead:beef:2::2:10011) MPTCP	(duration  1741ms) [ OK ]
# ns1 MPTCP -> ns3 (10.0.3.2:10012      ) MPTCP	(duration   226ms) [ OK ]
# ns1 MPTCP -> ns3 (dead:beef:3::2:10013) MPTCP	(duration   247ms) [ OK ]
# ns1 MPTCP -> ns4 (10.0.3.1:10014      ) MPTCP	(duration   889ms) [ OK ]
# ns1 MPTCP -> ns4 (dead:beef:3::1:10015) MPTCP	(duration  3348ms) [ OK ]
# ns2 MPTCP -> ns1 (10.0.1.1:10016      ) MPTCP	(duration    41ms) [ OK ]
# ns2 MPTCP -> ns1 (dead:beef:1::1:10017) MPTCP	(duration    46ms) [ OK ]
# ns2 MPTCP -> ns3 (10.0.2.2:10018      ) MPTCP	(duration   246ms) [ OK ]
# ns2 MPTCP -> ns3 (dead:beef:2::2:10019) MPTCP	(duration   246ms) [ OK ]
# ns2 MPTCP -> ns3 (10.0.3.2:10020      ) MPTCP	(duration   209ms) [ OK ]
# ns2 MPTCP -> ns3 (dead:beef:3::2:10021) MPTCP	(duration   247ms) [ OK ]
# ns2 MPTCP -> ns4 (10.0.3.1:10022      ) MPTCP	(duration  2255ms) [ OK ]
# ns2 MPTCP -> ns4 (dead:beef:3::1:10023) MPTCP	(duration   589ms) [ OK ]
# ns3 MPTCP -> ns1 (10.0.1.1:10024      ) MPTCP	(duration   207ms) [ OK ]
# ns3 MPTCP -> ns1 (dead:beef:1::1:10025) MPTCP	(duration   207ms) [ OK ]
# ns3 MPTCP -> ns2 (10.0.1.2:10026      ) MPTCP	(duration   189ms) [ OK ]
# ns3 MPTCP -> ns2 (dead:beef:1::2:10027) MPTCP	(duration   326ms) [ OK ]
# ns3 MPTCP -> ns2 (10.0.2.1:10028      ) MPTCP	(duration   189ms) [ OK ]
# ns3 MPTCP -> ns2 (dead:beef:2::1:10029) MPTCP	(duration   189ms) [ OK ]
# ns3 MPTCP -> ns4 (10.0.3.1:10030      ) MPTCP	(duration    54ms) [ OK ]
# ns3 MPTCP -> ns4 (dead:beef:3::1:10031) MPTCP	(duration    69ms) [ OK ]
# ns4 MPTCP -> ns1 (10.0.1.1:10032      ) MPTCP	(duration   190ms) [ OK ]
# ns4 MPTCP -> ns1 (dead:beef:1::1:10033) MPTCP	(duration   670ms) [ OK ]
# ns4 MPTCP -> ns2 (10.0.1.2:10034      ) MPTCP	(duration   297ms) [ OK ]
# ns4 MPTCP -> ns2 (dead:beef:1::2:10035) MPTCP	(duration   514ms) [ OK ]
# ns4 MPTCP -> ns2 (10.0.2.1:10036      ) MPTCP	(duration   209ms) [ OK ]
# ns4 MPTCP -> ns2 (dead:beef:2::1:10037) MPTCP	(duration   211ms) [ OK ]
# ns4 MPTCP -> ns3 (10.0.2.2:10038      ) MPTCP	(duration    43ms) [ OK ]
# ns4 MPTCP -> ns3 (dead:beef:2::2:10039) MPTCP	(duration    49ms) [ OK ]
# ns4 MPTCP -> ns3 (10.0.3.2:10040      ) MPTCP	(duration    44ms) [ OK ]
# ns4 MPTCP -> ns3 (dead:beef:3::2:10041) MPTCP	(duration    50ms) [ OK ]
# INFO: with peek mode: saveWithPeek
# ns1 MPTCP -> ns1 (10.0.1.1:10042      ) MPTCP	(duration    68ms) [ OK ]
# ns1 MPTCP -> ns1 (10.0.1.1:10043      ) TCP  	(duration    30ms) [ OK ]
# ns1 TCP   -> ns1 (10.0.1.1:10044      ) MPTCP	(duration    29ms) [ OK ]
# ns1 MPTCP -> ns1 (dead:beef:1::1:10045) MPTCP	(duration    68ms) [ OK ]
# ns1 MPTCP -> ns1 (dead:beef:1::1:10046) TCP  	(duration    31ms) [ OK ]
# ns1 TCP   -> ns1 (dead:beef:1::1:10047) MPTCP	(duration    28ms) [ OK ]
# INFO: with peek mode: saveAfterPeek
# ns1 MPTCP -> ns1 (10.0.1.1:10048      ) MPTCP	(duration    66ms) [ OK ]
# ns1 MPTCP -> ns1 (10.0.1.1:10049      ) TCP  	(duration    31ms) [ OK ]
# ns1 TCP   -> ns1 (10.0.1.1:10050      ) MPTCP	(duration    30ms) [ OK ]
# ns1 MPTCP -> ns1 (dead:beef:1::1:10051) MPTCP	(duration    68ms) [ OK ]
# ns1 MPTCP -> ns1 (dead:beef:1::1:10052) TCP  	(duration    30ms) [ OK ]
# ns1 TCP   -> ns1 (dead:beef:1::1:10053) MPTCP	(duration    30ms) [ OK ]
# Time: 29 seconds
ok 1 selftests: net/mptcp: mptcp_connect.sh
# selftests: net/mptcp: pm_netlink.sh
# defaults addr list                                 [ OK ]
# defaults limits                                    [ OK ]
# simple add/get addr                                [ OK ]
# dump addrs                                         [ OK ]
# simple del addr                                    [ OK ]
# dump addrs after del                               [ OK ]
# duplicate addr                                     [ OK ]
# id addr increment                                  [ OK ]
# hard addr limit                                    [ OK ]
# above hard addr limit                              [ OK ]
# id limit                                           [ OK ]
# flush addrs                                        [ OK ]
# rcv addrs above hard limit                         [ OK ]
# subflows above hard limit                          [ OK ]
# set limits                                         [ OK ]
# set ids                                            [ OK ]
# wrap-around ids                                    [ OK ]
ok 2 selftests: net/mptcp: pm_netlink.sh
# selftests: net/mptcp: mptcp_join.sh
# Created /tmp/tmp.VfxfwYPDnG (size 1 KB) containing data sent by client
# Created /tmp/tmp.hlfBNtDvU9 (size 1 KB) containing data sent by server
# 01 no JOIN                              syn[ ok ] - synack[ ok ] - ack[ ok ]
# 02 single subflow, limited by client    syn[ ok ] - synack[ ok ] - ack[ ok ]
# 03 single subflow, limited by server    syn[ ok ] - synack[ ok ] - ack[ ok ]
# 04 single subflow                       syn[ ok ] - synack[ ok ] - ack[ ok ]
# 05 multiple subflows                    syn[ ok ] - synack[ ok ] - ack[ ok ]
# 06 multiple subflows, limited by server syn[ ok ] - synack[ ok ] - ack[ ok ]
# 07 single subflow, dev                  syn[ ok ] - synack[ ok ] - ack[ ok ]
# 08 unused signal address                syn[ ok ] - synack[ ok ] - ack[ ok ]
#                                         add[ ok ] - echo  [ ok ]
# 09 signal address                       syn[ ok ] - synack[ ok ] - ack[ ok ]
#                                         add[ ok ] - echo  [ ok ]
# 10 subflow and signal                   syn[ ok ] - synack[ ok ] - ack[ ok ]
#                                         add[ ok ] - echo  [ ok ]
# 11 multiple subflows and signal         syn[ ok ] - synack[ ok ] - ack[ ok ]
#                                         add[ ok ] - echo  [ ok ]
# 12 signal addresses                     syn[ ok ] - synack[ ok ] - ack[ ok ]
#                                         add[ ok ] - echo  [ ok ]
# 13 signal invalid addresses             syn[ ok ] - synack[ ok ] - ack[ ok ]
#                                         add[ ok ] - echo  [ ok ]
# Created /tmp/tmp.VfxfwYPDnG (size 88960 KB) containing data sent by client
# 14 multiple flows, signal, link failure syn[ ok ] - synack[ ok ] - ack[ ok ]
#                                         add[ ok ] - echo  [ ok ]
# 15 signal address, ADD_ADDR timeout     syn[ ok ] - synack[ ok ] - ack[ ok ]
#                                         add[ ok ] - echo  [ ok ]
# 16 signal address, ADD_ADDR6 timeout    syn[ ok ] - synack[ ok ] - ack[ ok ]
#                                         add[ ok ] - echo  [ ok ]
# 17 signal addresses, ADD_ADDR timeout   syn[ ok ] - synack[ ok ] - ack[ ok ]
#                                         add[ ok ] - echo  [ ok ]
# 18 invalid address, ADD_ADDR timeout    syn[ ok ] - synack[ ok ] - ack[ ok ]
#                                         add[ ok ] - echo  [ ok ]
# 19 remove single subflow                syn[ ok ] - synack[ ok ] - ack[ ok ]
#                                         rm [ ok ] - sf    [ ok ]
# 20 remove multiple subflows             syn[ ok ] - synack[ ok ] - ack[ ok ]
#                                         rm [ ok ] - sf    [ ok ]
# 21 remove single address                syn[ ok ] - synack[ ok ] - ack[ ok ]
#                                         add[ ok ] - echo  [ ok ]
#                                         rm [ ok ] - sf    [ ok ]
# 22 remove subflow and signal            syn[ ok ] - synack[ ok ] - ack[ ok ]
#                                         add[ ok ] - echo  [ ok ]
#                                         rm [ ok ] - sf    [ ok ]
# 23 remove subflows and signal           syn[ ok ] - synack[ ok ] - ack[ ok ]
#                                         add[ ok ] - echo  [ ok ]
#                                         rm [ ok ] - sf    [ ok ]
# 24 remove addresses                     syn[ ok ] - synack[ ok ] - ack[ ok ]
#                                         add[ ok ] - echo  [ ok ]
#                                         rm [ ok ] - sf    [ ok ]
# 25 remove invalid addresses             syn[ ok ] - synack[ ok ] - ack[ ok ]
#                                         add[ ok ] - echo  [ ok ]
#                                         rm [ ok ] - sf    [ ok ]
# 26 flush subflows and signal            syn[ ok ] - synack[ ok ] - ack[ ok ]
#                                         add[ ok ] - echo  [ ok ]
#                                         rm [ ok ] - sf    [ ok ]
# 27 flush subflows                       syn[ ok ] - synack[ ok ] - ack[ ok ]
#                                         rm [ ok ] - sf    [ ok ]
# 28 flush addresses                      syn[ ok ] - synack[ ok ] - ack[ ok ]
#                                         add[ ok ] - echo  [ ok ]
#                                         rm [ ok ] - sf    [ ok ]
# 29 flush invalid addresses              syn[ ok ] - synack[ ok ] - ack[ ok ]
#                                         add[ ok ] - echo  [ ok ]
#                                         rm [ ok ] - sf    [ ok ]
# 30 remove id 0 subflow                  syn[ ok ] - synack[ ok ] - ack[ ok ]
#                                         rm [ ok ] - sf    [ ok ]
# 31 remove id 0 address                  syn[ ok ] - synack[ ok ] - ack[ ok ]
#                                         add[ ok ] - echo  [ ok ]
#                                         rm [ ok ] - sf    [ ok ]
# 32 add single subflow                   syn[ ok ] - synack[ ok ] - ack[ ok ]
# 33 add signal address                   syn[ ok ] - synack[ ok ] - ack[ ok ]
#                                         add[ ok ] - echo  [ ok ]
# 34 add multiple subflows                syn[ ok ] - synack[ ok ] - ack[ ok ]
# 35 add multiple subflows IPv6           syn[ ok ] - synack[ ok ] - ack[ ok ]
# 36 add multiple addresses IPv6          syn[ ok ] - synack[ ok ] - ack[ ok ]
#                                         add[ ok ] - echo  [ ok ]
# 37 single subflow IPv6                  syn[ ok ] - synack[ ok ] - ack[ ok ]
# 38 unused signal address IPv6           syn[ ok ] - synack[ ok ] - ack[ ok ]
#                                         add[ ok ] - echo  [ ok ]
# 39 single address IPv6                  syn[ ok ] - synack[ ok ] - ack[ ok ]
#                                         add[ ok ] - echo  [ ok ]
# 40 remove single address IPv6           syn[ ok ] - synack[ ok ] - ack[ ok ]
#                                         add[ ok ] - echo  [ ok ]
#                                         rm [ ok ] - sf    [ ok ]
# 41 remove subflow and signal IPv6       syn[ ok ] - synack[ ok ] - ack[ ok ]
#                                         add[ ok ] - echo  [ ok ]
#                                         rm [ ok ] - sf    [ ok ]
# 42 single subflow IPv4-mapped           syn[ ok ] - synack[ ok ] - ack[ ok ]
# 43 signal address IPv4-mapped           syn[ ok ] - synack[ ok ] - ack[ ok ]
#                                         add[ ok ] - echo  [ ok ]
# 44 single subflow v4-map-v6             syn[ ok ] - synack[ ok ] - ack[ ok ]
# 45 signal address v4-map-v6             syn[ ok ] - synack[ ok ] - ack[ ok ]
#                                         add[ ok ] - echo  [ ok ]
# 46 single subflow v6-map-v4             syn[ ok ] - synack[ ok ] - ack[ ok ]
# 47 signal address v6-map-v4             syn[ ok ] - synack[ ok ] - ack[ ok ]
#                                         add[ ok ] - echo  [ ok ]
# 48 no JOIN with diff families v4-v6     syn[ ok ] - synack[ ok ] - ack[ ok ]
# 49 no JOIN with diff families v4-v6-2   syn[ ok ] - synack[ ok ] - ack[ ok ]
# 50 no JOIN with diff families v6-v4     syn[ ok ] - synack[ ok ] - ack[ ok ]
# 51 single subflow, backup               syn[ ok ] - synack[ ok ] - ack[ ok ]
#                                         ptx[ ok ] - prx   [ ok ]
# 52 single address, backup               syn[ ok ] - synack[ ok ] - ack[ ok ]
#                                         add[ ok ] - echo  [ ok ]
#                                         ptx[ ok ] - prx   [ ok ]
# 53 signal address with port             syn[ ok ] - synack[ ok ] - ack[ ok ]
#                                         add[ ok ] - echo  [ ok ] - pt [ ok ]
#                                         syn[ ok ] - synack[ ok ] - ack[ ok ]
#                                         syn[ ok ] - ack   [ ok ]
# 54 subflow and signal with port         syn[ ok ] - synack[ ok ] - ack[ ok ]
#                                         add[ ok ] - echo  [ ok ] - pt [ ok ]
#                                         syn[ ok ] - synack[ ok ] - ack[ ok ]
#                                         syn[ ok ] - ack   [ ok ]
# 55 remove single address with port      syn[ ok ] - synack[ ok ] - ack[ ok ]
#                                         add[ ok ] - echo  [ ok ] - pt [ ok ]
#                                         syn[ ok ] - synack[ ok ] - ack[ ok ]
#                                         syn[ ok ] - ack   [ ok ]
#                                         rm [ ok ] - sf    [ ok ]
# 56 remove subflow and signal with port  syn[ ok ] - synack[ ok ] - ack[ ok ]
#                                         add[ ok ] - echo  [ ok ] - pt [ ok ]
#                                         syn[ ok ] - synack[ ok ] - ack[ ok ]
#                                         syn[ ok ] - ack   [ ok ]
#                                         rm [ ok ] - sf    [ ok ]
# 57 flush subflows and signal with port  syn[ ok ] - synack[ ok ] - ack[ ok ]
#                                         add[ ok ] - echo  [ ok ]
#                                         rm [ ok ] - sf    [ ok ]
# 58 multiple addresses with port         syn[ ok ] - synack[ ok ] - ack[ ok ]
#                                         add[ ok ] - echo  [ ok ] - pt [ ok ]
#                                         syn[ ok ] - synack[ ok ] - ack[ ok ]
#                                         syn[ ok ] - ack   [ ok ]
# 59 multiple addresses with ports        syn[ ok ] - synack[ ok ] - ack[ ok ]
#                                         add[ ok ] - echo  [ ok ] - pt [ ok ]
#                                         syn[ ok ] - synack[ ok ] - ack[ ok ]
#                                         syn[ ok ] - ack   [ ok ]
# 60 single subflow with syn cookies      syn[ ok ] - synack[ ok ] - ack[ ok ]
# 61 multiple subflows with syn cookies   syn[ ok ] - synack[ ok ] - ack[ ok ]
# 62 subflows limited by server w cookies syn[ ok ] - synack[ ok ] - ack[ ok ]
# 63 signal address with syn cookies      syn[ ok ] - synack[ ok ] - ack[ ok ]
#                                         add[ ok ] - echo  [ ok ]
# 64 subflow and signal w cookies         syn[ ok ] - synack[ ok ] - ack[ ok ]
#                                         add[ ok ] - echo  [ ok ]
# 65 subflows and signal w. cookies       syn[ ok ] - synack[ ok ] - ack[ ok ]
#                                         add[ ok ] - echo  [ ok ]
ok 3 selftests: net/mptcp: mptcp_join.sh
# selftests: net/mptcp: diag.sh
# no msk on netns creation                          [  ok  ]
# after MPC handshake                               [  ok  ]
# ....chk remote_key                                [  ok  ]
# ....chk no fallback                               [  ok  ]
# check fallback                                    [  ok  ]
# many msk socket present                           [  ok  ]
ok 4 selftests: net/mptcp: diag.sh
# selftests: net/mptcp: simult_flows.sh
# balanced bwidth                                     4573 max 5005 [ OK ]
# balanced bwidth - reverse direction                 4559 max 5005 [ OK ]
# balanced bwidth with unbalanced delay               4543 max 5005 [ OK ]
# balanced bwidth with unbalanced delay - reverse direction  4568 max 5005 [ OK ]
# unbalanced bwidth                                   2934 max 3245 [ OK ]
# unbalanced bwidth - reverse direction               2912 max 3245 [ OK ]
# unbalanced bwidth with unbalanced delay             2935 max 3245 [ OK ]
# unbalanced bwidth with unbalanced delay - reverse direction  2911 max 3245 [ OK ]
# unbalanced bwidth with opposed, unbalanced delay    3020 max 3245 [ OK ]
# unbalanced bwidth with opposed, unbalanced delay - reverse direction  2912 max 3245 [ OK ]
ok 5 selftests: net/mptcp: simult_flows.sh
# selftests: net/mptcp: mptcp_sockopt.sh
# Created /tmp/tmp.k8XqT6eBv8 (size 1 KB) containing data sent by client
# Created /tmp/tmp.79jNWqx0ey (size 1 KB) containing data sent by server
# PASS: all packets had packet mark set
ok 6 selftests: net/mptcp: mptcp_sockopt.sh

--BOKacYhQ+x31HxR3
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename="job.yaml"

---

#! jobs/kernel-selftests.yaml
suite: kernel-selftests
testcase: kernel-selftests
category: functional
kconfig: x86_64-rhel-8.3-kselftests
need_memory: 3G
need_cpu: 2
kernel-selftests:
  group: mptcp
kernel_cmdline: sysctl.debug.test_sysctl.boot_int=1
job_origin: kernel-selftests.yaml

#! queue options
queue_cmdline_keys:
- branch
- commit
queue: bisect
testbox: lkp-skl-d05
tbox_group: lkp-skl-d05
submit_id: 60b77692aa6e803049956eb3
job_file: "/lkp/jobs/scheduled/lkp-skl-d05/kernel-selftests-mptcp-ucode=0xe2-debian-10.4-x86_64-20200603.cgz-a0aa657b74904f1ffff77eeb194591f99311e33f-20210602-12361-3lnuwv-0.yaml"
id: dc0c92f4d70b731b86c8c098169034e79fdd573f
queuer_version: "/lkp-src"

#! hosts/lkp-skl-d05
model: Skylake
nr_cpu: 4
memory: 32G
nr_ssd_partitions: 1
nr_hdd_partitions: 4
hdd_partitions: "/dev/disk/by-id/wwn-0x5000c50091e544de-part*"
ssd_partitions: "/dev/disk/by-id/wwn-0x55cd2e4151977e28-part2"
rootfs_partition: "/dev/disk/by-id/wwn-0x55cd2e4151977e28-part1"
brand: Intel(R) Core(TM) i5-6500 CPU @ 3.20GHz

#! include/category/functional
kmsg: 
heartbeat: 
meminfo: 

#! include/queue/cyclic
commit: a0aa657b74904f1ffff77eeb194591f99311e33f

#! include/testbox/lkp-skl-d05
need_kconfig_hw:
- CONFIG_E1000E=y
- CONFIG_SATA_AHCI
- CONFIG_DRM_I915
ucode: '0xe2'

# for sysctl

#! include/kernel-selftests
need_linux_headers: true
need_linux_selftests: true
need_kselftests: true
need_kconfig:
- CONFIG_BLOCK=y
- CONFIG_BTRFS_FS=m
- CONFIG_EFI=y
- CONFIG_EFIVAR_FS
- CONFIG_FTRACE=y
- CONFIG_IP_ADVANCED_ROUTER=y
- CONFIG_IP_MULTIPLE_TABLES=y
- CONFIG_MEMORY_HOTPLUG_SPARSE=y
- CONFIG_MEMORY_NOTIFIER_ERROR_INJECT
- CONFIG_NOTIFIER_ERROR_INJECTION
- CONFIG_RC_CORE=m ~ ">= v4.14-rc1"
- CONFIG_RC_DECODERS=y
- CONFIG_RC_DEVICES=y
- CONFIG_RUNTIME_TESTING_MENU=y
- CONFIG_STAGING=y
- CONFIG_SYNC_FILE=y
- CONFIG_TEST_FIRMWARE
- CONFIG_TEST_KMOD=m
- CONFIG_TEST_LKM=m
- CONFIG_TEST_USER_COPY
- CONFIG_TUN=m
- CONFIG_XFS_FS=m
enqueue_time: 2021-06-02 20:16:19.208722480 +08:00
_id: 60b77692aa6e803049956eb3
_rt: "/result/kernel-selftests/mptcp-ucode=0xe2/lkp-skl-d05/debian-10.4-x86_64-20200603.cgz/x86_64-rhel-8.3-kselftests/gcc-9/a0aa657b74904f1ffff77eeb194591f99311e33f"

#! schedule options
user: lkp
compiler: gcc-9
LKP_SERVER: internal-lkp-server
head_commit: 6fd63bbec78825af75a5a63bbff79bde8e27cba8
base_commit: 8124c8a6b35386f73523d27eacb71b5364a68c4c
branch: linux-devel/devel-hourly-20210602-031712
rootfs: debian-10.4-x86_64-20200603.cgz
result_root: "/result/kernel-selftests/mptcp-ucode=0xe2/lkp-skl-d05/debian-10.4-x86_64-20200603.cgz/x86_64-rhel-8.3-kselftests/gcc-9/a0aa657b74904f1ffff77eeb194591f99311e33f/0"
scheduler_version: "/lkp/lkp/.src-20210601-202423"
arch: x86_64
max_uptime: 2100
initrd: "/osimage/debian/debian-10.4-x86_64-20200603.cgz"
bootloader_append:
- root=/dev/ram0
- user=lkp
- job=/lkp/jobs/scheduled/lkp-skl-d05/kernel-selftests-mptcp-ucode=0xe2-debian-10.4-x86_64-20200603.cgz-a0aa657b74904f1ffff77eeb194591f99311e33f-20210602-12361-3lnuwv-0.yaml
- ARCH=x86_64
- kconfig=x86_64-rhel-8.3-kselftests
- branch=linux-devel/devel-hourly-20210602-031712
- commit=a0aa657b74904f1ffff77eeb194591f99311e33f
- BOOT_IMAGE=/pkg/linux/x86_64-rhel-8.3-kselftests/gcc-9/a0aa657b74904f1ffff77eeb194591f99311e33f/vmlinuz-5.13.0-rc3-00737-ga0aa657b7490
- sysctl.debug.test_sysctl.boot_int=1
- max_uptime=2100
- RESULT_ROOT=/result/kernel-selftests/mptcp-ucode=0xe2/lkp-skl-d05/debian-10.4-x86_64-20200603.cgz/x86_64-rhel-8.3-kselftests/gcc-9/a0aa657b74904f1ffff77eeb194591f99311e33f/0
- LKP_SERVER=internal-lkp-server
- nokaslr
- selinux=0
- debug
- apic=debug
- sysrq_always_enabled
- rcupdate.rcu_cpu_stall_timeout=100
- net.ifnames=0
- printk.devkmsg=on
- panic=-1
- softlockup_panic=1
- nmi_watchdog=panic
- oops=panic
- load_ramdisk=2
- prompt_ramdisk=0
- drbd.minor_count=8
- systemd.log_level=err
- ignore_loglevel
- console=tty0
- earlyprintk=ttyS0,115200
- console=ttyS0,115200
- vga=normal
- rw
modules_initrd: "/pkg/linux/x86_64-rhel-8.3-kselftests/gcc-9/a0aa657b74904f1ffff77eeb194591f99311e33f/modules.cgz"
linux_headers_initrd: "/pkg/linux/x86_64-rhel-8.3-kselftests/gcc-9/a0aa657b74904f1ffff77eeb194591f99311e33f/linux-headers.cgz"
linux_selftests_initrd: "/pkg/linux/x86_64-rhel-8.3-kselftests/gcc-9/a0aa657b74904f1ffff77eeb194591f99311e33f/linux-selftests.cgz"
kselftests_initrd: "/pkg/linux/x86_64-rhel-8.3-kselftests/gcc-9/a0aa657b74904f1ffff77eeb194591f99311e33f/kselftests.cgz"
bm_initrd: "/osimage/deps/debian-10.4-x86_64-20200603.cgz/run-ipconfig_20200608.cgz,/osimage/deps/debian-10.4-x86_64-20200603.cgz/lkp_20201211.cgz,/osimage/deps/debian-10.4-x86_64-20200603.cgz/rsync-rootfs_20200608.cgz,/osimage/deps/debian-10.4-x86_64-20200603.cgz/kernel-selftests_20210507.cgz,/osimage/pkg/debian-10.4-x86_64-20200603.cgz/kernel-selftests-x86_64-0d95472a-1_20210507.cgz,/osimage/deps/debian-10.4-x86_64-20200603.cgz/hw_20200715.cgz"
ucode_initrd: "/osimage/ucode/intel-ucode-20210222.cgz"
lkp_initrd: "/osimage/user/lkp/lkp-x86_64.cgz"
site: inn

#! /lkp/lkp/.src-20210601-202423/include/site/inn
LKP_CGI_PORT: 80
LKP_CIFS_PORT: 139
oom-killer: 
watchdog: 

#! runtime status
last_kernel: 5.13.0-rc4-05786-g54ecdfa482d6

#! user overrides
kernel: "/pkg/linux/x86_64-rhel-8.3-kselftests/gcc-9/a0aa657b74904f1ffff77eeb194591f99311e33f/vmlinuz-5.13.0-rc3-00737-ga0aa657b7490"
dequeue_time: 2021-06-02 21:23:02.484922456 +08:00
job_state: finished
loadavg: 0.31 0.27 0.17 1/142 13577
start_time: '1622640283'
end_time: '1622640745'
version: "/lkp/lkp/.src-20210601-202455:c2f094db-dirty:b74eaac4d"

--BOKacYhQ+x31HxR3
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename=reproduce

ln -sf /usr/bin/clang
ln -sf /usr/bin/llc
sed -i s/default_timeout=45/default_timeout=300/ kselftest/runner.sh
sed -i s/default_timeout=45/default_timeout=300/ /kselftests/kselftest/runner.sh
/kselftests/run_kselftest.sh -c net/mptcp

--BOKacYhQ+x31HxR3--
