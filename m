From: Joel Newkirk <netfilter@newkirk.us>
Subject: Re: How does a NAT-packet traverse?
Date: Sat, 15 Mar 2003 22:32:48 -0500
Sender: netfilter-admin@lists.netfilter.org
Message-ID: <200303152232.48204.netfilter@newkirk.us>
References: <20030314070154.5FDA81CFB5E00@sm203.163.com>
Reply-To: netfilter@newkirk.us
Mime-Version: 1.0
Content-Type: text/plain;
  charset="gb2312"
Content-Transfer-Encoding: quoted-printable
Cc: "netfilter-devel@lists.netfilter.org" <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-admin@lists.netfilter.org>
To: Bobo <boboaq@163.com>,
   "netfilter@lists.netfilter.org" <netfilter@lists.netfilter.org>
In-Reply-To: <20030314070154.5FDA81CFB5E00@sm203.163.com>
Errors-To: netfilter-admin@lists.netfilter.org
List-Help: <mailto:netfilter-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter>,
	<mailto:netfilter-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter>,
	<mailto:netfilter-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter/>
List-Id: netfilter-devel.vger.kernel.org

On Friday 14 March 2003 02:02 am, Bobo wrote:
>  Hello:
>
>         Now,I  am studying how to setup Iptable rules,and I meet a
> question.
>
>         I would like to know how netfilter  do with a packet which is
> the response of
>
>         a NAT-packet from the inside network?
>
>         Where does netfilter do with these packets and give them
> original IP address?

I assume you mean that a client behind an NATting gateway has sent out a=20
packet (perhaps an HTTP request) which has been SNATted in POSTROUTING=20
so that it uses the gateway's public IP instead of the client's private=20
IP - and you are asking about the return traffic.

They come to the NATting box from the destination of the original packet,=
=20
and hit PREROUTING.  They are recognized as being replies to outbound=20
traffic that was SNATted, so while in nat PREROUTING (or just after, I'm=20
not certain) the SNAT that was performed on the request is reversed on=20
the reply, so that the destination IP is changed from the gateway's=20
public IP to the client's private IP. =20

After PREROUTING a routing decision is made, which recognizes these=20
packets as destined for a client machine on the local network, NOT the=20
gateway itself.  (the unSNAT has already taken place, the DestIP is now=20
the original client)  At this point the packet goes to the FORWARD=20
chain, and so long as it is ACCEPTed there, it goes to POSTROUTING and=20
then out the local interface to the original client machine.

>        Will these packets pass through INPUT chains and go out from
> OUT chains?and  they are

Nope.  INPUT is for packets destined for the gateway machine itself in=20
this scenario.  While the return packets have that machine's public IP=20
as their destination when they come in, this is changed to the IP of the=20
original client before routing decision, so they go to FORWARD instead=20
of INPUT.  OUTPUT would be for traffic originating on the gateway=20
itself.

>        changed at the local process ?

All these changes are handled by netfilter in the kernel, before anything=
=20
in userspace ever sees the packet.  A local process normally cannot see=20
a packet unless the routing decision determines that it is destined for=20
the local box (the one running the firewall rules) and sends it to the=20
INPUT chain, which would have to ACCEPT it.  THEN it would be possible=20
for a local userspace process to see the packet.

j
