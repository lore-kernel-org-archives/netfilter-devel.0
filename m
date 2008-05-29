From: Jan Engelhardt <jengelh@medozas.de>
Subject: Re: About IPSec ALG
Date: Thu, 29 May 2008 16:27:13 +0200 (CEST)
Message-ID: <alpine.LNX.1.10.0805291515200.19264@fbirervta.pbzchgretzou.qr>
References: <182d06220805290231w314e2f16v4f38bfde69055e6f@mail.gmail.com>  <alpine.LNX.1.10.0805291148210.19264@fbirervta.pbzchgretzou.qr> <182d06220805290453n2b637d32x417d52794cda9709@mail.gmail.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: netfilter-devel@vger.kernel.org
To: Sarge Gorden <metalblade@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from sovereign.computergmbh.de ([85.214.69.204]:51483 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754489AbYE2O1P (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 29 May 2008 10:27:15 -0400
In-Reply-To: <182d06220805290453n2b637d32x417d52794cda9709@mail.gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Thursday 2008-05-29 13:53, Sarge Gorden wrote:

>If the VPN server or client doesn't support NAT-T.
>Then multiple hosts behind a single NAT address couldn't
>simultaneously establish and maintain tunnels to the multiple exterior
>hosts.
>Only one host could establish...
>
>But if both side support NAT-T, it works.

(This is called udpencap in Linux.)

That is the commonly-raised problem with NAT. (Suggestion:
abandon NAT, get an IPv6 address.)

It is just not possible to have a conntracking ALG because when
people designed ESP, they did so in a way that makes it virtually
impossible to track it. ESP is unidirectional, which is quite bad
since connection tracking uses a
(source-information,destination-information) tuple. But ok, we could
live with an unidirectional ESP *if* we knew the SPI it uses, but
IKE was designed in a way so as to encrypt the SPIs used for the ESP
stream, giving no way of knowing them beforehand. It is a perfect
example of how to shoot oneself in the foot, multiple times.
