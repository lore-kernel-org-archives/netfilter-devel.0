From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH v2] Fix overquota output result
Date: Thu, 31 Jul 2014 20:46:43 +0200
Message-ID: <20140731184643.GA7770@salvia>
References: <20140730170115.GA6364@salvia>
 <1406812353-2930-1-git-send-email-a.perevalov@samsung.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: alexey.perevalov@hotmail.com, mathieu.poirier@linaro.org,
	netfilter-devel@vger.kernel.org, kyungmin.park@samsung.com,
	hs81.go@samsung.com
To: Alexey Perevalov <a.perevalov@samsung.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:60982 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750952AbaGaSqo (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 31 Jul 2014 14:46:44 -0400
Content-Disposition: inline
In-Reply-To: <1406812353-2930-1-git-send-email-a.perevalov@samsung.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Thu, Jul 31, 2014 at 05:12:33PM +0400, Alexey Perevalov wrote:
> Current implementation shows "packet" for none byte quota type.
> It means "packet" was used for overquota counter as well and it
> wasn't so informative.
> 
> This commmit adds additional column - overquota with yes/no value.

Applied, thanks.
