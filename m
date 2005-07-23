From: Bart De Schuymer <bdschuym@pandora.be>
Subject: Re: [NETFILTER]: Kill ebt_ulog
Date: Sat, 23 Jul 2005 21:34:39 +0000
Message-ID: <1122154479.3382.29.camel@localhost.localdomain>
References: <42E1ADB2.1080109@trash.net>
	<1122119412.4484.5.camel@localhost.localdomain>
	<42E267C8.9090005@trash.net>
	<1122148193.3382.16.camel@localhost.localdomain>
	<42E2A2E9.8050800@trash.net>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Cc: Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Patrick McHardy <kaber@trash.net>
In-Reply-To: <42E2A2E9.8050800@trash.net>
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

Op za, 23-07-2005 te 22:04 +0200, schreef Patrick McHardy:
> The QUEUE target will get a queue-number argument. Userspace can
> register for different queues using netlink messages. All this
> will be handled by the core to we don't need ipt_ULOG/ebt_ulog
> anymore.

What if someone wants to just get a copy sent to userspace while the
kernel continues routing the copied packet? AFAIK this behaviour can't
be obtained using the queue target.

> The problem is that we can't create two kernel sockets for the same
> netlink family. Netlink families are a scarce resource, so I don't think
> it makes much sense to waste another one for a soon (couple of days)
> deprecated mechanism. I propose to continue this discussion once the
> new code is there, so we can see if it fits your needs.

If the generic code is such that other modules can make it send messages
through the NETLINK_NFLOG socket, then those problems are over. I think
there is no problem in keeping ULOG and QUEUE as long as they use the
generic framework, those targets do different things.

I'll be unreachable, most of the time, from July 25 'till August 7, I
hope I can catch up on the discussion then...

cheers,
Bart
