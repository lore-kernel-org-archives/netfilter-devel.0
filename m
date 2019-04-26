Return-Path: <SRS0=OoQ/=S4=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,USER_AGENT_NEOMUTT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0815FC43219
	for <netfilter-devel@archiver.kernel.org>; Fri, 26 Apr 2019 17:03:52 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id D37D1206E0
	for <netfilter-devel@archiver.kernel.org>; Fri, 26 Apr 2019 17:03:51 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726224AbfDZRDv (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Fri, 26 Apr 2019 13:03:51 -0400
Received: from mail.us.es ([193.147.175.20]:60594 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725944AbfDZRDv (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 26 Apr 2019 13:03:51 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 9671D1031AE
        for <netfilter-devel@vger.kernel.org>; Fri, 26 Apr 2019 19:03:49 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 8599CDA706
        for <netfilter-devel@vger.kernel.org>; Fri, 26 Apr 2019 19:03:49 +0200 (CEST)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id 7B389DA702; Fri, 26 Apr 2019 19:03:49 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 7BE84DA706;
        Fri, 26 Apr 2019 19:03:47 +0200 (CEST)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Fri, 26 Apr 2019 19:03:47 +0200 (CEST)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from us.es (sys.soleta.eu [212.170.55.40])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: 1984lsi)
        by entrada.int (Postfix) with ESMTPSA id 56E574265A31;
        Fri, 26 Apr 2019 19:03:47 +0200 (CEST)
Date:   Fri, 26 Apr 2019 19:03:46 +0200
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Taehee Yoo <ap420073@gmail.com>
Cc:     fw@strlen.de, netfilter-devel@vger.kernel.org
Subject: Re: [PATCH nf 2/4] netfilter: nft_flow_offload: do not make
 un-established tcp flow_offload session.
Message-ID: <20190426170346.yxkjrhgsh6snqzbs@salvia>
References: <20190426165327.3533-1-ap420073@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190426165327.3533-1-ap420073@gmail.com>
User-Agent: NeoMutt/20170113 (1.7.2)
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Sat, Apr 27, 2019 at 01:53:27AM +0900, Taehee Yoo wrote:
> nft_flow_offload_eval() makes flow_offload session but it doesn't check
> tcp state.
> So, it can make un-ESTABLISHED tcp flow offload session such as SYN-RECV.
> But, this is not a normal case.
> 
> Fixes: a3c90f7a2323 ("netfilter: nf_tables: flow offload expression")
> Signed-off-by: Taehee Yoo <ap420073@gmail.com>
> ---
>  net/netfilter/nft_flow_offload.c | 3 +++
>  1 file changed, 3 insertions(+)
> 
> diff --git a/net/netfilter/nft_flow_offload.c b/net/netfilter/nft_flow_offload.c
> index ff50bc1b144f..8538ddf9c6bf 100644
> --- a/net/netfilter/nft_flow_offload.c
> +++ b/net/netfilter/nft_flow_offload.c
> @@ -84,6 +84,9 @@ static void nft_flow_offload_eval(const struct nft_expr *expr,
>  
>  	switch (ct->tuplehash[IP_CT_DIR_ORIGINAL].tuple.dst.protonum) {
>  	case IPPROTO_TCP:
> +		if (ct->proto.tcp.state != TCP_CONNTRACK_ESTABLISHED)
> +			goto out;

You can restrict this via policy:

        ct status assured flow add @x

I've been considering to remove this defensive check

diff --git a/net/netfilter/nft_flow_offload.c
b/net/netfilter/nft_flow_offload.c
index 6e6b9adf7d38..bb8ea4cefc34 100644
--- a/net/netfilter/nft_flow_offload.c
+++ b/net/netfilter/nft_flow_offload.c
@@ -94,10 +94,6 @@ static void nft_flow_offload_eval(const struct nft_expr *expr,
        if (help)
                goto out;
 
-       if (ctinfo == IP_CT_NEW ||
-           ctinfo == IP_CT_RELATED)
-               goto out;
-
        if (test_and_set_bit(IPS_OFFLOAD_BIT, &ct->status))
                goto out;

Given that we can restrict this via policy, ie.

        ct state established flow add @x

And this would fix the flowtable infrastructure UDP traffic that only
goes in one direction.

We can document in the manpage a few examples for this.
