From: Jan Engelhardt <jengelh@computergmbh.de>
Subject: Re: Reject with tcp-reset on a bridge
Date: Wed, 23 Apr 2008 20:53:29 +0200 (CEST)
Message-ID: <alpine.LNX.1.10.0804232050150.15791@fbirervta.pbzchgretzou.qr>
References: <d95317090804231131j66d2f84fp20a548c7d0f4d0a3@mail.gmail.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: netfilter@vger.kernel.org,
	Netfilter Developer Mailing List
	<netfilter-devel@vger.kernel.org>
To: Gilad Benjamini <gilad.benjamini@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from sovereign.computergmbh.de ([85.214.69.204]:40632 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752057AbYDWSxa (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 23 Apr 2008 14:53:30 -0400
In-Reply-To: <d95317090804231131j66d2f84fp20a548c7d0f4d0a3@mail.gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Wednesday 2008-04-23 20:31, Gilad Benjamini wrote:

>I am using iptables to firewall connections on a bridge.
>
>The rule below (minimized to the sake of the example) works
>       iptables -A FORWARD -p tcp -j REJECT
>
>A TCP-reset variation doesn't work
>      iptables -A FORWARD -p tcp -j REJECT  --reject-with tcp-reset
>
>The TCP packets don't go through, but I don't see a RST, or any other
>packet, coming back.
>My options are:
>   a. Something is wrong in my configuration
>   b. This isn't suppose to work
>   c. This doesn't work because of a bug
>   d. None of the above
>
>Which is it ?

Since missing features may be perceived as bugs but which of course
are not, it would be 0.5*c+0.5*d.

http://marc.info/?l=netfilter-devel&m=120716501006420&w=2
