From: Ranjeet Shetye <ranjeet.shetye2@zultys.com>
Subject: Re: 2.6 IPSEC + SNAT
Date: Wed, 01 Oct 2003 12:16:09 -0700
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <1065035768.2548.8.camel@ranjeet-pc2.zultys.com>
References: <20031001121648.GA8755@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Cc: kuznet@ms2.inr.ac.ru, davem@redhat.com, jmorris@redhat.com,  linux-net@vger.kernel.org, netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Herbert Xu <herbert@gondor.apana.org.au>
In-Reply-To: <20031001121648.GA8755@gondor.apana.org.au>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

On Wed, 2003-10-01 at 05:16, Herbert Xu wrote:
> Hi:
> 
> I have received bug reports saying that SNAT does not work when the
> packets have to be SNATed before they can enter an IPSEC tunnel
> under the 2.6 IPSEC stack.
> 
> The problem is that SNAT can only be performed in POSTROUTING while
> IPSEC policy lookups are done at the same time as the route lookup.
> 
> Has anyone else thought about this problem?
> 
> I have considered introducing a new NAT chain between filtering
> and routing where you can place SNAT rules into.  Of course, the
> same thing applies to reverse DNAT rules as well.
> 
> Any opinions on this would be appreciated.
> 
> Thanks,

This is precisely the problem I pointed out a month or so back but I
never got any response on it.

Here's my take on it.

NAT is not an elegant standard. Its a hack to provide a temporary fix
for the IPv4 address space crunch. On the other hand, IPSec is a good 
standard and is also mandatory for IPv6. Hence the focus should be on
IPSec much more than on NAT.

Now, NAT-Traversal encapsulates IPSec packets in UDP. Can we do an IPSec
- NAT-Traversal combo in order to solve this problem ? Maybe have a
POSTROUTING_NATTRAVERSAL table that will be automatically filled with
entries based on active IPSec tunnels or policies ?

Not a NetFilter expert like you guys are, but I know enough to be
dangerous :)

-- 

Ranjeet Shetye
Senior Software Engineer
Zultys Technologies
Ranjeet dot Shetye2 at Zultys dot com
http://www.zultys.com/
 
The views, opinions, and judgements expressed in this message are solely
those of the author. The message contents have not been reviewed or
approved by Zultys.
