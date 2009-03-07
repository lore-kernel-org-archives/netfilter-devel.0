From: Jan Engelhardt <jengelh@medozas.de>
Subject: Re: [ANNOUNCE] ulogd 2.0.0beta3
Date: Sat, 7 Mar 2009 15:43:47 +0100 (CET)
Message-ID: <alpine.LSU.2.00.0903071542590.26625@fbirervta.pbzchgretzou.qr>
References: <49B166E0.7030201@netfilter.org> <20090307103406.GB4678@prithivi.gnumonks.org>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Pablo Neira Ayuso <pablo@netfilter.org>,
	netfilter-devel@vger.kernel.org
To: Harald Welte <laforge@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from sovereign.computergmbh.de ([85.214.69.204]:39239 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753861AbZCGOnv (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Sat, 7 Mar 2009 09:43:51 -0500
In-Reply-To: <20090307103406.GB4678@prithivi.gnumonks.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


On Saturday 2009-03-07 11:34, Harald Welte wrote:
>On Fri, Mar 06, 2009 at 07:09:36PM +0100, Pablo Neira Ayuso wrote:
>>       Link ulogd2 with libpthread
>
>I was just reading this and all alarm sirens went on.  I don't know
>why that is neccessary, and I hope it is just due to some library dependency.
>
>When I created ulogd and ulogd2, I never intended them to become some kind of
>multi-threaded monster with a complex locking and synchronization nightmare.

Yeah there seems to be not a single pthread_ call or type in use,
so I wonder why it was done.
