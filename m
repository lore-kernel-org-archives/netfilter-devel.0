From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [nft PATCH 4/4] tests: regression: add xt compat tests
Date: Thu, 9 Apr 2015 17:46:43 +0200
Message-ID: <20150409154643.GA5738@salvia>
References: <20150408174818.28553.96128.stgit@nfdev2.cica.es>
 <20150408174834.28553.53067.stgit@nfdev2.cica.es>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org, kaber@trash.net
To: Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:35027 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755331AbbDIPmg (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 9 Apr 2015 11:42:36 -0400
Content-Disposition: inline
In-Reply-To: <20150408174834.28553.53067.stgit@nfdev2.cica.es>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Wed, Apr 08, 2015 at 07:48:34PM +0200, Arturo Borrero Gonzalez wrote:
> This patch adds several regression test for the xt compat stuff.
> 
> Note the current output is:
>  ip/xt.t: 25 unit tests, 0 error, 0 warning
>  ip6/xt.t: 25 unit tests, 0 error, 0 warning
>  bridge/xt.t: 26 unit tests, 0 error, 0 warning
>  arp/xt.t: 12 unit tests, 0 error, 0 warning

arp/xt.t is missing in the patchset, please resend this.

> 
> Signed-off-by: Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>
> ---
>  tests/regression/bridge/xt.t |   45 ++++++++++++++++++++++++++++++++++++++++++
>  tests/regression/ip/xt.t     |   45 ++++++++++++++++++++++++++++++++++++++++++
>  tests/regression/ip6/xt.t    |   45 ++++++++++++++++++++++++++++++++++++++++++
>  3 files changed, 135 insertions(+)
>  create mode 100644 tests/regression/bridge/xt.t
>  create mode 100644 tests/regression/ip/xt.t
>  create mode 100644 tests/regression/ip6/xt.t
