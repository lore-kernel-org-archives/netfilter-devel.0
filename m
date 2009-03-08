From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [ANNOUNCE] ulogd 2.0.0beta3
Date: Sun, 08 Mar 2009 13:33:59 +0100
Message-ID: <49B3BB37.8030501@netfilter.org>
References: <49B166E0.7030201@netfilter.org> <20090307103406.GB4678@prithivi.gnumonks.org> <alpine.LSU.2.00.0903071542590.26625@fbirervta.pbzchgretzou.qr> <20090308095318.GA4009@piche.inl.fr>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: Jan Engelhardt <jengelh@medozas.de>,
	Harald Welte <laforge@netfilter.org>,
	netfilter-devel@vger.kernel.org
To: Pierre Chifflier <p.chifflier@inl.fr>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:53946 "EHLO us.es"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751256AbZCHMeK (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Sun, 8 Mar 2009 08:34:10 -0400
In-Reply-To: <20090308095318.GA4009@piche.inl.fr>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Pierre Chifflier wrote:
> On Sat, Mar 07, 2009 at 03:43:47PM +0100, Jan Engelhardt wrote:
>> Yeah there seems to be not a single pthread_ call or type in use,
>> so I wonder why it was done.
> 
> Threads are not used, the -lpthread could even be dropped without
> any other effect than causing problems again with gdb.

Then, please investigate the reason that causes this problem and remove
the libpthread dependency. This also seem hackish to me (it's a patch
that you applied because your setup complained about missing pthread).

-- 
"Los honestos son inadaptados sociales" -- Les Luthiers
