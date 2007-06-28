From: Patrick McHardy <kaber@trash.net>
Subject: Re: [ANNOUNCE] Release of iptables 1.3.8
Date: Thu, 28 Jun 2007 18:02:34 +0200
Message-ID: <4683DB9A.8060304@trash.net>
References: <4680DAB6.9000903@trash.net>	<200706281139.l5SBduIn016853@toshiba.co.jp>	<4683A117.8000309@trash.net>	<200706281546.l5SFkEBG007744@toshiba.co.jp>
	<4683D8F0.8010706@trash.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@lists.netfilter.org, david@blue-labs.org,
	pablo@netfilter.org
To: Yasuyuki KOZAKAI <yasuyuki.kozakai@toshiba.co.jp>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
In-Reply-To: <4683D8F0.8010706@trash.net>
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

Patrick McHardy wrote:
>>
>> Done to commit. But I didn't kill KERNEL_64_USERSPACE_32 from Makefile,
>> SAME, and CLUSTERIP. They doesn't have compat layer in kernel
>> in the current.
>>   
>
> Thanks. I can fix CLUSTERIP. SANE is not too important since its
> deprecated and unfixable broken wrt. 64 bit cleanness. At some
> point we should remove it, I'll add it to feature-removal-schedule.
>
>
>


BTW, I would suggest to remove it entirely, it just doesn't work
properly. Most people won't use it anyways because I guess no sane
distributor compiles 32 bit packages on a 64 bit kernel exactly
because this kind of crap. For people that actually use it it will
break once we add proper support to the kernel.

I'll fix CLUSTERIP now ..
