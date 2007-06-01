From: Patrick McHardy <kaber@trash.net>
Subject: Re: [RFC][PATCH 0/7]: ct_extend
Date: Fri, 01 Jun 2007 17:33:59 +0200
Message-ID: <46603C67.4070201@trash.net>
References: <200705071200.l47C0UoM006287@toshiba.co.jp>	<e6af3bc80705301643w37922773ge6beab27d229718b@mail.gmail.com>	<465E5159.4050604@trash.net>
	<200705310902.l4V9212d010654@toshiba.co.jp>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Cc: mmohsenz@gmail.com, rusty@rustcorp.com.au,
	netfilter-devel@lists.netfilter.org, pablo@netfilter.org,
	kadlec@blackhole.kfki.hu
To: Yasuyuki KOZAKAI <yasuyuki.kozakai@toshiba.co.jp>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
In-Reply-To: <200705310902.l4V9212d010654@toshiba.co.jp>
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

Yasuyuki KOZAKAI wrote:
> I've revisited the issue of competition between NAT referring
> extension area for NAT and nfctnetlink trying to assign helper (which might
> result in reallocating extension area for NAT).
> 
> And I've found that the current nfctnetlink has similar but different
> problem. It is possible to change helper infomations while helper referring
> them.
> 
> After all, if we don't want to introduce rwlock for such competition,
> we'd better to limit nfctnetlink so that it doesn't assign, change, or
> remove helper of confirmed conntrack.
> 
> If people agree to remove ctnetlink_change_helper(), I'll submit the latest
> pactchset of ct_extend.


I don't think we can do that, it has been part of the ABI since the
beginning I think and we might need it for userspace helpers.

How about grabbing nf_conntrack_lock and replacing the entire conntrack
structure in this case?
