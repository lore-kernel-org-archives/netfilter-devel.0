From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH 2/3] libiptc: add symbol maps to libiptc
Date: Sat, 31 Dec 2011 17:36:10 +0100
Message-ID: <20111231163610.GD17114@1984>
References: <1325209595-23244-1-git-send-email-jengelh@medozas.de>
 <1325209595-23244-3-git-send-email-jengelh@medozas.de>
 <20111230114859.GA12204@1984>
 <alpine.LNX.2.01.1112301422230.8225@frira.zrqbmnf.qr>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Jan Engelhardt <jengelh@medozas.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:57578 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753179Ab1LaQgO (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Sat, 31 Dec 2011 11:36:14 -0500
Content-Disposition: inline
In-Reply-To: <alpine.LNX.2.01.1112301422230.8225@frira.zrqbmnf.qr>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Fri, Dec 30, 2011 at 02:49:49PM +0100, Jan Engelhardt wrote:
> 
> On Friday 2011-12-30 12:48, Pablo Neira Ayuso wrote:
> >On Fri, Dec 30, 2011 at 02:46:33AM +0100, Jan Engelhardt wrote:
> >> This is mostly cosmetic, as using a libxtables.so with a too old
> >> libiptc should now say something about "version symbol LIBIP4TC_1.4.13
> >> required" (or so) instead of just "unknown symbol: iptc_ops".
> >
> >I think this can be done much simpler. You can with the current symbol
> >list by the iptables version that includes the first symbol map.
> >[...]
> >Old iptables binaries will not benefit for such fine definition that
> >you're proposing.
> 
> I know, though it seemed like having it differentiated out is an
> interesting piece of documentation of history :)

I prefer to start from scratch not to confuse anyone. Add some note
stating something like: "prior to version 1.4.x, there was no symbol
mapping".

> >Moreover, I remember to have read that once you start using symbol
> >maps, you only bump the revision field of the c:r:a library version
> >numbers.
> >I looked into this time ago (and I'm telling you by heart), so please
> >correct me if I'm wrong.
> 
> This is a two-part consideration.
>
> 1.
> I do not see a big practical value in the R field and therefore do
> not care to change it for my projects. It perhaps tells you that
> something changed, but distro tools will of course clean up
> .so.12.3.4 if you install a new libfoo when it ships .so.12.3.5,
> and all the symlinks point to .so.12.3.5 then as well.
> 
> Consider so.12.3.5 misbehaving. Changing the .so.12/.so.12.3 symlink
> has no effect, since ldconfig will usually pick the newest version,
> which is still so.12.3.5. Therefore, people will do a distro-assisted
> downgrade or just remove 12.3.5 from their libdir rather than trying
> to fiddle export LD_PRELOAD=libfoo.so.12.3.4 into their environment.
> 
> So I find R rather useless. libc.so also does not care about it
> either :)

Not very useful, but for historical reason, it can be.

> >Moreover, I remember to have read that once you start using symbol
> >maps, you only bump the revision field of the c:r:a library version
> >numbers.
> 
> 2.
> Symbol maps are a means to have more than one {function
> implementation with the same name} to coexist, thereby making it
> possible to avoid having to delete an ABI revision that would
> otherwise be necessary, provided that you can keep the ABI for all
> existing symbols.
> 
> But one still needs to do C::A housekeeping, because deletion of old
> ABIs - if you do get around to do it someday - still demands
> adjusting C,A.

Indeed, make sense.
