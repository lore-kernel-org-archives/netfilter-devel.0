From: Harald Welte <laforge@netfilter.org>
Subject: Re: [ANNOUNCE] ulogd 2.0.0beta3
Date: Sat, 7 Mar 2009 07:34:06 -0300
Message-ID: <20090307103406.GB4678@prithivi.gnumonks.org>
References: <49B166E0.7030201@netfilter.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from ganesha.gnumonks.org ([213.95.27.120]:44473 "EHLO
	ganesha.gnumonks.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753119AbZCGM3Z (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Sat, 7 Mar 2009 07:29:25 -0500
Content-Disposition: inline
In-Reply-To: <49B166E0.7030201@netfilter.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hi guys,

congratulations on the new beta release.

On Fri, Mar 06, 2009 at 07:09:36PM +0100, Pablo Neira Ayuso wrote:
>       Link ulogd2 with libpthread

I was just reading this and all alarm sirens went on.  I don't know
why that is neccessary, and I hope it is just due to some library dependency.

When I created ulogd and ulogd2, I never intended them to become some kind of
multi-threaded monster with a complex locking and synchronization nightmare.

Sure, I'm no longer maintaining it, and I respect the decision of current
maintainers, but I just wanted to point that out.

-- 
- Harald Welte <laforge@netfilter.org>                 http://netfilter.org/
============================================================================
  "Fragmentation is like classful addressing -- an interesting early
   architectural error that shows how much experimentation was going
   on while IP was being designed."                    -- Paul Vixie
