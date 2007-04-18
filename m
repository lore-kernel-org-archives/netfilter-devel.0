From: Carlos Munoz <carlos@kenati.com>
Subject: Re: [PATCH 2.6.20.4] Connection tracking: New SIP ALG that actually
 works
Date: Wed, 18 Apr 2007 10:53:44 -0700
Message-ID: <46265B28.2020501@kenati.com>
References: <4625334F.40308@kenati.com> <4625A2F9.3030502@trash.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Ranjit Deshpande <ranjit@kenati.com>, netfilter-devel@lists.netfilter.org
To: Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
In-Reply-To: <4625A2F9.3030502@trash.net>
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
> Carlos Munoz wrote:
>   
>> This is a SIP ALG that actually works. It has been tested extensively
>> with Asterisk, Vonage, and other SIP servers. It allows for VOIP
>> applications to run on the router itself as well as behind the router.
>> We have been shipping this SIP ALG for some time now. We tested the SIP
>> ALG distributed with kernel 2.6.20.4 and it didn't work (none of the
>> SIP ALGs distributed with the kernel that we've tested have ever worked).
>>     
>
>
> What you should have done is report the problems you were seeing or send
> patches for the existing version. We're not going to just toss in a
> huge rewritten version, especially not since you're reintroducing
> a lot of bugs and do lots of things that only work on 2.4.
>
>   
Hi Patrick,

I understand. We've had our sip alg before one was distributed with the 
kernel sources. When we upgrade to new kernel versions we regression 
test all features and the sip alg has always failed. So we keep using 
our sip alg. Management won't allocate resources to fix the sip alg in 
the kernel when ours works. However, that might change if our sip alg 
stops working.


Carlos Munoz
