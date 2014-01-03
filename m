From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH] netfilter: CT: improve error treatment
Date: Fri, 3 Jan 2014 23:54:01 +0100
Message-ID: <20140103225401.GA18380@localhost>
References: <1388653425-30466-1-git-send-email-eric@regit.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: pablo@netfilter.org, netfilter-devel@vger.kernel.org
To: Eric Leblond <eric@regit.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:37850 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753541AbaACWyF (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 3 Jan 2014 17:54:05 -0500
Content-Disposition: inline
In-Reply-To: <1388653425-30466-1-git-send-email-eric@regit.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Thu, Jan 02, 2014 at 10:03:45AM +0100, Eric Leblond wrote:
> If setting event mask fails then we were returning 0 for success.
> This patch updates return code to -EINVAL in case of problem.

Applied to nf-next, thanks Eric.
