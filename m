From: Zeeshan Ali <zeelists@yahoo.com>
Subject: Re: [ANNOUNCE] nfsim - netfilter simulation environment
Date: Wed, 7 Jan 2004 11:25:30 -0800 (PST)
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <20040107192530.99189.qmail@web60701.mail.yahoo.com>
References: <200401072029.03638.jeremy@redfishsoftware.com.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: netfilter-devel@lists.netfilter.org
In-Reply-To: <200401072029.03638.jeremy@redfishsoftware.com.au>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

Hello again,
  OK, all those errors seems to be gone but now i get
these errors:

gcc -Wstrict-prototypes -Wunused -Wall -g -ggdb -Wa,-W
-I. -I/home/zak/downloads/nfsim/core
-I/home/zak/downloads/nfsim/kernelenv/include
-I/home/zak/downloads/nfsim/netfilter/include  -c -o
core/netfilter.o core/netfilter.c
core/netfilter.c:453: conflicting types for
`nf_hook_slow'
/home/zak/downloads/nfsim/core/core.h:166: previous
declaration of `nf_hook_slow'
core/netfilter.c: In function `nf_hook_slow':
core/netfilter.c:472: warning: implicit declaration of
function `br_read_lock_bh'
core/netfilter.c:472: `BR_NETPROTO_LOCK' undeclared
(first use in this function)core/netfilter.c:472:
(Each undeclared identifier is reported only once
core/netfilter.c:472: for each function it appears
in.)
core/netfilter.c:501: warning: implicit declaration of
function `br_read_unlock_bh'
core/netfilter.c: In function `nf_reinject':
core/netfilter.c:512: `BR_NETPROTO_LOCK' undeclared
(first use in this function)core/netfilter.c: In
function `ip_route_me_harder':
core/netfilter.c:568: structure has no member named
`bound_dev_if'
core/netfilter.c:581: warning: implicit declaration of
function `ip_dev_find'
core/netfilter.c:581: warning: assignment makes
pointer from integer without a cast
core/netfilter.c:587: structure has no member named
`bound_dev_if'
make[1]: *** [core/netfilter.o] Error 1
make[1]: Leaving directory
`/home/zak/downloads/nfsim/netfilter'
make: *** [netfilter/netfilter.o] Error 2

__________________________________
Do you Yahoo!?
Yahoo! Hotjobs: Enter the "Signing Bonus" Sweepstakes
http://hotjobs.sweepstakes.yahoo.com/signingbonus
