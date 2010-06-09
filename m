From: Patrick McHardy <kaber@trash.net>
Subject: Re: [NETFILTER] [PATCH] xt_sctp: use WORD_ROUND macro to calculate
 length of multiple of 4 bytes
Date: Wed, 09 Jun 2010 14:48:09 +0200
Message-ID: <4C0F8D89.8080702@trash.net>
References: <4C0BE429.5030902@cn.fujitsu.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@vger.kernel.org
To: Shan Wei <shanwei@cn.fujitsu.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:33658 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757516Ab0FIMsH (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 9 Jun 2010 08:48:07 -0400
In-Reply-To: <4C0BE429.5030902@cn.fujitsu.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Shan Wei wrote:
> Use  WORD_ROUND to round an int up to the next multiple of 4.
>   


Applied, thanks.
