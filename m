From: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Subject: Re: raw table breaks iptables binary compatibility
Date: Wed, 12 Nov 2003 00:40:59 +0100 (CET)
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <Pine.LNX.4.33.0311120036220.26091-100000@blackhole.kfki.hu>
References: <20031109093556.GC1005@sunbeam.de.gnumonks.org>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Henrik Nordstrom <hno@marasystems.com>,
	<netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Harald Welte <laforge@netfilter.org>
In-Reply-To: <20031109093556.GC1005@sunbeam.de.gnumonks.org>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

On Sun, 9 Nov 2003, Harald Welte wrote:

> btw: isn't there a way we can do this without compatibility issues?

If the structure had got a private part, hidden from the userspace...
2.7 issue. :-)

> Can't we put this information into an additional 'magic' matchinfo
> struct?  one that doesn't really match anything, but gets automatically
> added (and filled in) for every rule?
>
> I doubt the rule-number tracing will be used in a lot of setups - and
> this way we could make it run-time configurable.  Something like a
> global iptables parameter (iptables -A INPUT -T .....) where '-T' means
> 'insert a hidden trace matchinfo for rulenumber and chainname'.

Then one should set up tracking at two places: first in the raw table
by 'tagging' the interesting packets and then the rules as well.

I'll separate the backward-incompatible TRACE target from the raw table.

Best regards,
Jozsef
-
E-mail  : kadlec@blackhole.kfki.hu, kadlec@sunserv.kfki.hu
PGP key : http://www.kfki.hu/~kadlec/pgp_public_key.txt
Address : KFKI Research Institute for Particle and Nuclear Physics
          H-1525 Budapest 114, POB. 49, Hungary
