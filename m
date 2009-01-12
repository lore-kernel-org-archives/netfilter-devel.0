From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: doc: escape minus sign in manpages
Date: Mon, 12 Jan 2009 02:36:10 +0100
Message-ID: <496A9E8A.10405@netfilter.org>
References: <alpine.LSU.2.00.0901090313110.16418@fbirervta.pbzchgretzou.qr>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: kaber@trash.net,
	Netfilter Developer Mailing List
	<netfilter-devel@vger.kernel.org>
To: Jan Engelhardt <jengelh@medozas.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:51648 "EHLO us.es"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751907AbZALBg0 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Sun, 11 Jan 2009 20:36:26 -0500
In-Reply-To: <alpine.LSU.2.00.0901090313110.16418@fbirervta.pbzchgretzou.qr>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Jan Engelhardt wrote:
> parent fbb9d345e207d1441922d22e0be86f428c815ae7
> commit 39428b78ecfdbefb941f3eabc63f7e2d8c460e08
> Author: Jan Engelhardt <jengelh@medozas.de>
> Date:   Fri Jan 9 03:09:47 2009 +0100
> 
> doc: escape minus sign in manpages
> 
> groff formats '-' as a hyphen, and '\-' is needed for a minus.
> 
> Signed-off-by: Jan Engelhardt <jengelh@medozas.de>
> ---
[...]
> --- a/extensions/libip6t_HL.man
> +++ b/extensions/libip6t_HL.man
> @@ -7,11 +7,11 @@ table.
>  .PP
>  .B Don't ever set or increment the value on packets that leave your local network!
>  .TP
> -.BI "--hl-set " "value"
> +\fB\-\-hl\-set\fP \fIvalue\fP

I like this change.

> --- a/extensions/libip6t_LOG.man
> +++ b/extensions/libip6t_LOG.man
> @@ -1,31 +1,31 @@
>  Turn on kernel logging of matching packets.  When this option is set
>  for a rule, the Linux kernel will print some information on all
> -matching packets (like most IPv6 IPv6-header fields) via the kernel log
> +matching packets (like most IPv6 IPv6\-header fields) via the kernel log
                                        ^^
But hyphen is fine here.

Could you rework you script to actually change only options to minus?
This would result in a smaller patch.

-- 
"Los honestos son inadaptados sociales" -- Les Luthiers
