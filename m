From: Patrick McHardy <kaber@trash.net>
Subject: Re: skb_ip_make_writable and skbs not owned by a socket
Date: Mon, 03 Jan 2005 02:36:35 +0100
Message-ID: <41D8A1A3.3060308@trash.net>
References: <41D86571.6070501@trash.net>
	<20050102235757.GA26856@postel.suug.ch>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="------------060305070908090202080007"
Cc: "David S. Miller" <davem@redhat.com>, Rusty Russell <rusty@rustcorp.com.au>,
	Jamal Hadi Salim <hadi@cyberus.ca>,
	Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Thomas Graf <tgraf@suug.ch>
In-Reply-To: <20050102235757.GA26856@postel.suug.ch>
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

This is a multi-part message in MIME format.
--------------060305070908090202080007
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit

Thomas Graf wrote:

>* Patrick McHardy <41D86571.6070501@trash.net> 2005-01-02 22:19
>  
>
>>skb_ip_make_writable copies the packet as soon as the data area needs
>>to be touched. This is of course necessary for packets generated locally,
>>but can't we mangle the data area of skbs with skb->sk == NULL without
>>copying them ?
>>    
>>
>
>Theoretically there could be a driver for a S/G capable nic producing
>pskbs. I'm not aware of such a driver though. Assuming there is no
>such driver at the moment, the question is whether to make all the
>paths aware as a precaution (net/sched/ is not aware as of now). I
>think everyone would agree if there wasn't such ia high possible
>performance impact respectively saving. Thoughts?
>
I was refering to a different problem. skb_ip_make_writable copies
skbs when the data area needs to be mangled to avoid disturbing the
tcp retransmission queue. Not sure why it is done for UDP and ICMP.
My question is if we can asume it is safe to alter the data area of
a skb, if it is not shared, or cloned, in the linear range and
skb->sk == NULL. See the attached patch. A different question is
why we can't simply do this:

(cut-n-paste, I would cut at least one goto in a patch)

int skb_ip_make_writable(struct sk_buff **pskb, unsigned int writable_len)
{
        struct sk_buff *nskb;

        if (writable_len > (*pskb)->len)
                return 0;

        /* Not exclusive use of packet?  Must copy. */
        if (skb_shared(*pskb) || skb_cloned(*pskb))
                goto copy_skb;

        if (skb_headlen(skb) <= writable_len)
                return 1;
        goto pull_skb;

copy_skb:
        nskb = skb_copy(*pskb, GFP_ATOMIC);
        if (!nskb)
                return 0;
        BUG_ON(skb_is_nonlinear(nskb));

        /* Rest of kernel will get very unhappy if we pass it a
           suddenly-orphaned skbuff */
        if ((*pskb)->sk)
                skb_set_owner_w(nskb, (*pskb)->sk);
        kfree_skb(*pskb);
        *pskb = nskb;
        return 1;

pull_skb:
        return pskb_may_pull(*pskb, writable_len);
}

Packets cloned or shared with the TCP retransmission queue are
already caught by the second condition. This should avoid lots
of copies compared to the current code.

Regards
Patrick


--------------060305070908090202080007
Content-Type: text/plain;
 name="x"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="x"

===== net/core/netfilter.c 1.37 vs edited =====
--- 1.37/net/core/netfilter.c	2004-11-13 14:41:07 +01:00
+++ edited/net/core/netfilter.c	2005-01-03 02:17:16 +01:00
@@ -691,6 +691,12 @@
 	if (writable_len <= (*pskb)->nh.iph->ihl*4)
 		return 1;
 
+	if (skb->sk == NULL) {
+		if (skb_headlen(skb) <= writable_len)
+			return 1;
+		goto pull_skb;
+	}
+
 	iplen = writable_len - (*pskb)->nh.iph->ihl*4;
 
 	/* DaveM says protocol headers are also modifiable. */

--------------060305070908090202080007--
