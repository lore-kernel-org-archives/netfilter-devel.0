From: Patrick McHardy <kaber@trash.net>
Subject: Re: [IPTABLES][PATCH 2/2 v2] xt_sctp: support FORWARD_TSN chunk type
Date: Tue, 08 Jun 2010 14:17:19 +0200
Message-ID: <4C0E34CF.5090607@trash.net>
References: <4C0BE416.4070503@cn.fujitsu.com> <4C0BEDA8.6090603@cn.fujitsu.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Cc: linux-sctp@vger.kernel.org, netfilter-devel@vger.kernel.org
To: Shan Wei <shanwei@cn.fujitsu.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:41876 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751834Ab0FHMRU (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 8 Jun 2010 08:17:20 -0400
In-Reply-To: <4C0BEDA8.6090603@cn.fujitsu.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On 06.06.2010 20:49, Shan Wei wrote:
> The latest kernel has implemented Partial Reliability Extension
> that defined in RFC3758.
> 
> This patch adds FORWARD_TSN chunk for tracing.

Applied, thanks.
