From: linux lover <linux_lover2004@yahoo.com>
Subject: Help Urgent (getting Oops in kfree_skb)
Date: Tue, 3 May 2005 08:07:56 -0700 (PDT)
Message-ID: <20050503150756.78518.qmail@web52209.mail.yahoo.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
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

Hello,     
      On 2 ethernet linux box. After it gets started i
ifdown both eth's and do ping localhost.
 2 packets goes and received on 127.0.0.1 but after
that packet comes with source IP 0.0.0.0 and 
in ip_rcv function 
/* When the interface is in promisc. mode, drop all
the crap
	 * that it receives, do not try to analyse it.
	 */
	if (skb->pkt_type == PACKET_OTHERHOST)
		goto drop;
drop:
        kfree_skb(skb);
             I have also not started tcpdump or
ethereal then why kfree_skb gives
Oops that  Warning: kfree_skb passed an skb still on a
list (from c020b804)
    Please correct me if i am getting Oops problem in
wrong way and help to solve it.
regards,
linux_lover.

__________________________________________________
Do You Yahoo!?
Tired of spam?  Yahoo! Mail has the best spam protection around 
http://mail.yahoo.com 
