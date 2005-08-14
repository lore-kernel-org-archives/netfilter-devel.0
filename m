From: "Michael" <oni@atice.org>
Subject: patch-o-matic problem with ip_nat_pptp
Date: Sun, 14 Aug 2005 17:26:13 +1000
Message-ID: <E1E4Csn-0005rz-B4@wombat.digitalis.net.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
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

I've recently starting playing with patch-o-matic and have hit some
issues. The box is running version 2.6.11.11 of the kernel and iptables
version 1.3.2.

When I try to load the ip_nat_pptp module I get:

paddington netfilter # modprobe ip_nat_pptp
WARNING: Error inserting ip_conntrack_pptp
(/lib/modules/2.6.11.11/kernel/net/ipv4/netfilter/ip_conntrack_pptp.ko):
Unknown symbol in module, or unknown parameter (see dmesg)
FATAL: Error inserting ip_nat_pptp
(/lib/modules/2.6.11.11/kernel/net/ipv4/netfilter/ip_nat_pptp.ko):
Unknown symbol in module, or unknown parameter (see dmesg)

Below are the relevant sections from dmesg:

ip_conntrack_pptp: Unknown symbol __ip_conntrack_expect_find
ip_nat_pptp: Unknown symbol ip_nat_pptp_hook_inbound
ip_nat_pptp: Unknown symbol ip_nat_pptp_hook_expectfn
ip_nat_pptp: Unknown symbol ip_nat_pptp_hook_exp_gre
ip_nat_pptp: Unknown symbol ip_nat_pptp_hook_outbound

I'm running version 20050811 of patch-o-matic. Out of all the options I
only applied the pptp & gre tunnelling patches.

--
Michael
oni@atice.org
