From: Cedric Blancher <blancher@cartel-securite.fr>
Subject: [OT] Re: rp_filtering
Date: Mon, 11 Jul 2005 20:05:49 +0200
Message-ID: <1121105149.5236.5.camel@anduril.intranet.cartel-securite.net>
References: <Pine.LNX.4.61.0507111946560.32325@yvahk01.tjqt.qr>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: quoted-printable
Cc: Netfilter Developer Mailing List <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Jan Engelhardt <jengelh@linux01.gwdg.de>
In-Reply-To: <Pine.LNX.4.61.0507111946560.32325@yvahk01.tjqt.qr>
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

Le lundi 11 juillet 2005 =E0 19:50 +0200, Jan Engelhardt a =E9crit :
> rp_filter is said to be a route path verification (etc.)
>   ippp0  217.245.127.134
>   eth0   192.168.222.1
> However, I've just done a ping 217.245.127.134 from a windows client insi=
de=20
> the eth0 network, took a peek at iptraf and saw that echo requests and re=
plies=20
> were directly going from/to eth0/192.168.222.34(windows).

It's normal Linux behaviour. You can join any Linux box IP on any of its
interfaces.

> That means someone could send a srcip=3D192.168.222.1 dstip=3D217.245.127=
.134=20
> packet to me on ippp0, could it? Or where is the verification...

No, because you cannot use a Linux box own IP as source of a packet
received on any other interface than lo. If you do this, packet will be
discarded.

BTW, what's the relation with Netfilter ?


--=20
http://sid.rstack.org/
PGP KeyID: 157E98EE FingerPrint: FA62226DA9E72FA8AECAA240008B480E157E98EE
>> Hi! I'm your friendly neighbourhood signature virus.
>> Copy me to your signature file and help me spread!
