From: Robert Borger <bborger@navcorp.com>
Subject: NAT behind IPSEC GW working OK - please review patch
Date: Fri, 11 Mar 2005 11:38:14 -0600
Message-ID: <DB15CAD558452949A35006D66C5C5A99010F8B@nav-post.navcorp.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="iso-8859-1"
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

I have a subnet behind an IPSEC GW which is
NATed to the IPSEC GW address.  The IPSEC tunnel
is between the GW host address and the subnet
behind the remote IPSEC GW. It is required that
the NATed packets from the local subnet and the
packets originating on the GW must both pass
through the tunnel to the remote subnet.

Before applying the Patrick McHardy ipsec0x
and policy patches, there where problems
getting the NATed packets out over the tunnel.

After the patches where applied, the packets
got out the tunnel and returned via the tunnel
as expected, but were dropped during forwarding.

It appeared that the packet was still considered
to be an part of the encrypted stream and there
was no policy to forward it to the local subnet.

I changed the "xfrm_policy_check" function in
"./include/net/xfrm.h" to allow forwarding if
the "decap_done" flag is set.

Does anyone see any detrimental effects for this change?

Could I have achieved the same result with a
configuration change?

I started with a virgin 2.6.10 kernel then applied the
Patrick McHardy patches ported for the 2.6.10 kernel from:
http://www.zcu.cz/ftp/pub/network/shorewall/contrib/IPSEC

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


Thank You,
Bob Borger

-- 
No virus found in this outgoing message.
Checked by AVG Anti-Virus.
Version: 7.0.308 / Virus Database: 266.7.1 - Release Date: 3/9/05
 
