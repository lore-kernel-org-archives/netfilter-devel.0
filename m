From: Robby Workman <robby@rlworkman.net>
Subject: Re: [ANNOUNCE] nftables 0.3 release
Date: Fri, 27 Jun 2014 12:42:36 -0500
Message-ID: <20140627124236.793bc975.robby@rlworkman.net>
References: <20140625155210.GA31550@localhost>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@vger.kernel.org
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from harrier.slackbuilds.org ([207.223.116.211]:41302 "EHLO
	harrier.slackbuilds.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752293AbaF0RuX (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 27 Jun 2014 13:50:23 -0400
In-Reply-To: <20140625155210.GA31550@localhost>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Wed, 25 Jun 2014 17:52:10 +0200
Pablo Neira Ayuso <pablo@netfilter.org> wrote:

> The Netfilter project presents:
> 
>         nftables 0.3
> 
> This release contains bug fixes, syntax cleanups, new features,
> support for all new features contained in the recent 3.15 kernel
> release.


Hi Pablo,

I get this error after configure:

  checking for readline in -lreadline... no
  configure: error: No suitable version of libreadline found

It appears that you're depending on distro-specific enhancements to
readline, specifically that Fedora explicitly links libtinfo, Arch
explicitly links ncurses, etcetera, while according to upstream
readline, this should not occur -- from INSTALL file in readline:

The readline `configure' recognizes a single `--with-PACKAGE' option:

`--with-curses'
    This tells readline that it can find the termcap library functions
    (tgetent, et al.) in the curses library, rather than a separate
    termcap library.  Readline uses the termcap functions, but does not
    link with the termcap or curses library itself, allowing applications
    which link with readline the to choose an appropriate library.
    This option tells readline to link the example programs with the
    curses library rather than libtermcap.

I think this will be useful:
https://www.gnu.org/software/autoconf-archive/ax_lib_readline.html

-RW
