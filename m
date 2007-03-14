From: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Subject: Re: [PATCH 1/1] Re: dangerous? Setting mark in nat table
Date: Wed, 14 Mar 2007 15:47:51 +0100 (CET)
Message-ID: <Pine.LNX.4.64.0703141522190.26704@blackhole.kfki.hu>
References: <et6fp4$l04$1@sea.gmane.org>
	<Pine.LNX.4.61.0703131632190.18488@yvahk01.tjqt.qr>
	<45F6CD7C.40708@ufomechanic.net>
	<Pine.LNX.4.61.0703131717440.18488@yvahk01.tjqt.qr>
	<1173868532.26913.39.camel@henriknordstrom.net>
	<45F7D657.8070907@trash.net>
	<1173876211.26913.73.camel@henriknordstrom.net>
	<45F7F027.9050300@ufomechanic.net> <45F7F3C6.3060908@trash.net>
	<Pine.LNX.4.64.0703141415200.26704@blackhole.kfki.hu>
	<45F802AF.6010307@ufomechanic.net>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Cc: Jan Engelhardt <jengelh@linux01.gwdg.de>,
	netfilter-devel@lists.netfilter.org, Patrick McHardy <kaber@trash.net>,
	Henrik Nordstrom <henrik@henriknordstrom.net>
To: Amin Azez <azez@ufomechanic.net>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
In-Reply-To: <45F802AF.6010307@ufomechanic.net>
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

Hi,

On Wed, 14 Mar 2007, Amin Azez wrote:

>> Sorry, but I disagree. The DSCP, ECN, TOS, TTL, HL targets modify the
>> packet itself and thus all belong to the mangle table alone.
> I'd like to be with Jozsef on that (while we have the current framework,
> although I hate the mangle/filter distinction) except that local-out
> packets at least have a FILTER after DNAT before routing, but
> bridged/routed packets don't have anything betweenPREROUTING DNAT and
> routing. With the current framework we could do with a FILTER and MANGLE
> both before and after NAT on PREROUTING and communicate using marks.

Something I miss here: the mangle table has got all the hooks. Before and 
after routing (DNAT), both for local and forwarded packets.

> However, to me, NAT is just a 1-packet MANGLE; and FILTER and MANGLE are
> an arbitrary distinction.
>
> It would make more sense to have only 1 table and let users invent
> NAT/MANGLE/FILTER chains if they wanted (for old times sake); and just
> treat snat and dnat targets as if they had an implicit "-m ctstate
> --ctstate NEW".

That is doable, but someting else, not iptables (plural :-).

> Am I right, or do tables still help?

I believe the tables help to distinguis among functionalities. You can 
argue that the targets *are* the functionalities and not the tables and 
you were right. But we have got hooks *and* priorities at the hooks in 
netfilter. So in the one table model the user had to keep in mind not only 
the hooks (chains) but the priorities as well: before conntrack, after 
conntrack, before routing, after routing, at the same hook. Exactly what 
is solved by the tables in iptables.

Best regards,
Jozsef
-
E-mail  : kadlec@blackhole.kfki.hu, kadlec@sunserv.kfki.hu
PGP key : http://www.kfki.hu/~kadlec/pgp_public_key.txt
Address : KFKI Research Institute for Particle and Nuclear Physics
           H-1525 Budapest 114, POB. 49, Hungary
