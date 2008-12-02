From: Patrick McHardy <kaber@trash.net>
Subject: Re: [PATCH] More secure SYSRQ for xtables-addons
Date: Tue, 02 Dec 2008 02:39:31 +0100
Message-ID: <493491D3.50708@trash.net>
References: <492E926D.5020807@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Cc: John Haxby <john.haxby@oracle.com>,
	Netfilter Development Mailinglist
	<netfilter-devel@vger.kernel.org>
To: Jan Engelhardt <jengelh@medozas.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:58999 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752146AbYLBBjf (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 1 Dec 2008 20:39:35 -0500
In-Reply-To: <492E926D.5020807@oracle.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

John Haxby wrote:
> Rationale:
> 
> I want to be able to use SYSRQ to reboot, crash or partially diagnose 
> machines that become unresponsive for one reason or another.   These 
> machines, typically, are blades or rack mounted machines that do not 
> have a PS/2 connection for a keyboard and the old method of wheeling 
> round a "crash trolley" that has a monitor and a keyboard on it no 
> longer works:  USB keyboards rarely, if ever, work because by the time 
> the machine is responding only to a ping, udev is incapable of setting 
> up a new keyboard.g/majordomo-info.html

This module is starting to look kind of useful. Maybe its time for
a resubmission for review and possibly merging once these patches
are included.

If we were to merge it, it would also be good to get some feedback
from the crypto guys about whether the chosen authentication scheme
meets its claims.
