From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH nf v5 2/3] netfilter: nat_helper: Make sure every proto
 nat module uses its nat_helper
Date: Fri, 14 Apr 2017 02:11:07 +0200
Message-ID: <20170414001107.GA28754@salvia>
References: <cover.1490955730.git.fgao@ikuai8.com>
 <74aaa9aaa69d65fa46d56faf5c4de671abf4a5cf.1490955730.git.fgao@ikuai8.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org, Gao Feng <fgao@ikuai8.com>
To: gfree.wind@foxmail.com
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:33294 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751718AbdDNALX (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 13 Apr 2017 20:11:23 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id B7C7DC125F
        for <netfilter-devel@vger.kernel.org>; Fri, 14 Apr 2017 02:11:18 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 7B53FDA848
        for <netfilter-devel@vger.kernel.org>; Fri, 14 Apr 2017 02:11:18 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 2400CDA862
        for <netfilter-devel@vger.kernel.org>; Fri, 14 Apr 2017 02:11:12 +0200 (CEST)
Content-Disposition: inline
In-Reply-To: <74aaa9aaa69d65fa46d56faf5c4de671abf4a5cf.1490955730.git.fgao@ikuai8.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Fri, Mar 31, 2017 at 06:38:20PM +0800, gfree.wind@foxmail.com wrote:
> +static struct nf_ct_nat_helper pptp_nat = {
> +	.name			= "pptp_nat",

Why all these with "xyz_nat" names?

This is going to break ctnetlink, as this is the name that identifies
the NAT helper to be used.

> +	.expectfn		= pptp_expectfn,
> +};
> +
>  static void pptp_expectfn(struct nf_conn *ct,
>  			 struct nf_conntrack_expect *exp)
>  {
> @@ -221,7 +229,7 @@ static int exp_gre(struct nf_conn *ct, __be16 callid, __be16 peer_callid)
>  			  &ct->tuplehash[dir].tuple.src.u3,
>  			  &ct->tuplehash[dir].tuple.dst.u3,
>  			  IPPROTO_GRE, &peer_callid, &callid);
> -	exp_orig->expectfn = pptp_expectfn;
> +	exp_orig->nat_helper = &pptp_nat;
>  
>  	/* reply direction, PAC->PNS */
>  	dir = IP_CT_DIR_REPLY;
> @@ -230,7 +238,7 @@ static int exp_gre(struct nf_conn *ct, __be16 callid, __be16 peer_callid)
>  			  &ct->tuplehash[dir].tuple.src.u3,
>  			  &ct->tuplehash[dir].tuple.dst.u3,
>  			  IPPROTO_GRE, &callid, &peer_callid);
> -	exp_reply->expectfn = pptp_expectfn;
> +	exp_reply->nat_helper = &pptp_nat;

Why do we need to attach nat_helper instead of expectfn? I would
prefer we do not.
