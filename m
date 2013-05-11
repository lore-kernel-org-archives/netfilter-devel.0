From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH 09/11] db: add ring buffer for DB query
Date: Sat, 11 May 2013 21:29:22 +0200
Message-ID: <20130511192922.GA10791@localhost>
References: <1368168538-29780-1-git-send-email-eric@regit.org>
 <1368168538-29780-10-git-send-email-eric@regit.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Eric Leblond <eric@regit.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:58758 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753802Ab3EKT33 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Sat, 11 May 2013 15:29:29 -0400
Content-Disposition: inline
In-Reply-To: <1368168538-29780-10-git-send-email-eric@regit.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hi Eric,

On Fri, May 10, 2013 at 08:48:56AM +0200, Eric Leblond wrote:
> This patch adds an optional ring buffer option which modify
> the way database queries are made. The main thread is only handling
> kernel message reading and query formatting. The SQL request is made
> in a separate dedicated thread.
> The idea is to try to avoid buffer overrun by minimizing the time
> requested to treat kernel message. Doing synchronous SQL request, as
> it was made before was causing a delay which could cause some messages
> to be lost in case of burst from kernel side.

Would be feasible to make asynchronous SQL requests instead, so you
can skip the use of pthread?

Regards.
