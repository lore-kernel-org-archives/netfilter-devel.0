From: Jan Engelhardt <jengelh@medozas.de>
Subject: Re: [PATCH] iptables: Add limits.h to get INT_MIN, INT_MAX, ...
Date: Sat, 21 Feb 2009 03:51:26 +0100 (CET)
Message-ID: <alpine.LSU.2.00.0902210347001.28533@fbirervta.pbzchgretzou.qr>
References: <20090220162831.1d0bf3d4@extreme> <alpine.LSU.2.00.0902210224330.25933@fbirervta.pbzchgretzou.qr>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Patrick McHardy <kaber@trash.net>, netfilter-devel@vger.kernel.org
To: Stephen Hemminger <shemminger@vyatta.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from sovereign.computergmbh.de ([85.214.69.204]:51547 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752841AbZBUCv3 (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 20 Feb 2009 21:51:29 -0500
In-Reply-To: <alpine.LSU.2.00.0902210224330.25933@fbirervta.pbzchgretzou.qr>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


On Saturday 2009-02-21 02:25, Jan Engelhardt wrote:
>On Saturday 2009-02-21 01:28, Stephen Hemminger wrote:
>
>>Fix build failure of iptables utilities on debian/ubuntu, maybe other distros.
>>The values INT_MIN and INT_MAX are used by many filters and these
>>are defined in limits.h
>
>No this is not right IMO, limits.h should be included for the same 
>reason you would not do that to kernel's .h files.
>Instead, limits.h should go in the .c files.

I wonder what debian has different in its Glibc files that
limits.h is not included like it is for everybody else.

Anyway, of course it should be included where due.
Gawd, that led me to have clean some unnecessary includes
up beforehand, but oh well.

Could you try the "limits" branch of git://dev.medozas.de/iptables
if it compiles for you?


Jan
