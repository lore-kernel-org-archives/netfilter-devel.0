From: Jan Engelhardt <jengelh@inai.de>
Subject: Re: CRYPT target patch for newer kernel ?
Date: Wed, 8 Aug 2012 17:34:49 +0200 (CEST)
Message-ID: <alpine.LNX.2.01.1208081733550.2908@frira.zrqbmnf.qr>
References: <1344428741.4763.21.camel@localhost>  <alpine.LNX.2.01.1208081535440.857@frira.zrqbmnf.qr>  <1344433984.4763.28.camel@localhost>  <alpine.LNX.2.01.1208081613060.1203@frira.zrqbmnf.qr> <1344435326.4763.36.camel@localhost>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: netfilter-devel <netfilter-devel@vger.kernel.org>,
	nefilter@vger.kernel.org
To: Arif Hossain <aftnix@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from seven.medozas.de ([5.9.24.206]:51838 "EHLO seven.medozas.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S964895Ab2HHPew (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 8 Aug 2012 11:34:52 -0400
In-Reply-To: <1344435326.4763.36.camel@localhost>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Wednesday 2012-08-08 16:15, Arif Hossain wrote:

>On Wed, 2012-08-08 at 16:15 +0200, Jan Engelhardt wrote:
><snip>
>> You can probably even use IPsec without StrongSWAN, if you manage to 
>> knit together the pieces using `ip xfrm state` and `ip xfrm policy`.
>> 
>
>I guess i'm not clarifying my issue transparently. The client device is
>far from linux or POSIX etc. Its ip stack does not have IPSEC either.
>And its a vendor locked thing. We can install userland stuff. nothing
>else. And to if i'm not wrong ,to enable IPSEC, we need to first port it
>to the client machine. And its not possible and not feasible. We just
>want to encrypt the UDP traffic. 

If it is not linux, it's pretty much irrelevant for this discussion 
group.
