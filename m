From: Martin Josefsson <gandalf@wlug.westbo.se>
Subject: Re: [PATCH] fix correct_cache() in libiptc.c
Date: 05 Jul 2003 19:38:40 +0200
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <1057426720.12433.140.camel@tux.rsn.bth.se>
References: <1057411145.12437.128.camel@tux.rsn.bth.se>
	 <20030705171403.GG7073@sunbeam.de.gnumonks.org>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Cc: Netfilter-devel <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Harald Welte <laforge@netfilter.org>
In-Reply-To: <20030705171403.GG7073@sunbeam.de.gnumonks.org>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

On Sat, 2003-07-05 at 19:14, Harald Welte wrote:

> Yes, as stated on the mailinglist, I even expect it to still be broken a
> bit.
> 
> Expect it to break even more in the future, I'm currently working on an
> almost total reimplementation of the whole library.   The ruleset load
> time ist still unbearable.

I hope you are abandoning the "API" the current library has?
It will break a lot of "third-party" stuff but IMHO it's worth it.

> > I'm not sure if my new limits in the first if-statement are 100%
> > correct. I don't know the code that well, and honestly I never want to,
> > I got enough exposure for several lifetimes last night. The code is
> > absolutely horrible...
> 
> *agreed*.  I vote for presenting Rusty with an award for obfuscated code
> at the workshop ;)  

Yes we really have to. I still can't understand how it's possible to
write code like that. Is there a special school you can go to in order
to learn? :)

> Oh well, I undestand.  This was a mistake.  correct_cache() was first
> written for inserting entries, and the additional code part for rule
> deletion turns out to be broken in several ways.
> 
> I'm going to apply your patch now, and then deal with this issue.

Good, thanks. You'll commit it so people can delete their chains until
your rewrite is finished?
The patch has had some testing by the person who reported the problem
and it seemed to work fine.

> Let's hope this is the last thing I have to do in the old libiptc.

Lets hope this is the last thing _anyone_ has to do in the old libiptc
:) It has to be a violation of human rights to read that code (forced or
not)

-- 
/Martin
