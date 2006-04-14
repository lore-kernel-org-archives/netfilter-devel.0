From: varun <varun@rocsys.com>
Subject: Re: iptables doubt
Date: Fri, 14 Apr 2006 09:03:46 +0530
Message-ID: <443F181A.6070506@rocsys.com>
References: <443D06A7.1060504@rocsys.com> <443E21C1.9090508@info.ucl.ac.be>
	<443E341F.1080206@rocsys.com> <443E42E6.2010405@info.ucl.ac.be>
	<443E4BAA.3020607@rocsys.com> <443E4F34.10206@info.ucl.ac.be>
	<443E57E6.8080005@rocsys.com>
	<Pine.LNX.4.64.0604131801560.4261@mercury.sdinet.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Sven-Haegar Koch <haegar@sdinet.de>
In-Reply-To: <Pine.LNX.4.64.0604131801560.4261@mercury.sdinet.de>
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

Yeah it is true but this can done only after safe but not dynamically? 
Is there a way to do dynamically?

Varun







Sven-Haegar Koch wrote:

> On Thu, 13 Apr 2006, varun wrote:
>
>>                         The features i want to implement like that 
>> priority for policy is that imagine a scenario where user added some 
>> policies and then for some reason wants one policy to be checked 
>> before checking others then he would have to add the policy again and 
>> delete the old policy isint it?
>
>
> Every iptables rule change is loading the whole ruleset into 
> userspace, modifying it, and copying the result back into kernelspace.
>
> So you should be able to fetch the rules (f.e. with iptables-save), 
> modify them as you like, and push them back (iptables-restore).
>
> c'ya
> sven
>
