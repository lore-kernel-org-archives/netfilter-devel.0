From: Cedric de Launois <delaunois@info.ucl.ac.be>
Subject: Re: iptables ROUTE
Date: Mon, 10 Jan 2005 11:07:42 +0100
Message-ID: <1105351662.9214.23.camel@descartes.info.ucl.ac.be>
References: <001301c4f465$2ae966b0$030aa8c0@T>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: quoted-printable
Cc: Netfilter-devel <netfilter-devel@lists.netfilter.org>,
	Patrick Schaaf <bof@bof.de>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Tadas <tpt@pupa.da.ru>
In-Reply-To: <001301c4f465$2ae966b0$030aa8c0@T>
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

Le vendredi 07 janvier 2005 =E0 05:01 +0200, Tadas a =E9crit :
> Hi,

Hi, comments below...

> I am using your iptables ROUTE module quite much, it is very usefull th=
ing
> which alows to do what most of people cant even imagine.
> i prefer to use iptables route instead of linux native routing, because=
 it
> is more flexibe. --tee option should allow to fix multicast routing pro=
blem
> now there is no way to route such traffic on linux

You should also direct your mail to Patrick Schaaf, who coded the --tee
option.

> But something is wrong with --tee option, as I aunderstand it should no=
t
> affect anything, but packet disapears instead, and goes nowhere.
> everything elese is working. I am using little old kernel 2.4.22 but th=
at
> should not be problem.
>  I used latest source code from CVS
>=20
> also seems this module somehow incorrectly handle multicat traffic,  ev=
en
> without tee option it should be able to forward it ,
> but I dont see anything on other side.
> I am not sure is there are no other problems, why this dont work. So I =
will
> check everything again, but seems there is some problems wih ROUTE modu=
le

This option wasn't intented to solve multicast routing issues,
so I'm not surprised of your problems.=20

> Now I did not have time to fix these problems myself, you probably can =
do
> that much easer, because you know better your own code.
> also I think one more option is needed: now tee can only copy and send
> immediately, what is not enough, because it may be nesecary to mangle p=
acket
> before sending.
> the most easy way is to send copied packet to some iptables chain inste=
ad of
> sending to interface. probably this is even more easy to implement. and=
 much
> more flexible.
> because we can mark and  route that copy anytime then.

My feeling is also that we need something more flexible, like a target th=
at
duplicates a packet and sets a mark to it, so that further rules can be a=
pplied.
Patrick : would this king of target fill your needs ?

> I am going to write some iptables extensions too, but little later.

What about a 'DUP' target ?

Cedric
