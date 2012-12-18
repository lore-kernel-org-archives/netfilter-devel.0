From: Jan Engelhardt <jengelh@inai.de>
Subject: Re: NAT pool
Date: Tue, 18 Dec 2012 23:58:53 +0100 (CET)
Message-ID: <alpine.LNX.2.01.1212182348580.8238@nerf07.vanv.qr>
References: <CAOSBYzcjkZiPA7zFC62OoQGdzTiw7c4aavvBE1_FM+Su1x5Mxg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: netfilter-devel@vger.kernel.org
To: =?UTF-8?Q?Miguel_Alejandro_Gonz=C3=A1lez?= <maggonzz@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from ares07.inai.de ([5.9.24.206]:45587 "EHLO ares07.inai.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751228Ab2LRW6z (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 18 Dec 2012 17:58:55 -0500
In-Reply-To: <CAOSBYzcjkZiPA7zFC62OoQGdzTiw7c4aavvBE1_FM+Su1x5Mxg@mail.gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Tuesday 2012-12-18 23:32, Miguel Alejandro Gonz=C3=A1lez wrote:

>I was wondering how the pool of ipv4 addresses works in netfilter. I
>know you can configure a range or subnet from iptables when you are
>configuring NAT.I was reading some NAT code from the kernel, but I
>think it just checks if the packet's address is in the range
>specified.

get_unique_tuple() makes sure they don't overlap.

>I guess my main question is, if there is a ipv4 pool implementation in
>netfilter. If so, can it be used by other modules?

As much as other modules are already using it.
The question should not be whether it can be used, but whether it can b=
e=20
used for what.
--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
