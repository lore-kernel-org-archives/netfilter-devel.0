From: Marcelo Tosatti <marcelo@conectiva.com.br>
Subject: Re: [2.4 patch] netfilter Configure.help cleanup
Date: Wed, 2 Jul 2003 16:25:05 -0300 (BRT)
Sender: linux-kernel-owner@vger.kernel.org
Message-ID: <Pine.LNX.4.55L.0307021624510.17865@freak.distro.conectiva>
References: <20030630051516.AAEC12C220@lists.samba.org>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Adrian Bunk <bunk@fs.tum.de>, netfilter-devel@lists.netfilter.org,
	linux-kernel@vger.kernel.org, linux-net@vger.kernel.org
Return-path: <linux-kernel-owner+linux-kernel=40quimby.gnus.org@vger.kernel.org>
To: Rusty Russell <rusty@rustcorp.com.au>
In-Reply-To: <20030630051516.AAEC12C220@lists.samba.org>
List-Id: netfilter-devel.vger.kernel.org


Make that go through davem, please.

On Mon, 30 Jun 2003, Rusty Russell wrote:

> In message <20030627233357.GN24661@fs.tum.de> you write:
> > - remove useless short descriptions above CONFIG_*
>
> > -Connection tracking (required for masq/NAT)
> >  CONFIG_IP_NF_CONNTRACK
>
> Can you really do this?  A quick skim didn't find anyone else skipping
> this line...
>
> Thanks,
> Rusty.
> --
>   Anyone who quotes me in their sig is an idiot. -- Rusty Russell.
>
