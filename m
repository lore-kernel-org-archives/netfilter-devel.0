From: Harald Welte <laforge@netfilter.org>
Subject: Re: [ANNOUNCE] ulogd 2.0.0beta3
Date: Sun, 8 Mar 2009 10:24:26 -0300
Message-ID: <20090308132426.GG4220@prithivi.gnumonks.org>
References: <49B166E0.7030201@netfilter.org> <20090307103406.GB4678@prithivi.gnumonks.org> <alpine.LSU.2.00.0903071542590.26625@fbirervta.pbzchgretzou.qr> <20090308095318.GA4009@piche.inl.fr>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Jan Engelhardt <jengelh@medozas.de>,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	netfilter-devel@vger.kernel.org
To: Pierre Chifflier <p.chifflier@inl.fr>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from ganesha.gnumonks.org ([213.95.27.120]:60554 "EHLO
	ganesha.gnumonks.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751884AbZCHNYu (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Sun, 8 Mar 2009 09:24:50 -0400
Content-Disposition: inline
In-Reply-To: <20090308095318.GA4009@piche.inl.fr>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Ok, thanks for the explanation. seems fine to me.

Now the only question is whether this wastes (significant) resources (i.e.
resident set size or anything) in case ulogd2 runs on a small embedded box.

If it is debugging-only, one could also enable it only for a debug-build (when
-g / -pg is set)

regards,
-- 
- Harald Welte <laforge@netfilter.org>                 http://netfilter.org/
============================================================================
  "Fragmentation is like classful addressing -- an interesting early
   architectural error that shows how much experimentation was going
   on while IP was being designed."                    -- Paul Vixie
