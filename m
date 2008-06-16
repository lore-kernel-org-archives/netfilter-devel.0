From: Patrick McHardy <kaber@trash.net>
Subject: Re: arptables issue with user-defined chains and -j RETURN
Date: Mon, 16 Jun 2008 09:28:49 +0200
Message-ID: <48561631.4040807@trash.net>
References: <484EAE6E.30206@somanetworks.com>  <484F6D62.8020602@trash.net> <1213466540.2945.13.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Ben Gamsa <ben@somanetworks.com>, netfilter-devel@vger.kernel.org
To: Bart De Schuymer <bdschuym@pandora.be>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:54706 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752202AbYFPH2y (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 16 Jun 2008 03:28:54 -0400
In-Reply-To: <1213466540.2945.13.camel@localhost.localdomain>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Bart De Schuymer wrote:
> Op wo, 11-06-2008 te 08:14 +0200, schreef Patrick McHardy:
>> I think the error is in userspace, it shouldn't define the value
>> dependant on a non-fixed value. If the kernel did this as well
>> before the intoduction of x_tables (which defined ARPT_RETURN
>> to XT_RETURN), compatibility was already broken by the introduction
>> of NF_STOP a long time ago. So I think the correct fix is to
>> resync the arp_tables userspace header files with the kernel.
> 
> Things compile fine from CVS using the KERNEL_DIR directive with your
> favorite kernel source.
> I'm having more trouble than I like getting things to compile by just
> also including x_tables.h in the local arptables directory (__be16 isn't
> defined). I guess my /usr/include/linux directory isn't up-to-date. Is
> there any directive about this? How does iptables cope with this?


For iptables we ended up adding the types.h file to the
iptables source. I think arptables should do the same
to support compilation on old systems.
