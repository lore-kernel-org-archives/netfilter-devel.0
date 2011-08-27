From: Jan Engelhardt <jengelh@medozas.de>
Subject: Re: [PATCH] Parsing bug in libxt_conntrack.c 1.4.12
Date: Sat, 27 Aug 2011 18:12:20 +0200 (CEST)
Message-ID: <alpine.LNX.2.01.1108271808570.20178@frira.zrqbmnf.qr>
References: <1313705476.819.29.camel@sami.shorewall.net>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: netfilter-devel@vger.kernel.org
To: Tom Eastep <teastep@shorewall.net>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from seven.medozas.de ([188.40.89.202]:60985 "EHLO seven.medozas.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750908Ab1H0QMW (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Sat, 27 Aug 2011 12:12:22 -0400
In-Reply-To: <1313705476.819.29.camel@sami.shorewall.net>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Friday 2011-08-19 00:11, Tom Eastep wrote:

>Just discovered this little gem:
>
>sami:/home/teastep/iptables# iptables -N foo
>sami:/home/teastep/iptables# iptables -A foo -m conntrack --ctorigdstport 22
>iptables v1.4.12: conntrack rev 2 does not support port ranges
>Try `iptables -h' or 'iptables --help' for more information.
>sami:/home/teastep/iptables# 

Thanks for your reminder (via priv). I have taken your patch, but also 
the liberty to fix the actual cause.

Pending merge, you can see the tree/commits at 
git://dev.medozas.de/iptables fixes-2
