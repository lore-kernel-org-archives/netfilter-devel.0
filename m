Return-Path: <SRS0=H0Uh=TP=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.5 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,USER_AGENT_MUTT autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 01177C04E53
	for <netfilter-devel@archiver.kernel.org>; Wed, 15 May 2019 19:46:02 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id B1E332082E
	for <netfilter-devel@archiver.kernel.org>; Wed, 15 May 2019 19:46:01 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=resnulli-us.20150623.gappssmtp.com header.i=@resnulli-us.20150623.gappssmtp.com header.b="BbJXmDG7"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726347AbfEOTqB (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 15 May 2019 15:46:01 -0400
Received: from mail-wr1-f67.google.com ([209.85.221.67]:47099 "EHLO
        mail-wr1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726302AbfEOTqA (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 15 May 2019 15:46:00 -0400
Received: by mail-wr1-f67.google.com with SMTP id r7so727676wrr.13
        for <netfilter-devel@vger.kernel.org>; Wed, 15 May 2019 12:45:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=b5z8hCqG9wUGn0plAW7o1pY8YHDHnM+Fm/iAD1XBLtU=;
        b=BbJXmDG7BREG4a+WA1NtdlWtdzRJxlYvj88I9mn3Yn7WiMUuZsZ5U0n/lzltSyTIdD
         vkUHq3z+p3O0NGYSalV8e5glKTBi0igNJXzeUbcJBKwKuBvWhx63fi6z+HfXd7+59j4O
         3eT8KX8EVjc+mso86ICrNJKd2SjoncYBhGBHMnAVQcZYcCSdB7b6k1E3v3GVqpM+18hc
         W4kN4o7h0dxySgw9nhRxT9k72/2qI3FX8iSfEQnZS8+G3/hRndqwlVYdeXlWtk5ijS06
         uMfiQ80h1Ged5fqc5HOo8Mx1aG9F+TBZuwCV81KtgOlYsAmxY3ahWVd2thA/8gRC6dKd
         N91Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=b5z8hCqG9wUGn0plAW7o1pY8YHDHnM+Fm/iAD1XBLtU=;
        b=NZZErEKs5O/ow/Gyczm84CUsNCO3vCkz4uV+zTZfpEp3MYPD3z7jFwTttr1r1MBcy2
         0Y1LzbM2xnK4KzFU1dh7LOqt9FEvdt0OgI5Q3cNo7DHMwFiYOH0eXO+/NYNtDLZVv3KS
         kPil+XDC8D2ppqwLatTrT8clCY02S4iVq8DCu2Ekc2yV6lWWwoo2luPI4p8NunhX2Dsf
         YPFxT0Eg8LXgG0JaMPsF58Chxp5AZy6gkEA6viT5CeUvv5/7uayLaSBXQuy4Cs8zGf+H
         7gdgD2PBp2y+hWZ6PYJn5dh4Kd50HEZYnmBu1VeIeuxwhL/evtcn7d7vWJEjOZY+dLP9
         5slQ==
X-Gm-Message-State: APjAAAW82akKBkabWpgI2s7VHAKeJ7NooTaUF7Aeqd0LYbxTcw2SxjCU
        6oj96c5Rz2AmvNd5Nmcuiox0mA==
X-Google-Smtp-Source: APXvYqxb3n32PQYA2Fnv7fp0jgXDk+Izn0L3cZzLbZS6Y2QA11J8jNsy3ETnFfcCQR1899P3R0Qotg==
X-Received: by 2002:adf:dbcc:: with SMTP id e12mr2898477wrj.134.1557949558259;
        Wed, 15 May 2019 12:45:58 -0700 (PDT)
Received: from localhost (jirka.pirko.cz. [84.16.102.26])
        by smtp.gmail.com with ESMTPSA id a184sm3408552wmh.36.2019.05.15.12.45.57
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Wed, 15 May 2019 12:45:57 -0700 (PDT)
Date:   Wed, 15 May 2019 21:45:56 +0200
From:   Jiri Pirko <jiri@resnulli.us>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
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
Message-ID: <20190515194556.GA2190@nanopsycho.orion>
References: <20190509163954.13703-1-pablo@netfilter.org>
 <20190509163954.13703-3-pablo@netfilter.org>
 <20190514170108.GC2584@nanopsycho>
 <20190514230331.trlmwnfa2rcs7hjt@salvia>
 <20190515091326.x5m6433gyznsgd45@salvia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190515091326.x5m6433gyznsgd45@salvia>
User-Agent: Mutt/1.11.3 (2019-02-01)
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Wed, May 15, 2019 at 11:13:26AM CEST, pablo@netfilter.org wrote:
>On Wed, May 15, 2019 at 01:03:31AM +0200, Pablo Neira Ayuso wrote:
>> On Tue, May 14, 2019 at 07:01:08PM +0200, Jiri Pirko wrote:
>> > Thu, May 09, 2019 at 06:39:51PM CEST, pablo@netfilter.org wrote:
>> > >This patch adds hardware offload support for nftables through the
>> > >existing netdev_ops->ndo_setup_tc() interface, the TC_SETUP_CLSFLOWER
>> > >classifier and the flow rule API. This hardware offload support is
>> > >available for the NFPROTO_NETDEV family and the ingress hook.
>> > >
>> > >Each nftables expression has a new ->offload interface, that is used to
>> > >populate the flow rule object that is attached to the transaction
>> > >object.
>> > >
>> > >There is a new per-table NFT_TABLE_F_HW flag, that is set on to offload
>> > >an entire table, including all of its chains.
>> > >
>> > >This patch supports for basic metadata (layer 3 and 4 protocol numbers),
>> > >5-tuple payload matching and the accept/drop actions; this also includes
>> > >basechain hardware offload only.
>> > >
>> > >Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
>> > 
>> > [...]
>> > 
>> > >+static int nft_flow_offload_chain(struct nft_trans *trans,
>> > >+				  enum flow_block_command cmd)
>> > >+{
>> > >+	struct nft_chain *chain = trans->ctx.chain;
>> > >+	struct netlink_ext_ack extack = {};
>> > >+	struct flow_block_offload bo = {};
>> > >+	struct nft_base_chain *basechain;
>> > >+	struct net_device *dev;
>> > >+	int err;
>> > >+
>> > >+	if (!nft_is_base_chain(chain))
>> > >+		return -EOPNOTSUPP;
>> > >+
>> > >+	basechain = nft_base_chain(chain);
>> > >+	dev = basechain->ops.dev;
>> > >+	if (!dev)
>> > >+		return -EOPNOTSUPP;
>> > >+
>> > >+	bo.command = cmd;
>> > >+	bo.binder_type = TCF_BLOCK_BINDER_TYPE_CLSACT_INGRESS;
>> > >+	bo.block_index = (u32)trans->ctx.chain->handle;
>> > >+	bo.extack = &extack;
>> > >+	INIT_LIST_HEAD(&bo.cb_list);
>> > >+
>> > >+	err = dev->netdev_ops->ndo_setup_tc(dev, TC_SETUP_BLOCK, &bo);
>> > 
>> > Okay, so you pretend to be clsact-ingress-flower. That looks fine.
>> > But how do you ensure that the real one does not bind a block on the
>> > same device too?
>> 
>> I could store the interface index in the block_cb object, then use the
>> tuple [ cb, cb_ident, ifindex ] to check if the block is already bound
>> by when flow_block_cb_alloc() is called.
>
>Actually cb_ident would be sufficient. One possibility would be to

That is what I wrote :)


>extend flow_block_cb_alloc() to check for an existing binding.
>
>diff --git a/net/core/flow_offload.c b/net/core/flow_offload.c
>index cf984ef05609..44172014cebe 100644
>--- a/net/core/flow_offload.c
>+++ b/net/core/flow_offload.c
>@@ -193,9 +193,15 @@ struct flow_block_cb *flow_block_cb_alloc(u32 block_index, tc_setup_cb_t *cb,
> {
>        struct flow_block_cb *block_cb;
> 
>+       list_for_each_entry(block_cb, &flow_block_cb_list, list) {
>+               if (block_cb->cb == cb &&
>+                   block_cb->cb_ident == cb_ident)
>+                       return ERR_PTR(-EBUSY);
>+       }
>+
>        block_cb = kzalloc(sizeof(*block_cb), GFP_KERNEL);
>        if (!block_cb)
>-               return NULL;
>+               return ERR_PTR(-ENOMEM);
> 
>        block_cb->cb = cb;
>        block_cb->cb_ident = cb_ident;
>
>Thanks.
