From: Darren.Reed@Sun.COM
Subject: Re: Developing a user space library for filtering
Date: Tue, 22 May 2007 13:50:20 -0700
Message-ID: <4653578C.3070407@Sun.COM>
References: <46521CB9.2040309@Sun.COM> <46522166.1090603@gmx.net>
	<465222C0.8050601@Sun.COM>
	<Pine.LNX.4.61.0705220826110.4452@yvahk01.tjqt.qr>
	<20070522064613.GA27619@oknodo.bof.de>
Mime-Version: 1.0
Content-Type: text/plain; format=flowed; charset=ISO-8859-1
Content-Transfer-Encoding: 7BIT
Cc: netfilter-devel@lists.netfilter.org,
	Jan Engelhardt <jengelh@linux01.gwdg.de>,
	Carl-Daniel Hailfinger <c-d.hailfinger.devel.2006@gmx.net>
To: Patrick Schaaf <bof@bof.de>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
In-reply-to: <20070522064613.GA27619@oknodo.bof.de>
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

Patrick Schaaf wrote:

>...
>Anyway, regarding the original request, I don't think it is sensible to
>expect from netfilter developers to invent such a library, especially
>when the scope is desired to be abstracting from netfilter.
>

At this point in time, I was looking for people who might be interested
in helping design such an API.  In the end, what I'm hoping for is to
have a common API delivered as part of OpenSolaris as well as both
FreeBSD and NetBSD.  Given that it's still being drafted, I'm opening
the door and asking if there is anyone from Linux who's interested in
participating.  I should point out that I'm not interested in requesting
anyone here write code that isn't [L]GPL'd.

...

> Bringing back that
>analogy, it would be a task for the developers of a vastly successful
>high level firewall application running on all kinds of basic firewalls.
>  
>

Why should they have to do that?  That requires:
1) they understand the API of every firewall they support
2) to track the API changes of every firewall they support
3) recompile/redeliver their software every time that API changes

None of those 3 options are what I would call palatable.

Imagine if everytime a new glibc was delivered you needed to
recompile all of your programs, from ls all the way through to the
X server, or...

>Personally, I think that it would be bound to fail anyway, because
>different basic firewall structures are very different in what and
>how they operate. But that's just the fast opinion of somebody who
>has neither need nor vision for userlevel firewall applications
>and systems other than Linux/netfilter.
>  
>

The point of this is to understand that the low level/basic
structures of firewall software are quite different but the
"end goal" is the same.

For example, all firewalls let you say "block traffic between
X & Y", it is just how that is done which is different.  The
idea is to capture the high level goals (c.f. "block ..")
into an API that applications can use.

Darren
