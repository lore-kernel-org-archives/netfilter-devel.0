From: Patrick McHardy <kaber@trash.net>
Subject: Re: NAT behind IPSEC GW working OK - please review patch
Date: Sun, 20 Mar 2005 17:12:52 +0100
Message-ID: <423DA104.7000402@trash.net>
References: <DB15CAD558452949A35006D66C5C5A99010F8B@nav-post.navcorp.com>
	<1111256850.19630.11.camel@leto.cs.pocnet.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Robert Borger <bborger@navcorp.com>, netfilter-devel@lists.netfilter.org,
	Andrew Hall <temp02@bluereef.com.au>
To: Christophe Saout <christophe@saout.de>
In-Reply-To: <1111256850.19630.11.camel@leto.cs.pocnet.net>
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

Christophe Saout wrote:
>>static inline int xfrm_policy_check(struct sock *sk, int dir, struct sk_buff
>>*skb, unsigned short family)
>>{
>>  if (sk && sk->sk_policy[XFRM_POLICY_IN])
>>    return __xfrm_policy_check(sk, dir, skb, family);
>>		
>>  return(!xfrm_policy_list[dir] && !skb->sp) ||
>>    (skb->sp && skb->sp->decap_done) || /* Added this line */
>>    (skb->dst->flags & DST_NOPOLICY) ||
>>    __xfrm_policy_check(sk, dir, skb, family);
>>}
> 
> 
> I can confirm that this fixes the problem you described.
> (I'm using the IPSEC+NAT patches I forward-ported for 2.6.11).
> 
> The line you added should be enclosed in an pair of #ifdef
> CONFIG_NETFILTER and #endif.

This is not correct, the reason why the packets are dropped
is most likely a missing forward policy. If this is not the
case, there must be a bug somewhere in nf_nat_decode_session4().

Regards
Patrick
