From: Patrick McHardy <kaber@trash.net>
Subject: [PATCH 2.6 0/8]: Netfilter Update
Date: Fri, 04 Mar 2005 13:00:22 +0100
Message-ID: <42284DD6.5090301@trash.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
To: "David S. Miller" <davem@davemloft.net>,
	Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>
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

Hi Dave,

following are a couple of netfilter fixes for 2.6. The patches
are based on your net-2.6 tree, but also apply cleanly to your
2.6.12 tree. Unfortunately no bitkeeper tree this time because
someone messed up our firewall rules.


<ariel:blueslice.com>:
   o [NETFILTER]: SCTP conntrack: fix association restart

<mstjohns:mindspring.com>:
   o [NETFILTER]: fix ip6_queue inefficiencies

Andi Kleen:
   o [NETFILTER]: Reduce netfilter memory use on MP systems

Jozsef Kadlecsik:
   o [NETFILTER]: Fix multiple problems with TCP window tracking

Patrick McHardy:
   o [NETFILTER]: Don't insist on ICMP errors carrying 8 byte of 
protocol header
   o [NETFILTER]: Fix /proc/net/ip_conntrack seq_file operations
   o [NETFILTER]: Use num_possible_cpus instead of NR_CPUS in 
{ip6_,arp_,eb}tables
   o [NETFILTER]: Use correct types in seq_printf calls
