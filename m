Return-Path: <SRS0=MMpb=TO=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,USER_AGENT_NEOMUTT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BEBDDC04AB4
	for <netfilter-devel@archiver.kernel.org>; Tue, 14 May 2019 23:03:38 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 98D172084E
	for <netfilter-devel@archiver.kernel.org>; Tue, 14 May 2019 23:03:38 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726416AbfENXDi (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 14 May 2019 19:03:38 -0400
Received: from mail.us.es ([193.147.175.20]:51016 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726180AbfENXDh (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 14 May 2019 19:03:37 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 05A27F279E
        for <netfilter-devel@vger.kernel.org>; Wed, 15 May 2019 01:03:35 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id DEAC7DA781
        for <netfilter-devel@vger.kernel.org>; Wed, 15 May 2019 01:03:34 +0200 (CEST)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id DC2B4DA712; Wed, 15 May 2019 01:03:34 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 52C05DA703;
        Wed, 15 May 2019 01:03:32 +0200 (CEST)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Wed, 15 May 2019 01:03:32 +0200 (CEST)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from us.es (sys.soleta.eu [212.170.55.40])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: 1984lsi)
        by entrada.int (Postfix) with ESMTPSA id 031CB4265A31;
        Wed, 15 May 2019 01:03:32 +0200 (CEST)
Date:   Wed, 15 May 2019 01:03:31 +0200
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Jiri Pirko <jiri@resnulli.us>
Cc:     netfilter-devel@vger.kernel.org, davem@davemloft.net,
        netdev@vger.kernel.org, thomas.lendacky@amd.com,
        f.fainelli@gmail.com, ariel.elior@cavium.com,
        michael.chan@broadcom.com, santosh@chelsio.com,
        madalin.bucur@nxp.com, yisen.zhuang@huawei.com,
        salil.mehta@huawei.com, jeffrey.t.kirsher@intel.com,
        tariqt@mellanox.com, saeedm@mellanox.com, jiri@mellanox.com,
        idosch@mellanox.com, jakub.kicinski@netronome.com,
        peppe.cavallaro@st.com, grygorii.strashko@ti.com, andrew@lunn.ch,
        vivien.didelot@savoirfairelinux.com, alexandre.torgue@st.com,
        joabreu@synopsys.com, linux-net-drivers@solarflare.com,
        ganeshgr@chelsio.com, ogerlitz@mellanox.com,
        Manish.Chopra@cavium.com, marcelo.leitner@gmail.com,
        mkubecek@suse.cz, venkatkumar.duvvuru@broadcom.com,
        julia.lawall@lip6.fr, john.fastabend@gmail.com
Subject: Re: [PATCH net-next,RFC 2/2] netfilter: nf_tables: add hardware
 offload support
Message-ID: <20190514230331.trlmwnfa2rcs7hjt@salvia>
References: <20190509163954.13703-1-pablo@netfilter.org>
 <20190509163954.13703-3-pablo@netfilter.org>
 <20190514170108.GC2584@nanopsycho>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190514170108.GC2584@nanopsycho>
User-Agent: NeoMutt/20170113 (1.7.2)
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Tue, May 14, 2019 at 07:01:08PM +0200, Jiri Pirko wrote:
> Thu, May 09, 2019 at 06:39:51PM CEST, pablo@netfilter.org wrote:
> >This patch adds hardware offload support for nftables through the
> >existing netdev_ops->ndo_setup_tc() interface, the TC_SETUP_CLSFLOWER
> >classifier and the flow rule API. This hardware offload support is
> >available for the NFPROTO_NETDEV family and the ingress hook.
> >
> >Each nftables expression has a new ->offload interface, that is used to
> >populate the flow rule object that is attached to the transaction
> >object.
> >
> >There is a new per-table NFT_TABLE_F_HW flag, that is set on to offload
> >an entire table, including all of its chains.
> >
> >This patch supports for basic metadata (layer 3 and 4 protocol numbers),
> >5-tuple payload matching and the accept/drop actions; this also includes
> >basechain hardware offload only.
> >
> >Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
> 
> [...]
> 
> >+static int nft_flow_offload_chain(struct nft_trans *trans,
> >+				  enum flow_block_command cmd)
> >+{
> >+	struct nft_chain *chain = trans->ctx.chain;
> >+	struct netlink_ext_ack extack = {};
> >+	struct flow_block_offload bo = {};
> >+	struct nft_base_chain *basechain;
> >+	struct net_device *dev;
> >+	int err;
> >+
> >+	if (!nft_is_base_chain(chain))
> >+		return -EOPNOTSUPP;
> >+
> >+	basechain = nft_base_chain(chain);
> >+	dev = basechain->ops.dev;
> >+	if (!dev)
> >+		return -EOPNOTSUPP;
> >+
> >+	bo.command = cmd;
> >+	bo.binder_type = TCF_BLOCK_BINDER_TYPE_CLSACT_INGRESS;
> >+	bo.block_index = (u32)trans->ctx.chain->handle;
> >+	bo.extack = &extack;
> >+	INIT_LIST_HEAD(&bo.cb_list);
> >+
> >+	err = dev->netdev_ops->ndo_setup_tc(dev, TC_SETUP_BLOCK, &bo);
> 
> Okay, so you pretend to be clsact-ingress-flower. That looks fine.
> But how do you ensure that the real one does not bind a block on the
> same device too?

I could store the interface index in the block_cb object, then use the
tuple [ cb, cb_ident, ifindex ] to check if the block is already bound
by when flow_block_cb_alloc() is called.

Thanks.
