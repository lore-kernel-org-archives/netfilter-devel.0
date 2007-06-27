From: Patrick McHardy <kaber@trash.net>
Subject: Re: [NETFILTER]: nf_conntrack: use hlists for conntrack hash
Date: Wed, 27 Jun 2007 09:27:39 +0200
Message-ID: <4682116B.70702@trash.net>
References: <46816369.4070407@trash.net>
	<200706270703.l5R73LS6001509@toshiba.co.jp>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@lists.netfilter.org
To: Yasuyuki KOZAKAI <yasuyuki.kozakai@toshiba.co.jp>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
In-Reply-To: <200706270703.l5R73LS6001509@toshiba.co.jp>
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
>> Convert conntrack hash to hlists to reduce its size and cache
>> footprint. Since the default hashsize to max. entries ratio
>> sucks (1:16), this patch doesn't reduce the amount of memory
>> used for the hash by default, but instead uses a better ratio
>> of 1:8, which results in the same max. entries value.
>>     
>
> What do you think the impact to nat hash table is ? nf_nat_htable_size
> is set to nf_conntrack_htable_size at initialization.
>
> I think we can also replace list with hlist for nat hash and then
> there is no problem.
>   

Sounds good, I'll look into that today.
