From: "Laurence J. Lane" <ljlane@nontoxic.org>
Subject: hppa and s390 build error, 1.2.9 + 2.4.24 headers
Date: Fri, 13 Feb 2004 12:42:22 -0500
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <20040213174222.GC14190@absolom.libra.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: netfilter-devel@lists.netfilter.org
Content-Disposition: inline
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

Does anyone have an idea of what is going wrong in the error below? It 
happens on s390 and hppa with 2.4.24 headers. Both build fine with 2.4.19
headers.

  full s390 build log: http://shorl.com/dufrustabulifra
  full hppa build log: http://shorl.com/fiprysabopesti
  all build logs: http://shorl.com/devufetiprahu

failed hppa build excerpt:

  cc -O2 -Wall -Wunused -I/build/buildd/iptables-1.2.9/debian/build/linux-2.4.24/include -Iinclude/ -DIPTABLES_VERSION=\"1.2.9\"  -fPIC -o extensions/libipt_connlimit_sh.o -c extensions/libipt_connlimit.c
  In file included from /build/buildd/iptables-1.2.9/debian/build/linux-2.4.24/include/linux/netfilter_ipv4/ip_conntrack.h:52,
                   from extensions/libipt_connlimit.c:9:
  /build/buildd/iptables-1.2.9/debian/build/linux-2.4.24/include/linux/netfilter_ipv4/ip_conntrack_icmp.h:9: error: parse error before "atomic_t"
  /build/buildd/iptables-1.2.9/debian/build/linux-2.4.24/include/linux/netfilter_ipv4/ip_conntrack_icmp.h:9: warning: no semicolon at end of struct or union
  In file included from extensions/libipt_connlimit.c:9:
  /build/buildd/iptables-1.2.9/debian/build/linux-2.4.24/include/linux/netfilter_ipv4/ip_conntrack.h:58: error: field `icmp' has incomplete type
  make[1]: *** [extensions/libipt_connlimit_sh.o] Error 1
