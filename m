From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: libnetfilter_conntrack autotools updates
Date: Sun, 12 Sep 2010 11:19:17 +0200
Message-ID: <4C8C9B15.5020900@netfilter.org>
References: <1283988763-1577-1-git-send-email-jengelh@medozas.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@vger.kernel.org
To: Jan Engelhardt <jengelh@medozas.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:56292 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750997Ab0ILJTW (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Sun, 12 Sep 2010 05:19:22 -0400
In-Reply-To: <1283988763-1577-1-git-send-email-jengelh@medozas.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On 09/09/10 01:32, Jan Engelhardt wrote:
> Jan Engelhardt (7):
>       build: use autoconf-suggested naming of files
>       build: use modern call syntax for AC_INIT, AM_INIT_AUTOMAKE
>       build: avoid use of deprecated INCLUDES
>       build: use simpler autoreconf in autogen
>       build: run AC_CANONICAL_HOST only
>       build: no need for error message in PKG_CHECK_MODULES
>       Add .gitignore

All applied and pushed to git. Thanks Jan.
