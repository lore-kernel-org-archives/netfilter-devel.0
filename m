From: Pablo Neira <pablo@eurodev.net>
Subject: Re: problem with conntrack utility and kernel 2.6.14
Date: Tue, 01 Nov 2005 17:39:23 +0100
Message-ID: <43679A3B.6070009@eurodev.net>
References: <4361EAAB.1090206@fliegl.de> <4361F6DF.3050106@eurodev.net>
	<43621028.40705@fliegl.de> <43627A8F.9060307@eurodev.net>
	<436281BB.2010100@fliegl.de> <436373E8.7040606@eurodev.net>
	<436398C7.4070402@fliegl.de> <4365A097.1080001@eurodev.net>
	<Pine.LNX.4.62.0510310911090.9468@bizon.gios.gov.pl>
	<4366C031.6020504@eurodev.net>
	<Pine.LNX.4.63.0511011116550.3512@bizon.gios.gov.pl>
	<436773EB.6000608@eurodev.net>
	<Pine.LNX.4.63.0511011605010.12220@bizon.gios.gov.pl>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Deti Fliegl <deti@fliegl.de>, netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Krzysztof Oledzki <olenf@ans.pl>
In-Reply-To: <Pine.LNX.4.63.0511011605010.12220@bizon.gios.gov.pl>
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

Krzysztof Oledzki wrote:
> On Tue, 1 Nov 2005, Pablo Neira wrote:
> 
>> Krzysztof Oledzki wrote:
>>
>>>> You can't kill conntracks *just* by the ID. The connection tracking 
>>>> table currently uses the tuple information (source, destination, 
>>>> protocol information) to place the conntrack in hashes, same thing 
>>>> to perform lookups.
>>>
>>> So, why do we need this conntrack ID? Only for userspace applications?
>>
>> Because of two reasons:
>>
>> a) We have to provide a way to uniquely identify a conntrack. On slow 
>> devices, it could happen that a connection with the same src/dst/proto 
>> could be re-created in a very short period of time. So the user can be 
>> sure that he's killing that conntrack, and not a similar that 
>> represents a re-opened connection.
> 
> So one can pass this id as an additional information? OK. :)

That is :)

> BTW: I think conntrack-tool should inform that conntrack killing fails 
> because kernel isn't able to find a matching conntrack.

That is what it currently does, are you observing a different behaviour?

# conntrack -D --orig-src 1.1.1.1 --orig-dst 2.2.2.2 -p tcp 
--orig-port-src 2005 --orig-port-dst 21
NFNETLINK answers: No such file or directory
Operation failed: such conntrack doesn't exist

>> b) Netlink dumping is not atomic, for that reason we need a way to 
>> know from which point we stopped dumping the connection tracking 
>> table. Keeping a pointer to the lastest conntrack processed won't work 
>> because of the timers. It could happen that a conntrack expires at the 
>> time that  the process of dumping continues. So the idea is using the 
>> ID to establish such breakpoint, and continue from the lastest 
>> conntrack ID processed if it's still present, otherwise we'll process 
>> the next conntrack ID higher than the lastest processed.
> 
> But to do this you need to travel the structure from the beginning and 
> so dumping may require operations like O(n) anyway?

No, we store the last bucket processed in a temporary control buffer, so 
we can continue from this bucket and then look for the last conntrack 
processed in the list associated to this bucket.

-- 
Pablo
