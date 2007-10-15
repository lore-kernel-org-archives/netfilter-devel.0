From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: conntrack-tools not working with DESTDIR
Date: Mon, 15 Oct 2007 17:12:43 +0200
Message-ID: <4713836B.6020306@netfilter.org>
References: <20070925165422.GB5852@slop.flatline.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@vger.kernel.org
To: Andreas Kotes <count-linux@flatline.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:57269 "EHLO us.es"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754517AbXJOPKP (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 15 Oct 2007 11:10:15 -0400
In-Reply-To: <20070925165422.GB5852@slop.flatline.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

Hi Andreas,

Andreas Kotes wrote:
> when using DESTDIR=/home/user/somewhere (the standard to set a different
> sysroot - see http://www.gnu.org/prep/standards/html_node/DESTDIR.html)
> with
> 
> libnfnetlink 0.0.30
> libnetfilter_conntrack 0.0.81
> conntrack-tools 0.9.5
> 
> and configure with --prefix=/ I get a libtool-problem:
> 
> libtool: link: cannot find the library `//lib/libnfnetlink.la' or
> unhandled argument `//lib/libnfnetlink.la'
> 
> .. this seems to have changed with 0.9.4, as 0.9.3 builds without a
> problem this way. building without DESTDIR and with
> --prefix=/home/user/somewhere works as well, but is not the way this
> ought to be done ...
> 
> btw: CFLAGS and LDFLAGS point to $DESTDIR/include and $DESTDIR/lib
> respectively - albeit using
> [LIBNFNETLINK|LIBNETFILTER_CONNTRACK]_[CFLAGS|LIBS] gives basically the
> same result ..
> 
> Can someone look into this and fix it, please?

Strange, this stuff works fine here. I have no clue where the problem is
since those makefiles you mentioned are automatically by automake.

-- 
"Los honestos son inadaptados sociales" -- Les Luthiers
