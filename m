From: Chris Rankin <rankincj@yahoo.com>
Subject: H323 connection tracking in Linux 2.6.20.1
Date: Sun, 25 Feb 2007 20:56:46 +0000 (GMT)
Message-ID: <117085.22319.qm@web52904.mail.yahoo.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8bit
Cc: netfilter-devel@lists.netfilter.org
To: coreteam@netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
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

Hi,

I am trying the H323 connection tracking in Linux 2.6.20.1, but am getting the following errors:

Feb 25 20:42:59 wellhouse kernel: nf_ct_h245: packet dropped
Feb 25 20:43:04 wellhouse last message repeated 10 times
Feb 25 20:43:17 wellhouse kernel: printk: 1 messages suppressed.
Feb 25 20:43:17 wellhouse kernel: nf_ct_h245: packet dropped
Feb 25 20:43:23 wellhouse last message repeated 2 times
Feb 25 20:43:24 wellhouse kernel: printk: 5 messages suppressed.
Feb 25 20:43:24 wellhouse kernel: nf_ct_h245: packet dropped
Feb 25 20:43:44 wellhouse kernel: printk: 9 messages suppressed.
Feb 25 20:43:44 wellhouse kernel: nf_ct_q931: decoding error: out of bound
Feb 25 20:43:44 wellhouse kernel: nf_ct_q931: decoding error: out of bound

I suspect that this is related to my GNU Gatekeeper 2.0.8, which I have running on my firewall
machine. At the moment, the only way that I have managed to make a H323 connection has been to
disable H245 in Ekiga. However, I don't need the firewall rule to allow the UDP traffic explicitly
any more.

Cheers,
Chris

P.S. Removing the nf_conntrack_h323 module quickly kills my machine.



		
___________________________________________________________ 
Yahoo! Messenger - with free PC-PC calling and photo sharing. http://uk.messenger.yahoo.com
