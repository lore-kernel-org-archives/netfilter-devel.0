From: Jan Engelhardt <jengelh@inai.de>
Subject: Re: [libnftnl PATCH v2] utils: fix arp family number
Date: Mon, 20 Oct 2014 13:03:58 +0200 (CEST)
Message-ID: <alpine.LSU.2.11.1410201303250.3410@nerf08.vanv.qr>
References: <20141020105022.24332.84204.stgit@nfdev.cica.es>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: netfilter-devel@vger.kernel.org, pablo@netfilter.org
To: Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from ares08.inai.de ([46.4.84.70]:43766 "EHLO ares08.inai.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753486AbaJTLNK (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 20 Oct 2014 07:13:10 -0400
In-Reply-To: <20141020105022.24332.84204.stgit@nfdev.cica.es>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Monday 2014-10-20 12:51, Arturo Borrero Gonzalez wrote:
> 
>+static const char *nft_family_str[NFPROTO_NUMPROTO] = {

static const char *const nft_family_str[NFPROTO_NUMPROTO] = {

If you make it const, might as well make it really const.
