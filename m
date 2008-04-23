From: "Gilad Benjamini" <gilad.benjamini@gmail.com>
Subject: Re: Reject with tcp-reset on a bridge
Date: Wed, 23 Apr 2008 13:02:52 -0700
Message-ID: <d95317090804231302p3d405eao83b48c0a10da259b@mail.gmail.com>
References: <d95317090804231131j66d2f84fp20a548c7d0f4d0a3@mail.gmail.com>
	 <alpine.LNX.1.10.0804232050150.15791@fbirervta.pbzchgretzou.qr>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: netfilter@vger.kernel.org,
	"Netfilter Developer Mailing List" <netfilter-devel@vger.kernel.org>
To: "Jan Engelhardt" <jengelh@computergmbh.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from wa-out-1112.google.com ([209.85.146.182]:41971 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754028AbYDWUCx (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 23 Apr 2008 16:02:53 -0400
Received: by wa-out-1112.google.com with SMTP id m16so4858732waf.23
        for <netfilter-devel@vger.kernel.org>; Wed, 23 Apr 2008 13:02:52 -0700 (PDT)
In-Reply-To: <alpine.LNX.1.10.0804232050150.15791@fbirervta.pbzchgretzou.qr>
Content-Disposition: inline
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

My scenario is slightly different.
tcpdump doesn't show ANY response, with the right or wrong MAC.

Ubuntu 7.10, kernel 2.6.22-14

2008/4/23, Jan Engelhardt <jengelh@computergmbh.de>:
> On Wednesday 2008-04-23 20:31, Gilad Benjamini wrote:
>
>  >I am using iptables to firewall connections on a bridge.
>  >
>  >The rule below (minimized to the sake of the example) works
>  >       iptables -A FORWARD -p tcp -j REJECT
>  >
>  >A TCP-reset variation doesn't work
>  >      iptables -A FORWARD -p tcp -j REJECT  --reject-with tcp-reset
>  >
>  >The TCP packets don't go through, but I don't see a RST, or any other
>  >packet, coming back.
>  >My options are:
>  >   a. Something is wrong in my configuration
>  >   b. This isn't suppose to work
>  >   c. This doesn't work because of a bug
>  >   d. None of the above
>  >
>  >Which is it ?
>
>
> Since missing features may be perceived as bugs but which of course
>  are not, it would be 0.5*c+0.5*d.
>
>  http://marc.info/?l=netfilter-devel&m=120716501006420&w=2
>
