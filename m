From: Harald Welte <laforge@gnumonks.org>
Subject: Re: [patch] tcp connection tracking 2.4.19
Date: Thu, 17 Oct 2002 00:46:43 +0200
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <20021016224643.GC2408@naboo.club.berlin.ccc.de>
References: <20021016074837.GA18011@old.homeip.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Martin Renold <martinxyz@gmx.ch>
Content-Disposition: inline
In-Reply-To: <20021016074837.GA18011@old.homeip.net>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

On Wed, Oct 16, 2002 at 09:48:37AM +0200, Martin Renold wrote:
> hi,
> 
> There is a bug in the stable 2.4.19 kernel in the ip_conntrack code that
> allows the final ACK of a SYN - SYN/ACK - ACK tcp handshake to establish
> an ASSURED connection even if it has a wrong sequence number. The current
> code only checks the ACK number.

The question is whether this is really to be called a 'bug'.  Netfilter
connection tracking never claimed to do full state tracking, neither did
it claim to do sequence number tracking.  It does all it can without
tracking sequence/ack numbers and window sizes.

You can also send FIN flagged packets with a wrong sequence number to 
terminate a connection (conntrack entry, that is).

This is not a bug in the code, but an architectural disadvantage of
doing this kind of simplified non-sequence-number-tracking TCP state
tracking.
> -- 
> Thunder's just a noise, boys, lightnin' does the work
> -- (Chad Brock/John Hadley/Kelly Garrett)

-- 
Live long and prosper
- Harald Welte / laforge@gnumonks.org               http://www.gnumonks.org/
============================================================================
GCS/E/IT d- s-: a-- C+++ UL++++$ P+++ L++++$ E--- W- N++ o? K- w--- O- M- 
V-- PS+ PE-- Y+ PGP++ t++ 5-- !X !R tv-- b+++ DI? !D G+ e* h+ r% y+(*)
