From: "Simon May" <simon@imsl.es>
Subject: re &ip_conntrack_lock not readlocked
Date: Tue, 12 Nov 2002 10:21:51 +0100
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <013701c28a2c$ef342000$4200000a@simon>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: <netfilter-devel@lists.netfilter.org>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

I have been seeing the message
=======================
Nov 12 09:58:01 clients kernel: ASSERT: ip_nat_core.c:839 &ip_conntrack_lock
not readlocked
Nov 12 09:58:01 clients kernel: ASSERT ip_conntrack_core.c:94
&ip_conntrack_lock_Rsmp_4193d6ac readlocked
Nov 12 09:58:01 clients kernel: ASSERT: ip_nat_core.c:839 &ip_conntrack_lock
not readlocked
=======================
in the logs and believe it may be related to
having aliases on the card eg eth0:1 etc

This is with kernel 2.4.18 and iptables-1.2.7a

I'm not sure that it's actually doing any harm but
can not find much about it.

any helpful comments would be apreciated

Kind Regards
Simon May
Network Administrator
Internet Marketing S.L.
Telephone 971 72 92 04
Fax 971 71 92 04
Email simon@imsl.es
