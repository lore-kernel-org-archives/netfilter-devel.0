From: "Marco Berizzi" <pupilla@hotmail.com>
Subject: snat to multiple source ip
Date: Mon, 26 Sep 2005 17:38:48 +0200
Message-ID: <BAY103-DAV93096D8E2EFC3B50E721DB28B0@phx.gbl>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: <netfilter-devel@lists.netfilter.org>
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

Hello everybody.
I would like to better understand the SNAT target when
multiple --to-source are specified.

Man states:

"You can add several --to-source option. If you specify
more than one source address, either via an address range
or multiple --to-source options, a simple round-robin  (one
after another in cycle) takes place between these addresses."

iptables -t nat -I POSTROUTING -s ipX --protocol tcp
-j SNAT --to first_ip --to second_ip

This round robin cycle is per socket. Correct?

But, after a little test, I have concluded that SNAT
choose the second IP when the system open a second
socket to the same host.

SNAT test results:

1st socket opened to a.a.a.a  -->> SNAT with first_ip
2nd socket opened to b.b.b.b  -->> SNAT with first_ip
3rd socket opened to c.c.c.c  -->> SNAT with first_ip
4th socket opened to b.b.b.b  -->> SNAT with second_ip
5th socket opened to d.d.d.d  -->> SNAT with first_ip
6th socket opened to a.a.a.a  -->> SNAT with second_ip

I think it should work in this manner:

1st socket opened to a.a.a.a  -->> SNAT with first_ip
2nd socket opened to b.b.b.b  -->> SNAT with second_ip
3rd socket opened to c.c.c.c  -->> SNAT with first_ip
4th socket opened to b.b.b.b  -->> SNAT with second_ip
5th socket opened to d.d.d.d  -->> SNAT with first_ip
6th socket opened to a.a.a.a  -->> SNAT with second_ip

May anyone confirm this? Wrong or correct?
