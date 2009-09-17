From: Patrick McHardy <kaber@trash.net>
Subject: Re: [PATCH] Fix NAT issue in 2.6.30.4+
Date: Thu, 17 Sep 2009 13:24:39 +0200
Message-ID: <4AB21C77.1010306@trash.net>
References: <alpine.DEB.2.00.0909102134290.12124@blackhole.kfki.hu> <4AB2184F.9090208@trash.net> <alpine.DEB.2.00.0909171319040.5343@blackhole.kfki.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@vger.kernel.org
To: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:58544 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755115AbZIQLYj (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 17 Sep 2009 07:24:39 -0400
In-Reply-To: <alpine.DEB.2.00.0909171319040.5343@blackhole.kfki.hu>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Jozsef Kadlecsik wrote:
> On Thu, 17 Sep 2009, Patrick McHardy wrote:
> 
>> I got one reject in the removal of nf_conntrack_tcp_update() due
>> to the use of write_lock() instead of spin_lock() in your patch
>> (seems to be based on an old tree), this is the patch I committed:
> 
> Uhh, I forgot to forward-port the patch, sorry: I used the 2.6.30.5 tree 
> for verifying the bug and testing the fix.

I double checked and it looks fine, apart from the minor reject.
I'll give it some testing myself before pushing upstream.
