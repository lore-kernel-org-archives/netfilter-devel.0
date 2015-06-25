From: Geert Uytterhoeven <geert@linux-m68k.org>
Subject: Re: net/netfilter/ipset: work around gcc-4.4.4 initializer bug (was:
 Re: linux-next: Tree for Jun 25)
Date: Thu, 25 Jun 2015 10:46:56 +0200
Message-ID: <CAMuHMdUvC-Y0eNQ8DEm=ZG1xm99YkfFovTw1VzSTd295SJxjLA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: Linux-Next <linux-next@vger.kernel.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	Stephen Rothwell <sfr@canb.auug.org.au>,
	netfilter-devel@vger.kernel.org
To: Andrew Morton <akpm@linux-foundation.org>,
	"David S. Miller" <davem@davemloft.net>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

On Thu, Jun 25, 2015 at 10:17 AM, Stephen Rothwell <sfr@canb.auug.org.au> wrote:
> Changes since 20150624:
>
> The net-next tree lost its build failure.

> $ git checkout -b akpm remotes/origin/akpm/master
> Applying: net/netfilter/ipset: work around gcc-4.4.4 initializer bug

I can confirm this patch (which I couldn't find on any mailing list) is also
needed for gcc 4.1.2.

Note that the issue is in mainline since last night.

Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
