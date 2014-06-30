From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH 1/3] extra: use inet_ntop instead of inet_ntoa
Date: Mon, 30 Jun 2014 11:48:48 +0200
Message-ID: <20140630094848.GA5038@localhost>
References: <1403260021-8732-1-git-send-email-lantw44@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: lantw44@gmail.com
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:39620 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751590AbaF3Jsx (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 30 Jun 2014 05:48:53 -0400
Content-Disposition: inline
In-Reply-To: <1403260021-8732-1-git-send-email-lantw44@gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Fri, Jun 20, 2014 at 06:26:59PM +0800, lantw44@gmail.com wrote:
> From: Ting-Wei Lan <lantw44@gmail.com>
> 
> The result of inet_ntoa() will be overwritten by the next call to
> inet_ntoa(), so using it twice in the same snprintf() call causes
> wrong result.

Applied, thanks Lan.
