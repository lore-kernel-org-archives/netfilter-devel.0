From: Cedric Blancher <blancher@cartel-securite.fr>
Subject: Re: New extension: CRYPT target
Date: Sun, 21 May 2006 22:34:50 +0200
Message-ID: <1148243690.1016.3.camel@anduril.intranet.cartel-securite.net>
References: <44708E68.9080508@speedy.com.ar>  <4470A895.5090707@rtij.nl>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: quoted-printable
Cc: Gervasio Bernal <gervasiobernal@speedy.com.ar>,
	netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Martijn Lievaart <m@rtij.nl>
In-Reply-To: <4470A895.5090707@rtij.nl>
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

Le dimanche 21 mai 2006 =E0 19:51 +0200, Martijn Lievaart a =E9crit :
> Minor critisism, this will not catch the data channels of ftp, only the=20
> control channel. Active ftp uses a *source* port of 20, passive ftp=20
> (which is more common nowadays) uses whatever port range the server uses=20
> for data channels (typically something like 30000-31000).

You can use helper match, something like -m helper --helper ftp.


--=20
http://sid.rstack.org/
PGP KeyID: 157E98EE FingerPrint: FA62226DA9E72FA8AECAA240008B480E157E98EE
>> Hi! I'm your friendly neighbourhood signature virus.
>> Copy me to your signature file and help me spread!
