From: "Jeremy Fowler" <jfowler@westrope.com>
Subject: RE: Connecttrack Access
Date: Fri, 6 Dec 2002 16:59:34 -0600
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <MFEGKJBMPCLPMMMBAACNGEOJODAA.jfowler@westrope.com>
References: <20021205204003.GO11068@naboo.club.berlin.ccc.de>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
Cc: <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: "Harald Welte" <laforge@gnumonks.org>
In-Reply-To: <20021205204003.GO11068@naboo.club.berlin.ccc.de>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

Thanks, I found that out. Do you know of a reference somewhere that tells me
what each column represents for each protocol. Do you know of any libraries that
parses that file into a linked list of C structures?

> -----Original Message-----
> From: Harald Welte [mailto:laforge@gnumonks.org]
> Sent: Thursday, December 05, 2002 2:40 PM
> To: Jeremy Fowler
> Cc: netfilter-devel@lists.netfilter.org
> Subject: Re: Connecttrack Access
>
>
> On Fri, Nov 22, 2002 at 12:41:03PM -0600, Jeremy Fowler wrote:
> > New to the list, so sorry if this has been asked before. I was wondering if
> > there is a library interface to access the connecttrack module's MASQUERADE
> > feature to get a list of what port/ipaddr assignments. Basically
> looking for a
> > way to let a user-space program track SNAT connections and port usage.
>
> read and parse /proc/net/ip_conntrack.
>
> --
> Live long and prosper
> - Harald Welte / laforge@gnumonks.org               http://www.gnumonks.org/
> ============================================================================
> GCS/E/IT d- s-: a-- C+++ UL++++$ P+++ L++++$ E--- W- N++ o? K- w--- O- M-
> V-- PS+ PE-- Y+ PGP++ t++ 5-- !X !R tv-- b+++ DI? !D G+ e* h+ r% y+(*)
>
