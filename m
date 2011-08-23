From: Jan Engelhardt <jengelh@medozas.de>
Subject: Re: [PATCH 1/6] libxt_u32: fix missing allowance for inversion
Date: Tue, 23 Aug 2011 09:34:00 +0200 (CEST)
Message-ID: <alpine.LNX.2.01.1108230933290.11455@frira.zrqbmnf.qr>
References: <1313868294-21471-1-git-send-email-jengelh@medozas.de> <1313868294-21471-2-git-send-email-jengelh@medozas.de> <CAA93jw6mpDL6rLXM+9SpAhafkDdKoSfhAxU8UM87vUqjuzjYJw@mail.gmail.com> <alpine.LNX.2.01.1108210917340.11614@frira.zrqbmnf.qr>
 <CAA93jw7sjY=QtBo=QDhG3Z3goHA1zAbVoD-JrqeuASQSzt2nwA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: kaber@trash.net, netfilter-devel@vger.kernel.org
To: Dave Taht <dave.taht@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from seven.medozas.de ([188.40.89.202]:41092 "EHLO seven.medozas.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752068Ab1HWHeE (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 23 Aug 2011 03:34:04 -0400
In-Reply-To: <CAA93jw7sjY=QtBo=QDhG3Z3goHA1zAbVoD-JrqeuASQSzt2nwA@mail.gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


On Monday 2011-08-22 18:31, Dave Taht wrote:
>>
>> Yeah, there are other extensions (xt_dccp) that I have come across in my
>> audit sweep of all extensions so far.
>
>I saw the fixes to dccp go by today, but where I'd hit the problem was
>with the 'dscp' matches. I have a test implementation of diffserv (
>https://github.com/dtaht/Diffserv ) where a quick test against this
>release of iptables showed the inversion regression as per the above
>bug note...

The last sent batch contains fixes across the board, including
dscp, dccp, and some others.
