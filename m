From: "Andrew Hall" <temp02@bluereef.com.au>
Subject: Re: NAT behind IPSEC GW working OK - please review patch
Date: Mon, 21 Mar 2005 13:10:52 +1100
Message-ID: <000001c52dc4$ce0437b0$5001010a@bluereef.local>
References: <DB15CAD558452949A35006D66C5C5A99010F8B@nav-post.navcorp.com>
	<1111256850.19630.11.camel@leto.cs.pocnet.net>
	<423DA104.7000402@trash.net>
Mime-Version: 1.0
Content-Type: text/plain; format=flowed; charset="iso-8859-1";
	reply-type=response
Content-Transfer-Encoding: 7bit
Cc: Robert Borger <bborger@navcorp.com>, netfilter-devel@lists.netfilter.org
To: "Patrick McHardy" <kaber@trash.net>,
	"Christophe Saout" <christophe@saout.de>
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

> Christophe Saout wrote:
>>>static inline int xfrm_policy_check(struct sock *sk, int dir, struct 
>>>sk_buff
>>>*skb, unsigned short family)
>>>{
>>>  if (sk && sk->sk_policy[XFRM_POLICY_IN])
>>>    return __xfrm_policy_check(sk, dir, skb, family);
>>>
>>>  return(!xfrm_policy_list[dir] && !skb->sp) ||
>>>    (skb->sp && skb->sp->decap_done) || /* Added this line */
>>>    (skb->dst->flags & DST_NOPOLICY) ||
>>>    __xfrm_policy_check(sk, dir, skb, family);
>>>}
>>
>>
>> I can confirm that this fixes the problem you described.
>> (I'm using the IPSEC+NAT patches I forward-ported for 2.6.11).
>>
>> The line you added should be enclosed in an pair of #ifdef
>> CONFIG_NETFILTER and #endif.
>
> This is not correct, the reason why the packets are dropped
> is most likely a missing forward policy. If this is not the
> case, there must be a bug somewhere in nf_nat_decode_session4().
>
> Regards
> Patrick
>
There definately seems to be an issue somewhere, because I haven't been able 
to get SNAT working via the tunnel in transport mode without this patch, but 
this maybe an issue with my understanding of how the policy match works. Can 
you please confirm the following:

Traffic that requires SNAT modification will need a policy match to be 
applied to a rule in the POSTROUTING chain. IPSEC with your patches applied 
will make the traffic pass the POSTROUTING chain twice. The first time is 
clear, and the second time is encrypted. To mark packets for translation we 
set a rule something like the following:

iptables -A POSTROUTING -t nat -s 10.1.1.0/24 -d 10.1.2.0/24 -m policy --pol 
none -j SNAT --to-source 11.1.1.200

Is this correct? Setting pol = none matches on traffic that has not yet been 
encrypted (but will be next time through the chain), and pol = ipsec matches 
on traffic that has already been encrypted (for POSTROUTING) and visa versa 
for PREROUTING? Your confirmation will help clarify if I'm doing this 
properly or if there is infact a problem with my configuration.

Thanks,
Andrew. 
