From: Pablo Neira <pablo@eurodev.net>
Subject: Re: [PATCH 1/2] updates for [nf|ct]netlink and event API
Date: Thu, 30 Jun 2005 02:27:02 +0200
Message-ID: <42C33C56.10708@eurodev.net>
References: <42C03F2E.30706@eurodev.net>
	<42C0806E.3010400@trash.net>	<20050628071308.GE13239@sunbeam.de.gnumonks.org>	<42C1747A.3010703@trash.net>
	<42C2F2DF.7070301@eurodev.net>	<42C2FC14.80609@trash.net>
	<20050629201625.GY25641@sunbeam.de.gnumonks.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>,
	Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Harald Welte <laforge@netfilter.org>
In-Reply-To: <20050629201625.GY25641@sunbeam.de.gnumonks.org>
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

Harald Welte wrote:
> On Wed, Jun 29, 2005 at 09:52:52PM +0200, Patrick McHardy wrote:
> 
>>>So I think that we can group event, say:
>>>
>>>level 1 (weak):
>>>    - IPCT_NEW
>>>    - IPCT_DESTROY
>>>
>>>level 2 (normal):
>>>    - IPCT_NEW
>>>    - IPCT_UPDATE
>>>    - IPCT_STATUS
>>>    - ...
>>>    - IPCT_DESTROY
>>>
>>>At reserve some groups to let the user define some level whenever he
>>>wants. Although such level would be unique.
>>>
>>>OTOH, there are 10 events currently, why is that bad creating a group
>>>per event?
>>
>>I don't think its bad, but I fear hitting the 32 group limit some day.
>>Probably that fear is unfounded and we're never going to reach 32
>>different types of events. Harald, what do you think?
> 
> 
> I think it's not all that much of a problem.  I doubt that conntrack
> will get 22 more events anytime soon.  The other problem is, don't we
> overlap with other nfnetlink-based groups?
> 
> nfnetlink acts as a a multiplex between netlink and the higher layers,
> so I guess we only have 32groups for nfnetlink as a whole... and there
> is other stuff like ip_queue and ULOG that is to be ported on top of
> nfnetlink...

You're right, we can't do that. In short:

nfnetlink currently relies on the fact that is the user program that 
decides if a packet was sent to it or not. In case that it wasn't, the 
program drops it.

Say we've got ip_queue and ip_conntrack_netlink on top of nfnetlink: 
ip_queue sends a packet to user space and ip_conntrack_netlink sends 
event notifications. If both the ipqueue userspace program and 
libctnetlink are subscribed to the same group, they both will receive 
spam from each other.

To avoid this spamming situation, every subsystem could reserve just one 
group and user programs must get subscribed to the corresponding group 
that is interested in. In conclusion, nfnetlink would support up to 32 
subsystems but user space programs won't get spam from other subsystem.

So, back to ip_conntrack_netlink, we still have the performance issue 
with regards to the events. Userspace programs will decide if the event 
received is interesting for them or not.

a) We could extend netlink code with some kind of ioctl that sets a mask 
to say what kind of events are interesting for a given userspace program.

b) The fact that we can send events and nobody's listening to them is 
more difficult to catch up. Maybe a function that checks if there are 
listeners available before sending an event could help: In that case 
such function would be kind of racy because we can lose some messages 
while a userspace program is binding to a given netlink socket. This 
isn't that annoying, I prefer losing a couple of messages than hurting 
performance generating messages that won't be ever delivered.

--
Pablo
