From: Rob McMillen <rvmcmil@cablespeed.com>
Subject: libipulog question (again)
Date: Wed, 4 Sep 2002 19:34:37 -0400 (EDT)
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <Pine.LNX.4.44.0209041924230.2080-100000@localhost.localdomain>
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

Hope this is the right medium.  I am really having problems with ULOG.  I 
have a simple rule

iptables -A OUTPUT -d 192.168.0.1 -j ULOG

I start ulog_test.

ulog_test 10 1 0

I then do a ping 192.168.0.1.

and I get an infinite loop of:

Hook=3 Mark=0 len=84

Anyone ever run into this?

Thanks in advance,

Rob
