From: Bob Arctor <curious@pb194.luban.sdi.tpnet.pl>
Subject: udp REJECT....
Date: Mon, 27 Jan 2003 05:13:19 +0100
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <200301270513.19862.curious@pb194.luban.sdi.tpnet.pl>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-2"
Content-Transfer-Encoding: quoted-printable
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: netfilter-devel@lists.netfilter.org
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

hello... i have problems with dDoS attacks, and would like to set up my l=
inux=20
routers dDoS proof and not being relays like most of available commercial=
=20
routers.

i am not very skilled in using iptables, but as far i know it is not poss=
ible=20
to write following rule :

ip A is attacker ip V is victim.

R is our router.

udp packets go from A to V via R . Victim have soft/alive admin and start=
s to=20
reject packtets from Attacker (udp flood) . they go via same route - beca=
use=20
they're rejected. so first router hitted by them should be R .

router should then block 10x packets recieved from attacker - by rejectin=
g=20
them too, instead of forwarding them to victim.
so for each rejected packtet from victim router should reject next 10 pac=
kets=20
recieved from attacker .  this way victim'll recieve only 1/10 of origina=
l=20
packets coming from attacker. it would be also nice to add feature to=20
dynamically set how much packets Router should reject.
this way there is also possible shaping of traffic while Victim have=20
congested connection - by rejecting packets which can't fit queue. this w=
ay=20
Attacker can stop sending packets for a while, while they would be droppe=
d=20
anyway, so it could reduce network load ...

i think something like syncookies plugin could help - because it have to=20
build up new iptables rule basing on analyse of incoming packets...

i think about quick nasty hack :=20
forward all rejected packets back to forward queue (to it's input)
deny forwarding of rejected packets (on output of this queue, so victim'l=
l=20
not recieve his own rejected packets back, but they'll pass thru forward=20
queue anyway...)
apply TBF on each forward queue  and set it up so it would 'overflow' onl=
y if=20
rejected packet is in . when overflowed it should block all traffic.
i think there is iptables rule for counting packets. it should be set up =
this=20
way, that this 'locked' state would last for at least 10 packets no matte=
r=20
rejected or not.=20

this is very ugly, as you need to set up tbf queue with detecting of reje=
cted=20
packet presence and drop queue for each rejected packet on out of this qu=
eue=20
for each udp port you forward...
but if someone owns powerfull machine for router - it is better than leav=
ing=20
machine unprotected acting as dDoS relay.


i know this solution contains many logical errors, i would be gratefull i=
f=20
someone at least tried to understand what i meant, and wrote working=20
solution...=20



--=20
--=20
