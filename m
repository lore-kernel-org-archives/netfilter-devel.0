From: Patrick McHardy <kaber@trash.net>
Subject: Re: [PATCH v2 1/2] nfnetlink: netns support
Date: Wed, 10 Feb 2010 13:24:15 +0100
Message-ID: <4B72A56F.7070503@trash.net>
References: <20100113144024.GA4534@x200> <4B4DE0AF.9040509@trash.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@vger.kernel.org,
	containers@lists.linux-foundation.org
To: Alexey Dobriyan <adobriyan@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:49311 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755193Ab0BJMYd (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 10 Feb 2010 07:24:33 -0500
In-Reply-To: <4B4DE0AF.9040509@trash.net>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Patrick McHardy wrote:
> Alexey Dobriyan wrote:
>> Make nfnl socket per-petns.
> 
> Applied, thanks.

While merging the nf-next tree with the changes from net-next I noticed
that this patch allows any namespace to send configurations and verdicts
to nfnetlink_{log,queue}. It seems you need to add a check for init_net
to their recv functions unless I'm missing something.
