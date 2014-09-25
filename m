From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCHv2 libmnl] socket: creating a struct mnl_socket from a
 pre-existing socket
Date: Thu, 25 Sep 2014 12:49:18 +0200
Message-ID: <20140925104918.GA4920@salvia>
References: <20140920060536.GA15209@gmail.com>
 <20140925003327.GB20985@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: The netfilter developer mailinglist
	<netfilter-devel@vger.kernel.org>, Florian Westphal <fw@strlen.de>
To: Ken-ichirou MATSUZAWA <chamaken@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:44171 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751237AbaIYKsJ (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 25 Sep 2014 06:48:09 -0400
Content-Disposition: inline
In-Reply-To: <20140925003327.GB20985@gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Thu, Sep 25, 2014 at 09:33:27AM +0900, Ken-ichirou MATSUZAWA wrote:
> This patch defines a new function mnl_socket_fdopen() which creates a
> struct mnl_socket object from a pre-existing socket like obtained from
> other process, different domain/type from the same prodess.

Applied, thanks.

