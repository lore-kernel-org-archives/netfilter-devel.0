From: Patrick McHardy <kaber@trash.net>
Subject: Re: [PATCH] Couldn't load/find match `u32'
Date: Fri, 28 Sep 2007 17:25:45 +0200
Message-ID: <46FD1CF9.4090203@trash.net>
References: <20070928075459.M24408@ascenvision.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@vger.kernel.org
To: Hann-Huei Chiou <koala@ascenvision.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:54675 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754417AbXI1P0N (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 28 Sep 2007 11:26:13 -0400
In-Reply-To: <20070928075459.M24408@ascenvision.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

Hann-Huei Chiou wrote:
> Sorry if op, since I can't find list archives and can't connect
> to bugzilla.
> 
> iptables (up to 0927 snapshot) keeps complaining of "Couldn't
> load (or find, if NO_SHARED_LIBS=1) match `u32'. After comparing
> with other libxt_*.c, I found that there's no member ".family"
> in the "u32_reg" structure, while ".family = AF_INET6" exists
> in "u32_reg6"


Applied, thanks.

