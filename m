From: Rusty Russell <rusty@rustcorp.com.au>
Subject: Re: PATCH: extra conntrack stats
Date: Thu, 01 May 2003 17:38:42 +1000
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <20030501083011.97D772C053@lists.samba.org>
References: <20030501070408.GD15143@oknodo.bof.de>
Cc: Martin Josefsson <gandalf@wlug.westbo.se>,
	Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>,
	Rolf Fokkens <fokkensr@fokkensr.vertis.nl>,
	Harald Welte <laforge@netfilter.org>,
	Netfilter-devel <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Patrick Schaaf <bof@bof.de>
In-reply-to: Your message of "Thu, 01 May 2003 09:04:08 +0200."
             <20030501070408.GD15143@oknodo.bof.de>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

In message <20030501070408.GD15143@oknodo.bof.de> you write:
> Argh. Are you worried about architectures with 8 byte or less cache lines?

Yes, an embedded chip might value space above all else.  But noone
seems to, so it's probably OK.

> Well, use another field in the skbuff, then. I would recycle nfcache,
> but that's just because nobody ever explained to me what it would be
> used for... :)

It was so you can optimize fastroute: you can cache decisions made by
netfilter hooks.  But it was never actually used.  It could be dropped
in 2.7.

> > (although we'd have to be a
> > little careful to explicitly align a conntrack if we were to use a
> > dummy one for a "notrack" target.
> 
> Unless you are after static initializability, what keeps us from
> allocating such dummies in the same way as we allocate the rest?

As I said, you'd have to be careful.  The logical way would be to
simply declare a static variable, which will still work as long as you
align it.

Cheers!
Rusty.
--
  Anyone who quotes me in their sig is an idiot. -- Rusty Russell.
