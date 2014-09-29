From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [nft PATCH 1/3] rule: rename do_command_list_cleanup() to
 table_cleanup()
Date: Mon, 29 Sep 2014 12:38:23 +0200
Message-ID: <20140929103823.GB16284@salvia>
References: <1411554740-16660-1-git-send-email-arturo.borrero.glez@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:46871 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750911AbaI2KhK (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 29 Sep 2014 06:37:10 -0400
Content-Disposition: inline
In-Reply-To: <1411554740-16660-1-git-send-email-arturo.borrero.glez@gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Wed, Sep 24, 2014 at 12:32:18PM +0200, Arturo Borrero Gonzalez wrote:
> Let's use a more generic name for this functions, since it has nothing to do
> with commands.

Applied, thanks.
