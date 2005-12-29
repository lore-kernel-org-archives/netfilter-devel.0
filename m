From: "Greg Scott" <GregScott@InfraSupportEtc.com>
Subject: Error compiling ipt_IPMARK with kernel 2.6.14-5, iptables 1.3.4,
	POM-20051227
Date: Wed, 28 Dec 2005 18:43:05 -0600
Message-ID: <925A849792280C4E80C5461017A4B8A26D3E@mail733.InfraSupportEtc.com>
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

Trying to to a kernel build for 2.6.14-5 with iptables 1.3.4 and
POM-20051227.  Here is a snippet from the output. =20

  CC [M]  net/ipv4/netfilter/ipt_DSCP.o
  CC [M]  net/ipv4/netfilter/ipt_MARK.o
  CC [M]  net/ipv4/netfilter/ipt_IPMARK.o
net/ipv4/netfilter/ipt_IPMARK.c: In function 'target':
net/ipv4/netfilter/ipt_IPMARK.c:36: error: 'struct sk_buff' has no
member named 'nfcache'
net/ipv4/netfilter/ipt_IPMARK.c:36: error: 'NFC_ALTERED' undeclared
(first use in this function)
net/ipv4/netfilter/ipt_IPMARK.c:36: error: (Each undeclared identifier
is reported only once
net/ipv4/netfilter/ipt_IPMARK.c:36: error: for each function it appears
in.)
make[3]: *** [net/ipv4/netfilter/ipt_IPMARK.o] Error 1
make[2]: *** [net/ipv4/netfilter] Error 2
make[1]: *** [net/ipv4] Error 2
make: *** [net] Error 2
[root@dsi-fw linux]#=20

I looked in the list archives and found some references here:
https://lists.netfilter.org/pipermail/netfilter-devel/2005-October/02195
0.html

For now I just won't use it.  Is there a patch available that fixes
ipt_IPMARK yet? =20

Thanks

- Greg Scott
