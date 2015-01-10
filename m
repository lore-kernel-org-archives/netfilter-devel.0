From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH 1/3] eval: refactor NAT evaluation functions
Date: Sat, 10 Jan 2015 19:59:42 +0100
Message-ID: <20150110185942.GA7282@salvia>
References: <1420901955-21087-1-git-send-email-kaber@trash.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:47369 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750770AbbAJS44 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Sat, 10 Jan 2015 13:56:56 -0500
Content-Disposition: inline
In-Reply-To: <1420901955-21087-1-git-send-email-kaber@trash.net>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Sat, Jan 10, 2015 at 02:59:13PM +0000, Patrick McHardy wrote:
> The redir and masq evaluation functions include some useless context
> updates and checks.
> 
> Refactor the NAT code to have a single instance of address and transport
> evaluation functions for simplicity and unified error reporting.

Thanks a lot for revisiting these changes Patrick!
