From: Russell Whitaker <russ@ashlandhome.net>
Subject: bug report
Date: Sat, 2 Aug 2003 11:10:45 -0700 (PDT)
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <Pine.LNX.4.53.0308021058060.423@bigred.russwhit.org>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: netfilter-devel@lists.netfilter.org
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

hi
Downloaded vers 1.2.8

Executing this:
  make KERNEL_DIR=/home/russ/linux-2.6.0-test2 > ../tmp 2>&1

I got:

Extensions found: IPv4:recent IPv6:ah IPv6:esp IPv6:frag IPv6:ipv6header IPv6:hbh IPv6:dst IPv6:rt
cc -O2 -Wall -Wunused -I/home/russ/linux-2.6.0-test2/include -Iinclude/ -DIPTABLES_VERSION=\"1.2.8\"  -fPIC -o extensions/libipt_physdev_sh.o -c extensions/libipt_physdev.c
extensions/libipt_physdev.c: In function `parse':
extensions/libipt_physdev.c:86: `IPT_PHYSDEV_OP_MATCH_IN' undeclared (first use in this function)
extensions/libipt_physdev.c:86: (Each undeclared identifier is reported only once
extensions/libipt_physdev.c:86: for each function it appears in.)
extensions/libipt_physdev.c:97: `IPT_PHYSDEV_OP_MATCH_OUT' undeclared (first use in this function)
extensions/libipt_physdev.c: In function `print':
extensions/libipt_physdev.c:144: `IPT_PHYSDEV_OP_MATCH_IN' undeclared (first use in this function)
extensions/libipt_physdev.c:146: `IPT_PHYSDEV_OP_MATCH_OUT' undeclared (first use in this function)
extensions/libipt_physdev.c: In function `save':
extensions/libipt_physdev.c:156: `IPT_PHYSDEV_OP_MATCH_IN' undeclared (first use in this function)
extensions/libipt_physdev.c:158: `IPT_PHYSDEV_OP_MATCH_OUT' undeclared (first use in this function)
make: *** [extensions/libipt_physdev_sh.o] Error 1

Kernel 2.6.0-test2 seems to work OK but since don't want to run without a
firewall went back to 2.4.21 for now.

Suggestions? Fix? Patch?

Thanks,
  Russ
