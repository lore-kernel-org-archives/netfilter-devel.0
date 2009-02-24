From: Jan Engelhardt <jengelh@medozas.de>
Subject: Re: [PATCH] iptables: Add limits.h to get INT_MIN, INT_MAX, ...
Date: Tue, 24 Feb 2009 16:22:54 +0100 (CET)
Message-ID: <alpine.LSU.2.00.0902241622270.6453@fbirervta.pbzchgretzou.qr>
References: <20090220162831.1d0bf3d4@extreme> <alpine.LSU.2.00.0902210224330.25933@fbirervta.pbzchgretzou.qr> <alpine.LSU.2.00.0902210347001.28533@fbirervta.pbzchgretzou.qr> <49A3FFB0.4050609@trash.net>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Stephen Hemminger <shemminger@vyatta.com>,
	netfilter-devel@vger.kernel.org
To: Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from sovereign.computergmbh.de ([85.214.69.204]:60220 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754493AbZBXPW5 (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 24 Feb 2009 10:22:57 -0500
In-Reply-To: <49A3FFB0.4050609@trash.net>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


On Tuesday 2009-02-24 15:09, Patrick McHardy wrote:
>> I wonder what debian has different in its Glibc files that
>> limits.h is not included like it is for everybody else.
>
> It works fine for me on Debian.

Debian Glibc 2.9_3 also has limits.h removed from bits/socket.h.

>> Could you try the "limits" branch of git://dev.medozas.de/iptables
>> if it compiles for you?
>
> Unless Stephen has time to test this, I'll apply his patch. This
> doesn't seem worth loosing time over.
>
Please do.
