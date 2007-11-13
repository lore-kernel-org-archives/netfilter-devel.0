From: Patrick McHardy <kaber@trash.net>
Subject: Re: [NETFILTER]: Unable to delete a SAME rule (Using SAME target
 problems)
Date: Tue, 13 Nov 2007 16:37:20 +0100
Message-ID: <4739C4B0.9070009@trash.net>
References: <47399B38.8090805@sw.ru>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@vger.kernel.org,
	johnpeng <johnpeng@unitytek.com.tw>
To: devel@openvz.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:48992 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754498AbXKMPiF (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 13 Nov 2007 10:38:05 -0500
In-Reply-To: <47399B38.8090805@sw.ru>
Sender: netfilter-devel-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

Konstantin Khorenko wrote:
> Dear all,
> 
> The problem description: unable to delete a SAME target rule.
> 
> [...]
> At the moment i can see only 3 ways of fixing this:
> * reassemble struct ipt_same_info - put 'ipnum' and 'iparray' at the end of the
> structure. This will save generic code both in kernel and userspace.
> 
> * let struct ipt_same_info be as is, teach userspace to manipulate more complex
> masks (not only first X bytes of the structure)
> 
> * let struct ipt_same_info be as is, teach kernel to zero pointers and all the
> fields which are used only in kernel.
> 
> All these ways are quite painful, but could someone please comment this - may
> be i just missed and some decision had been already done on this issue?


Actually yes, thats why haven't got compat support for SAME yet.
Because of these issues and since SAME is obsolete nowadays I've
decided to put it on feature-removal-schedule instead of trying
to work around the problems, it will be removed at 1.1.08:

What:   iptables SAME target 

When:   1.1. 2008
Files:  net/ipv4/netfilter/ipt_SAME.c, 
include/linux/netfilter_ipv4/ipt_SAME.h
Why:    Obsolete for multiple years now, NAT core provides the same 
behaviour.
         Unfixable broken wrt. 32/64 bit cleanness.
Who:    Patrick McHardy <kaber@trash.net>
