From: Patrick McHardy <kaber@trash.net>
Subject: src: add redirect support
Date: Fri, 12 Dec 2014 15:29:29 +0000
Message-ID: <20141212152929.GJ8013@acer.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: pablo@netfilter.org, netfilter-devel@vger.kernel.org
To: arturo.borrero.glez@gmail.com
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:62988 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030661AbaLLP3f (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 12 Dec 2014 10:29:35 -0500
Content-Disposition: inline
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Looking at the redir bug report on netfilter-devel, I noticed some
odd syntax for the redir statement.

The changelog states:

  The syntax is:
        
  % nft add rule nat prerouting redirect [port] [nat_flags]

The actual syntax though is:

redir_stmt_arg          :       COLON   expr

What do we need that colon for? redirect by definition redirects to
the local host, the argument is always only a port expression.
