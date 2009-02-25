From: Patrick McHardy <kaber@trash.net>
Subject: Re: [PATCH] iptables: Add limits.h to get INT_MIN, INT_MAX, ...
Date: Wed, 25 Feb 2009 08:25:45 +0100
Message-ID: <49A4F279.40000@trash.net>
References: <20090220162831.1d0bf3d4@extreme> <alpine.LSU.2.00.0902210224330.25933@fbirervta.pbzchgretzou.qr> <alpine.LSU.2.00.0902210347001.28533@fbirervta.pbzchgretzou.qr> <49A3FFB0.4050609@trash.net> <alpine.LSU.2.00.0902241622270.6453@fbirervta.pbzchgretzou.qr>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Stephen Hemminger <shemminger@vyatta.com>,
	netfilter-devel@vger.kernel.org
To: Jan Engelhardt <jengelh@medozas.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:53604 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756073AbZBYHZt (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 25 Feb 2009 02:25:49 -0500
In-Reply-To: <alpine.LSU.2.00.0902241622270.6453@fbirervta.pbzchgretzou.qr>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Jan Engelhardt wrote:
> On Tuesday 2009-02-24 15:09, Patrick McHardy wrote:
>>> I wonder what debian has different in its Glibc files that
>>> limits.h is not included like it is for everybody else.
>> It works fine for me on Debian.
> 
> Debian Glibc 2.9_3 also has limits.h removed from bits/socket.h.
> 
>>> Could you try the "limits" branch of git://dev.medozas.de/iptables
>>> if it compiles for you?
>> Unless Stephen has time to test this, I'll apply his patch. This
>> doesn't seem worth loosing time over.
>>
> Please do.

Applied, thanks.
