From: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Subject: Re: raw table breaks iptables binary compatibility
Date: Thu, 13 Nov 2003 11:20:55 +0100 (CET)
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <Pine.LNX.4.33.0311131111300.28150-100000@blackhole.kfki.hu>
References: <20031109093255.GB1005@sunbeam.de.gnumonks.org>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Henrik Nordstrom <hno@marasystems.com>,
	<netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Harald Welte <laforge@netfilter.org>
In-Reply-To: <20031109093255.GB1005@sunbeam.de.gnumonks.org>
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

> On Sun, Nov 09, 2003 at 02:12:43AM +0100, Henrik Nordstrom wrote:
> > I don't quite see why these are required for the 'raw' table. Seems to be
> > related to debugging or error management on rulesets incompatible with
> > 'raw'. In any case the effect is probably not that desireable from a
> > p-o-m/base patch..
>
> yes, they are for the 'TRACE' target that is included with the raw
> patch.  Initially the patch didn't add these fields, but then jozsef
> implemented it for speeding up the logging of rule numbers.
>
> Jozsef: could you split out the raw.patch in
>
> a) one that just adds the table (and the NOTRACK target)
> b) another one that adds the TRACE target (and thus depends on the LOG changes)

I have committed the separation of the raw target into a backward
compatible raw patch (with NOTRACK target) and a backward
incompatible TRACE target patch in cvs.

The defragmentation of locally generated packets bug you reported and
fixed is included in the raw patches under patch-o-matic/ and
patch-o-matic_2.5/ as well.

Best regards,
Jozsef
-
E-mail  : kadlec@blackhole.kfki.hu, kadlec@sunserv.kfki.hu
PGP key : http://www.kfki.hu/~kadlec/pgp_public_key.txt
Address : KFKI Research Institute for Particle and Nuclear Physics
          H-1525 Budapest 114, POB. 49, Hungary
