From: "php0t" <php0t@zorro.hu>
Subject: connlimit
Date: Mon, 14 Aug 2006 01:14:20 +0200
Message-ID: <002d01c6bf2e$351f1c70$650ba8c0@DORKA>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
Cc: ole@ans.pl
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


  Dear developers,

I've had a nice time trying to limit connections. The kernel is
2.6.17.8.
Apart from the first couple of annoyances (such as the patch being
renamed from iplimit to connlimit, patch-o-matic not being able to apply
it to the current kernel etc), I've managed to patch manually, compile
it as a module and load it.

  However, when I try to add an according test rule, I get the 'Invalid
argument' error, and dmesg says:
ip_tables: connlimit match: invalid size 0 != 16

I also tried going to the site mentioned in the latest pom-ng's
source.list:

# ipp2p, time, IPMARK and connlimit maintained by Krzysztof Oledzki
<ole@ans.pl>
http://people.netfilter.org/ole/pom/

But all I get is a smiley :)

When I google for my current problem, most suggest that connlimit is
out-of-date, nobody cares about it any more, etc.

As I'm no C coder, my two questions are,
1) what could I do  to make this work ? Are there any similar modules
available that are stable?
2) could it be possible to stabilize this patch and have it added to the
kernel source? There are so many iptables extensions and modules by
default that are probably rarely used, why is this (IMHO very basic)
feature excluded?

  Thanks for reading and any replies
P.
