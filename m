From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH] arptables: remove dead dynamic hooks code
Date: Wed, 12 Nov 2014 12:58:53 +0100
Message-ID: <20141112115853.GA32535@salvia>
References: <1415712022-31842-1-git-send-email-gustavo@zacarias.com.ar>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Gustavo Zacarias <gustavo@zacarias.com.ar>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:54271 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751507AbaKLL46 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 12 Nov 2014 06:56:58 -0500
Content-Disposition: inline
In-Reply-To: <1415712022-31842-1-git-send-email-gustavo@zacarias.com.ar>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Tue, Nov 11, 2014 at 10:20:22AM -0300, Gustavo Zacarias wrote:
> The code is unused and #if'ed away, it also breaks pure-static
> builds because of the dlfcn.h include.

Applied, thanks.
