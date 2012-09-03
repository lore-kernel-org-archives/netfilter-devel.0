From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH] properly annotate ipv4_netfilter_{init,fini}()
Date: Mon, 3 Sep 2012 17:32:25 +0200
Message-ID: <20120903153225.GD19926@1984>
References: <4FDF1C97020000780008A64E@nat28.tlf.novell.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: kaber@trash.net, netfilter-devel@vger.kernel.org
To: Jan Beulich <JBeulich@suse.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:56551 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932281Ab2ICPc2 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 3 Sep 2012 11:32:28 -0400
Content-Disposition: inline
In-Reply-To: <4FDF1C97020000780008A64E@nat28.tlf.novell.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Mon, Jun 18, 2012 at 11:18:31AM +0100, Jan Beulich wrote:
> Despite being just a few bytes of code, they should still have proper
> annotations.

I missed this small one, now applied, thanks Jan.
