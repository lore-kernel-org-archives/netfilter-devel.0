From: Patrick McHardy <kaber@trash.net>
Subject: Re: [nf_tables PATCH] netfilter: nf_tables: add set_elem
 notifications
Date: Wed, 2 Apr 2014 13:48:03 +0200
Message-ID: <20140402114803.GB26334@macbook.localnet>
References: <20140401120606.4305.13228.stgit@nfdev.cica.es>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org, pablo@netfilter.org
To: Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:44331 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758551AbaDBLsG (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 2 Apr 2014 07:48:06 -0400
Content-Disposition: inline
In-Reply-To: <20140401120606.4305.13228.stgit@nfdev.cica.es>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Tue, Apr 01, 2014 at 02:06:07PM +0200, Arturo Borrero Gonzalez wrote:
> This patch adds set_elems notifications.
> 
> When a set_elem is added/deleted, all listening peers in userspace will
> receive the corresponding notification.
> 
> Signed-off-by: Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>

Acked-by: Patrick McHardy <kaber@trash.net>
