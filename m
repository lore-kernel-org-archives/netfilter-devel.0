From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [nf_tables PATCH 4/6 v5] netfilter: nf_tables: add helpers to
 schedule objects deletion
Date: Tue, 9 Sep 2014 16:04:43 +0200
Message-ID: <20140909140443.GA22864@salvia>
References: <1409668946-8168-1-git-send-email-arturo.borrero.glez@gmail.com>
 <1409668946-8168-5-git-send-email-arturo.borrero.glez@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org, kaber@trash.net
To: Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:53581 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756732AbaIIODw (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 9 Sep 2014 10:03:52 -0400
Content-Disposition: inline
In-Reply-To: <1409668946-8168-5-git-send-email-arturo.borrero.glez@gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Tue, Sep 02, 2014 at 04:42:25PM +0200, Arturo Borrero Gonzalez wrote:
> This patch refactor the code to schedule objects deletion.
> 
> They are useful in follow-up patches.
> 
> In order to be able to use these new helper functions in all the code,
> they are placed in the top of the file, with all the dependant functions
> and symbols.

Applied, thanks Arturo.

I have also renamed disactivate to deactivate as requested by Patrick.

