From: Patrick McHardy <kaber@trash.net>
Subject: Re: Automatically load modules in iptables-save
Date: Fri, 20 Mar 2009 19:42:04 +0100
Message-ID: <49C3E37C.50107@trash.net>
References: <20090316171014.GG31952@ralph.linux2go.dk> <20090319125532.GC20472@ralph.linux2go.dk> <49C24332.2020107@trash.net> <20090319135006.GD20472@ralph.linux2go.dk> <alpine.LSU.2.00.0903191452550.27642@fbirervta.pbzchgretzou.qr> <20090319142935.GE20472@ralph.linux2go.dk> <alpine.LSU.2.00.0903191530310.31487@fbirervta.pbzchgretzou.qr> <20090319154301.GF20472@ralph.linux2go.dk> <alpine.LSU.2.00.0903191701060.14674@fbirervta.pbzchgretzou.qr>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Soren Hansen <soren@ubuntu.com>, netfilter-devel@vger.kernel.org
To: Jan Engelhardt <jengelh@medozas.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:35190 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754314AbZCTSmM (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 20 Mar 2009 14:42:12 -0400
In-Reply-To: <alpine.LSU.2.00.0903191701060.14674@fbirervta.pbzchgretzou.qr>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Jan Engelhardt wrote:
> Here is a reworked version that also adds the missing IPv6
> and manpage bits, pullable from the usual place at
> 
>  git://dev.medozas.de/iptables master
> 
> ---8<---
> iptables-save: module loading corrections
> 
> 1. Ignore the absence of /proc/net/ip_tables_names, which happens
> when x_tables.ko is not loaded. This is equivalent to having
> x_tables.ko, but no tabe modules, loaded. As such, success should
> be returned.
> 
> 2. Load table when explicitly requested by the -t option. Users might
> expect "*foo" etc. to be output when `iptables-save -t foo` is
> executed. So do autoload x_tables.ko and the table in this case.
> 
> *. Do this for both iptables-save and ip6tables-save, and adjust
> the manpages for the new -M (modprobe program location) option that
> is introduced.
> 
> Based upon a patch by Soren Hansen.

Looks good, thanks Jan. Pulled and pushed out.
