From: Eric Dumazet <eric.dumazet@gmail.com>
Subject: Re: `iptables -m tcp --syn` doesn't do what the man says
Date: Sun, 01 Apr 2012 19:53:31 +0200
Message-ID: <1333302811.2325.5397.camel@edumazet-glaptop>
References: <4F761E8E.9000708@gmail.com>  <20120401174240.GA11306@1984>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Cc: Artyom Gavrichenkov <ximaera@gmail.com>,
	netfilter-devel@vger.kernel.org
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-we0-f174.google.com ([74.125.82.174]:49599 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751769Ab2DARxf (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Sun, 1 Apr 2012 13:53:35 -0400
Received: by wejx9 with SMTP id x9so1297207wej.19
        for <netfilter-devel@vger.kernel.org>; Sun, 01 Apr 2012 10:53:34 -0700 (PDT)
In-Reply-To: <20120401174240.GA11306@1984>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Sun, 2012-04-01 at 19:42 +0200, Pablo Neira Ayuso wrote:

> I understand your concern, but the info in the manpage is correct:
> basically, it can be extracted from it that --syn will not match
> SYN+FIN packets.
> 
> As you point in your patch, you have to use:
> 
> --tcp-flags  SYN,RST,ACK  SYN
> 
> in your rule-set for the situation that you describe.
> 
> Changing the default behaviour of --syn to catch this case is
> delicate, I don't want to break backward compatibility.

Agreed.

With TCP Fast Open, it might be possible to send a SYN+FIN+cookies+DATA
in a single frame.



