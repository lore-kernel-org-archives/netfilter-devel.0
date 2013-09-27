From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH v2] iptables: extensions/GNUMakefile.in use CPPFLAGS
Date: Fri, 27 Sep 2013 16:44:00 +0200
Message-ID: <20130927144400.GA14954@localhost>
References: <alpine.LSU.2.10.9.1308200149450.1576@nerf07.vanv.qr>
 <1377189887-12537-1-git-send-email-ljlane@debian.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: "Laurence J. Lane" <ljlane@debian.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:49403 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753166Ab3I0OoJ (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 27 Sep 2013 10:44:09 -0400
Content-Disposition: inline
In-Reply-To: <1377189887-12537-1-git-send-email-ljlane@debian.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Thu, Aug 22, 2013 at 12:44:47PM -0400, Laurence J. Lane wrote:
> "All other Makefiles add CPPFLAGS to ${COMPILE} (automake), but GNUmakefile.in
>  doesn't set it."
> 
> http://bugs.debian.org/665286

Applied, thanks.
