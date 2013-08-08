From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH] iptables: correctly reference generated file
Date: Thu, 8 Aug 2013 12:30:09 +0200
Message-ID: <20130808102850.GA21639@localhost>
References: <1375862956-22870-1-git-send-email-ljaenicke@innominate.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Lutz Jaenicke <ljaenicke@innominate.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:48941 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S964991Ab3HHKaS (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 8 Aug 2013 06:30:18 -0400
Content-Disposition: inline
In-Reply-To: <1375862956-22870-1-git-send-email-ljaenicke@innominate.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Wed, Aug 07, 2013 at 10:09:16AM +0200, Lutz Jaenicke wrote:
> Since
>   iptables: use autoconf to process .in man pages
> the file "iptables-extensions.8.tmpl" is generated from
> "iptables-extensions.8.tmpl.in" and is consequently no
> longer found in ${srcdir} but in the build directory.
> (Becomes visible with builddir != srcdir)

Applied, thanks Lutz.
