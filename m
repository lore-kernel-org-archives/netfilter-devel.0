From: Pablo Neira <pablo@eurodev.net>
Subject: Re: missing conntrack protocol on updates
Date: Tue, 14 Jun 2005 04:30:33 +0200
Message-ID: <42AE4149.8090903@eurodev.net>
References: <42A033E9.3020907@ufomechanic.net> <42A23449.5020708@eurodev.net>
	<42ADA1BC.9080706@ufomechanic.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Amin Azez <azez@ufomechanic.net>
In-Reply-To: <42ADA1BC.9080706@ufomechanic.net>
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

Hi Amin,

Amin Azez wrote:
>> This seems related to you hack. All those update messages tell me that 
>> you are sending a netlink event message for every 
>> IPCT_PROTINFO_VOLATILE event, aren't you? 
> 
> As the dport addresses are all different I'm not sure how you conclude 
> this.

Could you assure you that you're losing messages under heavy loads (tons 
of updates) without your patch?

>> Maybe you're doing something similar, 
> 
> I'm not deliberately sending a message for every 
> IPCT_PROTOINFO_VOLATILE, although - good guess - I will be wanting to 
> get more frequent updates for long lived connections.

OK, I've caught you, you're spamming ;). In case that we'd want more 
frequent updates I'll need to implement a solution based on a buffer as 
Harald currently does in ULOG and do some benchmarks.

>> I'd need to see the code anyway.
> 
> I'll send patches to conntrack and to kernel 2.6.12 seperately.

I've got a major re-sync against ctnetlink and friends (conntrack tool 
included) lying around here. I'll pass it to Harald as soon as I finish 
  the testing. This update implies tons of changes, so you'll have to 
rework your patch. I know that it's a pain in the neck but don't forget 
that this stuff is still under development. There's a snapshot at 
people.netfilter.org.

>> If my guess is correct, such loss of messages is related to the nature 
>> of the netlink sockets. Netlink is a unreliable protocol. Under 
>> *heavy* loads and if the messages are sent from interrupt context it 
>> will be likely to drop messages for spamming events.
> 
> 
> Aye, I've been able to do this, but never drop only part of a message, 
> usually the entire netlink packet is dropped, so its interesting that 
> only the protocol part is missing.

I see the protocol part here, I think that since IPCT_PROTOINFO is only 
set when the protocol state changes, so I bet that this is related to 
you hack.

--
Pablo
