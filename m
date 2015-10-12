From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH libmnl 1/2] socket: introduce mnl_socket_open2()
Date: Mon, 12 Oct 2015 16:48:26 +0200
Message-ID: <20151012144826.GA2375@salvia>
References: <cover.1443815157.git.g.nault@alphalink.fr>
 <8ecf77e50d2acd0b20bdd18038b8e25fd6c86ec0.1443815157.git.g.nault@alphalink.fr>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Guillaume Nault <g.nault@alphalink.fr>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:36009 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751912AbbJLOtn (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 12 Oct 2015 10:49:43 -0400
Content-Disposition: inline
In-Reply-To: <8ecf77e50d2acd0b20bdd18038b8e25fd6c86ec0.1443815157.git.g.nault@alphalink.fr>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Fri, Oct 02, 2015 at 10:12:33PM +0200, Guillaume Nault wrote:
> Define mnl_socket_open2() so that user can pass a set of SOCK_* flags
> at socket creation time.

Applied, thanks for your patience.

Skipping patch 2/2 though.
