From: Nicola Padovano <nicola.padovano@gmail.com>
Subject: Re: get tcp header
Date: Tue, 7 Sep 2010 13:31:12 +0200
Message-ID: <AANLkTimBRXYHv63w90h83k13GQDHdjmXd=ES+2iFyHmG@mail.gmail.com>
References: <AANLkTikz7+MsnB4B0PPLX6ypGaLLnpcXgaXryctaT2LW@mail.gmail.com>
 <alpine.LNX.2.01.1008312034240.10509@obet.zrqbmnf.qr> <AANLkTikQoVP_c6JfoSjz46WrARzP1QEEeuoabSdRjk8A@mail.gmail.com>
 <AANLkTinQvTBiw7Gno42xdRdgF5_aCGb8BdEo82ocoY2e@mail.gmail.com>
 <alpine.LNX.2.01.1009011251590.20617@obet.zrqbmnf.qr> <AANLkTinOVgpRO8TcLVKfypTWtbK3MSzamyMwfm0E8dYL@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: netfilter-devel <netfilter-devel@vger.kernel.org>
To: Jan Engelhardt <jengelh@medozas.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-wy0-f174.google.com ([74.125.82.174]:55979 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755996Ab0IGLiL (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 7 Sep 2010 07:38:11 -0400
Received: by wyf22 with SMTP id 22so4131096wyf.19
        for <netfilter-devel@vger.kernel.org>; Tue, 07 Sep 2010 04:38:10 -0700 (PDT)
In-Reply-To: <AANLkTinOVgpRO8TcLVKfypTWtbK3MSzamyMwfm0E8dYL@mail.gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

(I'm not sure I sent this mail, sorry if you already have one)

ME: in general: when i can use the skb_transport_header function?

JAN: When a transport header pointer has been set. Which is when the
appropriate layer-X function has processed it. (After ip_rcv for
example)
On the output path, since it goes in the reverse direction, it will
always be set.

so, today i checked this.
this is my iptables rule:

iptables -t filter -A OUTPUT -d 192.168.0.1 -p tcp -j TAR

and this is the code's lines of xt_TAR module

printk(KERN_INFO "xt_TAR-----> tcp header: %p\n",skb_transport_header(skb));
printk(KERN_INFO "xt_TAR-----> ip header: %p\n",skb_network_header(skb));

but the skb_transport_header returns the same value of
skb_network_header, so even though we are on the output path, the
transport_header is not set...........

what's wrong?

--
Nicola Padovano
e-mail: nicola.padovano@gmail.com
web: http://npadovano.altervista.org
