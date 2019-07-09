Return-Path: <SRS0=D85U=VG=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.2 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 84CCAC606B0
	for <netfilter-devel@archiver.kernel.org>; Tue,  9 Jul 2019 06:21:02 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 5932921537
	for <netfilter-devel@archiver.kernel.org>; Tue,  9 Jul 2019 06:21:02 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=resnulli-us.20150623.gappssmtp.com header.i=@resnulli-us.20150623.gappssmtp.com header.b="mzoMzL+u"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726018AbfGIGVC (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 9 Jul 2019 02:21:02 -0400
Received: from mail-wr1-f67.google.com ([209.85.221.67]:47005 "EHLO
        mail-wr1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725832AbfGIGVB (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 9 Jul 2019 02:21:01 -0400
Received: by mail-wr1-f67.google.com with SMTP id z1so14961431wru.13
        for <netfilter-devel@vger.kernel.org>; Mon, 08 Jul 2019 23:21:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:content-transfer-encoding:in-reply-to
         :user-agent;
        bh=ii+SXJ6+lfZyOMkcgHiyxZo8EJmBOTy8e2tqhigbHgM=;
        b=mzoMzL+uHjgHbharxa6BcWOTmRpcvyOhY1DkVle/hIw5aphi/yagKx8zIgSi8AHTGE
         8VQwdWSyV7AQZ67NzZXEoojinQ7FTenP+7PftdgjHYNiJ6oISdx49oemqROx06TL68Yl
         hzc5Rdzji2xumhrB3Rml3dtritWa+LvzjpeCa+/W0SsbqAebpNWe0E/lR3kKJuNmWh7j
         wlePILMgzUS6KTPjb6/gx8I5E9CBOltn5mWPCaRxRpeEb2sWXON+MxmMtYIZ1S1ZCeyR
         +IdzfKZgetmraUoX4wXKBgPbd2Gy2E3XbySc4jY2cdUNlvmtPqvtaEPQcvm3e9CEe1/q
         ExFQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to:user-agent;
        bh=ii+SXJ6+lfZyOMkcgHiyxZo8EJmBOTy8e2tqhigbHgM=;
        b=NNz3SjXLyXuVuW4weorf1Kn8v4WfQje4rl+FSTHcTW9rig3TwuD6Jor6Zt0xdmR9HV
         cnnl5ts1G01YsgdcjTfOXaxlbh3ExCYjSReCb4Z7qZPcwftLEed8x7CHg4tOaSLxKdit
         7xd3AYTek7k45lT4Pjz8oA6S2FTGBr7VEjRK08i0Yk+Te+evm8+kvdVQBC5xrGY7KxUt
         +nvaZlnNZLVumYUWdfp4DL+cVJlrfrch0KEwwYTsolZo2mT71BtrIVa6jiC0qWnxyfsk
         hsF3vvl8Xgi9sBgafBajJM+PhaSGDCfmQ3evcF5RH0prKzX3P7l+5sJ3Umq1kSfaP1cK
         P2Ow==
X-Gm-Message-State: APjAAAUA/JiyGrJida3bIsHKfzenN1k1F+wabzwfKSiPIwrnKfiEAVPm
        xm3wi6GW6+hBz/f/1xTTKJL2hQ==
X-Google-Smtp-Source: APXvYqwMuAxaX1kwGYFqL8yFCzZQLst+dSPzj80a5gurwUi/qGC6E0PqpmLgwMja9ali6xLiVwN6qA==
X-Received: by 2002:a5d:6284:: with SMTP id k4mr23350348wru.179.1562653259657;
        Mon, 08 Jul 2019 23:20:59 -0700 (PDT)
Received: from localhost (jirka.pirko.cz. [84.16.102.26])
        by smtp.gmail.com with ESMTPSA id v15sm17182167wru.61.2019.07.08.23.20.59
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Mon, 08 Jul 2019 23:20:59 -0700 (PDT)
Date:   Tue, 9 Jul 2019 08:20:58 +0200
From:   Jiri Pirko <jiri@resnulli.us>
To:     Jakub Kicinski <jakub.kicinski@netronome.com>
Cc:     Pablo Neira Ayuso <pablo@netfilter.org>, netdev@vger.kernel.org,
        davem@davemloft.net, thomas.lendacky@amd.com, f.fainelli@gmail.com,
        ariel.elior@cavium.com, michael.chan@broadcom.com,
        madalin.bucur@nxp.com, yisen.zhuang@huawei.com,
        salil.mehta@huawei.com, jeffrey.t.kirsher@intel.com,
        tariqt@mellanox.com, saeedm@mellanox.com, jiri@mellanox.com,
        idosch@mellanox.com, peppe.cavallaro@st.com,
        grygorii.strashko@ti.com, andrew@lunn.ch, vivien.didelot@gmail.com,
        alexandre.torgue@st.com, joabreu@synopsys.com,
        linux-net-drivers@solarflare.com, ogerlitz@mellanox.com,
        Manish.Chopra@cavium.com, marcelo.leitner@gmail.com,
        mkubecek@suse.cz, venkatkumar.duvvuru@broadcom.com,
        maxime.chevallier@bootlin.com, cphealy@gmail.com,
        netfilter-devel@vger.kernel.org
Subject: Re: [PATCH net-next,v3 11/11] netfilter: nf_tables: add hardware
 offload support
Message-ID: <20190709062058.GI2282@nanopsycho.orion>
References: <20190708160614.2226-1-pablo@netfilter.org>
 <20190708160614.2226-12-pablo@netfilter.org>
 <20190708184437.4d29648a@cakuba.netronome.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20190708184437.4d29648a@cakuba.netronome.com>
User-Agent: Mutt/1.11.4 (2019-03-13)
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Tue, Jul 09, 2019 at 03:44:37AM CEST, jakub.kicinski@netronome.com wrote:
>On Mon,  8 Jul 2019 18:06:13 +0200, Pablo Neira Ayuso wrote:
>> This patch adds hardware offload support for nftables through the
>> existing netdev_ops->ndo_setup_tc() interface, the TC_SETUP_CLSFLOWER
>> classifier and the flow rule API. This hardware offload support is
>> available for the NFPROTO_NETDEV family and the ingress hook.
>> 
>> Each nftables expression has a new ->offload interface, that is used to
>> populate the flow rule object that is attached to the transaction
>> object.
>> 
>> There is a new per-table NFT_TABLE_F_HW flag, that is set on to offload
>> an entire table, including all of its chains.
>> 
>> This patch supports for basic metadata (layer 3 and 4 protocol numbers),
>> 5-tuple payload matching and the accept/drop actions; this also includes
>> basechain hardware offload only.
>> 
>> Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
>
>Any particular reason to not fence this off with a device feature
>(ethtool -k)?  Then you wouldn't need that per-driver list abomination
>until drivers start advertising it..  IDK if we want the per-device
>offload enable flags or not in general, it seems like a good idea in
>general for admin to be able to disable offload per device 🤷
>
>> +static int nft_flow_offload_rule(struct nft_trans *trans,
>> +				 enum tc_fl_command command)
>> +{
>> +	struct nft_flow_rule *flow = nft_trans_flow_rule(trans);
>> +	struct nft_rule *rule = nft_trans_rule(trans);
>> +	struct tc_cls_flower_offload cls_flower = {};
>> +	struct nft_base_chain *basechain;
>> +	struct netlink_ext_ack extack;
>> +	__be16 proto = ETH_P_ALL;
>> +
>> +	if (!nft_is_base_chain(trans->ctx.chain))
>> +		return -EOPNOTSUPP;
>> +
>> +	basechain = nft_base_chain(trans->ctx.chain);
>> +
>> +	if (flow)
>> +		proto = flow->proto;
>> +
>> +	nft_flow_offload_common_init(&cls_flower.common, proto, &extack);
>> +	cls_flower.command = command;
>> +	cls_flower.cookie = (unsigned long) rule;
>> +	if (flow)
>> +		cls_flower.rule = flow->rule;
>> +
>> +	return nft_setup_cb_call(basechain, TC_SETUP_CLSFLOWER, &cls_flower);
>> +}
>
>Are we 100% okay with using TC cls_flower structures and defines in nft
>code?

Yeah, your right. Should be renamed and moved to "flow offload" as well.
