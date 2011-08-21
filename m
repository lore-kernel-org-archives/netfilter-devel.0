From: Jan Engelhardt <jengelh@medozas.de>
Subject: Re: [PATCH 1/6] libxt_u32: fix missing allowance for inversion
Date: Sun, 21 Aug 2011 09:25:38 +0200 (CEST)
Message-ID: <alpine.LNX.2.01.1108210917340.11614@frira.zrqbmnf.qr>
References: <1313868294-21471-1-git-send-email-jengelh@medozas.de> <1313868294-21471-2-git-send-email-jengelh@medozas.de> <CAA93jw6mpDL6rLXM+9SpAhafkDdKoSfhAxU8UM87vUqjuzjYJw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: kaber@trash.net, netfilter-devel@vger.kernel.org
To: Dave Taht <dave.taht@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from seven.medozas.de ([188.40.89.202]:36028 "EHLO seven.medozas.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750878Ab1HUHZk (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Sun, 21 Aug 2011 03:25:40 -0400
In-Reply-To: <CAA93jw6mpDL6rLXM+9SpAhafkDdKoSfhAxU8UM87vUqjuzjYJw@mail.gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


[oh, the mailing list daemon seems unresponsive for I have not 
received the 2nd copy, and neither did the web crawlers...]


On Saturday 2011-08-20 23:40, Dave Taht wrote:

>I keep seeing inversion match fixes go by on this version of iptables. I ran
>across one also, on the port to cerowrt of this version of iptables, in the
>"dscp" tables matches.
>
>http://www.bufferbloat.net/issues/216#note-48
>
>but have not poked into it further (am travelling). Fixed?

This is unfortunate indeed, but somewhat owed to the fact that this was 
not encoded reliably previously, in other words, negations were 
sometimes erroneously allowed as each match checked for this themselves. 

With the move to the Guided Option Parser, negation became centrally 
checked and thus needs to be explicit mentioned. With the initial 
conversion to GOP, I may have missed adding XTOPT_INVERT in some cases 
because of that repetitive action.

Yeah, there are other extensions (xt_dccp) that I have come across in my 
audit sweep of all extensions so far.
