From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH iptables] libxt_CT: add support for flextuples
Date: Mon, 4 May 2015 12:38:55 +0200
Message-ID: <20150504103855.GA12211@salvia>
References: <92ac128c5849a4e3da0287e37a00ba47e06aecee.1430733890.git.daniel@iogearbox.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org, Thomas Graf <tgraf@suug.ch>,
	Madhu Challa <challa@noironetworks.com>
To: Daniel Borkmann <daniel@iogearbox.net>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:54140 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752003AbbEDKeR (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 4 May 2015 06:34:17 -0400
Content-Disposition: inline
In-Reply-To: <92ac128c5849a4e3da0287e37a00ba47e06aecee.1430733890.git.daniel@iogearbox.net>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Mon, May 04, 2015 at 12:23:56PM +0200, Daniel Borkmann wrote:
> This adds iptables user space part for configuration of flextuples.
> I also noticed that ct_print*() zone reporting had a whitespace bug,
> which is fixed here as well (it needs to be prefixed).

I would really like not to overload the ct template thing with more
features. This started as a simple way to indicate what features are
available in the conntrack. We have discussed already that we should
provide a way to enable conntrack from a rule, this rule should
indicate all of the features that you want to attach to that
conntrack. This requires a /proc switch to disable the existing
behaviour to avoid breaking backward.
