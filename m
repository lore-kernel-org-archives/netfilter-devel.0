From: Harald Welte <laforge@gnumonks.org>
Subject: Re: iprange non-range recognition
Date: Sun, 25 Oct 2009 14:50:21 +0100
Message-ID: <20091025135021.GX29852@prithivi.gnumonks.org>
References: <1253741194-26060-1-git-send-email-jengelh@medozas.de>
 <20091025100943.GR29852@prithivi.gnumonks.org>
 <alpine.LSU.2.00.0910251123490.3852@obet.zrqbmnf.qr>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org, kaber@trash.net
To: Jan Engelhardt <jengelh@medozas.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from ganesha.gnumonks.org ([213.95.27.120]:55746 "EHLO
	ganesha.gnumonks.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753315AbZJYNyr (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Sun, 25 Oct 2009 09:54:47 -0400
Content-Disposition: inline
In-Reply-To: <alpine.LSU.2.00.0910251123490.3852@obet.zrqbmnf.qr>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Sun, Oct 25, 2009 at 11:28:12AM +0100, Jan Engelhardt wrote:
> >sorry for the long delay, I've merged your patches into iptables master.
> 
> [Re the other message] I took the freedom to continue to push to my 
> master 

of course.

> Ok so they got merged, though you seemed to have done that with 
> cherry-pick rather than merge (they are the same after all). Just a note 
> - you c-p'd them all in _reverse_. I hope they applied though.

yes, I've cherry-picked them since I didn't know I would merge all/most of
them.  As you know, I wasn't really doing this in a particularly
controlled/organized way.. I simply wanted to merge some of the stuff
to avoid trees to diverge unneccessarily and avoid fixes from going
upstream.

If there's anything else you have pending, as indicated, please re-send.

-- 
- Harald Welte <laforge@gnumonks.org>           http://laforge.gnumonks.org/
============================================================================
"Privacy in residential applications is a desirable marketing option."
                                                  (ETSI EN 300 175-7 Ch. A6)
