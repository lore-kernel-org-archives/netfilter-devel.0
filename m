From: Jan Engelhardt <jengelh@medozas.de>
Subject: Re: Problem with Linux networking in 3.X kernels
Date: Sun, 4 Dec 2011 17:20:52 +0100 (CET)
Message-ID: <alpine.LNX.2.01.1112041720180.30677@frira.zrqbmnf.qr>
References: <CACD+8rMdSKLb85GX5RBRNv5L0KaYVaQYbYM184_wE5cyOo94Ng@mail.gmail.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Netfilter Developer Mailing List
	<netfilter-devel@vger.kernel.org>,
	Bart De Schuymer <bdschuym@pandora.be>
To: =?UTF-8?Q?Artur_Fija=C5=82kowski?= <wiki.warx@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from seven.medozas.de ([188.40.89.202]:36760 "EHLO seven.medozas.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754595Ab1LDQUz (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Sun, 4 Dec 2011 11:20:55 -0500
In-Reply-To: <CACD+8rMdSKLb85GX5RBRNv5L0KaYVaQYbYM184_wE5cyOo94Ng@mail.gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Cc set.

On Sunday 2011-12-04 15:09, Artur Fija=C5=82kowski wrote:

>Hi!
>
>On friday I found very nasty bug in 3.X kernels - vlan device does not
>work on bridge port. I don't know where to report this bug so I ask
>you for helping ;) me with this report.
>
>Detailed problem:
>If ethernet device has vlans and is incorporated as bridge port it
>completely drops incoming vlan packets. I tested this with wireshark
>and I observed:
>* when device is not bridge port vlan works normally (there is network
>connectivity via vlan interface)
>* when device is added as bridge port it still sends packets via vlan
>interface, but does not recieve them - wireshark sees packets in both
>directions, but they are dropped somewhere in kernel, because in file
>/proc/net/vlan/DEVNAME counters on incoming packets does not
>increment.
>
>I observed this problem on 2 kernels:
>* 3.1.1-gentoo
>* 3.0.6-gentoo
>With two different ethernet devices:
>*  Broadcom Nextreme IIII (tg3 kernel driver)
>*  Broadcom BCM4401-B0 (b44 kernel driver)
>
>vlan devices were created with ip link add link ... command, with vlan=
 ID 3972.
>
>If you tell me where to report this problem and what additional info
>get I will do it.
>
>
>Thanks in advance
>AJF/WarX
>

--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
