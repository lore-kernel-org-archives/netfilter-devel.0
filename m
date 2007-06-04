From: Patrick McHardy <kaber@trash.net>
Subject: Re: [RFC][PATCH 0/7]: ct_extend
Date: Mon, 04 Jun 2007 13:58:37 +0200
Message-ID: <4663FE6D.20005@trash.net>
References: <465E5159.4050604@trash.net>	<200705310902.l4V9212d010654@toshiba.co.jp>	<46603C67.4070201@trash.net>
	<200706040045.l540jnhh008964@toshiba.co.jp>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Cc: mmohsenz@gmail.com, rusty@rustcorp.com.au,
	netfilter-devel@lists.netfilter.org, pablo@netfilter.org,
	kadlec@blackhole.kfki.hu
To: Yasuyuki KOZAKAI <yasuyuki.kozakai@toshiba.co.jp>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
In-Reply-To: <200706040045.l540jnhh008964@toshiba.co.jp>
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
> From: Patrick McHardy <kaber@trash.net>
> Date: Fri, 01 Jun 2007 17:33:59 +0200
> 
>>How about grabbing nf_conntrack_lock and replacing the entire conntrack
>>structure in this case?
> 
> 
> It requires very complicated operations. I want to avoid that as possible.
> 
> I'm thinking about exporting nf_nat_lock and locks of helpers, and grabbing
> all of them just before reallocating extended area. But I'm not sure it is
> possible because we have to take care about deadlock due to grabbing
> multiple locks in different order.
> 
> One more idea is Rusty's comment in the original patch, it replaces array
> of extended area with linked list. But it results in so many small memory
> objects. Hmm...


If it results in one allocation per extension I don't think its a good
idea, one benefit of the array is that we can allocate the room for
multiple extensions at once if we already know its going to be needed.
