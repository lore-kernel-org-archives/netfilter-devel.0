From: Harald Welte <laforge@gnumonks.org>
Subject: Re: [PATCH] remove exessive timer updates (3/4)
Date: Sat, 8 Jun 2002 09:37:33 +0200
Sender: netfilter-devel-admin@lists.samba.org
Message-ID: <20020608073733.GB1109@naboo.de.gnumonks.org>
References: <1023365846.845.26.camel@tux>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Netfilter-devel <netfilter-devel@lists.samba.org>
Return-path: <netfilter-devel-admin@lists.samba.org>
To: Martin Josefsson <gandalf@wlug.westbo.se>
Content-Disposition: inline
In-Reply-To: <1023365846.845.26.camel@tux>
Errors-To: netfilter-devel-admin@lists.samba.org
List-Help: <mailto:netfilter-devel-request@lists.samba.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.samba.org>
List-Subscribe: <http://lists.samba.org/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.samba.org?subject=subscribe>
List-Unsubscribe: <http://lists.samba.org/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.samba.org?subject=unsubscribe>
List-Archive: <http://lists.samba.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

On Thu, Jun 06, 2002 at 02:24:04PM +0200, Martin Josefsson wrote:
> Here's the patch that lead up to the first patch (the renaming of
> death_by_timeout and exporting it).

ah. now I understand what the exporting was all about :)

> This patch adds a check to ip_ct_refresh() so it doesn't update the
> timer of a connection unless it's been >HZ ticks since the last update.
> both del_timer() and add_timer() disables interrupts while
> removing/inserting the timer, no reason to do this for each packet.

sounds interesting and should give quite some speedup.  Did you do any
benchmarking on that?


> /Martin

-- 
Live long and prosper
- Harald Welte / laforge@gnumonks.org               http://www.gnumonks.org/
============================================================================
GCS/E/IT d- s-: a-- C+++ UL++++$ P+++ L++++$ E--- W- N++ o? K- w--- O- M- 
V-- PS+ PE-- Y+ PGP++ t++ 5-- !X !R tv-- b+++ DI? !D G+ e* h+ r% y+(*)
