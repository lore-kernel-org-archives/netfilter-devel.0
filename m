From: Harald Welte <laforge@gnumonks.org>
Subject: Re: [PATCH] tcp window tracking patch with SACK support
Date: Fri, 18 Oct 2002 16:48:18 +0200
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <20021018144818.GJ2408@naboo.club.berlin.ccc.de>
References: <20021017163909.GO344@pc.ilinx> <Pine.LNX.4.33.0210181255170.10340-100000@blackhole.kfki.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.33.0210181255170.10340-100000@blackhole.kfki.hu>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

On Fri, Oct 18, 2002 at 01:09:43PM +0200, Jozsef Kadlecsik wrote:
> Hello,
> 
> As it was reported several times on the mailing list, the tcp window
> tracking patch could cause long SMTP delays in some cases.
> 
> After dumping a lot of traffic and replaying the streams it turned
> out that the book-keeping inside the patch could go out of sync when SACK
> was used. In another words, SACK was not supported by the patch and it
> could cause legitimate packets to be blocked.

Mmmh.. I see. 

> I have committed the new tcp-window-tracking.patch with SACK support in
> the cvs.

great, thanks.

> It'd be very helpful if sites which experienced the long SMTP delays could
> give a try to the new version of the patch and then send a report: 'yeah,
> it's seems to be OK' or 'nope, still bad'. :-)

well, I'd rather not test it on kashyyyk.netfilter.org for some time...
so I really have to rely on others for testing. Please tell me about
your erxperience with this new patch.

> Best regards,
> Jozsef

-- 
Live long and prosper
- Harald Welte / laforge@gnumonks.org               http://www.gnumonks.org/
============================================================================
GCS/E/IT d- s-: a-- C+++ UL++++$ P+++ L++++$ E--- W- N++ o? K- w--- O- M- 
V-- PS+ PE-- Y+ PGP++ t++ 5-- !X !R tv-- b+++ DI? !D G+ e* h+ r% y+(*)
