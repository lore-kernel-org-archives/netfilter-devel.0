From: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Subject: Re: PATCH: extra conntrack stats
Date: Fri, 2 May 2003 14:18:38 +0200 (CEST)
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <Pine.LNX.4.33.0305021411200.7105-100000@blackhole.kfki.hu>
References: <20030501112613.GC26924@sunbeam.de.gnumonks.org>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Martin Josefsson <gandalf@wlug.westbo.se>,
	Rolf Fokkens <fokkensr@fokkensr.vertis.nl>,
	Rusty Russell <rusty@rustcorp.com.au>, Patrick Schaaf <bof@bof.de>,
	Netfilter-devel <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Harald Welte <laforge@netfilter.org>
In-Reply-To: <20030501112613.GC26924@sunbeam.de.gnumonks.org>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

On Thu, 1 May 2003, Harald Welte wrote:

> I would really like to see a simple patch changing the hash function
> before.  This patch can be pushed to davem after a relatively short time
> period of testing, since it shouldn't touch too much of the conntrack
> core.

Still sitting and chewing the problem which hash function to choose,
decided yet undecided...

I'm working on an updated raw patch (+ splitted up to internal logging +
raw patches) and an updated and further tuned tcp window tracking patch (+
splitted up to proc + tcp window tracking patches). It'll take probably
one more week and then I'll submit a patch on a better hash function for
conntrack.

Best regards,
Jozsef
-
E-mail  : kadlec@blackhole.kfki.hu, kadlec@sunserv.kfki.hu
PGP key : http://www.kfki.hu/~kadlec/pgp_public_key.txt
Address : KFKI Research Institute for Particle and Nuclear Physics
          H-1525 Budapest 114, POB. 49, Hungary
