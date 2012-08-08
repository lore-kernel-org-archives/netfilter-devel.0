From: Arif Hossain <aftnix@gmail.com>
Subject: Re: CRYPT target patch for newer kernel ?
Date: Wed, 08 Aug 2012 20:15:26 +0600
Message-ID: <1344435326.4763.36.camel@localhost>
References: <1344428741.4763.21.camel@localhost>
	 <alpine.LNX.2.01.1208081535440.857@frira.zrqbmnf.qr>
	 <1344433984.4763.28.camel@localhost>
	 <alpine.LNX.2.01.1208081613060.1203@frira.zrqbmnf.qr>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel <netfilter-devel@vger.kernel.org>,
	nefilter@vger.kernel.org
To: Jan Engelhardt <jengelh@inai.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-pb0-f46.google.com ([209.85.160.46]:46251 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757380Ab2HHO0Q (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 8 Aug 2012 10:26:16 -0400
In-Reply-To: <alpine.LNX.2.01.1208081613060.1203@frira.zrqbmnf.qr>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Wed, 2012-08-08 at 16:15 +0200, Jan Engelhardt wrote:
<snip>
> You can probably even use IPsec without StrongSWAN, if you manage to 
> knit together the pieces using `ip xfrm state` and `ip xfrm policy`.
> 

I guess i'm not clarifying my issue transparently. The client device is
far from linux or POSIX etc. Its ip stack does not have IPSEC either.
And its a vendor locked thing. We can install userland stuff. nothing
else. And to if i'm not wrong ,to enable IPSEC, we need to first port it
to the client machine. And its not possible and not feasible. We just
want to encrypt the UDP traffic. 

> 
> >Just for an example, we used tls for only the initial session
> >establishment, not the original data, and it proved very inefficient so
> >we had to abandon the thing completely.
> 
> So perhaps you did something really wrong?

Not actually, we did standard stuff. But the the poor and brain dead
processor could not handle it. The speed is ok if you want to surf web,
but its inadequate for real time data. Again i'm talking about a retard
processor with retard amount of memory. 

  
-- 
Cheers

aft
aftnix@gmail.com

