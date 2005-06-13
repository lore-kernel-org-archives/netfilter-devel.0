From: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Subject: Re: [RFC] alternative to conntrack ID
Date: Mon, 13 Jun 2005 09:41:44 +0200 (CEST)
Message-ID: <Pine.LNX.4.58.0506130908500.20636@blackhole.kfki.hu>
References: <424747E3.7000300@eurodev.net> <42502F8D.5030504@trash.net>
	<4254258E.5000204@eurodev.net> <42627BC4.8070103@trash.net>
	<Pine.LNX.4.58.0504290904450.8609@blackhole.kfki.hu>
	<20050429080242.GJ9735@sunbeam.de.gnumonks.org>
	<42789366.20702@ufomechanic.net>
	<4278B23A.7050406@trash.net> <4278B98E.7090707@ufomechanic.net>
	<427B8A46.8090006@trash.net> <427D26E7.8060701@ingate.com>
	<427D3EAF.3020200@trash.net> <427D41FA.5080506@ingate.com>
	<1115648236.25627.17.camel@nienna.balabit>
	<428A1807.8070708@ufomechanic.net> <428A5141.20901@trash.net>
	<Pine.LNX.4.58.0505180948180.9582@blackhole.kfki.hu>
	<42A23EDA.2090307@eurodev.net> <42A24F3B.8050607@eurodev.net>
	<Pine.LNX.4.58.0506061017330.16223@blackhole.kfki.hu>
	<42A83B96.4050302@eurodev.net> <42A83D72.1000106@eurodev.net>
	<Pine.LNX.4.58.0506091519580.7610@blackhole.kfki.hu>
	<42A9698F.30909@eurodev.net>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>,
	Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Pablo Neira <pablo@eurodev.net>
In-Reply-To: <42A9698F.30909@eurodev.net>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: </pipermail/netfilter-devel>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
Sender: netfilter-devel-bounces@lists.netfilter.org
Errors-To: netfilter-devel-bounces@lists.netfilter.org
List-Id: netfilter-devel.vger.kernel.org

Hi Pablo,

On Fri, 10 Jun 2005, Pablo Neira wrote:

> > How are you going to handle id collision due to wraparound?
>
> yes, 8 bits is too short. About the wraparound problem, I'm planning to
> re-use id's. The id of a new conntrack will be set to the lastest
> inserted in the bucket plus one.
>
> However this wouldn't uniquely identify a conntrack: Say a connection is
> established, lastest conntrack in the bucket uses id A, so its id will
> be set to A+1. After quite some time the connection is closed. Then, in
> a very short period of time, another connection with the same tuples is
> established and lastest conntrack id is still A, in that case the id of
> the new conntrack will be set to A+1 again.

Wouldn't be more straightforward to store the last assigned id value in
the bucket and simply increment that whenever the next value is used up?
(Id collision is actually not a big problem, because the entries are
identified by the tuples in the first place.)

At dumping we could use the flip-bit solution: entries which are already
dumped were marked with the next value of the bit. Of course user requests
for dumping must be serialized, but conntrack replication could benefit
from such schema, because new entries could be added to the conntrack
table and replicated during full conntrack table replication as well.

Best regards,
Jozsef
-
E-mail  : kadlec@blackhole.kfki.hu, kadlec@sunserv.kfki.hu
PGP key : http://www.kfki.hu/~kadlec/pgp_public_key.txt
Address : KFKI Research Institute for Particle and Nuclear Physics
          H-1525 Budapest 114, POB. 49, Hungary
