From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH 3/3] build: use automake and pkgconfig
Date: Tue, 19 Nov 2013 21:28:15 +0100
Message-ID: <20131119202815.GC4929@localhost>
References: <1382280491-9921-1-git-send-email-jengelh@inai.de>
 <1382280491-9921-4-git-send-email-jengelh@inai.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Jan Engelhardt <jengelh@inai.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:45046 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752914Ab3KSU2U (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 19 Nov 2013 15:28:20 -0500
Content-Disposition: inline
In-Reply-To: <1382280491-9921-4-git-send-email-jengelh@inai.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Sun, Oct 20, 2013 at 04:48:11PM +0200, Jan Engelhardt wrote:
> This now also honors the cflags as obtained from pkgconfig, otherwise
> one gets a compile error if the headers are in a location other than
> /usr/include.

I don't want to consider changing the build system at this stage.
