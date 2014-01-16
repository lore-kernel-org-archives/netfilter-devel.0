From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [libnftables PATCH] ct: fix missing NFT_CT_L3PROTOCOL in
 ctkey2str_array
Date: Thu, 16 Jan 2014 18:51:26 +0100
Message-ID: <20140116175126.GA18487@localhost>
References: <20140115181846.25192.17850.stgit@nfdev.cica.es>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:57264 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750968AbaAPRvc (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 16 Jan 2014 12:51:32 -0500
Content-Disposition: inline
In-Reply-To: <20140115181846.25192.17850.stgit@nfdev.cica.es>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Wed, Jan 15, 2014 at 07:18:46PM +0100, Arturo Borrero Gonzalez wrote:
> Due to missing NFT_CT_L3PROTOCOL key in ctkey2str_array, a segfault is
> produced when the str2ctkey() loop reaches that position, since strcmp()
> will try to compare a NULL value.

Good catch. Applied, thanks.
