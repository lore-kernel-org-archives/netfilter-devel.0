From: Eric Dumazet <eric.dumazet@gmail.com>
Subject: Re: TEE broken in 3.6
Date: Wed, 17 Oct 2012 10:34:22 +0200
Message-ID: <1350462862.26103.127.camel@edumazet-glaptop>
References: <20121016211319.3f07a7e3@goldlack.enda.eu>
	 <1350417618.3954.1494.camel@edumazet-glaptop>
	 <20121017094543.2ddb0397@goldlack.enda.eu>
	 <1350460131.26103.68.camel@edumazet-glaptop>  <20121017082323.GA13289@1984>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Cc: Torsten Luettgert <ml-netfilter@enda.eu>,
	netfilter-devel@vger.kernel.org
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-bk0-f46.google.com ([209.85.214.46]:35767 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752108Ab2JQIeZ (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 17 Oct 2012 04:34:25 -0400
Received: by mail-bk0-f46.google.com with SMTP id jk13so3411521bkc.19
        for <netfilter-devel@vger.kernel.org>; Wed, 17 Oct 2012 01:34:24 -0700 (PDT)
In-Reply-To: <20121017082323.GA13289@1984>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Wed, 2012-10-17 at 10:23 +0200, Pablo Neira Ayuso wrote:
> On Wed, Oct 17, 2012 at 09:48:51AM +0200, Eric Dumazet wrote:
> > On Wed, 2012-10-17 at 09:45 +0200, Torsten Luettgert wrote:
> > > On Tue, 16 Oct 2012 22:00:18 +0200
> > > Eric Dumazet <eric.dumazet@gmail.com> wrote:
> > > 
> > > > Could you try latest tree, with the following patch ?
> > > 
> > > Yeah, that works.
> > > 
> > > I'm still a bit sad, though, since I'll have to wait for 3.7 now (no
> > > FLOWI_FLAG_KNOWN_NH in 3.6.*), or is there any solution for those "old"
> > > kernels, too?
> > > 
> > > Regards,
> > > Torsten
> > 
> > I believe its stable material, it will reach 3.6.3 or 3.6.4 dont worry.
> 
> @Eric: I've included the description to the patch (just to save you
> some time to make it yourself).
> 
> Let me know if you're OK with the one attached. If not, feel free to
> pass me yours.

Oops, sorry I missed that, feel free to chose your version or mine !

Thanks


