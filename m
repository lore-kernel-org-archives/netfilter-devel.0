From: Cedric Blancher <blancher@cartel-securite.fr>
Subject: Re: Creating rules without the /sbin/iptables command?
Date: Wed, 17 Mar 2004 20:25:39 +0100
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <1079551538.1424.23.camel@anduril.intranet.cartel-securite.net>
References: <40589CF8.8010007@nk.nl>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Transfer-Encoding: quoted-printable
Cc: netfilter@lists.netfilter.org, netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Victor Julien <victor@nk.nl>
In-Reply-To: <40589CF8.8010007@nk.nl>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

Le mer 17/03/2004 =E0 19:46, Victor Julien a =E9crit :
> My program (written in c) creates rules by opening a pipe to=20
> /sbin/iptables. However this is quite slow with large rulessets and on=20
> slow hardware. Is there another way, like an iptables librarycall or=20
> something?

You could use iptables libs that stand in /usr/lib/iptables, just like
iptables does.

You should however ask netfilter developpers mailing list.

Cc : netfilter-devel@lists.netfilter.org

--=20
http://www.netexit.com/~sid/
PGP KeyID: 157E98EE FingerPrint: FA62226DA9E72FA8AECAA240008B480E157E98EE
>> Hi! I'm your friendly neighbourhood signature virus.
>> Copy me to your signature file and help me spread!
