From: Jan Engelhardt <jengelh@computergmbh.de>
Subject: Re: Conntrack in-kernel question
Date: Wed, 5 Mar 2008 14:51:01 +0100 (CET)
Message-ID: <Pine.LNX.4.64.0803051446170.7660@fbirervta.pbzchgretzou.qr>
References: <1129421204695076@webmail25.yandex.ru>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: netfilter-devel@vger.kernel.org, netfilter@vger.kernel.org
To: Oleg Petrov <dsacode@yandex.ru>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from sovereign.computergmbh.de ([85.214.69.204]:56885 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751256AbYCENvD (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 5 Mar 2008 08:51:03 -0500
In-Reply-To: <1129421204695076@webmail25.yandex.ru>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


On Mar 5 2008 08:31, Oleg Petrov wrote:
>
>I'm working on kernel module used for network accounting and it's base=
d
>on amazing netfilter connection tracking code. But I lack some informa=
tion
>in nf_conn structure. Can you please advice what's preferable way of
>getting such information:
>
>1) In/out interface indices.
>More accurately, I'm interested in SNMP
>interface indices to export accounting information but I hadn't seen
>any interface stuff in conntrack code.

Conntrack does not deal with interfaces=C2=A0=E2=80=94 that is a routin=
g thing.
It would be perfectly valid to send an SNMP query out on eth0,
and receive the reply on eth1, while the re-reply goes out on eth2...

Hence conntrack only deals with <source address, destination address,
other bits like port numbers or for example ESP SPI indexes> tuples.
There is a dirty hack, which is skb->iif, but I would not rely on it.

>2) TCP connection flags and IP ToS (Type of Service).
>
>If this is not implemented in conntrack, please describe me preferable
>way for adding support of this into netfilter - and I'll do so.

TOS is not part of the unique tuple to identify a connection,
hence I do not think it should be used as such (though you are free
to do so, but I tell you, the result may not work).

Or you can=C2=A0=E2=80=94 but again it only makes sense for learning nf=
ct=C2=A0=E2=80=94
to force the same TOS bit on any connection (and if that is not
the case, drop it.)
--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
