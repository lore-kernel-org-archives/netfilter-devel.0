From: Patrick Schaaf <bof@bof.de>
Subject: Re: cttest-0.1
Date: Fri, 5 Jul 2002 18:54:15 +0200
Sender: netfilter-devel-admin@lists.samba.org
Message-ID: <20020705185415.A13116@oknodo.bof.de>
References: <20020628203624.A4136@oknodo.bof.de> <15644.45834.373409.220647@isis.cs3-inc.com> <20020702144048.GM18333@naboo.rchrd.phub.net.cable.rogers.com> <20020702183242.E7684@oknodo.bof.de> <20020702183547.F7684@oknodo.bof.de> <15649.59247.55523.824241@isis.cs3-inc.com> <20020702203117.G7684@oknodo.bof.de> <20020702235206.H7684@oknodo.bof.de> <20020703041502.GH20570@aaricia.hemmet.chalmers.se> <20020705161028.GB3729@aaricia.hemmet.chalmers.se>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <netfilter-devel-admin@lists.samba.org>
To: netfilter-devel@lists.samba.org
Content-Disposition: inline
In-Reply-To: <20020705161028.GB3729@aaricia.hemmet.chalmers.se>; from gozem@aaricia.hemmet.chalmers.se on Fri, Jul 05, 2002 at 06:10:28PM +0200
Errors-To: netfilter-devel-admin@lists.samba.org
List-Help: <mailto:netfilter-devel-request@lists.samba.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.samba.org>
List-Subscribe: <http://lists.samba.org/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.samba.org?subject=subscribe>
List-Unsubscribe: <http://lists.samba.org/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.samba.org?subject=unsubscribe>
List-Archive: <http://lists.samba.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

Martin, Joakim,

thank you for your cttest runs. They both provide new data points,
coming from a router instead of a server. They confirm that we should
at least strongly avoid even hash bucket counts. In all examples we have
now, both the original hash, and Don's abcd hash detoriate badly.

The interesting new theme, when comparing my "transproxy server"
statistics with your router statistics, is that for the odd
bucket sizes, the original hash does a lot better in the router
case than it does in the server case.

Today, I wrote a new comparison, using rdtsc() to time the CPU usage
of the hash calculation within cttest. I'll make a cttest-0.2 soon,
so everybody can reproduce. However, here's the preliminary result:
on a 1Ghz P-III machine, compiled with march=i686, the original hash
function takes 55ns per call. The abcd hash is better, at 43ns per call.
After inlining the crc32() function, the crc32 hash 185ns per call.
My experience is that a one-longer hash list, when scanned, needs one
more memory roundtrip at about 200ns latency. Maybe it's double that
with the current ip_conntrack layout, but I'll whine about this at
another time. It is clear that even the cost of the crc32 calculation
is negligible if we can save one on the list length on average.

Overall, these results seem to call for this set of actions:

- make the hash bucket count at least individible by 2. This should go
  as a strong suggestion into the documentation, and should be implemented
  in the default initialization code. Anybody volunteering for one or
  the other? I'll do the code part, but I won't do the docs.
- given the clear advantage of the abcd hash over the original hash in
  the server case, make the abcd hash at least a compile time option,
  or better yet, a module load time option. I can do that, too.

For the code, would one or two patch-o-matic type patches against 2.4.18-rc1
be the desired deliverable?

best regards
  Patrick
