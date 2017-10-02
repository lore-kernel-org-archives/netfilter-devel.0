From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [ulogd2 PATCH] ulogd2: add new config option: load_all_plugins
Date: Mon, 2 Oct 2017 12:44:29 +0200
Message-ID: <20171002104429.GB2832@salvia>
References: <150633836700.6370.2675458398740561976.stgit@nfdev2.cica.es>
 <20170929113949.GA28566@salvia>
 <CAOkSjBjjzDA8HVYAYuDutg_+Miz7s=5PExY6zsOj8h+kkGjNxA@mail.gmail.com>
 <CAOkSjBi1gUQjH5vGtCC4eRE36-PcWdN6r_NL7--PoNQv1VhK0g@mail.gmail.com>
 <20170930101203.GB2078@salvia>
 <CAOkSjBh0gU4r7mxLVnTRCzQdnSydebJsdg-+-Sym8seL8EXB+Q@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Netfilter Development Mailing list
        <netfilter-devel@vger.kernel.org>
To: Arturo Borrero Gonzalez <arturo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from [213.95.27.120] ([213.95.27.120]:56384 "EHLO
        ganesha.gnumonks.org" rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org
        with ESMTP id S1751160AbdJBKpq (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 2 Oct 2017 06:45:46 -0400
Content-Disposition: inline
In-Reply-To: <CAOkSjBh0gU4r7mxLVnTRCzQdnSydebJsdg-+-Sym8seL8EXB+Q@mail.gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Sat, Sep 30, 2017 at 12:43:36PM +0200, Arturo Borrero Gonzalez wrote:
> On 30 September 2017 at 12:12, Pablo Neira Ayuso <pablo@netfilter.org> wrote:
> > On Sat, Sep 30, 2017 at 11:48:11AM +0200, Arturo Borrero Gonzalez wrote:
> >> On 30 September 2017 at 11:43, Arturo Borrero Gonzalez
> >> <arturo@netfilter.org> wrote:
> >> >
> >> > Ok, but how could we avoid putting there a complex, arch-dependant path?
> >>
> >> i.e, in Debian this means a path like:
> >>
> >> /usr/lib/mips64el-linux-gnuabi64/ulogd/ulogd_filter_IFINDEX.so
> >>
> >> so user should use /usr/lib/mips64el-linux-gnuabi64/ which is very ugly.
> >> If the config file is copied to a machine with a different arch, amd64
> >> for example, then path should be modified to:
> >>
> >> /usr/lib/x86_64-linux-gnu/ulogd/
> >>
> >> Complex and ugly. We should avoid that. I think we should offer a
> >> default at build/configure time.
> >
> > I think @pkglibdir@ in ulogd.conf.in will set this to the
> > corresponding arch-dependent folder at configure/build time, right?
> 
> The point is to don't have the ugly string in the config file.
> Transparent to the user. Simplify the config file.

OK.

What if we default to loading all plugins if user specifies no
"plugin=" at all in the configuration file?

No worries in terms of breaking backward compatibility, so far ulogd2
just bails out if no plugin is available.

That would simplify the configuration file as you're searching for.
