From: Harald Welte <laforge@gnumonks.org>
Subject: Re: conntrack performance/DoS formula
Date: Tue, 2 Jul 2002 16:38:21 +0200
Sender: netfilter-devel-admin@lists.samba.org
Message-ID: <20020702143821.GL18333@naboo.rchrd.phub.net.cable.rogers.com>
References: <15643.31140.525551.843205@isis.cs3-inc.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@lists.samba.org
Return-path: <netfilter-devel-admin@lists.samba.org>
To: Don Cohen <don-nf@isis.cs3-inc.com>
Content-Disposition: inline
In-Reply-To: <15643.31140.525551.843205@isis.cs3-inc.com>
Errors-To: netfilter-devel-admin@lists.samba.org
List-Help: <mailto:netfilter-devel-request@lists.samba.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.samba.org>
List-Subscribe: <http://lists.samba.org/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.samba.org?subject=subscribe>
List-Unsubscribe: <http://lists.samba.org/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.samba.org?subject=unsubscribe>
List-Archive: <http://lists.samba.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

On Thu, Jun 27, 2002 at 01:46:28PM -0700, Don Cohen wrote:
> 
> I had mentioned that I was hoping to remember/find the appropriate
> formula for the probability of a hash bucket reaching its limit.
> I got out my prob-stat book from I-won't-mention-how-many years ago.

[thanks for your detailad analysis, I will try to look at all the
details ASAP].

> My guess is that the amount of time required to do 20 iterations
> comparing connection data with elements of a list in a bucket is
> very small compared to the amount of time otherwise spent on a
> packet.  On the other hand, a hash bucket is also pretty cheap.
> The data for a connection takes much more space than 2 hash buckets, 
> or even 10.  And with 10L buckets the chance of overflow at M=10
> is only 1E-19, for M=20 it's somewhere around 1E-40.

ok the question is now to test this in the real world, which can be
fairly easily done, as the hashsize is configurable.

> So, there you have it.

-- 
Live long and prosper
- Harald Welte / laforge@gnumonks.org               http://www.gnumonks.org/
============================================================================
GCS/E/IT d- s-: a-- C+++ UL++++$ P+++ L++++$ E--- W- N++ o? K- w--- O- M- 
V-- PS+ PE-- Y+ PGP++ t++ 5-- !X !R tv-- b+++ DI? !D G+ e* h+ r% y+(*)
