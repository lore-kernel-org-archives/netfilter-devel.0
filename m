From: Jan Engelhardt <jengelh@medozas.de>
Subject: Re: Invalid size of target
Date: Tue, 15 Jul 2008 16:52:15 +0200 (CEST)
Message-ID: <alpine.LNX.1.10.0807151650130.2212@fbirervta.pbzchgretzou.qr>
References: <48bd37870807141225k7c8ed4c2o747bff281792b13f@mail.gmail.com>  <48bd37870807141226n4a5a8b8fwf1b5284d42b5a7b5@mail.gmail.com>  <alpine.LNX.1.10.0807142204050.13215@fbirervta.pbzchgretzou.qr>  <48bd37870807141336u3f821c32s5f9cb9ee0fe94370@mail.gmail.com>
  <alpine.LNX.1.10.0807142313290.13215@fbirervta.pbzchgretzou.qr> <48bd37870807150547r6211bb9bp74c1d3490c019000@mail.gmail.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: netfilter-devel@vger.kernel.org
To: Kevin Sookocheff <kevin.sookocheff@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from sovereign.computergmbh.de ([85.214.69.204]:35316 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751911AbYGOOwR (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 15 Jul 2008 10:52:17 -0400
In-Reply-To: <48bd37870807150547r6211bb9bp74c1d3490c019000@mail.gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


On Tuesday 2008-07-15 14:47, Kevin Sookocheff wrote:

>Great, that worked wonderfully!
>
>So, just out of curiosity and for completeness, do you know why this
>error would present itself only on SMP kernels?  I'm presuming it has
>something to do with what version of IPTables is compiled in the
>kernel.

The kernel-level iptables component has no version number (it uses
the kernel version). For best interoperability (and chance to get an
answer to a bugreport), 2.6.18 or any kernel more recent than that,
specifically its latest stable versions, and userspace
iptables=C2=A0>=3D=C2=A01.4.1.1 are strongly recommended.
--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
