From: Alexander Piavka <piavka@cs.bgu.ac.il>
Subject: iptables compile error: NFC_IP_TOS undeclared
Date: Thu, 10 Feb 2005 17:10:40 +0200 (IST)
Message-ID: <Pine.GSO.4.33.0502101706320.8272-100000@indigo>
References: <60195.142.169.215.10.1108046474.squirrel@142.169.215.10>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
To: <netfilter-devel@lists.netfilter.org>, <netfilter@lists.netfilter.org>
In-Reply-To: <60195.142.169.215.10.1108046474.squirrel@142.169.215.10>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter>,
	<mailto:netfilter-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: </pipermail/netfilter>
List-Post: <mailto:netfilter@lists.netfilter.org>
List-Help: <mailto:netfilter-request@lists.netfilter.org?subject=help>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter>,
	<mailto:netfilter-request@lists.netfilter.org?subject=subscribe>
Sender: netfilter-bounces@lists.netfilter.org
Errors-To: netfilter-bounces@lists.netfilter.org
List-Id: netfilter-devel.vger.kernel.org


 Hi, compiling iptables-1.3.0rc gives the following error:

 Extensions found: IPv4:CLUSTERIP IPv4:mport IPv4:psd IPv4:recent
IPv4:ROUTE IPv4:set IPv4:SET IPv6:ah IPv6:esp IPv6:frag IPv6:ipv6header
IPv6:hbh IPv6:dst IPv6:ROUTE IPv6:rt
gcc -O2 -Wall -Wunused -I/usr/src/linux-2.6.10-ct_sync-rc1/include
-Iinclude/ -DIPTABLES_VERSION=\"1.3.0rc1\"  -fPIC -o
extensions/libipt_dscp_sh.o -c extensions/libipt_dscp.c
extensions/libipt_dscp.c: In function `init':
extensions/libipt_dscp.c:29: error: `NFC_IP_TOS' undeclared (first use in
this function)
extensions/libipt_dscp.c:29: error: (Each undeclared identifier is
reported only once
extensions/libipt_dscp.c:29: error: for each function it appears in.)
extensions/libipt_dscp.c: At top level:
extensions/libipt_dscp_helper.c:69: warning: 'dscp_to_name' defined but
not used
make: *** [extensions/libipt_dscp_sh.o] Error 1

 Please help.
