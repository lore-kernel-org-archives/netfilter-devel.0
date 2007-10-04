From: Patrick McHardy <kaber@trash.net>
Subject: Re: Addrtype match: renaming functions
Date: Thu, 04 Oct 2007 07:00:05 +0200
Message-ID: <47047355.30005@trash.net>
References: <4703b9ed.Kwc375N0W4hwnpA7%panther@balabit.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@vger.kernel.org
To: Laszlo Attila Toth <panther@balabit.hu>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:39826 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751221AbXJDFAs (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 4 Oct 2007 01:00:48 -0400
In-Reply-To: <4703b9ed.Kwc375N0W4hwnpA7%panther@balabit.hu>
Sender: netfilter-devel-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

Laszlo Attila Toth wrote:
> Hello,
> 
> The function names in libipt_addrtype.c makes debugging hard, also I renamed them
> prefixed by 'addrtype_'.


Applied, thanks Laszlo.


> @@ -191,11 +191,11 @@
>  	.version 	= IPTABLES_VERSION,
>  	.size 		= IPT_ALIGN(sizeof(struct ipt_addrtype_info)),
>  	.userspacesize 	= IPT_ALIGN(sizeof(struct ipt_addrtype_info)),
> -	.help 		= &help,
> -	.parse 		= &parse,
> -	.final_check 	= &final_check,
> -	.print 		= &print,
> -	.save 		= &save,
> +	.help 		= &addrtype_help,
> +	.parse 		= &addrtype_parse,
> +	.final_check 	= &addrtype_final_check,
> +	.print 		= &addrtype_print,
> +	.save 		= &addrtype_save,


Just a hint for future patches: the & is not required, I personally
prefer to omit them. Not worth sending another patch though.
