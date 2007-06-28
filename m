From: Patrick McHardy <kaber@trash.net>
Subject: Re: [ANNOUNCE] Release of iptables 1.3.8
Date: Thu, 28 Jun 2007 17:51:12 +0200
Message-ID: <4683D8F0.8010706@trash.net>
References: <4680DAB6.9000903@trash.net>	<200706281139.l5SBduIn016853@toshiba.co.jp>	<4683A117.8000309@trash.net>
	<200706281546.l5SFkEBG007744@toshiba.co.jp>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@lists.netfilter.org, david@blue-labs.org,
	pablo@netfilter.org
To: Yasuyuki KOZAKAI <yasuyuki.kozakai@toshiba.co.jp>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
In-Reply-To: <200706281546.l5SFkEBG007744@toshiba.co.jp>
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
> Date: Thu, 28 Jun 2007 13:52:55 +0200
>
>   
>> Yasuyuki KOZAKAI wrote:
>>     
>>> From: Patrick McHardy <kaber@trash.net>
>>> Date: Tue, 26 Jun 2007 11:21:58 +0200
>>>       
>>>> Indeed, thanks for the reminder. The KERNEL_64_USERSPACE_32 stuff
>>>> needs to go.
>>>>
>>>> Patches for that are welcome.
>>>>     
>>>>         
>>> How state on this is ? If anyone doesn't do it until I come from dinner,
>>> I'll take it. It conflicts some of xtasble patches I've updated.
>>>       
>> I don't think anyone is working on it so far.
>>     
>
> Done to commit. But I didn't kill KERNEL_64_USERSPACE_32 from Makefile,
> SAME, and CLUSTERIP. They doesn't have compat layer in kernel
> in the current.
>   

Thanks. I can fix CLUSTERIP. SANE is not too important since its
deprecated and unfixable broken wrt. 64 bit cleanness. At some
point we should remove it, I'll add it to feature-removal-schedule.
