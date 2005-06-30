From: Pablo Neira <pablo@eurodev.net>
Subject: Re: [PATCH 1/2] updates for [nf|ct]netlink and event API
Date: Thu, 30 Jun 2005 11:47:27 +0200
Message-ID: <42C3BFAF.7040900@eurodev.net>
References: <42C03F2E.30706@eurodev.net>
	<42C0806E.3010400@trash.net>	<20050628071308.GE13239@sunbeam.de.gnumonks.org>	<42C1747A.3010703@trash.net>
	<42C2F2DF.7070301@eurodev.net>	<42C2FC14.80609@trash.net>
	<20050629201625.GY25641@sunbeam.de.gnumonks.org>
	<42C33C56.10708@eurodev.net> <42C34290.6090305@trash.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Harald Welte <laforge@netfilter.org>,
	Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Patrick McHardy <kaber@trash.net>
In-Reply-To: <42C34290.6090305@trash.net>
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
> Pablo Neira wrote:
>>To avoid this spamming situation, every subsystem could reserve just one
>>group and user programs must get subscribed to the corresponding group
>>that is interested in. In conclusion, nfnetlink would support up to 32
>>subsystems but user space programs won't get spam from other subsystem.
> 
> 
> That's how it should be done. Conntrack is an exceptional case in that
> it is the only part in the kernel I know of that generates asynchronous
> netlink messages at high speed, so I think reserving multiple groups
> is the right way.

OK, I'm fine with the solution based on groups. Then I'll go that way.

>>So, back to ip_conntrack_netlink, we still have the performance issue
>>with regards to the events. Userspace programs will decide if the event
>>received is interesting for them or not.
>>
>>a) We could extend netlink code with some kind of ioctl that sets a mask
>>to say what kind of events are interesting for a given userspace program.
> 
> 
> Please no ioctls. Groups are fine, if one group per event is too much we
> need to group them somehow. Maybe:
> 
> 1) creation/destruction
> 2) status changes
> 3) timeout
> 4) protoinfo
> 5) helper
> 6) nat
> 7) expectations
> 
> 
>>b) The fact that we can send events and nobody's listening to them is
>>more difficult to catch up. Maybe a function that checks if there are
>>listeners available before sending an event could help: In that case
>>such function would be kind of racy because we can lose some messages
>>while a userspace program is binding to a given netlink socket. This
>>isn't that annoying, I prefer losing a couple of messages than hurting
>>performance generating messages that won't be ever delivered.
> 
> 
> That race shouldn't be a problem. Userspace can't know when exactly it
> will start receiving events anyway.

So, should be a netlink function to check if there are currently 
listeners worth it?

--
Pablo
