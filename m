From: =?ISO-8859-1?Q?S=E9bastien_Bernard?= <sbernard@nerim.net>
Subject: Re: pppoe with NAT not working
Date: Fri, 21 Oct 2005 19:13:11 +0200
Message-ID: <435921A7.6050703@nerim.net>
References: <23027.::ffff:195.115.41.103.1129902602.squirrel@webmail.nerim.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: quoted-printable
Cc: netfilter-devel@lists.netfilter.org, netfilter@lists.netfilter.org
Return-path: <netfilter-bounces@lists.netfilter.org>
In-Reply-To: <23027.::ffff:195.115.41.103.1129902602.squirrel@webmail.nerim.net>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter>,
	<mailto:netfilter-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: </pipermail/netfilter>
List-Post: <mailto:netfilter@lists.netfilter.org>
List-Help: <mailto:netfilter-request@lists.netfilter.org?subject=help>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter>,
	<mailto:netfilter-request@lists.netfilter.org?subject=subscribe>
Sender: netfilter-bounces@lists.netfilter.org
Errors-To: netfilter-bounces@lists.netfilter.org
List-Id: netfilter-devel.vger.kernel.org

S=E9bastien Bernard a =E9crit :

>Hi,
>I got a real big headache.
>
>My DSL provider a few ago upgraded my line and for this changed the BAS =
my
>box used to connect with.
>
>I had to reconfigure the ppp configuration.
>Before, I was using :
>pty "/usr/sbin/pppoe -I eth0 -T 80 -m 1452"
>It ceased working.
>
>The new configuration is using the rp-pppoe.so plugin as :
>plugin /usr/lib/pppd/2.4.3/rp-pppoe.so
>
>Since this modification, I'm not able to do any NAT or MASQUERADE with m=
y
>gateway.
>My network architecture is :
>
>Private lan (192.168.x.x) =3D> GW (public fixed address) =3D> DSl Modem =
=3D>
>Internet
>
>When any machine on the private LAN try make a connection to an outside
>address, the connection made is ok.
>
>The three-way handshake is OK with the packets correctly NATED.
>
>When the outside peer tries to send data to the internal peer, the Gatew=
ay
>sends a reset back to it without breaking the connection inside of cours=
e.
>
>It looks like the netfilters didn't accept the incoming packets with
>payload as part of the nated connection.
>
>I had a look to the ip_conntrak connection and the faulty connection is
>correctly tracked, with an entry.
>
>I don't really understand what is happenning.
>
>The configuration is nothing special and could resumed as :
>iptables -t nat -A POSTROUTING -o ppp0 -j SNAT --to-source <public addre=
ss>
>
>This was working before and I didn't touch anything to the configuration
>but the public address that changed when I moved to a speedier DSL line.
>
>If anyone could propose an explaination ...
>
>  Seb
> =20
>
I figured out the problem.

NAT is not working with the rp-pppoe.so plugin.
I moved back to the

pty "/usr/sbin/pppoe -I eth0 -T 80 -m 1452"

Which worked now (go figure...).
And NAT is working again.

Any reason for this ?
