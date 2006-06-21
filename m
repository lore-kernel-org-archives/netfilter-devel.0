From: Amin Azez <azez@ufomechanic.net>
Subject: Re: [PATCH] ipt_account rate patch
Date: Wed, 21 Jun 2006 10:16:53 +0100
Message-ID: <44990E85.4080308@ufomechanic.net>
References: <e6ueuc$qsq$1@sea.gmane.org> <4497FCD6.2000706@trash.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Patrick McHardy <kaber@trash.net>
In-Reply-To: <4497FCD6.2000706@trash.net>
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
> Amin Azez wrote:
>   
>> Here are some patches I did for ipt_account before ipt_ACCOUNT which
>> supports larger subnets was re-released.
>>
>> As well as per-ip packet and byte counting, the patches also does per-ip
>> rate calculating, so you can use this as part of a rate limiting rule
>> and drop packets that would exceed the rate.
>>
>> You get to choose whether or not dropped packets should also be accounted.
>>
>> Just as ipt_account supports total-subnet accounting, so we also support
>> total-subnet rate calculations as well.
>>
>> The rate calculations are an improved version of what is in
>> ip_conntrack_rate.c, namely we can handle the timer wraps around zero.
>>     
>
> How do you want me to handle this? The account patch is no longer in
> pom, the extension is still part of iptables. 
oh. Was there a strong reason for it being dropped?
I see that most of the patchlets have gone from:
http://svn.netfilter.org/cgi-bin/viewcvs.cgi/trunk/patch-o-matic-ng/patchlets/
including the newer ipt_ACCOUNT
> Do you want me to apply
> the iptables part or do you simply want to add it as an iptables.patch
> to the account repository?
>   
It won't make sense to do either until I can work out where the kernel
side bit needs stashing.

Did I miss something about pom-ng cleanup?

Sam
