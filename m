From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH 2/2] ulogd: Implement PID file writing
Date: Sat, 11 May 2013 21:21:50 +0200
Message-ID: <20130511192150.GA10646@localhost>
References: <1368291713-40132-1-git-send-email-bootc@bootc.net>
 <1368291713-40132-3-git-send-email-bootc@bootc.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org, Eric Leblond <eric@regit.org>
To: Chris Boot <bootc@bootc.net>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:58475 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753117Ab3EKTV4 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Sat, 11 May 2013 15:21:56 -0400
Content-Disposition: inline
In-Reply-To: <1368291713-40132-3-git-send-email-bootc@bootc.net>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hi Chris,

On Sat, May 11, 2013 at 06:01:53PM +0100, Chris Boot wrote:
> The deamon currently does not have the ability to write a PID file to track its
> process ID. This is very useful to an init script and to ensure there is only
> one running instance. This patch implements this functionality.

This belongs to the scope of the script and it doesn't seem to be
useful for the internal operation of ulogd2.

You can generate that PID file with something like:

ps -ef | grep ulogd$ | awk '{ printf $2 }'

And someone may want to have more than one instance of ulogd2, that's
perfectly possible. Actually that's a good idea if you need to log
both NFLOG and NFCT at the same time and you're running ulogd2 in a
multi-core system. That will help to avoid hitting Netlink overrun
errors.

Regards.
