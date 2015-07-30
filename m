From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH 1/2 nf] netfilter: bridge: do not initialize statics to 0
 or NULL
Date: Thu, 30 Jul 2015 13:59:37 +0200
Message-ID: <20150730115937.GA7116@salvia>
References: <1438229172-25925-1-git-send-email-bernhard.thaler@wvnet.at>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: kadlec@blackhole.kfki.hu, netfilter-devel@vger.kernel.org
To: Bernhard Thaler <bernhard.thaler@wvnet.at>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:55055 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750995AbbG3Lxo (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 30 Jul 2015 07:53:44 -0400
Content-Disposition: inline
In-Reply-To: <1438229172-25925-1-git-send-email-bernhard.thaler@wvnet.at>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Thu, Jul 30, 2015 at 06:06:12AM +0200, Bernhard Thaler wrote:
> Fix checkpatch.pl "ERROR: do not initialise statics to 0 or NULL" for
> all statics explicitly initialized to 0.

Applied to nf-next, thanks for following up on this.

