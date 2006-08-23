From: Patrick McHardy <kaber@trash.net>
Subject: Re: [PATCH 3/3][CONNTRACK] Fix race condition in early drop
Date: Wed, 23 Aug 2006 06:38:55 +0200
Message-ID: <44EBDBDF.8070308@trash.net>
References: <200608220435.k7M4ZSLf001686@toshiba.co.jp>	<44EB0ACA.8080109@netfilter.org>	<44EB171B.9080505@netfilter.org>
	<200608230228.k7N2SDTf000802@toshiba.co.jp>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Cc: laforge@netfilter.org, netfilter-devel@lists.netfilter.org,
	pablo@netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Yasuyuki KOZAKAI <yasuyuki.kozakai@toshiba.co.jp>
In-Reply-To: <200608230228.k7N2SDTf000802@toshiba.co.jp>
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
>>Pablo Neira Ayuso wrote:
>>
>>>>How about incrementing {ip,nf}_conntrack_count at first ?
>>>>
>>>>    1. atomic_add()
>>>>    2. if {ip,nf}_conntrack_count > {ip,nf}_conntrack_max (not '>=' )
>>>>       then early_drop()
>>>>    3. if early_drop() failed, atomic_dec()
>>>
>>>
>>>I thought about this possibility but then we can't guarantee the fixed 
>>>maximum number of conntracks in the system.
>>
>>Hm, actually this is wrong, we can guarantee the maximum number but 
>>aren't we somehow fooling the counter? I mean, the counter can reach 
>>values higher than conntrack_max during a short period.
> 
> 
> good point. I don't mind fooling the counter in this short period,


Me neither. We can already be off by more than one since early_drop
just removes a conntrack from the hash tables, but it is not necessarily
destroyed immediately (at which point the counter is decremented).
This is a reason why we can't loop while waiting for the counter to
decrement.
