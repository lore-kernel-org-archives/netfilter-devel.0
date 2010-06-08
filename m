From: Patrick McHardy <kaber@trash.net>
Subject: Re: [IPTABLES][PATCH 1/2] xt_sctp: Trace DATA chunk that supports
 SACK-IMMEDIATELY extension
Date: Tue, 08 Jun 2010 14:16:08 +0200
Message-ID: <4C0E3488.6040402@trash.net>
References: <4C0BE408.7070606@cn.fujitsu.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@vger.kernel.org, linux-sctp@vger.kernel.org
To: Shan Wei <shanwei@cn.fujitsu.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:41838 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755137Ab0FHMQJ (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 8 Jun 2010 08:16:09 -0400
In-Reply-To: <4C0BE408.7070606@cn.fujitsu.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On 06.06.2010 20:08, Shan Wei wrote:
> SACK-IMMEDIATELY extension has defined in: 
> http://tools.ietf.org/html/draft-tuexen-tsvwg-sctp-sack-immediately-03.
> 
> And the latest kernel has added a I flag in DATA chunk to support this extension.
> So let iptables/netfilter can trace it.

Applied, thanks.
