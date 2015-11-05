From: Jan Engelhardt <jengelh@inai.de>
Subject: Re: Determine the interface being used by a socket
Date: Thu, 5 Nov 2015 22:12:26 +0100 (CET)
Message-ID: <alpine.LSU.2.20.1511051942530.14131@nerf40.vanv.qr>
References: <CACw4T0onF+QmM0m42CavFVr+4v4ww5Q-u49So-4LdkGKjmNbiQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Cc: netfilter-devel@vger.kernel.org
To: David Hinkle <hinkle@cipafilter.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from ares41.inai.de ([46.4.122.207]:39796 "EHLO ares41.inai.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751522AbbKEVM2 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 5 Nov 2015 16:12:28 -0500
In-Reply-To: <CACw4T0onF+QmM0m42CavFVr+4v4ww5Q-u49So-4LdkGKjmNbiQ@mail.gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Thursday 2015-11-05 18:43, David Hinkle wrote:

>we want our proxy server to be able to determine which interface
>each socket is using [...] Right now the best idea I have is to
>reserve [and use] some bits of the connmark [...] I can get to the
>conntrack data, but I doesn't look like conntrack is recording which
>interfaces each flow is using.

A socket, and a flow, may be using multiple interfaces. Separate
packets can take different paths, and they may loop through
encapsulation/tunnels.

And AF_KCM brings a new can of Gagh into the game.


>Is there an API I could call from userspace to figure out what
>interface is being used by a specific connection?

RTM_GETROUTE (man 7 rtnetlink).

A demonstration can be found with `ip route get 62.245.227.22`.
