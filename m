From: Patrick McHardy <kaber@trash.net>
Subject: Re: [PATCH] netfilter: ip6table_filter in netns for real
Date: Tue, 17 Jun 2008 13:48:57 +0200
Message-ID: <4857A4A9.3050204@trash.net>
References: <20080617023057.GA22003@martell.zuzino.mipt.ru>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@vger.kernel.org, den@openvz.org, xemul@openvz.org
To: Alexey Dobriyan <adobriyan@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:61705 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755065AbYFQLtH (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 17 Jun 2008 07:49:07 -0400
In-Reply-To: <20080617023057.GA22003@martell.zuzino.mipt.ru>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Alexey Dobriyan wrote:
> One still needs to remove checks in nf_hook_slow() and nf_sockopt_find()
> to test this, though.
> 
> Signed-off-by: Alexey Dobriyan <adobriyan@gmail.com>

Applied, thanks.
