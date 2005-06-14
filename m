From: Amin Azez <azez@ufomechanic.net>
Subject: Re: missing conntrack protocol on updates
Date: Tue, 14 Jun 2005 10:37:35 +0100
Message-ID: <42AEA55F.6040903@ufomechanic.net>
References: <42A033E9.3020907@ufomechanic.net> <42A23449.5020708@eurodev.net>
	<42ADA1BC.9080706@ufomechanic.net> <42AE4149.8090903@eurodev.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Pablo Neira <pablo@eurodev.net>
In-Reply-To: <42AE4149.8090903@eurodev.net>
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

> Hi Amin,
>
> Amin Azez wrote:
>
>>> This seems related to you hack. All those update messages tell me 
>>> that you are sending a netlink event message for every 
>>> IPCT_PROTINFO_VOLATILE event, aren't you? 
>>
>>
>> As the dport addresses are all different I'm not sure how you 
>> conclude this.
>
>
> Could you assure you that you're losing messages under heavy loads 
> (tons of updates) without your patch?

I'm only losing messages when I re-invoke the enumeration of all 
contracks over the event connection AND when I am slow at processing 
these events through talking to other processes.

>
>>> Maybe you're doing something similar, 
>>
>>
>> I'm not deliberately sending a message for every 
>> IPCT_PROTOINFO_VOLATILE, although - good guess - I will be wanting to 
>> get more frequent updates for long lived connections.
>
>
> OK, I've caught you, you're spamming ;). In case that we'd want more 
> frequent updates I'll need to implement a solution based on a buffer 
> as Harald currently does in ULOG and do some benchmarks.

Aye, I did think of a variation of the enumeration where it only dumps 
conntracks that have been in existance more than so-long since their 
last dump or maybe to only dump conntracks that have been in existance 
for more than so-long and clients just invoke this dump periodically.

>
>>> I'd need to see the code anyway.
>>
>>
>> I'll send patches to conntrack and to kernel 2.6.12 seperately.
>
>
> I've got a major re-sync against ctnetlink and friends (conntrack tool 
> included) lying around here. I'll pass it to Harald as soon as I 
> finish  the testing. This update implies tons of changes, so you'll 
> have to rework your patch. I know that it's a pain in the neck but 
> don't forget that this stuff is still under development. There's a 
> snapshot at people.netfilter.org.
>
OK, I'll grab the snapshot thanks, and then send patches along with a 
patch to libnfnetlink with non-blocking read loop on the netlink socket 
and which permits the event handler to signify that the read-loop should 
exit. This allows the application using libnfnetlink to exit the read 
loop based on signals and such, and then re-enter the read loop later. 
I'm also adding in/out device name to /proc/net/ip_conntrack and related 
netlink events.

>>> If my guess is correct, such loss of messages is related to the 
>>> nature of the netlink sockets. Netlink is a unreliable protocol. 
>>> Under *heavy* loads and if the messages are sent from interrupt 
>>> context it will be likely to drop messages for spamming events.
>>
>>
>>
>> Aye, I've been able to do this, but never drop only part of a 
>> message, usually the entire netlink packet is dropped, so its 
>> interesting that only the protocol part is missing.
>
>
> I see the protocol part here, I think that since IPCT_PROTOINFO is 
> only set when the protocol state changes, so I bet that this is 
> related to you hack.
>
I'll look for this now then.

Thanks

Amin
