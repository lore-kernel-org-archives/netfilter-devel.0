From: Cedric Blancher <blancher@cartel-securite.fr>
Subject: Re: How to log all the packets through netfilter?
Date: 12 Mar 2003 11:56:17 +0100
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <1047466577.9484.3.camel@elendil.intranet.cartel-securite.net>
References: <20030312103355.9C1FF1C9C2DCC@sm206.163.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: quoted-printable
Cc: "netfilter@lists.netfilter.org" <netfilter@lists.netfilter.org>,
   "netfilter-devel@lists.netfilter.org" <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Bobo <boboaq@163.com>
In-Reply-To: <20030312103355.9C1FF1C9C2DCC@sm206.163.com>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

Le mer 12/03/2003 a 11:34, Bobo a ecrit :
>         While using IPtables,I am now trying to log all the packets
> the firewall receives.
>      Now,I could log such packets that match the set rules.If receive
> some packet which does=20
> not meet any rules in a chain,how to log it?

End you chain with a LOG target alone, e.g. for INPUT chain :

	iptables -A INPUT -j LOG

At the end of script.

--=20
C=E9dric Blancher  <blancher@cartel-securite.fr>
IT systems and networks security expert  - Cartel S=E9curit=E9
Phone : +33 (0)1 44 06 97 87 - Fax: +33 (0)1 44 06 97 99
PGP KeyID:157E98EE  FingerPrint:FA62226DA9E72FA8AECAA240008B480E157E98EE
