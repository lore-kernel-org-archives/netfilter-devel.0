From: Patrick McHardy <kaber@trash.net>
Subject: Re: [PATCH] Fix NAT issue in 2.6.30.4+
Date: Wed, 28 Oct 2009 16:54:23 +0100
Message-ID: <4AE8692F.6050503@trash.net>
References: <alpine.DEB.2.00.0909102134290.12124@blackhole.kfki.hu> <alpine.DEB.2.00.0909171319040.5343@blackhole.kfki.hu> <4AB21C77.1010306@trash.net> <200910221255.15936.thomas.jarosch@intra2net.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@vger.kernel.org
To: Thomas Jarosch <thomas.jarosch@intra2net.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:60333 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752351AbZJ1PyZ (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 28 Oct 2009 11:54:25 -0400
In-Reply-To: <200910221255.15936.thomas.jarosch@intra2net.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Thomas Jarosch wrote:
> On Thursday, 17. September 2009 13:24:39 you wrote:
>> Jozsef Kadlecsik wrote:
>>> On Thu, 17 Sep 2009, Patrick McHardy wrote:
>>>> I got one reject in the removal of nf_conntrack_tcp_update() due
>>>> to the use of write_lock() instead of spin_lock() in your patch
>>>> (seems to be based on an old tree), this is the patch I committed:
>>> Uhh, I forgot to forward-port the patch, sorry: I used the 2.6.30.5
>>> tree for verifying the bug and testing the fix.
>> I double checked and it looks fine, apart from the minor reject.
>> I'll give it some testing myself before pushing upstream.
> 
> Maybe that's something for -stable?
> 
> Kernel 2.6.30.9 still seems affected (the patch applies cleanly).

Yes, I'll pass it on to -stable once its upstream (which should be
very soon now).
