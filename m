From: Jan Engelhardt <jengelh@medozas.de>
Subject: Re: [PATCH] More secure SYSRQ for xtables-addons
Date: Tue, 2 Dec 2008 02:53:37 +0100 (CET)
Message-ID: <alpine.LNX.1.10.0812020241170.23359@fbirervta.pbzchgretzou.qr>
References: <492E926D.5020807@oracle.com> <493491D3.50708@trash.net>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: John Haxby <john.haxby@oracle.com>,
	Netfilter Development Mailinglist
	<netfilter-devel@vger.kernel.org>
To: Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from sovereign.computergmbh.de ([85.214.69.204]:53160 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752364AbYLBBxi (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 1 Dec 2008 20:53:38 -0500
In-Reply-To: <493491D3.50708@trash.net>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


On Tuesday 2008-12-02 02:39, Patrick McHardy wrote:
>> 
>> I want to be able to use SYSRQ to reboot, crash or partially diagnose
>> machines that become unresponsive for one reason or another.   These
>> machines, typically, are blades or rack mounted machines that do not have a
>> PS/2 connection for a keyboard and the old method of wheeling round a "crash
>> trolley" that has a monitor and a keyboard on it no longer works:  USB
>> keyboards rarely, if ever, work because by the time the machine is responding
>> only to a ping, udev is incapable of setting up a new
>> keyboard.g/majordomo-info.html
>
> This module is starting to look kind of useful. Maybe its time for
> a resubmission for review and possibly merging once these patches
> are included.
>
> If we were to merge it, it would also be good to get some feedback
> from the crypto guys about whether the chosen authentication scheme
> meets its claims.
>
It looks similar to RFC 2617 HA1 generation. Should be ok.
In paranoia mode, the administrator can always change the
password after using it (effectively making it some sort of OTP).

On the other hand, xt_SYSRQ could, theoretically, also do a full
three-way authentication instead of the SPA it currently does. But I
think that is a bit of overkill.
