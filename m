From: KOVACS Krisztian <hidden@balabit.hu>
Subject: Re: list delete bug: kernel crash
Date: Tue, 31 Aug 2004 12:50:37 +0200
Sender: netfilter-devel-bounces@lists.netfilter.org
Message-ID: <1093949437.2435.4.camel@nienna.balabit>
References: <003701c48ee9$e1ad1f40$0a00a8c0@aziz>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-2
Content-Transfer-Encoding: quoted-printable
Cc: netfilter-devel <netfilter-devel@lists.netfilter.org>,
	netfilter@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: security <security@lea-linux.com>
In-Reply-To: <003701c48ee9$e1ad1f40$0a00a8c0@aziz>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: </pipermail/netfilter-devel>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
Errors-To: netfilter-devel-bounces@lists.netfilter.org
List-Id: netfilter-devel.vger.kernel.org


  Hi,

2004-08-31, k keltez=E9ssel 01:34-kor security ezt =EDrta:
> Aug 30 20:42:24 gateway kernel: NF_IP_ASSERT:
> net/ipv4/netfilter/ip_conntrack_core.c:1115(ip_conntrack_alter_reply)
> Aug 30 20:42:24 gateway kernel: NF_IP_ASSERT:
> net/ipv4/netfilter/ip_conntrack_core.c:1115(ip_conntrack_alter_reply)
> Aug 30 20:44:24 gateway kernel: LIST_DELETE:
> net/ipv4/netfilter/ip_conntrack_core.c:300
> `&ct->tuplehash[IP_CT_DIR_REPLY]'(f3cedca4) not in
>  &ip_conntrack_hash[hr].
>=20
> I have search in bugzilla and google and, apparently, this bug has been=
 solve
> since kernel 2.6.5.
> But i have kernel 2.6.8.1 and i have try kernel 2.6.6 and 2.6.7: same c=
rash
>=20
> But it hard to "see" because i can stay 1 week without crash, or 5mn.
>=20
> I have the "local NAT" activated.

  As always, the first thing you should try is testing the memory of
your computer. The problems seems to be caused by trying to call
ip_nat_setup_info() on an already confirmed connection, which is known
to cause hash corruption.

  BTW, while running memtest, could you send us the nat table of your
iptables ruleset, along with the routing setup? And also a list of
loaded (iptables-related) kernel modules would be useful.

--=20
 Regards,
   Krisztian KOVACS
