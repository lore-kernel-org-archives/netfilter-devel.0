From: Bart De Schuymer <bdschuym@pandora.be>
Subject: Re: [NETFILTER]: Kill ebt_ulog
Date: Sat, 23 Jul 2005 19:49:53 +0000
Message-ID: <1122148193.3382.16.camel@localhost.localdomain>
References: <42E1ADB2.1080109@trash.net>
	<1122119412.4484.5.camel@localhost.localdomain>
	<42E267C8.9090005@trash.net>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Cc: Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Patrick McHardy <kaber@trash.net>
In-Reply-To: <42E267C8.9090005@trash.net>
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

Op za, 23-07-2005 te 17:52 +0200, schreef Patrick McHardy:
> Bart De Schuymer wrote:
> > Op za, 23-07-2005 te 04:38 +0200, schreef Patrick McHardy:
> > 
> >>plain text document bijlage (x)
> >>[NETFILTER]: Kill ebt_ulog
> >>
> >>It uses NETLINK_NFLOG, which is also used by ipt_ULOG, so it causes
> >>conflicts in netlink_kernel_create. As no userspace daemon exists,
> >>and a generic replacement by Harald will follow in the next couple
> >>of days, kill it.
> > 
> > Killing ebt_ulog is not the right thing, it is an ebtables module that
> > is used by people (which is why I made it). The right thing would be to
> > make ebt_ulog use Harald's upcoming generic code, which is hopefully not
> > restricted to iptables.
> 
> The upcoming code will be a generic replacement, so there's no need to
> have ipt_ULOG/ebt_ulog except for backwards compatiblity reasons.
> Is there actually a userspace daemon for ebt_ulog? In any case it makes
> little sense to allocate a new netlink number for ebt_ulog since it
> will break userspace compatiblity anyway.

I wrote an example (see the ebtables CVS) that receives the netlink
messages and prints out data for ping requests and replies.
Gustavo Carneiro released some Perl code that handles the netlink
messages (see http://ebtables.sourceforge.net/examples.html#easy). There
is no full-blown full-featured daemon, I don't think that's always what
people want anyway.
What mechanism will let the user decide which packets should be sent to
userspace? I think it would be a bad thing if {ip,eb}tables could no
longer be used for that (it's not just backwards compatibility).

I think changing the netlink number is a lot less drastic w.r.t.
userspace compatibility than bluntly removing ebt_ulog. Perhaps it's my
awful memory, but I seem to remember that ipt_ULOG and ebt_ulog could be
used together. Anyway, it's sad that they can't share NETLINK_NFLOG,
differentiation between both message flows is easily accomplished by the
user with using a different netlink group number (but this issue should
be fixed by the generic implementation).

cheers,
Bart
