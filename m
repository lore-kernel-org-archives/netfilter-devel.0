From: Bob Arctor <curious@pb194.luban.sdi.tpnet.pl>
Subject: Re: dDoS attacks
Date: Tue, 28 Jan 2003 02:06:10 +0100
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <200301280206.10751.curious@pb194.luban.sdi.tpnet.pl>
References: <20030127232648.31312.21611.Mailman@kashyyyk> <15925.52939.339426.673375@isis.cs3-inc.com>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: don-netf@isis.cs3-inc.com (Don Cohen),
	netfilter-devel@lists.netfilter.org
In-Reply-To: <15925.52939.339426.673375@isis.cs3-inc.com>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

On Tuesday 28 January 2003 01:28, Don Cohen wrote:
> To paraphrase, I think the idea is that when the router sees a packet
> from A to B complaining about traffic then it drops the next n packets
> from B to A.
it sends them back - complaining they're sent, like A did

> You may be correct that this cannot be done by iptables, but it's not
> a very good solution.  For one thing, what makes you think that
> packets with source address A were actually sent from A?
well. this is REJECTED packet. no other router could pass it to this rout=
er,=20
except from someone from my subnet (using same switch, being physically=20
connected to one multiport router, which doesn't distinguish between=20
interfaces... this way attacker can also flood me or do whatever like coz=
 is=20
on same subnet)
if someone would try, this can be easily detected as REJECT packed spoofi=
ng=20
because we have REJECTED packet which we never sent to C(third party).
thus we know C is spoofing our network and we can DROP all REJECT packets=
=20
from C considering damage or abuse, untill damage/abuse isn't fixed.=20

remember that you can sent rejected packets only to peer you have bidir=20
contact with, so i.e. if you have only downlink (i.e. via sat) you can't=20
send rejected packet to be relayed to router (you can only do that if you=
=20
have secure tunnel to router, which is usual scenario for such connection=
).
as REJECTED packets will not be relayed, but only will either block udp=20
traffic to your side (in this case only last router will be blocked and t=
hen=20
will be confused, because will not know where to forward REJECTED packet =
to=20
- because it never had such packet in it's queue, neither source adress w=
ill=20
match any of it's interfaces. it'll look like 'hey you rejected something=
 we=20
never sent to you, liar!')

> Your defense could be used to prevent you from communicating with the
> address of the attacker's choice (unless something prevents him from
> source spoofing).
this defense prevents from spoofing (and also flooding with REJECTED udp=20
packets you never sent to someone... right now you can be flooded this wa=
y.)

> Something closer to a solution is to use connection tracking and
it is completely different field.

>
> For (much) more info on this subject see http://cs3-inc.com/ddos.html

thx
--=20
--=20
