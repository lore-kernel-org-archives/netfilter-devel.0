From: Patrick McHardy <kaber@trash.net>
Subject: Re: Missing GPL headers
Date: Fri, 26 Feb 2010 16:06:43 +0100
Message-ID: <4B87E383.4020804@trash.net>
References: <4B87A59F.60602@redhat.com> <alpine.LSU.2.01.1002261154001.29558@obet.zrqbmnf.qr>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Cc: Thomas Woerner <twoerner@redhat.com>,
	Netfilter Development Mailinglist
	<netfilter-devel@vger.kernel.org>
To: Jan Engelhardt <jengelh@medozas.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:57698 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964942Ab0BZPGo (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 26 Feb 2010 10:06:44 -0500
In-Reply-To: <alpine.LSU.2.01.1002261154001.29558@obet.zrqbmnf.qr>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Jan Engelhardt wrote:
> On Friday 2010-02-26 11:42, Thomas Woerner wrote:
> 
>> Hello,
>>
>> lots of files in the iptables tree are missing the GPL header but contain
>> copyright messages.
> 
> I don't speak authoritatively, but the Linux kernel also has some files 
> - usually those dating back to the initial years of Linux - that have no 
> GPL header either, and everybody seems to be fine with that. See 
> kernel/exit.c.

Yeah, the COPYING file states GPL-2, that applies to all files which
don't carry a seperate copyright statement.
