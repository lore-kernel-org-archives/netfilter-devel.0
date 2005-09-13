From: zerbat@gmx.net
Subject: problems loading PPTP modules with 2.6.11 (gentoo)
Date: Tue, 13 Sep 2005 18:50:24 +0200 (MEST)
Message-ID: <17200.1126630224@www34.gmx.net>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
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

Hi all,

I've taken several attempts to get the pptp modules running with kernel
2.6.11 (gentoo hardened-sources, i.e. 2.6.11-hardened-r15). The modules do
compile, but while loading I get the results others have reported before:

ip_conntrack_pptp: Unknown symbol __ip_conntrack_expect_find
ip_conntrack_pptp: Unknown symbol __ip_conntrack_expect_find
ip_nat_pptp: Unknown symbol ip_nat_pptp_hook_inbound
ip_nat_pptp: Unknown symbol ip_nat_pptp_hook_expectfn
ip_nat_pptp: Unknown symbol ip_nat_pptp_hook_exp_gre
ip_nat_pptp: Unknown symbol ip_nat_pptp_hook_outbound

Even with svn p-o-m-ng and iptables, this stays the same. I can patch the
kernel with nfnetlink, but not with ctnetlink (4 rejects).

Is there a way to get pptp modules working with gentoo hardened sources? Do
they work with the regular sources? Do I have to wait for Harald to fix
everything..;)...?

Martin

-- 
5 GB Mailbox, 50 FreeSMS http://www.gmx.net/de/go/promail
+++ GMX - die erste Adresse für Mail, Message, More +++
