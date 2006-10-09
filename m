From: Patrick McHardy <kaber@trash.net>
Subject: Re: kernel oops in 2.6.17.7 (smp)
Date: Mon, 09 Oct 2006 17:04:28 +0200
Message-ID: <452A64FC.5060001@trash.net>
References: <45260F5A.60700@fliegl.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Deti Fliegl <deti@fliegl.de>
In-Reply-To: <45260F5A.60700@fliegl.de>
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

Deti Fliegl wrote:
> Hi there,
> 
> a kernel oops happens since ages with this setup with all recent kernels
> (since 2.6.12) - and most probably even with the latest versions. Here
> it takes about 60 days to reproduce:
> 
> ----------------------------------------------------------------
> Unable to handle kernel paging request at ffffc2000031d103 RIP:
> <ffffffff88103e83>{:ip_tables:ipt_do_table+194}
> PGD 11fc42067 PUD 11fc43067 PMD 11f72b067 PTE 0
> Oops: 0000 [1] SMP
> CPU 2
> Modules linked in: ipt_ipp2p ipt_REDIRECT af_packet i8xx_tco xt_CLASSIFY
> sch_htb xt_mark xt_CONNMARK ipt_SAME xt_state xt_pkttype xt_NOTRACK
> iptable_raw edd ipt_LOG xt_limit ipt_hashlimit xt_tcpudp
>  ip_conntrack_netlink ip_nat_ftp ip_conntrack_ftp thermal processor fan
> button iptable_nat battery ip_nat ac xt_MARK ip_conntrack nfnetlink
> iptable_filter iptable_mangle ip_tables x_tables ipmi_si ipmi_devintf
> ipmi_msghandler ext3 jbd ide_cd cdrom e1000 piix sg megaraid_mbox
> megaraid_mm sd_mod scsi_mod ide_disk ide_core
> Pid: 4709, comm: syslog-ng Not tainted 2.6.17.7-smp #1
> RIP: 0010:[<ffffffff88103e83>]
> <ffffffff88103e83>{:ip_tables:ipt_do_table+194}

This should be fixed in the latest 2.6.17-stable kernel. Please try and
report in case it still crashes.
