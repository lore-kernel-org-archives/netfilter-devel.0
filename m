From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [ULOGD PATCH 01/14] Fix SQL reconnection algorithm.
Date: Sat, 05 Apr 2008 15:55:30 +0200
Message-ID: <47F784D2.4020905@netfilter.org>
References: <1206289522679-git-send-email-eric@inl.fr> <12062895222895-git-send-email-eric@inl.fr>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@vger.kernel.org
To: Eric Leblond <eric@inl.fr>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:60007 "EHLO us.es"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751830AbYDENzp (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Sat, 5 Apr 2008 09:55:45 -0400
In-Reply-To: <12062895222895-git-send-email-eric@inl.fr>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Eric Leblond wrote:
> This patch fixes a problem in SQL reconnection algorithm which is managed in
> the db.c file for PgSQL and MySQL. In case of problem during request execution
> a new connection to the database was immediatly started without closing the
> previous one. The consequence was to block the database by having too much
> simultaneous open connections.
> 
> This patch fixes the problem by disconnectinng from the database after a
> request failure and trying to reconnect after a delay which is by default
> of 2 secondes. This delay can be customized via the reconnect configuration
> variable in the database configuration section.

Applied. Thanks Eric. BTW, an early impression, would it be possible to
handle db reconnections using the timer infrastructure?

-- 
"Los honestos son inadaptados sociales" -- Les Luthiers
