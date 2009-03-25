From: Patrick McHardy <kaber@trash.net>
Subject: Re: nftables-goes-automake patch series
Date: Wed, 25 Mar 2009 17:30:58 +0100
Message-ID: <49CA5C42.6020204@trash.net>
References: <1237937468-31476-1-git-send-email-jengelh@medozas.de> <49CA2D68.20601@trash.net> <alpine.LSU.2.00.0903251447320.13559@fbirervta.pbzchgretzou.qr> <49CA40B2.5010300@trash.net> <alpine.LSU.2.00.0903251540140.19598@fbirervta.pbzchgretzou.qr>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@vger.kernel.org
To: Jan Engelhardt <jengelh@medozas.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:34176 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753319AbZCYQbF (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 25 Mar 2009 12:31:05 -0400
In-Reply-To: <alpine.LSU.2.00.0903251540140.19598@fbirervta.pbzchgretzou.qr>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Jan Engelhardt wrote:
> On Wednesday 2009-03-25 15:33, Patrick McHardy wrote:
>>>> About automake - I'm glad you're fixing up the makefiles, but I'm
>>>> quite attached to the silent build and the automake version that
>>>> comes with Debian unstable is 1.10, so I assume it won't be
>>>> silent anymore.
>>> I do have a patch for 1.10 too, if you need.
>> I don't really want to compile my own automake. Can't we just keep
>> the silent build in combination with automake?
> 
> I am afraid I am not aware of any Makefile construct that would allow us 
> to have such (i.e. silent-by-default, and enabled with V=1) without 
> having to override the .c.o rules automake would normally provide.
> Overriding $(CC) is not going to work.

Well, I guess I'll give your patch to automake 1.10 a try.
