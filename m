From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH] Unconditionaly push mark to conntrack structure
Date: Wed, 31 May 2006 02:35:57 +0200
Message-ID: <447CE4ED.9010706@netfilter.org>
References: <E1Fh0am-0003Ct-Ph@fydelkass.inl.fr> <447CD8AA.2040502@trash.net>
	<447CDB83.1090606@trash.net> <447CE2B0.8000504@trash.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@lists.netfilter.org, Eric Leblond <eric@inl.fr>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Patrick McHardy <kaber@trash.net>
In-Reply-To: <447CE2B0.8000504@trash.net>
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
> Patrick McHardy wrote:
> 
>>Patrick McHardy wrote:
>>
>>
>>>Eric Leblond wrote:
>>>
>>>>This is needed in userspace as the mark can be used to select 
>>>>efficiently a subset of the conntrack events to work on.
>>>
>>>I'm a bit reluctant to special case mark, but mostly because I wonder
>>>whether we shouldn't just behave like all other networking subsystems
>>>and send update messages containing the entire new state. If you look
>>>at the optional information:
>>>
>>>- status bits are only 4 byte.
>>>- timeout is currently transmitted for every packet anyway - its better
>>> to just reduce the event rate (we even had a patch for this for ages)
>>
>>
>>Actually this isn't true, I just noticed we never send timeout update
>>notifications except for the first packet (which means we have tons
>>of unnecessary notifier chain calls). I think this isn't really
>>intended and was done to work around the high timeout event generation
>>rate. Pablo, do you more about this?

Indeed, the timer refresh event through netlink just burden the system 
and overrun the socket queue, so netlink starts dropping messages.

> More bad news .. the timeout is sent in HZ instead of USER_HZ. This
> unfortunately seems to call for an ABI break, I'd really hate to add
> a CTA_TIMEOUT2 attribute. I guess we can live with it since its
> usually not even included in the messages.

To be frank, I can't see how the timer can be useful from userspace. I 
think that we should remove it.

About Eric's patch, I think that he can keep a cache of conntracks in 
userspace, as conntrackd does, instead of increasing the message size 
for something that is not always required.

-- 
The dawn of the fourth age of Linux firewalling is coming; a time of 
great struggle and heroic deeds -- J.Kadlecsik got inspired by J.Morris
