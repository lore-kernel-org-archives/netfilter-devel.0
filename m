From: Cedric Blancher <blancher@cartel-securite.fr>
Subject: Re: tcp match silently drops packets
Date: Mon, 17 Oct 2005 16:01:26 +0200
Message-ID: <1129557686.11439.46.camel@anduril.intranet.cartel-securite.net>
References: <4349D97A.9070708@snapgear.com>
	<200510160751.j9G7ph5t009316@toshiba.co.jp>
	<Pine.LNX.4.61.0510161931530.32106@filer.marasystems.com>
	<Pine.LNX.4.61.0510162247010.802@filer.marasystems.com>
	<a60102c30510170647w24a8928o@mail.gmail.com>
	<Pine.LNX.4.61.0510171549520.21372@filer.marasystems.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: quoted-printable
Cc: Netfilter Developers <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Henrik Nordstrom <hno@marasystems.com>
In-Reply-To: <Pine.LNX.4.61.0510171549520.21372@filer.marasystems.com>
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

Le lundi 17 octobre 2005 =E0 15:52 +0200, Henrik Nordstrom a =E9crit :
> An IP fragment with offset 1 can overwrite parts of the TCP header, and i=
f=20
> this check is not there an attacker could bypass port matches in iptables=
=20
> by sending the packet in two fragments where the first fragment (which is=
=20
> used by the tcp match) has ports which is allowed by the ruleset and late=
r=20
> the second fragment (which is ignored by the tcp match) overwrites the=20
> port numbers with ports which would not be allowed by the ruleset.

I always though conntrack was defragmenting datagrams before filtering.
Thus, if we filter on defragmented datagrams, then we can't get foold by
fragmentation overlapping based attacks. Am I wrong ?


--=20
http://sid.rstack.org/
PGP KeyID: 157E98EE FingerPrint: FA62226DA9E72FA8AECAA240008B480E157E98EE
>> Hi! I'm your friendly neighbourhood signature virus.
>> Copy me to your signature file and help me spread!
