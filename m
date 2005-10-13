From: Ilkka =?iso-8859-1?q?Pietik=E4inen?= <ilkka.pietikainen@emicnetworks.com>
Subject: ip_queue: setting verdict blocks
Date: Thu, 13 Oct 2005 12:30:19 +0300
Message-ID: <200510131230.19776.ilkka.pietikainen@emicnetworks.com>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: netfilter-devel@lists.netfilter.org
Content-Disposition: inline
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

Hello,

We have seen this in two different environments: RedHat ES3 and Debian Sarge 
(with the default kernels).

We have an application that handles IP packets from ip_queue module (and 
basically DROP/ACCEPT each packet). Sometimer after the system has been up 
and running for few hours the application can no longer set the verdict for 
the packet (it seems that the sendmsg is blocking). Restarting of the 
application does not help and only way to get system back working is to rmmod 
all iptables related modules or reboot.

Some questions:

a) What could have caused sendmsg to block?
b) Is there some way to debug this problem?

Ilkka
