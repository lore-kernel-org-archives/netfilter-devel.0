From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH] Unconditionaly push mark to conntrack structure
Date: Tue, 06 Jun 2006 13:35:17 +0200
Message-ID: <44856875.2020108@netfilter.org>
References: <E1Fh0am-0003Ct-Ph@fydelkass.inl.fr> <447CD8AA.2040502@trash.net>
	<447CDB83.1090606@trash.net> <447CE2B0.8000504@trash.net>
	<447CE4ED.9010706@netfilter.org> <447CEAF3.5030903@trash.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@lists.netfilter.org, Eric Leblond <eric@inl.fr>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Patrick McHardy <kaber@trash.net>
In-Reply-To: <447CEAF3.5030903@trash.net>
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
> Pablo Neira Ayuso wrote:
> 
>>Patrick McHardy wrote:
>>
>>
>>>>Actually this isn't true, I just noticed we never send timeout update
>>>>notifications except for the first packet (which means we have tons
>>>>of unnecessary notifier chain calls). I think this isn't really
>>>>intended and was done to work around the high timeout event generation
>>>>rate. Pablo, do you more about this?
>>
>>
>>Indeed, the timer refresh event through netlink just burden the system
>>and overrun the socket queue, so netlink starts dropping messages.
> 
> 
> This is easy to fix by only sending an timer update for each connection
> once every n seconds. If done in ip_ct_refresh_acct it will also reduce
> the notifier load.
> 
> 
>>>More bad news .. the timeout is sent in HZ instead of USER_HZ. This
>>>unfortunately seems to call for an ABI break, I'd really hate to add
>>>a CTA_TIMEOUT2 attribute. I guess we can live with it since its
>>>usually not even included in the messages.
>>
>>
>>To be frank, I can't see how the timer can be useful from userspace. I
>>think that we should remove it.
> 
> 
> Don't you need it for synchronization? One example where it could be
> useful is to implement different timeout strategies (for example
> something like pf's adaptive timeouts) in userspace.

But these adaptive timeouts could be implemented in kernelspace. 
Although I don't know too much about the in-deep details of adaptive 
timeouts.

>>About Eric's patch, I think that he can keep a cache of conntracks in
>>userspace, as conntrackd does, instead of increasing the message size
>>for something that is not always required.
> 
> 
> Well, I do agree that any serious use of ctnetlink needs to take
> care of the unreliability of netlink and therefore maintain its
> own database that is resynchronized after losses etc. (I hope
> conntrackd does that :)) But I think at least the networking
> netlink subsystems should behave similar (it is for example
> a requirement for maintaining automatic libnl caches, should
> it be possible to use it with nfnetlink's different byteorder),
> and I don't think the few bytes saved are worth beeing incompatible
> with assumptions that hold for every other networking netlink
> protocol.

Unfortunately, ctnetlink is not doing any sequence tracking of the 
events at the moment :( and we have to. Here my old PIII 866MHz with a 
100Mbits network card starts dropping events when it reaches ~300 
simultaneos short TCP connections (2 seconds) with netperf. I'm going to 
cook a patch for this.
