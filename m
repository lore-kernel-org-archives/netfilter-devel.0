From: "Colin Harrison" <colin.harrison@virgin.net>
Subject: Unable to build iptables on linux kernel 2.6.10 + 2.6.11-rc2 +
	2.6.11-rc2-bk5
Date: Thu, 27 Jan 2005 15:53:05 -0000
Message-ID: <200501271553.j0RFr747004108@StraightRunning.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
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

Hi
I am experimenting with the linux kernel 2.6.10 + 2.6.11-rc2 +
2.6.11-rc2-bk5.
When I try to build CVS snapshot iptables (iptables-1.3.0-20050125) against
this kernel I get:-


make KERNEL_DIR=/home/src/kernel/linux-2.6.10
....
cc -O2 -Wall -Wunused -I/home/src/kernel/linux-2.6.10/include -Iinclude/
-DIPTABLES_VERSION=\"1.3.0-20050125\"  -fPIC -o
extensions/libipt_conntrack_sh.o -c extensions/libipt_conntrack.c
In file included from extensions/libipt_conntrack.c:13:
/home/src/kernel/linux-2.6.10/include/linux/netfilter_ipv4/ip_conntrack_tupl
e.h:67: error: parse error before "u8"
/home/src/kernel/linux-2.6.10/include/linux/netfilter_ipv4/ip_conntrack_tupl
e.h:67: warning: no semicolon at end of struct or union
/home/src/kernel/linux-2.6.10/include/linux/netfilter_ipv4/ip_conntrack_tupl
e.h:67: warning: no semicolon at end of struct or union
/home/src/kernel/linux-2.6.10/include/linux/netfilter_ipv4/ip_conntrack_tupl
e.h:70: warning: type defaults to `int' in declaration of `dir'
...

The kernel appears to be patched with all the latest conntrack changes and
compiles cleanly.

More info. can be supplied, as required.

Thanks

Colin Harrison
