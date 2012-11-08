From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: about ip header options
Date: Thu, 8 Nov 2012 13:42:38 +0100
Message-ID: <20121108124238.GA3741@1984>
References: <CAOSBYzf3VCAeKybJee6CFrB+PjQWesOHjxsJ6a7dpoC_CSxxVQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: netfilter-devel@vger.kernel.org
To: Miguel Alejandro =?iso-8859-1?Q?Gonz=E1lez?= <maggonzz@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:43737 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751118Ab2KHMmr (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 8 Nov 2012 07:42:47 -0500
Content-Disposition: inline
In-Reply-To: <CAOSBYzf3VCAeKybJee6CFrB+PjQWesOHjxsJ6a7dpoC_CSxxVQ@mail.gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hi Miguel,

On Wed, Nov 07, 2012 at 04:38:54PM -0600, Miguel Alejandro Gonz=E1lez w=
rote:
> Hello
>=20
> I have a netfilter module on the mangle table PREROUTING... I want to
> validate unexpired routes in ipv4 headers, but I think the TCP/IP
> stack already does this... because it is mentioned on the rfc 1812 so
> I'm guessing it is already implemented by the kernel
>=20
> but somehow my module catches the packet first before the kernel does
> its magic...
>=20
> As I understand the picture I'm attaching represents the whole proces=
s
> the TCP/IP stack performs to handle the options in a IPv4 packet, but
> I still don't understand how netfilter works with the stack

This is rather old, but it helps to provide the big picture:

http://open-source.arkoon.net/kernel/kernel_net.png

> Do I have to process the packet's options in my module or what?

I think it's better if you try to explain what you're trying to do
with your new extension. That may help to attract people to help you.
--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
