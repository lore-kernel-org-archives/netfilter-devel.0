From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH 2/2] ulogd: Implement PID file writing
Date: Sun, 12 May 2013 02:48:52 +0200
Message-ID: <20130512004852.GA11205@localhost>
References: <1368291713-40132-1-git-send-email-bootc@bootc.net>
 <1368291713-40132-3-git-send-email-bootc@bootc.net>
 <20130511192150.GA10646@localhost>
 <518EA9B3.8050606@bootc.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org, Eric Leblond <eric@regit.org>
To: Chris Boot <bootc@bootc.net>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:41861 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752432Ab3ELAs5 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Sat, 11 May 2013 20:48:57 -0400
Content-Disposition: inline
In-Reply-To: <518EA9B3.8050606@bootc.net>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Sat, May 11, 2013 at 09:27:31PM +0100, Chris Boot wrote:
[...]
> Hi Pablo,
> 
> I'd argue exactly the opposite point: that when you want multiple
> instances a PID file can help you work out which is which.

That new option may break existing setups with multiple instances.

> My patch adds an option that takes a filename argument, so two
> instances can write to two different PID files; grepping ps won't
> easily tell you which instance is the correct one (without resorting
> to grepping for command-line arguments).

You can use pidof. Many other debian init scripts use it to obtain the
process PID.

Regards.
