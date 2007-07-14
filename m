From: Patrick McHardy <kaber@trash.net>
Subject: Re: tcpmss match for IPv6 ?
Date: Sat, 14 Jul 2007 17:14:50 +0200
Message-ID: <4698E86A.4070301@trash.net>
References: <4696A0C6.6040905@plouf.fr.eu.org> <46977A73.5040200@trash.net>
	<4697ACCF.9090808@plouf.fr.eu.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: quoted-printable
Cc: netfilter-devel <netfilter-devel@lists.netfilter.org>,
	Yasuyuki KOZAKAI <yasuyuki.kozakai@toshiba.co.jp>
To: Pascal Hambourg <pascal.mail@plouf.fr.eu.org>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
In-Reply-To: <4697ACCF.9090808@plouf.fr.eu.org>
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

Pascal Hambourg wrote:
> Patrick McHardy a =E9crit :
>=20
>>
>> The latest iptables release should contain an IPv6 capable TCPMSS targ=
et.
>=20
>=20
> Thanks, but I was talking about an IPv6 capable tcpmss *match*.


Sorry, I misunderstood.

> I just made libip6t_tcpmss.c, ip6t_tcpmss.h and libip6t_tcpmss.man from
> the existing corresponding IPv4 files in iptables 1.3.8, roughly by
> replacing all occurrences of 'ip' with 'ip6'. It builds and seems to
> work on my x86 box. Shall I post a diff -ruN against the original
> iptables 1.3.8 tree here for review ?


ip6_tables ports for x_tables matches and targets should ideally already
use the xt_ structures and constants. If you send a patch for tcpmss
I'll happily add it to SVN.


BTW, Yasuyuki, whats the current state of your x_tables userspace
patches? I recall they we're almost finished when you posted them
a couple of month ago.
