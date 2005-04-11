From: harry@gol.net.gy
Subject: connlimit error?
Date: Mon, 11 Apr 2005 18:34:17 GMT
Message-ID: <200504111834.j3BIYH4w031979@mail.gol.net.gy>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: netfilter-devel@lists.netfilter.org
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

Hi,
With linux-2.6.11.6 and patch-o-matic-ng-20050410 (with redhat
gcc-2.96-110), you get:-

net/ipv4/netfilter/ipt_connlimit.c: In function `count_them':
net/ipv4/netfilter/ipt_connlimit.c:72: parse error before `struct'
make[3]: *** [net/ipv4/netfilter/ipt_connlimit.o] Error 1
make[2]: *** [net/ipv4/netfilter] Error 2

Apparently it was fixed
http://svn.netfilter.org/netfilter/branches/patch-o-matic-ng/linux-2.6.11/connlimit/
- I just replaced ipt_connlimit.c in the kernel with
http://svn.netfilter.org/netfilter/branches/patch-o-matic-ng/linux-2.6.11/connlimit/linux-2.6/net/ipv4/netfilter/ipt_connlimit.c
and it compiles clean (and works nicely too).
Question / suggestion - could someone include it in the pom releases ??
Thanks.
