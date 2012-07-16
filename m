From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [nfacct PATCH 0/1] Fix typo in cmd line parsing
Date: Mon, 16 Jul 2012 14:27:47 +0200
Message-ID: <20120716122747.GA17585@1984>
References: <1342302032-9108-1-git-send-email-eric@regit.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Eric Leblond <eric@regit.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:36654 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751375Ab2GPM1y (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 16 Jul 2012 08:27:54 -0400
Content-Disposition: inline
In-Reply-To: <1342302032-9108-1-git-send-email-eric@regit.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Sat, Jul 14, 2012 at 11:40:31PM +0200, Eric Leblond wrote:
> 
> Hello,
> 
> This patch fixes what looks like a typo in the command line parsing.
> I did not manage to find a good explanation to the current code and
> I thus decide to cool this little patch.

Applied, thanks Eric

You've fixed: nfacct list xml reset

that allows you to atomically get and reset counters while obtaining
them in XML.
