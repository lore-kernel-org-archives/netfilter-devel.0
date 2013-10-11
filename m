From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH 2/2] netfilter: ipt_ULOG: fix info leaks
Date: Fri, 11 Oct 2013 10:54:55 +0200
Message-ID: <20131011085455.GB4124@localhost>
References: <1380571508-15486-1-git-send-email-minipli@googlemail.com>
 <1380571508-15486-3-git-send-email-minipli@googlemail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org, Patrick McHardy <kaber@trash.net>,
	Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
To: Mathias Krause <minipli@googlemail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:49358 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753170Ab3JKIzA (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 11 Oct 2013 04:55:00 -0400
Content-Disposition: inline
In-Reply-To: <1380571508-15486-3-git-send-email-minipli@googlemail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Mon, Sep 30, 2013 at 10:05:08PM +0200, Mathias Krause wrote:
> The ulog messages leak heap bytes by the means of padding bytes and
> incompletely filled string arrays. Fix those by memset(0)'ing the
> whole struct before filling it.

Applied, thanks.
