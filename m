From: Patrick McHardy <kaber@trash.net>
Subject: Re: [NETFILTER]: Kill ebt_ulog
Date: Sat, 23 Jul 2005 22:04:57 +0200
Message-ID: <42E2A2E9.8050800@trash.net>
References: <42E1ADB2.1080109@trash.net>	
	<1122119412.4484.5.camel@localhost.localdomain>	
	<42E267C8.9090005@trash.net>
	<1122148193.3382.16.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Bart De Schuymer <bdschuym@pandora.be>
In-Reply-To: <1122148193.3382.16.camel@localhost.localdomain>
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

Bart De Schuymer wrote:
> Op za, 23-07-2005 te 17:52 +0200, schreef Patrick McHardy:
> 
>>The upcoming code will be a generic replacement, so there's no need to
>>have ipt_ULOG/ebt_ulog except for backwards compatiblity reasons.
>>Is there actually a userspace daemon for ebt_ulog? In any case it makes
>>little sense to allocate a new netlink number for ebt_ulog since it
>>will break userspace compatiblity anyway.
> 
> I wrote an example (see the ebtables CVS) that receives the netlink
> messages and prints out data for ping requests and replies.
> Gustavo Carneiro released some Perl code that handles the netlink
> messages (see http://ebtables.sourceforge.net/examples.html#easy). There
> is no full-blown full-featured daemon, I don't think that's always what
> people want anyway.
> What mechanism will let the user decide which packets should be sent to
> userspace? I think it would be a bad thing if {ip,eb}tables could no
> longer be used for that (it's not just backwards compatibility).

The QUEUE target will get a queue-number argument. Userspace can
register for different queues using netlink messages. All this
will be handled by the core to we don't need ipt_ULOG/ebt_ulog
anymore.

> I think changing the netlink number is a lot less drastic w.r.t.
> userspace compatibility than bluntly removing ebt_ulog. Perhaps it's my
> awful memory, but I seem to remember that ipt_ULOG and ebt_ulog could be
> used together. Anyway, it's sad that they can't share NETLINK_NFLOG,
> differentiation between both message flows is easily accomplished by the
> user with using a different netlink group number (but this issue should
> be fixed by the generic implementation).

The problem is that we can't create two kernel sockets for the same
netlink family. Netlink families are a scarce resource, so I don't think
it makes much sense to waste another one for a soon (couple of days)
deprecated mechanism. I propose to continue this discussion once the
new code is there, so we can see if it fits your needs.

Regards
Patrick
