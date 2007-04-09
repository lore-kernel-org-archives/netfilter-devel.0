From: Cedric Blancher <blancher@cartel-securite.fr>
Subject: Re: ICMP Land Attack
Date: Mon, 09 Apr 2007 14:36:47 +0200
Message-ID: <1176122208.20846.7.camel@anduril.intranet.cartel-securite.net>
References: <007a01c77a9d$b2727c50$dd2d10ac@synapse.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: quoted-printable
Cc: netfilter-devel@lists.netfilter.org
To: Manish Jain <manish.jain@globallogic.com>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
In-Reply-To: <007a01c77a9d$b2727c50$dd2d10ac@synapse.com>
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

Le lundi 09 avril 2007 =E0 17:23 +0530, Manish Jain a =E9crit :
> We are experiencing ICMP Land Attach (ICMP packet with [source ip =3D des=
t ip]
> && [source mac =3D=3D dest mac]).
> Do we have any standard mechanism to counter this attach using
> iptable/ipsets? Or any other suggestion?

Activate Reverse Path Filtering that checks if incoming interface is
consistent to routing table, and drops it if not:

for i in /proc/sys/net/ipv4/conf/*/rp_filter; do
	echo 1 > $i;
done

Don't forget to activate martians logging to see them in your logs:

for i in /proc/sys/net/ipv4/conf/*/log_martians; do
	echo 1 > $i;
done


In addition to this, when a packet reaching a Linux box comes from one
of its own IP address and is received on an external interface, it is
silently dropped.


--=20
http://sid.rstack.org/
PGP KeyID: 157E98EE FingerPrint: FA62226DA9E72FA8AECAA240008B480E157E98EE
>> Hi! I'm your friendly neighbourhood signature virus.
>> Copy me to your signature file and help me spread!
