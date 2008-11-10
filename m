From: Patrick McHardy <kaber@trash.net>
Subject: Re: NF_IP_PRE_ROUTING,... not defined
Date: Mon, 10 Nov 2008 19:10:50 +0100
Message-ID: <4918792A.2070309@trash.net>
References: <417f50830811100953i6edaa921x53de3710e956c97f@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@vger.kernel.org
To: Giant Sand Fan's <rampxxxx@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:56211 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754196AbYKJSLA (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 10 Nov 2008 13:11:00 -0500
In-Reply-To: <417f50830811100953i6edaa921x53de3710e956c97f@mail.gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Giant Sand Fan's wrote:
> because the #ifndef __KERNEL__ tags goes beyond NT_IP_PRE_ROUTING,..
> defines , this change appears in 2.6.25 (because I works in 2.6.22)
> and I cannot compile my kernel module hook with that version.
> 
> There is a way to do a correct development-compilation with this headers?
> 
> I cannot find anything about this issue.Yes I can move the "#endif"
> but i think that must not be right thing.
> 
> So sorry if I'm out of scope.

The kernel doesn't need these definitions anymore, so they're not
available to avoid people using them.

For external modules that need to compile with multiple version,
you can either add the necessary definitions yourself (the values
are part of the ABI and unchangable) or possibly use the compat
headers from xtables-addons.
