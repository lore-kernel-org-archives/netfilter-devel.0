From: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Subject: [ANNOUNCE] ipset 2.0 released
Date: Thu, 2 Dec 2004 20:32:13 +0100 (CET)
Message-ID: <Pine.LNX.4.58.0412022016180.29298@blackhole.kfki.hu>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: netfilter@lists.netfilter.org,
	netfilter-devel@lists.netfilter.org
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

I'm happy to announce ipset 2.0! If you want to

- store multiple IP addresses or port numbers and match against the
  collection at one swoop;
- dynamically update rules against IP addresses or ports without
  performance penalty;
- express complex IP address and port based rulesets with one single
  iptables rule and benefit from the speed of IP sets

then check out

	http://people.netfilter.org/kadlec/ipset/

This is a major rewriting of the previous ipset version. The most
important changes are

- Chaining of sets are changed: child sets replaced by bindings
- Kernel-userspace communication reorganized to minimize the
  number of syscalls
- Save and restore functionality implemented
- iphash type reworked: clashing resolved by double-hashing and by
  dynamically growing the set.

Best regards,
Jozsef
-
E-mail  : kadlec@blackhole.kfki.hu, kadlec@sunserv.kfki.hu
PGP key : http://www.kfki.hu/~kadlec/pgp_public_key.txt
Address : KFKI Research Institute for Particle and Nuclear Physics
          H-1525 Budapest 114, POB. 49, Hungary
