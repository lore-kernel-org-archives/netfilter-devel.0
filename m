From: "Graham - Reg.CA" <graham@reg.ca>
Subject: Re: match limit with inverse [!]
Date: Fri, 29 Nov 2002 02:11:15 -0800
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <009d01c2978f$a7b6fca0$2a00a8c0@zorro>
References: <00ae01c292ed$2c125aa0$2a00a8c0@zorro> <3DDFC7EC.9A16EB22@wanadoo.fr> <1038074008.8074.23.camel@elendil.intranet.cartel-securite.net>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="ISO-8859-15"
Content-Transfer-Encoding: quoted-printable
Cc: <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: "Cedric Blancher" <blancher@cartel-securite.fr>,
   "Jerome de Vivie" <jerome.de-vivie@wanadoo.fr>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

Thanks!  The new workaround is hardly as convenient, but we managed to wo=
rk
out a workable set of rules in the end.  It would have saved us a lot of
confusion if the documentation (man iptables) of  didn't imply that the "=
!"
rule worked.

Still it would be nice to see the proper inverse work for a later release=
 -
the "inverse" rule is hardly intuitive.

----- Original Message -----
From: "Cedric Blancher" <blancher@cartel-securite.fr>
To: "Jerome de Vivie" <jerome.de-vivie@wanadoo.fr>
Cc: "Graham- Reg.CA" <graham@reg.ca>; <netfilter-devel@lists.netfilter.or=
g>
Sent: Saturday, November 23, 2002 9:53 AM
Subject: Re: match limit with inverse [!]


> Le sam 23/11/2002 =E0 19:24, Jerome de Vivie a =E9crit :
> > Your out of luck. The patch hasn't been applied because it a kernel
> > header and could disturb older versions of netfilter. The patch is un=
der
> > http://perso.wanadoo.fr/jerome.de-vivie/ipt/
>
> However, we can emulate limit inverse with a user chain. Suppose you
> want to log and drop ICMPs that are over the 1/S limit :
>
> iptables -N inv_limit
> iptables -A FORWARD -p icmp -j inv_limit
> iptables -A inv_limit -m limit --limit 1/s -j RETURN \
> --log-prefix "Over limit ICMP "
> iptables -A inv_limit -j LOG
> iptables -A inv_limit -j DROP
> [...]
>
> That's only a workaround...
>
> --
> C=E9dric Blancher  <blancher@cartel-securite.fr>
> IT systems and networks security expert  - Cartel S=E9curit=E9
> Phone : +33 (0)1 44 06 97 87 - Fax: +33 (0)1 44 06 97 99
> PGP KeyID:157E98EE  FingerPrint:FA62226DA9E72FA8AECAA240008B480E157E98E=
E
