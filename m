From: Patrick McHardy <kaber@trash.net>
Subject: Re: [PATCH 12/33] netns ct: export netns list
Date: Tue, 09 Sep 2008 07:59:54 +0200
Message-ID: <48C610DA.40005@trash.net>
References: <48C01046.2070704@trash.net> <1220842990-30500-12-git-send-email-adobriyan@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Cc: netdev@vger.kernel.org, netfilter-devel@vger.kernel.org,
	containers@lists.linux-foundation.org
To: Alexey Dobriyan <adobriyan@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:62455 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753195AbYIIF74 (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 9 Sep 2008 01:59:56 -0400
In-Reply-To: <1220842990-30500-12-git-send-email-adobriyan@gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Alexey Dobriyan wrote:
> Conntrack code will use it for
> a) removing expectations and helpers when corresponding module is removed, and
> b) removing conntracks when L3 protocol conntrack module is removed.

Applied, thanks.
