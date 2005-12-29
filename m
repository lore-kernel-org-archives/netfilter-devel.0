From: "Greg Scott" <GregScott@InfraSupportEtc.com>
Subject: ipt_IPV4OPTSSTRIP is also broken;
	iptables 1.3.4, kernel 2.6.14-5, POM-20051227
Date: Wed, 28 Dec 2005 23:31:20 -0600
Message-ID: <925A849792280C4E80C5461017A4B8A26D3F@mail733.InfraSupportEtc.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="US-ASCII"
Content-Transfer-Encoding: quoted-printable
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
Content-class: urn:content-classes:message
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

Arrrrrgh - another broken module, ipt_IPV4OPTSSTRIP! Looks like the same
"nfcache" problem. =20
Here is an output snippet:

.
.
.
  CC [M]  net/ipv4/netfilter/ipt_CLASSIFY.o
  CC [M]  net/ipv4/netfilter/ip_nat_snmp_basic.o
  CC [M]  net/ipv4/netfilter/ipt_LOG.o
  CC [M]  net/ipv4/netfilter/ipt_IPV4OPTSSTRIP.o
net/ipv4/netfilter/ipt_IPV4OPTSSTRIP.c: In function 'target':
net/ipv4/netfilter/ipt_IPV4OPTSSTRIP.c:33: warning: implicit declaration
of function 'skb_ip_make_writable'
net/ipv4/netfilter/ipt_IPV4OPTSSTRIP.c:52: error: 'struct sk_buff' has
no member named 'nfcache'
net/ipv4/netfilter/ipt_IPV4OPTSSTRIP.c:52: error: 'NFC_ALTERED'
undeclared (first use in this function)
net/ipv4/netfilter/ipt_IPV4OPTSSTRIP.c:52: error: (Each undeclared
identifier is reported only once
net/ipv4/netfilter/ipt_IPV4OPTSSTRIP.c:52: error: for each function it
appears in.)
make[3]: *** [net/ipv4/netfilter/ipt_IPV4OPTSSTRIP.o] Error 1
make[2]: *** [net/ipv4/netfilter] Error 2
make[1]: *** [net/ipv4] Error 2
make: *** [net] Error 2
[root@dsi-fw linux] =20

- Greg Scott
