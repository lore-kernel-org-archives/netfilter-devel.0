From: Eicke Friedrich <tady@gmx.net>
Subject: POM ip_conntrack-timeouts.patch fails
Date: Tue, 20 May 2003 16:58:51 +0200
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <3ECA42AB.1020303@gmx.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
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

Hi,

I'm trying to apply the ip_conntrack-timeouts.patch to my system. I 
get the following error message when I choose t for test:

Testing patch extra/ip_conntrack-timeouts.patch...
Failed to patch copy of /usr/src/linux

I already applied a couple of patches to this system (CONNMARK for 
example) but this one refuses to work. It's the same for the 
tcp-window-patch that also allows to change the timeout values. Same 
error message.

The system:
Dual Athlon MP
Kernel 2.4.20-SMP-4GB
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


Any help would be greatly appricated! Thanks,
Eicke.
