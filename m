From: Thomas Jarosch <thomas.jarosch@intra2net.com>
Subject: Re: [PATCH] Fix NAT issue in 2.6.30.4+
Date: Thu, 22 Oct 2009 12:55:15 +0200
Message-ID: <200910221255.15936.thomas.jarosch@intra2net.com>
References: <alpine.DEB.2.00.0909102134290.12124@blackhole.kfki.hu> <alpine.DEB.2.00.0909171319040.5343@blackhole.kfki.hu> <4AB21C77.1010306@trash.net>
Mime-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Cc: Patrick McHardy <kaber@trash.net>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from rs02.intra2net.com ([81.169.173.116]:38063 "EHLO
	rs02.intra2net.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753837AbZJVLQd (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 22 Oct 2009 07:16:33 -0400
In-Reply-To: <4AB21C77.1010306@trash.net>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Thursday, 17. September 2009 13:24:39 you wrote:
> Jozsef Kadlecsik wrote:
> > On Thu, 17 Sep 2009, Patrick McHardy wrote:
> >> I got one reject in the removal of nf_conntrack_tcp_update() due
> >> to the use of write_lock() instead of spin_lock() in your patch
> >> (seems to be based on an old tree), this is the patch I committed:
> >
> > Uhh, I forgot to forward-port the patch, sorry: I used the 2.6.30.5
> > tree for verifying the bug and testing the fix.
> 
> I double checked and it looks fine, apart from the minor reject.
> I'll give it some testing myself before pushing upstream.

Maybe that's something for -stable?

Kernel 2.6.30.9 still seems affected (the patch applies cleanly).

Cheers,
Thomas
