From: Emmanuel Guiton <emmanuel@netlab.hut.fi>
Subject: Re: problem when loading ip_tables - solved.
Date: Thu, 25 Mar 2004 11:43:55 +0200
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <4062A9DB.4050803@netlab.hut.fi>
References: <Pine.LNX.4.44.0403241750440.31592-100000@filer.marasystems.com> <4061BEA7.80800@netlab.hut.fi>
Reply-To: emmanuel@netlab.hut.fi
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: netfilter-devel@lists.netfilter.org
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org


Hi!

The problem was the interdependance I mentioned earlier. I had included 
the header file of my module in the ip_conntrack_standalone.c which 
caused the ip_conntrack module to depend on my module which depends on 
ip_conntrack.

Thanks you Henrik for the clue about modules.dep!

Bye,

         Emmanuel



Emmanuel Guiton wrote:

>
> hi!
>
> Thanks for your suggestion, but I guess it may not be the problem. 
> When I recompiled the kernel, I did it from scratch icluding make dep. 
> So it should be up to date. However how can I ensure it?
> However, looking at modules.dep i noticed that I have a module A that 
> depends on a module B that itself depend on A. Can this 
> interdependance be a problem?
>
>        Emmanuel
>
>
>
> Henrik Nordstrom wrote:
>
>> On Wed, 24 Mar 2004, Emmanuel Guiton wrote:
>>
>>  
>>
>>> insmod: ip_tables: no module by that name found
>>>
>>> while the module ip_tables.o exists. insmod finds without problem 
>>> the other modules like for example ipt_REDIRECT, ip_conntrack, 
>>> iptable_nat...
>>>   
>>
>>
>>
>> Probably your modules.dep is not up to date.
>>
>> Regards
>> Henrik
>>  
>>
>
>
>
