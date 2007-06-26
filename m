From: Patrick McHardy <kaber@trash.net>
Subject: Re: xt_u32 20070626 (Re: VLAN match within iptables)
Date: Tue, 26 Jun 2007 15:19:20 +0200
Message-ID: <46811258.9020309@trash.net>
References: <1182849745.22167.13.camel@blas> <4680E3D7.6020401@netfilter.org>
	<4680E5CC.8070807@trash.net>
	<Pine.LNX.4.64.0706261423150.3137@fbirervta.pbzchgretzou.qr>
	<46810B7A.5020609@trash.net>
	<Pine.LNX.4.64.0706261511140.3137@fbirervta.pbzchgretzou.qr>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Netfilter Developer Mailing List <netfilter-devel@lists.netfilter.org>
To: Jan Engelhardt <jengelh@computergmbh.de>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
In-Reply-To: <Pine.LNX.4.64.0706261511140.3137@fbirervta.pbzchgretzou.qr>
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

Jan Engelhardt wrote:
> Subject: Add the U32 match from POM-NG

I prefer incremental patches. Your patch looks good,
I'm wondering about the constant 3 though. A int is
four bytes long.


+               if (skb->len < 3 || pos > skb->len - 3);

assume skb->len == 3, pos = 0. Its obviously incorrent.

+                               if (at + 3 < at || skb->len < at + 3 ||
+                                   pos > skb->len - at - 3)

Same here, just assume the same as above and at == 0.


So I'm replacing all 3s by 4s.
