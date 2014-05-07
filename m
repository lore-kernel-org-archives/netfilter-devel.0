From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH] nfacct: remove unecessary end of line check
Date: Wed, 7 May 2014 15:44:07 +0200
Message-ID: <20140507134407.GA5398@localhost>
References: <1399398511-15854-1-git-send-email-mathieu.poirier@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org, john.stultz@linaro.org
To: mathieu.poirier@linaro.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:33395 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933036AbaEGNoN (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 7 May 2014 09:44:13 -0400
Content-Disposition: inline
In-Reply-To: <1399398511-15854-1-git-send-email-mathieu.poirier@linaro.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Tue, May 06, 2014 at 11:48:31AM -0600, mathieu.poirier@linaro.org wrote:
> From: Mathieu Poirier <mathieu.poirier@linaro.org>
> 
> The EOF character alone should determine the end of input during
> restore operations.

Applied, thanks.

P.S: CC netfilter-devel@ is just fine, netfilter@ is for user
questions.
