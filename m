From: Patrick McHardy <kaber@trash.net>
Subject: Re: [PATCH 5/5] netns netfilter: put table module on netns stop
Date: Thu, 24 Jan 2008 18:48:48 +0100
Message-ID: <4798CF80.8030901@trash.net>
References: <20080124123002.GE27337@localhost.sw.ru>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Cc: netdev@vger.kernel.org, netfilter-devel@vger.kernel.org,
	devel@openvz.org
To: Alexey Dobriyan <adobriyan@sw.ru>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:48709 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751722AbYAXRsv (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 24 Jan 2008 12:48:51 -0500
In-Reply-To: <20080124123002.GE27337@localhost.sw.ru>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Alexey Dobriyan wrote:
> When number of entries exceeds number of initial entries, foo-tables code
> will pin table module. But during table unregister on netns stop,
> that additional pin was forgotten.

Applied, thanks.


