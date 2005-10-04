From: Gervasio Bernal <gervasiobernal@speedy.com.ar>
Subject: skb_shared || skb_cloned
Date: Tue, 04 Oct 2005 08:53:00 +0000
Message-ID: <434242EC.2070107@speedy.com.ar>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7BIT
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

Hi everybody!

I'm developing a new netfilter target that change some fields of the IP
header and I'm having some problems when skb are shared.

This is part of my code that verify the skb. If it is shared or cloned
with another application, it creates a new copy (skb_copy()) and frees
the old skb (kfree())

if (skb_shared(*pskb) || skb_cloned(*pskb))
{
	struct sk_buff *nskb;
	printk(KERN_INFO MOD "skb_shared || skb_cloned!!\n");
	nskb = skb_copy(*pskb, GFP_ATOMIC);
		
	if (!nskb)
		return NF_DROP;
		
	if ((*pskb)->sk)
		skb_set_owner_w(nskb, (*pskb)->sk);
		
	kfree_skb(*pskb);
	*pskb = nskb;
}

My doubt is: the other applications, which skb use? The new one, or the
copy?

This is what I did: I ran my new netfilter target with and Ethereal (so
that skb was share) but when I saw the output of Ethereal, it showed as
if it had not copied it. Is this correct???
