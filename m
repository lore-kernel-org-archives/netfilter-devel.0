From: Patrick McHardy <kaber@trash.net>
Subject: Re: H323 connection tracking in Linux 2.6.20.1
Date: Mon, 26 Feb 2007 17:54:24 +0100
Message-ID: <45E310C0.7050902@trash.net>
References: <117085.22319.qm@web52904.mail.yahoo.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@lists.netfilter.org
To: Chris Rankin <rankincj@yahoo.com>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
In-Reply-To: <117085.22319.qm@web52904.mail.yahoo.com>
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

Chris Rankin wrote:
> I am trying the H323 connection tracking in Linux 2.6.20.1, but am getting the following errors:
> 
> Feb 25 20:42:59 wellhouse kernel: nf_ct_h245: packet dropped
> Feb 25 20:43:04 wellhouse last message repeated 10 times
> Feb 25 20:43:17 wellhouse kernel: printk: 1 messages suppressed.
> Feb 25 20:43:17 wellhouse kernel: nf_ct_h245: packet dropped
> Feb 25 20:43:23 wellhouse last message repeated 2 times
> Feb 25 20:43:24 wellhouse kernel: printk: 5 messages suppressed.
> Feb 25 20:43:24 wellhouse kernel: nf_ct_h245: packet dropped
> Feb 25 20:43:44 wellhouse kernel: printk: 9 messages suppressed.
> Feb 25 20:43:44 wellhouse kernel: nf_ct_q931: decoding error: out of bound
> Feb 25 20:43:44 wellhouse kernel: nf_ct_q931: decoding error: out of bound

Please enable debugging in net/netfilter/nf_conntrack_h323_main.c
(change "#if 0" at about line 40 to "#if 1") and
net/netfilter/nf_conntrack_h323_asn1.c (change #define H323_TRACE
0 => 1) and post the output.

> I suspect that this is related to my GNU Gatekeeper 2.0.8, which I have running on my firewall
> machine. At the moment, the only way that I have managed to make a H323 connection has been to
> disable H245 in Ekiga. However, I don't need the firewall rule to allow the UDP traffic explicitly
> any more.
> 
> Cheers,
> Chris
> 
> P.S. Removing the nf_conntrack_h323 module quickly kills my machine.

Please try to capure the oops and post it.
