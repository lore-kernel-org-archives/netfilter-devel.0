From: "zhengchuanbo" <zhengcb@netpower.com.cn>
Subject: about ip_conntrack code
Date: Wed, 11 Feb 2004 9:48:20 +0800
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <200402110935640.SM00868@zhengcb>
Mime-Version: 1.0
Content-Type: text/plain;
      charset="GB2312"
Content-Transfer-Encoding: 7bit
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: netfilter-devel@lists.netfilter.org <netfilter-devel@lists.netfilter.org>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org


I'm trying to read the ip_conntrack code. But it is not easy for me to 
understand the code. So I wish someone could help. Thanks in advance.
	
When an skb is received, we could call the ip_conntrack_get as following 
to get the connection info,
	 ct = ip_conntrack_get((struct sk_buff *)skb, &ctinfo);
and it calls,
	__ip_conntrack_get(skb->nfct, ctinfo);

What I want to ask is in the __ip_conntrack_get, how is the ip_conntrack
transformed from nfct? I can see that the code just makes a transform in
the structure as follows,
		struct ip_conntrack *ct
		= (struct ip_conntrack *)nfct->master;

I can't understand how the connection info is got by the transform. Wish I
could get some help. 

BTW, is there some more detailed documnets on netfilter code?

Thanks again.
	
regards,
	
Jack
 	
	
