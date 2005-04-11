From: Maciej Soltysiak <pysiak_satriani@o2.pl>
Subject: libipt_REJECT does not compile with current svn
Date: Mon, 11 Apr 2005 20:02:22 +0200
Message-ID: <1995673631.20050411200222@o2.pl>
Reply-To: Maciej Soltysiak <pysiak_satriani@o2.pl>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
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

Trying to compile current svn with 2.6.12-rc2 give me this:

Extensions found: IPv4:CLUSTERIP IPv4:recent IPv6:ah IPv6:esp IPv6:frag IPv6:ipv6header IPv6:hbh IPv6:dst IPv6:rt
cc -O2 -Wall -Wunused -I/usr/src/linux/include -Iinclude/ -DIPTABLES_VERSION=\"1.3.1\"  -fPIC -o extensions/libipt_REJECT_sh.o -c extensions/libipt_REJECT.c
extensions/libipt_REJECT.c:50: error: `IPT_ICMP_FRAG_NEEDED' undeclared here (not in a function)
extensions/libipt_REJECT.c:50: error: initializer element is not constant
extensions/libipt_REJECT.c:50: error: (near initialization for `reject_table[7].with')
extensions/libipt_REJECT.c:50: error: initializer element is not constant
extensions/libipt_REJECT.c:50: error: (near initialization for `reject_table[7]')
extensions/libipt_REJECT.c:52: error: initializer element is not constant
extensions/libipt_REJECT.c:52: error: (near initialization for `reject_table[8]')
extensions/libipt_REJECT.c: In function `init_v1':
extensions/libipt_REJECT.c:110: error: dereferencing pointer to incomplete type
extensions/libipt_REJECT.c: In function `parse_v1':
extensions/libipt_REJECT.c:169: error: dereferencing pointer to incomplete type
extensions/libipt_REJECT.c:180: error: dereferencing pointer to incomplete type
extensions/libipt_REJECT.c:180: error: `IPT_ICMP_FRAG_NEEDED' undeclared (first use in this function)
extensions/libipt_REJECT.c:180: error: (Each undeclared identifier is reported only once
extensions/libipt_REJECT.c:180: error: for each function it appears in.)
extensions/libipt_REJECT.c:185: error: dereferencing pointer to incomplete type
extensions/libipt_REJECT.c: In function `print_v1':
extensions/libipt_REJECT.c:228: error: dereferencing pointer to incomplete type
extensions/libipt_REJECT.c:233: error: dereferencing pointer to incomplete type
extensions/libipt_REJECT.c:233: error: `IPT_ICMP_FRAG_NEEDED' undeclared (first use in this function)
extensions/libipt_REJECT.c:234: error: dereferencing pointer to incomplete type
extensions/libipt_REJECT.c: In function `save_v1':
extensions/libipt_REJECT.c:260: error: dereferencing pointer to incomplete type
extensions/libipt_REJECT.c:265: error: dereferencing pointer to incomplete type
extensions/libipt_REJECT.c:265: error: `IPT_ICMP_FRAG_NEEDED' undeclared (first use in this function)
extensions/libipt_REJECT.c:266: error: dereferencing pointer to incomplete type
extensions/libipt_REJECT.c: At top level:
extensions/libipt_REJECT.c:290: error: invalid application of `sizeof' to an incomplete type
extensions/libipt_REJECT.c:291: error: invalid application of `sizeof' to an incomplete type

--
Regards,
Maciej
