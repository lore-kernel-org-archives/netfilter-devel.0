From: David Miller <davem@davemloft.net>
Subject: Re: [PATCH 1/1] netfilter: nf_ct_tcp: pack nf_ct_tcp_flags to
 match user space
Date: Mon, 15 Mar 2010 12:03:24 -0700 (PDT)
Message-ID: <20100315.120324.124573128.davem@davemloft.net>
References: <1268157924-4879-1-git-send-email-ljaenicke@innominate.com>
	<1268157924-4879-2-git-send-email-ljaenicke@innominate.com>
	<4B9E66FC.10303@trash.net>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Cc: ljaenicke@innominate.com, netfilter-devel@vger.kernel.org
To: kaber@trash.net
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:35866
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S965682Ab0COTDD (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 15 Mar 2010 15:03:03 -0400
In-Reply-To: <4B9E66FC.10303@trash.net>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

From: Patrick McHardy <kaber@trash.net>
Date: Mon, 15 Mar 2010 17:57:32 +0100

> I would prefer to fix userspace to use sizeof(...) instead of
> using packed structs in the kernel. AFAICT, that should also
> work on all architectures.

Agreed.
