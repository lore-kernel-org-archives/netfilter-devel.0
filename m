From: Harald Welte <laforge@gnumonks.org>
Subject: Re: ip_conntrack_hash() problem
Date: Thu, 5 Sep 2002 10:19:55 +0200
Sender: linux-kernel-owner@vger.kernel.org
Message-ID: <20020905081955.GC1064@naboo.lincon.Uni-Koeln.DE>
References: <1031142822.3314.116.camel@biker.pdb.fsc.net> <20020904125628.GB1720@naboo.lincon.Uni-Koeln.DE> <1031145854.3359.125.camel@biker.pdb.fsc.net> <20020904152626.A11438@wotan.suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Martin Wilck <Martin.Wilck@Fujitsu-Siemens.com>,
	Netfilter Mailing List <netfilter-devel@lists.netfilter.org>,
	Linux Kernel mailing list <linux-kernel@vger.kernel.org>,
	Rusty Russell <rusty@rustcorp.com.au>,
	Patrick Schaaf <bof@bof.de>
Return-path: <linux-kernel-owner+linux-kernel=40quimby.gnus.org@vger.kernel.org>
To: Andi Kleen <ak@suse.de>
Content-Disposition: inline
In-Reply-To: <20020904152626.A11438@wotan.suse.de>
List-Id: netfilter-devel.vger.kernel.org

On Wed, Sep 04, 2002 at 03:26:26PM +0200, Andi Kleen wrote:
> > I think the hash function should be fixed, not the possible choice of
> > hash sizes, if that is at feasible.
> I also agree with Martin that it is better to fix the hash function in
> this case. Restricting to magic hash table sizes looks like a bad hack.

I wasn't proposing to restrict it.  Just make it chose a sane default.

> -Andi

-- 
Live long and prosper
- Harald Welte / laforge@gnumonks.org               http://www.gnumonks.org/
============================================================================
GCS/E/IT d- s-: a-- C+++ UL++++$ P+++ L++++$ E--- W- N++ o? K- w--- O- M- 
V-- PS+ PE-- Y+ PGP++ t++ 5-- !X !R tv-- b+++ DI? !D G+ e* h+ r% y+(*)
