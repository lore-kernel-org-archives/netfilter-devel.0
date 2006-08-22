From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH 3/3][CONNTRACK] Fix race condition in early drop
Date: Tue, 22 Aug 2006 15:46:50 +0200
Message-ID: <44EB0ACA.8080109@netfilter.org>
References: <44E97335.1080105@netfilter.org>
	<200608220435.k7M4ZSLf001686@toshiba.co.jp>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Cc: laforge@netfilter.org, netfilter-devel@lists.netfilter.org, kaber@trash.net
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Yasuyuki KOZAKAI <yasuyuki.kozakai@toshiba.co.jp>
In-Reply-To: <200608220435.k7M4ZSLf001686@toshiba.co.jp>
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

Hi Yasuyuki,

Yasuyuki KOZAKAI wrote:
> From: Pablo Neira Ayuso <pablo@netfilter.org>
> Date: Mon, 21 Aug 2006 10:47:49 +0200
> 
>>[CONNTRACK] Fix race condition in early drop
>>
>>On SMP environments the maximum number of conntracks can be overpassed
>>under heavy stress situations due to an existing race condition.
>>
>>       CPU A                   CPU B
>>    atomic_read()               ...
>>    early_drop()                ...
>>       ...                  atomic_read()
>>  allocate conntrack      allocate conntrack
>>    atomic_inc()             atomic_inc()
>>
[snip]
> 
> I think there is unfair case like following.
> 
>        CPU A                   CPU B
>     atomic_add_unless() == 0
>     early_drop()                  ...
>        ...                     atomic_add_unless() == 1
>     atomic_add_unless() == 0
>     early_drop()
> 
> The right to allocate conntrack is stolen by CPU B in this case.

Yes, but we're under stress so I'm not sure if fairness is important here.

> And there is no assurance that CPU A can exits this loop in short time.

You are right, this seems important. Instead of looping we can just give 
up if we lose race.

> How about incrementing {ip,nf}_conntrack_count at first ?
> 
>     1. atomic_add()
>     2. if {ip,nf}_conntrack_count > {ip,nf}_conntrack_max (not '>=' )
>        then early_drop()
>     3. if early_drop() failed, atomic_dec()

I thought about this possibility but then we can't guarantee the fixed 
maximum number of conntracks in the system.

Any comments?

-- 
The dawn of the fourth age of Linux firewalling is coming; a time of 
great struggle and heroic deeds -- J.Kadlecsik got inspired by J.Morris
