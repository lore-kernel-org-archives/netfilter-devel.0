From: Tero Pelander <tpeland@tkukoulu.fi>
Subject: iptables --syn and kernel behavior
Date: Sun, 20 Oct 2002 18:51:38 +0300 (EEST)
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <Pine.LNX.4.44.0210201836020.17904-100000@roope.top.tkukoulu.fi>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
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

According to a message that appeared in bugtraq linux 2.4.19 allows 
opening new connections with SYN and RST set, ACK reset. 
Iptables has option "--syn" that tries to protect from new connections 
but unfortunately the described packet would get through such rule.
Which one should be corrected? The iptables or linux kernel?

--man iptables--
  --syn
    It is equivalent to --tcp-flags SYN,RST,ACK SYN.

--bugtraq message--
Date: Fri, 18 Oct 2002 16:46:55 +0200
From: Paul Starzetz <paul@starzetz.de>
To: bugtraq@securityfocus.com
Message-ID: <3DB01EDF.5070004@starzetz.de>
Subject: Ambiguities in TCP/IP - firewall bypassing

* Linux 2.4.19

The examination of the source code of the TCP engine reveals that a TCP
connection can be opened by any combination of the TCP flags having the
SYN bit set and the ACK bit reset. For example we can open a TCP
connection by sending an obviously bogus SYN,RST packet:
