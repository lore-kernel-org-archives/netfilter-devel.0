From: Harald Welte <laforge@gnumonks.org>
Subject: Re: delaying problem...
Date: Tue, 22 Oct 2002 16:59:07 +0200
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <20021022145907.GL3039@naboo.club.berlin.ccc.de>
References: <18726679933.20021017154532@mail.ru>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: trajan <trajan@mail.ru>
Content-Disposition: inline
In-Reply-To: <18726679933.20021017154532@mail.ru>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

On Thu, Oct 17, 2002 at 03:45:32PM +0600, trajan wrote:
> Dear Mr. Harald Welte
> 
> I need Your help.
> How to delay packets sharply for 5 seconds when it pass through
> Linux gateway, from eth0 to eth1? Where can I find that utility?

you cannot find a ready-built utility for this.  You can implement it
for yourself, by using the QUEUE target and libipq from a userspace
process.  Please see the libipq manpages and the mailinglist archives.

> Thank You.
-- 
Live long and prosper
- Harald Welte / laforge@gnumonks.org               http://www.gnumonks.org/
============================================================================
GCS/E/IT d- s-: a-- C+++ UL++++$ P+++ L++++$ E--- W- N++ o? K- w--- O- M- 
V-- PS+ PE-- Y+ PGP++ t++ 5-- !X !R tv-- b+++ DI? !D G+ e* h+ r% y+(*)
