From: Jiri Slaby <jirislaby@gmail.com>
Subject: Re: patch-o-matic problem with ip_nat_pptp
Date: Sun, 14 Aug 2005 12:28:39 +0200
Message-ID: <42FF1CD7.9010209@gmail.com>
References: <E1E4Csn-0005rz-B4@wombat.digitalis.net.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Michael <oni@atice.org>
In-Reply-To: <E1E4Csn-0005rz-B4@wombat.digitalis.net.au>
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

Michael napsal(a):

>Hi,
>
>I've recently starting playing with patch-o-matic and have hit some
>issues. The box is running version 2.6.11.11 of the kernel and iptables
>version 1.3.2.
>
>When I try to load the ip_nat_pptp module I get:
>
>paddington netfilter # modprobe ip_nat_pptp
>WARNING: Error inserting ip_conntrack_pptp
>(/lib/modules/2.6.11.11/kernel/net/ipv4/netfilter/ip_conntrack_pptp.ko):
>Unknown symbol in module, or unknown parameter (see dmesg)
>FATAL: Error inserting ip_nat_pptp
>(/lib/modules/2.6.11.11/kernel/net/ipv4/netfilter/ip_nat_pptp.ko):
>Unknown symbol in module, or unknown parameter (see dmesg)
>
>Below are the relevant sections from dmesg:
>
>ip_conntrack_pptp: Unknown symbol __ip_conntrack_expect_find
>ip_nat_pptp: Unknown symbol ip_nat_pptp_hook_inbound
>ip_nat_pptp: Unknown symbol ip_nat_pptp_hook_expectfn
>ip_nat_pptp: Unknown symbol ip_nat_pptp_hook_exp_gre
>ip_nat_pptp: Unknown symbol ip_nat_pptp_hook_outbound
>  
>
If you want to use pptp with 2.6.11 tree, you have to add nfnetlink 
patch, because there aren't these functions. The problem is probably, 
that 2 patches overlap. The best way to use pptp from patch-o-magic is 
upgrade kernel to one of latest versions.

regards,

-- 
Jiri Slaby         www.fi.muni.cz/~xslaby
~\-/~      jirislaby@gmail.com      ~\-/~
241B347EC88228DE51EE A49C4A73A25004CB2A10
