From: Andreas Kotes <count-linux@flatline.de>
Subject: conntrack-tools not working with DESTDIR
Date: Tue, 25 Sep 2007 18:54:22 +0200
Message-ID: <20070925165422.GB5852@slop.flatline.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from flatline.de ([80.190.243.144]:42488 "EHLO mail.flatline.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750879AbXIYRDE (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 25 Sep 2007 13:03:04 -0400
Received: from shell.priv.flatline.de ([172.16.123.7] helo=slop.flatline.de)
	by mail.flatline.de with smtp (Exim 4.67)
	(envelope-from <count-linux@flatline.de>)
	id 1IaDfy-0004WJ-CN
	for netfilter-devel@vger.kernel.org; Tue, 25 Sep 2007 18:54:47 +0200
Content-Disposition: inline
Sender: netfilter-devel-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

Hello,

when using DESTDIR=/home/user/somewhere (the standard to set a different
sysroot - see http://www.gnu.org/prep/standards/html_node/DESTDIR.html)
with

libnfnetlink 0.0.30
libnetfilter_conntrack 0.0.81
conntrack-tools 0.9.5

and configure with --prefix=/ I get a libtool-problem:

libtool: link: cannot find the library `//lib/libnfnetlink.la' or
unhandled argument `//lib/libnfnetlink.la'

.. this seems to have changed with 0.9.4, as 0.9.3 builds without a
problem this way. building without DESTDIR and with
--prefix=/home/user/somewhere works as well, but is not the way this
ought to be done ...

btw: CFLAGS and LDFLAGS point to $DESTDIR/include and $DESTDIR/lib
respectively - albeit using
[LIBNFNETLINK|LIBNETFILTER_CONNTRACK]_[CFLAGS|LIBS] gives basically the
same result ..

Can someone look into this and fix it, please?

Thank you!

   Andreas

P.S: I got no idea why the formatting is this horribly in this mail. hm.

-- 
flatline IT services - Andreas Kotes - Tailored solutions for your IT needs
