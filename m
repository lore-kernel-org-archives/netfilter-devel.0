From: Cedric Blancher <blancher@cartel-securite.fr>
Subject: Re: match limit with inverse [!]
Date: 23 Nov 2002 18:53:28 +0100
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <1038074008.8074.23.camel@elendil.intranet.cartel-securite.net>
References: <00ae01c292ed$2c125aa0$2a00a8c0@zorro>
	 <3DDFC7EC.9A16EB22@wanadoo.fr>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: quoted-printable
Cc: "Graham- Reg.CA" <graham@reg.ca>, netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Jerome de Vivie <jerome.de-vivie@wanadoo.fr>
In-Reply-To: <3DDFC7EC.9A16EB22@wanadoo.fr>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

Le sam 23/11/2002 =E0 19:24, Jerome de Vivie a =E9crit :
> Your out of luck. The patch hasn't been applied because it a kernel
> header and could disturb older versions of netfilter. The patch is unde=
r
> http://perso.wanadoo.fr/jerome.de-vivie/ipt/

However, we can emulate limit inverse with a user chain. Suppose you
want to log and drop ICMPs that are over the 1/S limit :

	iptables -N inv_limit
	iptables -A FORWARD -p icmp -j inv_limit
	iptables -A inv_limit -m limit --limit 1/s -j RETURN \
		--log-prefix "Over limit ICMP "
	iptables -A inv_limit -j LOG
	iptables -A inv_limit -j DROP
	[...]

That's only a workaround...

--=20
C=E9dric Blancher  <blancher@cartel-securite.fr>
IT systems and networks security expert  - Cartel S=E9curit=E9
Phone : +33 (0)1 44 06 97 87 - Fax: +33 (0)1 44 06 97 99
PGP KeyID:157E98EE  FingerPrint:FA62226DA9E72FA8AECAA240008B480E157E98EE
