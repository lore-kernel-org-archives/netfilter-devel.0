From: Cedric Blancher <blancher@cartel-securite.fr>
Subject: Re: [OT] Re: rp_filtering
Date: Mon, 11 Jul 2005 20:34:04 +0200
Message-ID: <1121106844.5236.16.camel@anduril.intranet.cartel-securite.net>
References: <Pine.LNX.4.61.0507111946560.32325@yvahk01.tjqt.qr>
	<1121105149.5236.5.camel@anduril.intranet.cartel-securite.net>
	<Pine.LNX.4.61.0507112017040.28946@yvahk01.tjqt.qr>
Reply-To: netfilter@lists.netfilter.org
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: quoted-printable
Cc: Netfilter Developer Mailing List <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Jan Engelhardt <jengelh@linux01.gwdg.de>
In-Reply-To: <Pine.LNX.4.61.0507112017040.28946@yvahk01.tjqt.qr>
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

Le lundi 11 juillet 2005 =E0 20:18 +0200, Jan Engelhardt a =E9crit :
> Whoops, meant srcip=3D192.168.222.34

This won't be possible as well, because in this case, rp_filtering will
work. This source is routed via eth0, so no packet sourced from this IP
will not be allowed on ippp0.

> It's about filtering.
> I probably need to add a filter rule for ippp0 to prevent this case.

If you need a rule, then ask Netfilter users mailing list instead
(reply-to positionned to this list) :)))


--=20
http://sid.rstack.org/
PGP KeyID: 157E98EE FingerPrint: FA62226DA9E72FA8AECAA240008B480E157E98EE
>> Hi! I'm your friendly neighbourhood signature virus.
>> Copy me to your signature file and help me spread!
