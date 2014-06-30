From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: libreadline not found by configure [was Re: [ANNOUNCE] nftables 0.3
Date: Mon, 30 Jun 2014 13:22:19 +0200
Message-ID: <20140630112219.GA8205@localhost>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Robby Workman <robby@rlworkman.net>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:41987 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750913AbaF3LWn (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 30 Jun 2014 07:22:43 -0400
Content-Disposition: inline
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

release]
Reply-To: 
In-Reply-To: <20140627124236.793bc975.robby@rlworkman.net>

Hi Robby,

On Fri, Jun 27, 2014 at 12:42:36PM -0500, Robby Workman wrote:
> Hi Pablo,
> 
> I get this error after configure:
> 
>   checking for readline in -lreadline... no
>   configure: error: No suitable version of libreadline found
> 
> It appears that you're depending on distro-specific enhancements to
> readline, specifically that Fedora explicitly links libtinfo, Arch
> explicitly links ncurses, etcetera, while according to upstream
> readline, this should not occur -- from INSTALL file in readline:
> 
> The readline `configure' recognizes a single `--with-PACKAGE' option:
> 
> `--with-curses'
>     This tells readline that it can find the termcap library functions
>     (tgetent, et al.) in the curses library, rather than a separate
>     termcap library.  Readline uses the termcap functions, but does not
>     link with the termcap or curses library itself, allowing applications
>     which link with readline the to choose an appropriate library.
>     This option tells readline to link the example programs with the
>     curses library rather than libtermcap.
> 
> I think this will be useful:
> https://www.gnu.org/software/autoconf-archive/ax_lib_readline.html

Thanks for the detailed report.

Would you send us a patch that you can test in your fedora setup? I
would appreciate it. Thanks.
