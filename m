From: Jan Engelhardt <jengelh@computergmbh.de>
Subject: Re: VLAN match within iptables
Date: Tue, 26 Jun 2007 14:38:55 +0200 (CEST)
Message-ID: <Pine.LNX.4.64.0706261423150.3137@fbirervta.pbzchgretzou.qr>
References: <1182849745.22167.13.camel@blas> <4680E3D7.6020401@netfilter.org>
	<4680E5CC.8070807@trash.net>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: netfilter-devel@lists.netfilter.org, Amin Azez <azez@ufomechanic.net>,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	Jaime Nebrera <jnebrera@eneotecnologia.com>
To: Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
In-Reply-To: <4680E5CC.8070807@trash.net>
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


On Jun 26 2007 12:09, Patrick McHardy wrote:
>Pablo Neira Ayuso wrote:
>> Since you have to apply that patch to your kernel anyway, I suggest you
>> to apply the u32 patch instead (it is scheduled for 2.6.23 IIRC).
>
>I don't think that will work, it can't be used to match on data
>before skb->data since the offset can only be positive.

The VLAN ID is not in the Layer3 window. xt_u32 uses skb_copy_bits,
which seems to start at the Layer3 (IPv4/ipv6) header(why that?!).

>Jan, I just noticed the length checks are insufficient, very
>large positives offsets will lead to integer overflow and
>probably trigger the BUG afterwards.

Is this the right way to check for overflows?

                if (at > skb->len || at + pos > skb->len ||                     
                    at + pos + 3 > skb->len)                                    
                        return false;                                           


	Jan
-- 
