From: dragon <dragon@earthquake.hu>
Subject: 1.2.11 compile error
Date: 15 Aug 2004 15:46:59 +0000
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <1092584819.2136.9.camel@ekmek.hu>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
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

Hi

I tryd to compile iptables-1.2.11 with kernel 2.6.7, grsec 2.0.1 and I
have this error.

bash-2.05b# make
Extensions found: IPv4:recent IPv6:ah IPv6:esp IPv6:frag IPv6:ipv6header
IPv6:hbh IPv6:dst IPv6:rt
cc -O2 -Wall -Wunused -I/usr/src/linux/include -Iinclude/
-DIPTABLES_VERSION=\"1.2.11\"  -fPIC -o extensions/libipt_ah_sh.o -c
extensions/libipt_ah.c
In file included from include/libiptc/libiptc.h:6,
                 from include/iptables.h:5,
                 from extensions/libipt_ah.c:8:
/usr/src/linux/include/linux/netfilter_ipv4/ip_tables.h:255: warning:
declaration does not declare anything
/usr/src/linux/include/linux/netfilter_ipv4/ip_tables.h:255: warning: no
semicolon at end of struct or union
/usr/src/linux/include/linux/netfilter_ipv4/ip_tables.h:255: error:
parse error before ',' token
/usr/src/linux/include/linux/netfilter_ipv4/ip_tables.h:259: error:
parse error before '}' token
/usr/src/linux/include/linux/netfilter_ipv4/ip_tables.h:339: warning:
type defaults to `int' in declaration of `DECLARE_MUTEX'
/usr/src/linux/include/linux/netfilter_ipv4/ip_tables.h:339: warning:
parameter names (without types) in function declaration
/usr/src/linux/include/linux/netfilter_ipv4/ip_tables.h:339: warning:
`DECLARE_MUTEX' declared `static' but never defined
make: *** [extensions/libipt_ah_sh.o] Error 1
bash-2.05b# 


It is a kernel bug or I make wrong something?

gcc 3.3.4, glibc 2.3.3.

dragon
