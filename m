From: Eicke Friedrich <tady@gmx.net>
Subject: strange reboots
Date: Wed, 09 Jul 2003 12:01:00 +0200
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <3F0BE7DC.5090705@gmx.net>
References: <20030707084622.GA15410@openoffice.nl>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: netfilter-devel@lists.netfilter.org
In-Reply-To: <20030707084622.GA15410@openoffice.nl>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

Hi there,

I'm running a bridge with netfilter firewalling support. I wrote an
iptables extension (mainly a string-matching) that seemed to be pretty
stable during the test phase. Also I'm running a QoS module (HTB),
ipt_CONNMARK and ipt_MARK.
Now I notice a reboot from time to time but I can't find a reason. The
logs don't show anything. The reboots just occur if iptables and HTB
are loaded. If the system is just bridging (without firewalling) it
runs stable. Is it possible that netfilter causes a reboot? Any
experiences in this configuration?

Thanks,
Eicke.

The system:
Dual Athlon MP
512 MB RAM
Kernel 2.4.20 (SMP, 4GB) from kernel.org
iptables 1.2.8
patch-o-matic-20030107
Already applied: submitted/01_2.4.19
                  submitted/02_2.4.20
                  submitted/ipt_ULOG-mac_len-fix
                  submitted/ipt_multiport-invfix
                  pending/01_ip_conntrack_proto_tcp-lockfix
                  pending/03_REJECT-fwspotting-phrack60-fix
                  pending/04_ftp-conntrack-msg-fix
                  pending/05_ECN-tcpchecksum-littleendian-fix
                  base/ipt_unclean-ubit
                  base/mport
                  extra/CONNMARK

Jul  9 11:39:33 fink1 kernel: ip_tables: (C) 2000-2002 Netfilter core team
Jul  9 11:45:28 fink1 kernel: ip_conntrack version 2.1 (4095 buckets,
32760 max) - 156 bytes per conntrack
Jul  9 11:45:32 fink1 kernel: HTB init, kernel part version 3.7
Jul  9 11:45:32 fink1 insmod: Warning: loading
/lib/modules/2.4.20/kernel/net/ipv4/netfilter/ipt_CONNMARK.o will taint t
he kernel: no license
Jul  9 11:45:32 fink1 insmod:   See
http://www.tux.org/lkml/#export-tainted for information about tainted
modules
Jul  9 11:45:32 fink1 insmod: Module ipt_CONNMARK loaded, with warnings
