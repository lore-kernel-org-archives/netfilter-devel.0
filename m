From: Roberto Nibali <ratz@tac.ch>
Subject: 2.4.22-pre9 and pending patches issues
Date: Wed, 30 Jul 2003 09:22:35 +0200
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <3F27723B.7040502@tac.ch>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Netfilter Developers <netfilter-devel@lists.netfilter.org>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

Hi,

Sorry if this is a no-brainer but I have not been able to apply 
57_conntrack-tcp-nopickup.patch to the newest 2.4.22-pre9 kernel. Does anyone 
have a quick solution or do I have to merge manually? 39_ip_conntrack-proc.patch 
40_nf-log.patch 54_ip_nat-macro-args.patch 55_ipt_unclean-tcp-flag-table.patch, 
all to apply more or less cleanly to the newest drop.

Also the tcp-window-tracking patch is not applicable to this kernel. I reckon 
this is because 57_* doesn't apply. I haven't looked further into this.

In case you're interested:
# patch -p1 --dry-run < ../patches/tcp-window-tracking.patch
patching file include/linux/netfilter_ipv4/ip_conntrack_tcp.h
patching file include/linux/sysctl.h
Hunk #1 FAILED at 359.
1 out of 1 hunk FAILED -- saving rejects to file include/linux/sysctl.h.rej
patching file net/ipv4/netfilter/ip_conntrack_ftp.c
patching file net/ipv4/netfilter/ip_conntrack_irc.c
Hunk #2 succeeded at 108 (offset 2 lines).
patching file net/ipv4/netfilter/ip_conntrack_proto_tcp.c
Hunk #2 FAILED at 24.
Hunk #3 succeeded at 320 (offset 1 line).
Hunk #4 FAILED at 712.
Hunk #5 FAILED at 791.
3 out of 5 hunks FAILED -- saving rejects to file 
net/ipv4/netfilter/ip_conntrack_proto_tcp.c.rej
patching file net/ipv4/netfilter/ip_conntrack_standalone.c
Hunk #1 FAILED at 259.
Hunk #2 FAILED at 307.
Hunk #3 succeeded at 315 (offset -4 lines).
2 out of 3 hunks FAILED -- saving rejects to file 
net/ipv4/netfilter/ip_conntrack_standalone.c.rej
patching file net/ipv4/netfilter/ip_nat_helper.c
Hunk #1 succeeded at 456 (offset -5 lines).

I'll start merging by hand now ... unless someone beats me to it.

Best regards,
Roberto Nibali, ratz
-- 
echo '[q]sa[ln0=aln256%Pln256/snlbx]sb3135071790101768542287578439snlbxq' | dc
