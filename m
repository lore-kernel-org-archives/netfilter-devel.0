From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH 3/4] netfilter: bridge: re-order check_hbh_len()
Date: Fri, 12 Jun 2015 14:26:04 +0200
Message-ID: <20150612122604.GF13530@salvia>
References: <1432992578-4161-1-git-send-email-bernhard.thaler@wvnet.at>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: kadlec@blackhole.kfki.hu, netfilter-devel@vger.kernel.org,
	fw@strlen.de
To: Bernhard Thaler <bernhard.thaler@wvnet.at>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:55739 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753542AbbFLMUv (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 12 Jun 2015 08:20:51 -0400
Content-Disposition: inline
In-Reply-To: <1432992578-4161-1-git-send-email-bernhard.thaler@wvnet.at>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Sat, May 30, 2015 at 03:29:38PM +0200, Bernhard Thaler wrote:
> Prepare check_hbh_len() to be called from newly introduced
> br_validate_ipv6() in next commit.

Also applied, thanks.

