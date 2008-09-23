From: Jan Engelhardt <jengelh@medozas.de>
Subject: Re: Getting IPVS and Netfilter SNAT to play together
Date: Tue, 23 Sep 2008 09:21:26 -0400 (EDT)
Message-ID: <alpine.LNX.1.10.0809230920330.29878@fbirervta.pbzchgretzou.qr>
References: <f4845fc0809230313y14e69dc6s7b5e3e2f33f6beae@mail.gmail.com>  <alpine.LNX.1.10.0809230827410.29878@fbirervta.pbzchgretzou.qr>  <f4845fc0809230545n6c879a7eg7214b0a3b3db61a3@mail.gmail.com>
 <f4845fc0809230613l68c1ba90s16e5482479bd3c9c@mail.gmail.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: netfilter-devel@vger.kernel.org, Simon Horman <horms@verge.net.au>,
	Joseph Mack NA3T <jmack@wm7d.net>
To: Julius Volz <juliusv@google.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from sovereign.computergmbh.de ([85.214.69.204]:33687 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751141AbYIWNV1 (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 23 Sep 2008 09:21:27 -0400
In-Reply-To: <f4845fc0809230613l68c1ba90s16e5482479bd3c9c@mail.gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


On Tuesday 2008-09-23 09:13, Julius Volz wrote:
>
>Ok, the SYN/ACK from the backend is logged as --cstate INVALID in
>PREROUTING and INPUT. This means that Netfilter thinks it doesn't
>belong to any connection, although it just SNATed the SYN to the
>backend correctly? Hmm... how can this be?

That probably means skb->nfct is lost (set to NULL, which is what INVALID
indicates) after SNAT (PREROUTING), when IPVS kicks in.
