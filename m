From: Patrick McHardy <kaber@trash.net>
Subject: Re: libipq, kernel panics/oopses, and other undesirable traits
Date: Tue, 17 Aug 2004 12:40:02 +0200
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <4121E082.6050602@trash.net>
References: <E1BwO5M-000718-NF@giant.mindlink.net>	 <1092692707.22731.1687.camel@marx.mindlink.net>	 <41213777.9050701@trash.net> <1092703243.22731.1778.camel@marx.mindlink.net>
Mime-Version: 1.0
Content-Type: multipart/mixed;
 boundary="------------020809050605090706060206"
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Matt Walters <mattw@parasun.com>
In-Reply-To: <1092703243.22731.1778.camel@marx.mindlink.net>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

This is a multi-part message in MIME format.
--------------020809050605090706060206
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit

Matt Walters wrote:

>On Mon, 2004-08-16 at 15:38, Patrick McHardy wrote:
>
>>skb_tailroom should return 0 in this case and the skb should be linearized
>>by skb_copy_expand already. The check isn't triggered because this line is
>>wrong:
>>
>>diff = v->data_len - e->skb->len
>>
>>skb->len is the total length, including fragments. If we want to copy to it,
>>we either need to linearize it or look at skb_headlen(skb). It's complicated
>>getting everything right, I need to think about it some more.
>>    
>>

This patch on top of the ip_queue_nonlinear_skbs patch should fix the 
problem.
It wastes a couple of bytes when enlarging a non-linear skb, but that 
shouldn't be
a problem. When you test it, please try all three possibilities (replace 
by smaller,
equally sized and larger packet).

Regards
Patrick




--------------020809050605090706060206
Content-Type: text/plain;
 name="x"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="x"

===== net/ipv4/netfilter/ip_queue.c 1.16 vs edited =====
--- 1.16/net/ipv4/netfilter/ip_queue.c	2004-01-29 00:59:33 +01:00
+++ edited/net/ipv4/netfilter/ip_queue.c	2004-08-17 12:35:05 +02:00
@@ -362,6 +362,8 @@
 		}
 		skb_put(e->skb, diff);
 	}
+	if (!skb_ip_make_writable(&e->skb, v->data_len))
+		return -ENOMEM;
 	memcpy(e->skb->data, v->payload, v->data_len);
 	e->skb->nfcache |= NFC_ALTERED;
 

--------------020809050605090706060206--
