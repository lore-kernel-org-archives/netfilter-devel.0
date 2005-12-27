From: chip@innovates.com
Subject: conntrack NAT problem w/ UDP
Date: Tue, 27 Dec 2005 13:53:17 -0600
Message-ID: <47103.2108333476$1135713229@news.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: netfilter-devel@lists.netfilter.org
Content-Disposition: inline; filename="BDY.TXT"
	;Creation-Date="Tue, 27 Dec 2005 13:53:16 -0600"
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

There seems to be an intermittent problem w/ NAT when the source port 
and destination port are the same on UDP traffic.

I've found this on two routers, one with OpenWRT whiterussian RC3 
(kernel 2.4.30) and on SuSE 10 (kernel 2.6.13-15).  At random times NAT 
fails to operate on the UDP traffic for IAX2 from Asterisk.  IAX2 is UDP 
port 4569 to port 4569.  The kernel will stop rewriting the source port 
when using either SNAT or MASQUERADE.  

Rebooting the kernel is the only solution I have found to fixing the 
problem.  I have found numerous reports of this problem.  It's usually 
reported as Asterisk failing to register.  

I diagnosed the problem by sniffing the traffic between the router and 
internet device (DSL or cable modem).  This revealed the source address 
is not being rewritten.  

Any suggestions on how to further trace where the problem in netfilter 
is occurring would be of great benefit.  Unfortunately, I only see this 
problem once every couple months.  So I need to know where to look for 
more information on the problem.  

I've posted this bug in bugzilla ID #421.  


Chip Schweiss

Innovates, Inc.
4038 Avery Ln.
Bridgeton, MO 63044
(314) 298-3708 - (618) 207-3442 - (877) 444-2003
