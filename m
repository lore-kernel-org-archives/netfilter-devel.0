From: Allen Francom <aef@prismnet.com>
Subject: Re: Activating IPTables rules with external files (containing flag
 va lues).
Date: Mon, 16 Feb 2004 10:33:38 -0600 (CST)
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <20040216103033.I90371@tempest.prismnet.com>
References: <019BE2AC0F67D51198C000508B69393F0C1DDCE0@esf-exchange1a.brevard.k12.fl.us>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: "'netfilter-devel@lists.netfilter.org'" <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: "Ziemba, Jason@Viera" <jason.ziemba@brevard.k12.fl.us>
In-Reply-To: <019BE2AC0F67D51198C000508B69393F0C1DDCE0@esf-exchange1a.brevard.k12.fl.us>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org




Hi Jason,

There is documentation that comes with the Linux kernel,
to at least some degree on this.

Most likely what you are referring to are some settings
you can change in the /proc file system.

Files under /proc are actually little windows into
the live running kernel.

Some of these deal with networking parameters.

There are quite a few.  Mostly things work well by
default, but there are a number of things you might
want to change.

I do not know of a single comprehensive resource
on this topic and I would also like to see a pointer
to something on it.

Good question.

Sinc,
-AEF


On Mon, 16 Feb 2004, Ziemba, Jason@Viera wrote:
> A while back I located an article that described placing a 1 or 0 (or other
> flag value) into a file and then building IPTables rules that activated a
> specific rule based on the value contained within this file.
>
> I, of course, didn't bookmark that article (or print it out).
>
> Has anyone on this list came across a similar article (or done this
> themselves)?
> If so, could you please point me in the right direction to implement a
> configuration of this nature.
