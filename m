From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH 1/2] build: remove symlink-only extensions from static
 object list
Date: Wed, 10 Oct 2012 13:29:29 +0200
Message-ID: <20121010112929.GB25237@1984>
References: <1349865314-27640-1-git-send-email-jengelh@inai.de>
 <1349865314-27640-2-git-send-email-jengelh@inai.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Jan Engelhardt <jengelh@inai.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:34971 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751204Ab2JJL3d (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 10 Oct 2012 07:29:33 -0400
Content-Disposition: inline
In-Reply-To: <1349865314-27640-2-git-send-email-jengelh@inai.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Wed, Oct 10, 2012 at 12:35:13PM +0200, Jan Engelhardt wrote:
> $ ./configure --enable-static --disable-shared --enable-ipv4
>   --enable-ipv6 && make
> [...]
> make[3]: *** No rule to make target "libxt_NOTRACK.o", needed by
> "libext.a". Stop.

Already applied this yesterday.
