Return-Path: <SRS0=OoQ/=S4=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A26DAC43219
	for <netfilter-devel@archiver.kernel.org>; Fri, 26 Apr 2019 00:33:59 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 8A36D206C1
	for <netfilter-devel@archiver.kernel.org>; Fri, 26 Apr 2019 00:33:59 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729625AbfDZAd7 (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 25 Apr 2019 20:33:59 -0400
Received: from mail.us.es ([193.147.175.20]:55170 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727509AbfDZAd7 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 25 Apr 2019 20:33:59 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 35C39B4979
        for <netfilter-devel@vger.kernel.org>; Fri, 26 Apr 2019 02:33:57 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 28D63DA701
        for <netfilter-devel@vger.kernel.org>; Fri, 26 Apr 2019 02:33:57 +0200 (CEST)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id 1C2F8DA705; Fri, 26 Apr 2019 02:33:57 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id EF7DFDA702;
        Fri, 26 Apr 2019 02:33:54 +0200 (CEST)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Fri, 26 Apr 2019 02:33:54 +0200 (CEST)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from salvia.here (sys.soleta.eu [212.170.55.40])
        (Authenticated sender: pneira@us.es)
        by entrada.int (Postfix) with ESMTPA id 9AF5E4265A31;
        Fri, 26 Apr 2019 02:33:54 +0200 (CEST)
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Cc:     davem@davemloft.net, netdev@vger.kernel.org, jiri@mellanox.com,
        john.hurley@netronome.com, jakub.kicinski@netronome.com,
        ogerlitz@mellanox.com
Subject: [PATCH net-next,RFC 0/9] net: sched: prepare to reuse per-block callbacks from netfilter
Date:   Fri, 26 Apr 2019 02:33:37 +0200
Message-Id: <20190426003348.30745-1-pablo@netfilter.org>
X-Mailer: git-send-email 2.11.0
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Hi,

This patchset aims to introduce changes to reuse the existing .ndo_setup_tc
netdev operations from netfilter.

The idea is to move tcf_block_cb to net/core/flow_offload.c and rename
it to flow_block_cb. This object provides the minimal infrastructure to
set up per-block callbacks that are called to offload policies to
hardware.

The tcf_block object is specific for TC to share policies between
ingress devices. This object has a list of tcf_block_cb objects that are
called to offload the policies to hardware. In netfilter, the idea is to
store the list of tcf_block_cb objects in a chain that would be bound to
several devices, eg.

  chain x {
	type filter hook ingress devices = { eth0, eth1 } priority 0;
	...
  }

Hence, this emulates the shared blocks available in TC that Jiri made.

Note that the list of tcf_block_cb objects will be called to offload
policies in this chain.

To reuse this infrastructure, I need remove the dependency with the
tcf_block object and tc/cls_api (see .reoffload) that is called from the
driver side, this patchset reworks the per-block callback infrastructure
to set up the tcf_block_cb object from the driver, then convey the list
of callbacks using the tc_block_offload object back to the core.

            cls_api                         driver
	TC_SETUP_BLOCK    ---------->  setup tcf_block_cb
       tc_block_offload           add it to tc_block_offload->cb_list
                                                |
          register     <------------------------'
         tcf_block_cb
         ->reoffload

Therefore, registration does not happen from drivers anymore, instead
it is done from the core. The driver just sets up the tcf_block_cb
object that wires up the connection between the offloaded block (chains
in case of netfilter) and the driver.

This patchset is compile tested only at this stage.

Comments welcome, thanks.

Pablo Neira Ayuso (9):
  net: sched: move tcf_block_cb before indr_block
  net: sched: add tcf_block_cb_alloc()
  net: sched: add tcf_block_cb_free()
  net: sched: add tcf_block_setup()
  net: sched: add release callback to struct tcf_block_cb
  net: sched: add tcf_setup_block_offload()
  net: use tcf_block_setup() infrastructure
  net: sched: remove tcf_block_cb_{register,unregister}()
  net: cls_api: do not expose tcf_block to drivers

 drivers/net/ethernet/broadcom/bnxt/bnxt.c          |  26 +-
 drivers/net/ethernet/broadcom/bnxt/bnxt_vfr.c      |  28 +-
 drivers/net/ethernet/chelsio/cxgb4/cxgb4_main.c    |  26 +-
 drivers/net/ethernet/intel/i40e/i40e_main.c        |  26 +-
 drivers/net/ethernet/intel/iavf/iavf_main.c        |  35 +-
 drivers/net/ethernet/intel/igb/igb_main.c          |  23 +-
 drivers/net/ethernet/intel/ixgbe/ixgbe_main.c      |  27 +-
 drivers/net/ethernet/mellanox/mlx5/core/en_main.c  |  27 +-
 drivers/net/ethernet/mellanox/mlx5/core/en_rep.c   |  59 +-
 drivers/net/ethernet/mellanox/mlxsw/spectrum.c     |  64 ++-
 drivers/net/ethernet/netronome/nfp/abm/cls.c       |  17 +-
 drivers/net/ethernet/netronome/nfp/bpf/main.c      |  29 +-
 .../net/ethernet/netronome/nfp/flower/offload.c    |  62 +--
 drivers/net/ethernet/qlogic/qede/qede_main.c       |  23 +-
 drivers/net/ethernet/stmicro/stmmac/stmmac_main.c  |  22 +-
 drivers/net/netdevsim/netdev.c                     |  26 +-
 include/net/pkt_cls.h                              |  29 +-
 net/dsa/slave.c                                    |  15 +-
 net/sched/cls_api.c                                | 598 ++++++++++++---------
 19 files changed, 528 insertions(+), 634 deletions(-)

-- 
2.11.0
