From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH 3/5, V2, libnftnl] Implement rule comparison
Date: Mon, 8 Aug 2016 16:50:42 +0200
Message-ID: <20160808145042.GC6264@salvia>
References: <20160808111758.4062-1-carlosfg@riseup.net>
 <20160808124235.11135-1-carlosfg@riseup.net>
 <20160808124235.11135-3-carlosfg@riseup.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8bit
Cc: netfilter-devel@vger.kernel.org
To: Carlos Falgueras =?iso-8859-1?Q?Garc=EDa?= <carlosfg@riseup.net>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:44230 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751479AbcHHOuw (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 8 Aug 2016 10:50:52 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
	by mail.us.es (Postfix) with ESMTP id DC1AD1F18CE
	for <netfilter-devel@vger.kernel.org>; Mon,  8 Aug 2016 16:50:49 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id CEFD01B328C
	for <netfilter-devel@vger.kernel.org>; Mon,  8 Aug 2016 16:50:49 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id C0C401B3546
	for <netfilter-devel@vger.kernel.org>; Mon,  8 Aug 2016 16:50:47 +0200 (CEST)
Content-Disposition: inline
In-Reply-To: <20160808124235.11135-3-carlosfg@riseup.net>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Mon, Aug 08, 2016 at 02:42:33PM +0200, Carlos Falgueras García wrote:
> diff --git a/src/libnftnl.map b/src/libnftnl.map
> index c38e081..faaa90d 100644
> --- a/src/libnftnl.map
> +++ b/src/libnftnl.map
> @@ -527,4 +527,7 @@ LIBNFTNL_4.1 {
>  	nftnl_udata_get;
>  	nftnl_udata_next;
>  	nftnl_udata_parse;
> +
> +	nftnl_rule_cmp;
> +	nftnl_expr_cmp;

You have to place this in LIBNFTNL_4.2, but LIBNFTNL_4.2 should
inherit from LIBNFTNL_4.1.

>  } LIBNFTNL_4;

