From: Brad Fisher <brad@info-link.net>
Subject: Re: issue with the quota match
Date: Tue, 29 Mar 2005 09:53:32 -0600
Message-ID: <424979FC.8020005@info-link.net>
References: <1112030055.6205.23.camel@localhost> <42491710.4090400@eurodev.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Netfilter-Devel <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Borja Pacheco <bpacheco@acisa.es>
In-Reply-To: <42491710.4090400@eurodev.net>
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

Pablo Neira wrote:

> Borja Pacheco wrote:
>
>> In a first moment I insert a rule with an initial quota of 1000 bytes...
>>     0     0 ACCEPT     all  --  *      *       0.0.0.0/0
>> 0.0.0.0/0           quota: 1000 bytes
>>
>> Next, I generate packets and here it's the amazing result....
>>     8   448 ACCEPT     all  --  *      *       0.0.0.0/0
>> 0.0.0.0/0           quota: 712 bytes
>>
>> Theoretically, 1000 assigned bytes minus total traffic generated (448
>> bytes), must originate the remaining quota the rule has: 552. BUT IT 
>> SAYS 712 BYTES!!!!!
>
>
> quota doesn't count the ip headers (20 bytes). Some maths:
>
> 8 packets x 20 bytes = 160 bytes
> 552 + 160 = 712 bytes
>
> -- 
> Pablo
>
>
> !DSPAM:42491732223341143723889!
>
I had submitted a patch at one time that added an option to the quota 
match to tell it to count the headers...  If anyone's interested I could 
post it again (or you could try searching the list archive), but it is 
probably a little dated at the moment since I haven't done any work on 
it in quite a while...

-Brad
