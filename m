From: Matthias Andree <matthias.andree@gmx.de>
Subject: Re: [2.6] Nonsense-messages from iptables + co.
Date: Fri, 14 Nov 2003 21:01:19 +0100
Sender: linux-kernel-owner@vger.kernel.org
Message-ID: <20031114200119.GA27789@merlin.emma.line.org>
References: <20031114132054.GA646@merlin.emma.line.org> <20031114151004.GE2395@obroa-skai.de.gnumonks.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Harald Welte <laforge@gnumonks.org>,
	Netfilter Development Mailinglist
	<netfilter-devel@lists.netfilter.org>
Return-path: <linux-kernel-owner+linux-kernel=40quimby.gnus.org@vger.kernel.org>
To: Linux-Kernel mailing list <linux-kernel@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20031114151004.GE2395@obroa-skai.de.gnumonks.org>
List-Id: netfilter-devel.vger.kernel.org

On Fri, 14 Nov 2003, Harald Welte wrote:

> On Fri, Nov 14, 2003 at 02:20:54PM +0100, Matthias Andree wrote:
> > Who the heck added these unhelpful
> > 
> > "ipt_hook: happy cracking."
> > 
> > messages to iptables/mangling/connection tracking code? There are three
> > instances.
> 
> I guess it was Rusty.  The idea message is a funny way of telling you
> that you are sending incomplete ip headers.

Am I? what's with the *_limit() function called before the printk?

> Something that is not
> likely to occur unless you are trying to send corrupt packets via raw ip
> sockets...

Not at the times when these occurred.

> > If the kernel has got something to say, it should be clear what the
> > kernel means, say, maximum <whatever> rate exceeded or something, not
> > such junk like this.
> 
> There are people who do actually have fun developing linux code.  And
> Rusty has a peculiar sense of humor... for further reference see the
> comments like 'furniture shopping' throughout the netfilter/iptables
> source code.  I sometimes wish I had the same humor like he has.
> 
> Yes, I know.  Stuff like this is not exactly useful in error messages.
> I'd say it's one of the few remainders of the 2.3.x early development
> time.  Like the "Rusty's brain broke" messages that have recently been
> removed/replaced.
> 
> btw: *nix has a long history of funny error messages, like 'printer on
> fire' or others.

I don't mind having fun developing or placing funny error messages, and
I hadn't taken that as "serious problem" message but rather as "someone
in the wild tries to cheat on us" but how do I know?  I'm a bit more
cautious with network related stuff, particular with packet filtering
and things like that. I'd suggest that the fun be put in the comments,
or that funny error messages are accompanied by a plain text explanation
in parentheses, or there is at least a "dictionary" of error messages in
the comments of the *.c files that a geek could find...
