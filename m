From: Patrick McHardy <kaber@trash.net>
Subject: Re: [PATCH] ipt_CLUSTERIP: simplify seq_file code
Date: Fri, 22 Jan 2010 22:22:10 +0100
Message-ID: <4B5A1702.2070606@trash.net>
References: <20100122201957.GE22342@x200>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@vger.kernel.org
To: Alexey Dobriyan <adobriyan@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:56141 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754136Ab0AVVWT (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 22 Jan 2010 16:22:19 -0500
In-Reply-To: <20100122201957.GE22342@x200>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Alexey Dobriyan wrote:
> Pass "struct clusterip_config" itself to seq_file iterators
> and save one dereference. Proc entry itself isn't interesting.

Applied, thanks Alexey.
