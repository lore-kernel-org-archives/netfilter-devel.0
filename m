From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH 1/4] iptables: iptables: Add blank line after declaration
Date: Fri, 7 Apr 2017 18:12:19 +0200
Message-ID: <20170407161219.GA9327@salvia>
References: <20170331161351.26141-1-arushisinghal19971997@gmail.com>
 <20170331161351.26141-2-arushisinghal19971997@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Arushi Singhal <arushisinghal19971997@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:38326 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S934217AbdDGQM3 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 7 Apr 2017 12:12:29 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 137641373A5
        for <netfilter-devel@vger.kernel.org>; Fri,  7 Apr 2017 18:12:25 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 05C5FDA729
        for <netfilter-devel@vger.kernel.org>; Fri,  7 Apr 2017 18:12:25 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id D2452DA7E9
        for <netfilter-devel@vger.kernel.org>; Fri,  7 Apr 2017 18:12:22 +0200 (CEST)
Content-Disposition: inline
In-Reply-To: <20170331161351.26141-2-arushisinghal19971997@gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Fri, Mar 31, 2017 at 09:43:48PM +0530, Arushi Singhal wrote:
> Add blank line after the declaration of variable to follow kernel coding
> style.
> 
> Signed-off-by: Arushi Singhal <arushisinghal19971997@gmail.com>
> ---
>  iptables/getethertype.c | 1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/iptables/getethertype.c b/iptables/getethertype.c
> index 027ef4a..bf3e408 100644
> --- a/iptables/getethertype.c
> +++ b/iptables/getethertype.c
> @@ -75,6 +75,7 @@ struct ethertypeent *getethertypeent(void)
>  {
>  	char *e;
>  	char *endptr;
> +
>  	register char *cp, **q;

I don't see any need for this new empty line.
