From: "Andrew Hall" <temp02@bluereef.com.au>
Subject: ipsec with SNAT
Date: Fri, 18 Mar 2005 18:29:54 +1100
Message-ID: <019901c52b8c$47932a90$5001010a@bluereef.local>
Mime-Version: 1.0
Content-Type: text/plain; format=flowed; charset="iso-8859-1";
	reply-type=original
Content-Transfer-Encoding: 7bit
To: <netfilter-devel@lists.netfilter.org>
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

On 11th March Rob Borger wrote a request to add:

>
I changed the "xfrm_policy_check" function in
"./include/net/xfrm.h" to allow forwarding if
the "decap_done" flag is set.

Then I made this change to "xfrm.h":

static inline int xfrm_policy_check(struct sock *sk, int dir, struct sk_buff
*skb, unsigned short family)
{
  if (sk && sk->sk_policy[XFRM_POLICY_IN])
    return __xfrm_policy_check(sk, dir, skb, family);

  return(!xfrm_policy_list[dir] && !skb->sp) ||
    (skb->sp && skb->sp->decap_done) || /* Added this line */
    (skb->dst->flags & DST_NOPOLICY) ||
    __xfrm_policy_check(sk, dir, skb, family);
}
>
I think he was trying to get SNAT working through an ipsec tunnel. Can 
someone please confirm if this patch is required, and/or if SNAT should 
currently work with Patrick's ipsec patches (and policy match) applied to 
stock 2.6.10?

Can someone also please explain how the ipsec policy match is meant to work 
in relation to forcing NAT. Is --pol ipsec supposed to match packets that 
have or will be subject to encryption? An example would be good for marking 
packets to be SNATTed through the tunnel.

Thanks,

Andrew. 
