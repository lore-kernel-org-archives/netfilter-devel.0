From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH 3/3][CONNTRACK] Fix race condition in early drop
Date: Tue, 22 Aug 2006 16:39:23 +0200
Message-ID: <44EB171B.9080505@netfilter.org>
References: <44E97335.1080105@netfilter.org>	<200608220435.k7M4ZSLf001686@toshiba.co.jp>
	<44EB0ACA.8080109@netfilter.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Cc: laforge@netfilter.org, netfilter-devel@lists.netfilter.org, kaber@trash.net
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Yasuyuki KOZAKAI <yasuyuki.kozakai@toshiba.co.jp>
In-Reply-To: <44EB0ACA.8080109@netfilter.org>
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

Pablo Neira Ayuso wrote:
>> How about incrementing {ip,nf}_conntrack_count at first ?
>>
>>     1. atomic_add()
>>     2. if {ip,nf}_conntrack_count > {ip,nf}_conntrack_max (not '>=' )
>>        then early_drop()
>>     3. if early_drop() failed, atomic_dec()
> 
> 
> I thought about this possibility but then we can't guarantee the fixed 
> maximum number of conntracks in the system.

Hm, actually this is wrong, we can guarantee the maximum number but 
aren't we somehow fooling the counter? I mean, the counter can reach 
values higher than conntrack_max during a short period.

-- 
The dawn of the fourth age of Linux firewalling is coming; a time of 
great struggle and heroic deeds -- J.Kadlecsik got inspired by J.Morris
