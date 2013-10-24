From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: netfilter: xt_socket: add XT_SOCKET_NOWILDCARD flag causes
 behavioural change in userspace?
Date: Thu, 24 Oct 2013 11:52:12 +0200
Message-ID: <20131024095212.GA4422@localhost>
References: <52667EBC.5010709@ee.oulu.fi>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: edumazet@google.com, netfilter-devel@vger.kernel.org
To: Pekka =?iso-8859-1?Q?Pietik=E4inen?= <pp@ee.oulu.fi>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:34181 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754101Ab3JXJwV (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 24 Oct 2013 05:52:21 -0400
Content-Disposition: inline
In-Reply-To: <52667EBC.5010709@ee.oulu.fi>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hi Pekka,

On Tue, Oct 22, 2013 at 04:33:48PM +0300, Pekka Pietik=E4inen wrote:
> After a kernel update to 3.11 (feat. commit
> 681f130f39e10087475383e6771b9366e26bab0c) my "generate fake tcp
> connections from random ip addresses" app broke.

Did you give a try to revert it and things were working back fine? I
think the root cause for this behaviour change is not in that patch.
--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
