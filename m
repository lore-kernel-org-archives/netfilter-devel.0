From: Allen Francom <aef@tempest.prismnet.com>
Subject: Re: Netfilter as an application
Date: Fri, 16 Jan 2004 23:35:41 -0600 (CST)
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <20040116232355.Q76777@tempest.prismnet.com>
References: <20040116214721.82710.qmail@web40301.mail.yahoo.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: kernel_learner <kernel_learner@yahoo.com>
In-Reply-To: <20040116214721.82710.qmail@web40301.mail.yahoo.com>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org


Hi,

Well, in order for a user-space application to get
at the raw packets and presumably do things like
set promiscuous mode on ethernet adapter(s), that
takes root privileges for one thing ( last I tried )

Netfilter, what I know of it and what I've tried,
has cornfused me because it seemed intertwined
/ interdependent with kernel code and libraries
and gets packets in a structure that is generated
by the kernel etc., and so on.  ( too much for
me to try and deal with given limited time )

To me, netfilter does not look or feel like an
application having much if anything to do with
user-space.

However, I have done a few things with the IPQUEUE
"userspace module" extension ability.

This is where you can run a user program that gets
packets out of the kernel NETFILTER via a -j IPQUEUE
rule and it goes to your listening program.

Then you can in your program inspect the packets,
Accept, Deny or Drop them, and even modify the packets.

That's one thing.

I suggested Snort because it is all user-space and might
be more appropriate for your tinkerings due to the
way your request sounded.

Snort I believe throws promiscous mode on the
adapters and that takes root privileges.

Netfilter code itself to me ( and I'm no genius here )
but it is not what I'd start with for anything in
user-space, and from what I've seen I wouldn't even
try to fanagle the code to working in user-space.

It is kernel stuff with some command-line utilities
to manipulate the rules.  That's how I look at
netfilter.

Indeed, build a linux kernel and see all the kernel
modules.  Then look at the code to those modules
and see all the dependencies on other kernel code.

If I'm not mistaken, netfilter relies entirely on
the kernel network stack and cannot "stand-alone".

Too yucky to try in my book.

So I second my own recommendation to look at things
like Snort instead.

Also maybe try hogwash, and there are a couple other similar
projects.

Perhaps though what you want after reflecting on it
is to use the Netfilter IPQUEUE extension.

But not if you truly need or want an entirely
userspace self-contained something.

IMHO
-AEF


On Fri, 16 Jan 2004, kernel_learner wrote:

> Thanks Allen,
>
>  However I am not sure why you think user should have
> user priveleges. I am not saying I will use netfilter
> as it is.

> What exactly does the netfilter use from the Linux
> kernel?
>
> Where exactly does it interact with the kernel?
>
> Most of the extensions are modules..which is fine..I
> can easily convert them to user-application-code.
> I hope I am making myself clear...
