From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH] extensions: libipt_REJECT: Avoid to print the default
 reject with value in the translation
Date: Tue, 15 Mar 2016 01:24:02 +0100
Message-ID: <20160315002402.GA9588@salvia>
References: <20160312172929.GA15987@sonyv>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org, shivanib134@gmail.com,
	outreachy-kernel@googlegroups.com
To: Laura Garcia Liebana <nevola@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:57709 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752110AbcCOAYI (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 14 Mar 2016 20:24:08 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
	by mail.us.es (Postfix) with ESMTP id CB6DE114F48
	for <netfilter-devel@vger.kernel.org>; Tue, 15 Mar 2016 01:24:05 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id BE94FDA8F8
	for <netfilter-devel@vger.kernel.org>; Tue, 15 Mar 2016 01:24:05 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id 6BB94DA8F8
	for <netfilter-devel@vger.kernel.org>; Tue, 15 Mar 2016 01:24:03 +0100 (CET)
Content-Disposition: inline
In-Reply-To: <20160312172929.GA15987@sonyv>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Sat, Mar 12, 2016 at 06:29:32PM +0100, Laura Garcia Liebana wrote:
> Avoid to print the reject with value in the translation when the value is the default.
> 
> Before this patch:
> 
> $ sudo iptables-translate -A FORWARD -p TCP --dport 22 -j REJECT
> nft add rule ip filter FORWARD tcp dport 22 counter reject with icmp type port-unreachable
> 
> After this patch:
> 
> $ sudo iptables-translate -A FORWARD -p TCP --dport 22 -j REJECT
> nft add rule ip filter FORWARD tcp dport 22 counter reject
> 
> Signed-off-by: Laura Garcia Liebana <nevola@gmail.com>
> ---
>  extensions/libipt_REJECT.c | 8 ++++++--
>  1 file changed, 6 insertions(+), 2 deletions(-)
> 
> diff --git a/extensions/libipt_REJECT.c b/extensions/libipt_REJECT.c
> index 4148776..0e9b7d7 100644
> --- a/extensions/libipt_REJECT.c
> +++ b/extensions/libipt_REJECT.c
> @@ -17,6 +17,8 @@
>  #define IPT_ICMP_ADMIN_PROHIBITED	IPT_TCP_RESET + 1
>  #endif
>  
> +#define DEFAULT_REJECT_WITH	IPT_ICMP_PORT_UNREACHABLE

This code is rather easy to read so I'd suggest no need to add this
new definition, instead use IPT_ICMP_PORT_UNREACHABLE.

Thanks.
