From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH 1/2 libnftnl] expr: Improve bound checking in
 stringification functions
Date: Mon, 15 Aug 2016 12:32:21 +0200
Message-ID: <20160815103221.GA5883@salvia>
References: <20160815091239.GC3905@salvia>
 <20160815102737.11955-1-carlosfg@riseup.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8bit
Cc: netfilter-devel@vger.kernel.org
To: Carlos Falgueras =?iso-8859-1?Q?Garc=EDa?= <carlosfg@riseup.net>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:59972 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752650AbcHOKca (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 15 Aug 2016 06:32:30 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
	by mail.us.es (Postfix) with ESMTP id 990CFA4170
	for <netfilter-devel@vger.kernel.org>; Mon, 15 Aug 2016 12:32:28 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id 8B1DADA7FB
	for <netfilter-devel@vger.kernel.org>; Mon, 15 Aug 2016 12:32:28 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id 8FE9FDA7FE
	for <netfilter-devel@vger.kernel.org>; Mon, 15 Aug 2016 12:32:26 +0200 (CEST)
Content-Disposition: inline
In-Reply-To: <20160815102737.11955-1-carlosfg@riseup.net>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Mon, Aug 15, 2016 at 12:27:36PM +0200, Carlos Falgueras García wrote:
> --- a/src/utils.c
> +++ b/src/utils.c
> @@ -23,6 +23,7 @@
>  #include <linux/netfilter/nf_tables.h>
>  
>  static const char *const nftnl_family_str[NFPROTO_NUMPROTO] = {
> +	[NFPROTO_UNSPEC]	= "unknown",
>  	[NFPROTO_INET]		= "inet",
>  	[NFPROTO_IPV4]		= "ip",
>  	[NFPROTO_ARP]		= "arp",
> @@ -33,7 +34,7 @@ static const char *const nftnl_family_str[NFPROTO_NUMPROTO] = {
>  
>  const char *nftnl_family2str(uint32_t family)
>  {
> -	if (nftnl_family_str[family] == NULL)
> +	if (family >= NFPROTO_NUMPROTO || !nftnl_family_str[family])
>  		return "unknown";
>  
>  	return nftnl_family_str[family];

You only need this chunk.

Other spots have continuous enums, so there is no problem.
