From: "John A. Sullivan III" <john.sullivan@nexusmgmt.com>
Subject: Re: Creating rules without the /sbin/iptables command?
Date: Wed, 17 Mar 2004 18:04:42 -0500
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <1079564682.2112.1.camel@localhost>
References: <40589CF8.8010007@nk.nl>
	 <1079551538.1424.23.camel@anduril.intranet.cartel-securite.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Cc: Victor Julien <victor@nk.nl>, netfilter@lists.netfilter.org,
   netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Cedric Blancher <blancher@cartel-securite.fr>
In-Reply-To: <1079551538.1424.23.camel@anduril.intranet.cartel-securite.net>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

On Wed, 2004-03-17 at 14:25, Cedric Blancher wrote:
> Le mer 17/03/2004 =C3=A0 19:46, Victor Julien a =C3=A9crit :
> > My program (written in c) creates rules by opening a pipe to=20
> > /sbin/iptables. However this is quite slow with large rulessets and on=20
> > slow hardware. Is there another way, like an iptables librarycall or=20
> > something?
>=20
> You could use iptables libs that stand in /usr/lib/iptables, just like
> iptables does.
>=20
> You should however ask netfilter developpers mailing list.
>=20
> Cc : netfilter-devel@lists.netfilter.org
The above solution is probably better than mine but I write out my new
rules to a file in iptables-save format and then use iptables-restore -n
<filename>.  This is dramatically faster than calling iptables - John
--=20
John A. Sullivan III
Chief Technology Officer
Nexus Management
+1 207-985-7880
john.sullivan@nexusmgmt.com
---
If you are interested in helping to develop a GPL enterprise class
VPN/Firewall/Security device management console, please visit
http://iscs.sourceforge.net=20
