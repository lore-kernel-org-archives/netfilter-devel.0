Return-Path: <SRS0=0Xdd=RL=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_PASS,USER_AGENT_NEOMUTT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 58A3EC43381
	for <netfilter-devel@archiver.kernel.org>; Fri,  8 Mar 2019 17:40:29 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 39F2620868
	for <netfilter-devel@archiver.kernel.org>; Fri,  8 Mar 2019 17:40:29 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726967AbfCHRk2 (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Fri, 8 Mar 2019 12:40:28 -0500
Received: from mail.us.es ([193.147.175.20]:36182 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726887AbfCHRk2 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 8 Mar 2019 12:40:28 -0500
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 7C573D25F4
        for <netfilter-devel@vger.kernel.org>; Fri,  8 Mar 2019 18:40:26 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 694DADA863
        for <netfilter-devel@vger.kernel.org>; Fri,  8 Mar 2019 18:40:26 +0100 (CET)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id 5EB35DA86A; Fri,  8 Mar 2019 18:40:26 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 6ADDFDA863;
        Fri,  8 Mar 2019 18:40:24 +0100 (CET)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Fri, 08 Mar 2019 18:40:24 +0100 (CET)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from us.es (sys.soleta.eu [212.170.55.40])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: 1984lsi)
        by entrada.int (Postfix) with ESMTPSA id 434574265A2F;
        Fri,  8 Mar 2019 18:40:24 +0100 (CET)
Date:   Fri, 8 Mar 2019 18:40:23 +0100
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Karuna Grewal <karunagrewal98@gmail.com>
Cc:     fw@strlen.de, netfilter-devel@vger.kernel.org
Subject: Re: [PATCH nftables] meta: Add support for `time`
Message-ID: <20190308174023.bgyzgvmwxrmcrqcl@salvia>
References: <20190308172944.GA21564@nebula>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190308172944.GA21564@nebula>
User-Agent: NeoMutt/20170113 (1.7.2)
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Fri, Mar 08, 2019 at 10:59:44PM +0530, Karuna Grewal wrote:
> meta `time` can be used to match the timestamp of a packet.

Please, add tests for this to tests/py too.

Thanks.

>  include/linux/netfilter/nf_tables.h | 2 ++
>  src/meta.c                          | 3 +++
>  src/parser_bison.y                  | 1 +
>  src/scanner.l                       | 1 +
>  4 files changed, 7 insertions(+)
> 
> diff --git a/include/linux/netfilter/nf_tables.h b/include/linux/netfilter/nf_tables.h
> index 37036be0..a20fc966 100644
> --- a/include/linux/netfilter/nf_tables.h
> +++ b/include/linux/netfilter/nf_tables.h
> @@ -791,6 +791,7 @@ enum nft_exthdr_attributes {
>   * @NFT_META_SECPATH: boolean, secpath_exists (!!skb->sp)
>   * @NFT_META_IIFKIND: packet input interface kind name (dev->rtnl_link_ops->kind)
>   * @NFT_META_OIFKIND: packet output interface kind name (dev->rtnl_link_ops->kind)
> + * @NFT_META_TSTAMP_NS: packet arrival time (skb->tstamp)
>   */
>  enum nft_meta_keys {
>  	NFT_META_LEN,
> @@ -821,6 +822,7 @@ enum nft_meta_keys {
>  	NFT_META_SECPATH,
>  	NFT_META_IIFKIND,
>  	NFT_META_OIFKIND,
> +	NFT_META_TSTAMP_NS,
>  };
>  
>  /**
> diff --git a/src/meta.c b/src/meta.c
> index 7e44a2a3..1b35e508 100644
> --- a/src/meta.c
> +++ b/src/meta.c
> @@ -450,6 +450,9 @@ const struct meta_template meta_templates[] = {
>  	[NFT_META_OIFKIND]	= META_TEMPLATE("oifkind",   &ifname_type,
>  						IFNAMSIZ * BITS_PER_BYTE,
>  						BYTEORDER_HOST_ENDIAN),
> +	[NFT_META_TSTAMP_NS] = META_TEMPLATE("timestamp", &time_type,
> +						8 * BITS_PER_BYTE,
> +						BYTEORDER_HOST_ENDIAN),
>  };
>  
>  static bool meta_key_is_unqualified(enum nft_meta_keys key)
> diff --git a/src/parser_bison.y b/src/parser_bison.y
> index b20be3a8..58914486 100644
> --- a/src/parser_bison.y
> +++ b/src/parser_bison.y
> @@ -3874,6 +3874,7 @@ meta_key_unqualified	:	MARK		{ $$ = NFT_META_MARK; }
>  			|       OIFGROUP	{ $$ = NFT_META_OIFGROUP; }
>  			|       CGROUP		{ $$ = NFT_META_CGROUP; }
>  			|       IPSEC		{ $$ = NFT_META_SECPATH; }
> +			|	TIMESTAMP	{ $$ = NFT_META_TSTAMP_NS; }
>  			;
>  
>  meta_stmt		:	META	meta_key	SET	stmt_expr
> diff --git a/src/scanner.l b/src/scanner.l
> index 6f83aa11..bfb8c558 100644
> --- a/src/scanner.l
> +++ b/src/scanner.l
> @@ -507,6 +507,7 @@ addrstring	({macaddr}|{ip4addr}|{ip6addr})
>  "iifgroup"		{ return IIFGROUP; }
>  "oifgroup"		{ return OIFGROUP; }
>  "cgroup"		{ return CGROUP; }
> +"time"			{ return TIMESTAMP; }
>  
>  "classid"		{ return CLASSID; }
>  "nexthop"		{ return NEXTHOP; }
> -- 
> 2.17.1
> 
