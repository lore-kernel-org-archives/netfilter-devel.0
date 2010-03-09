From: David Miller <davem@davemloft.net>
Subject: Re: [PATCH 1/1] netfilter: nf_ct_tcp: pack nf_ct_tcp_flags to
 match user space
Date: Tue, 09 Mar 2010 09:41:16 -0800 (PST)
Message-ID: <20100309.094116.10935277.davem@davemloft.net>
References: <1268153297-4226-1-git-send-email-ljaenicke@innominate.com>
	<1268153297-4226-2-git-send-email-ljaenicke@innominate.com>
	<alpine.LSU.2.01.1003091802060.3823@obet.zrqbmnf.qr>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Cc: ljaenicke@innominate.com, netfilter-devel@vger.kernel.org
To: jengelh@medozas.de
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:36252
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751829Ab0CIRk4 (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 9 Mar 2010 12:40:56 -0500
In-Reply-To: <alpine.LSU.2.01.1003091802060.3823@obet.zrqbmnf.qr>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

From: Jan Engelhardt <jengelh@medozas.de>
Date: Tue, 9 Mar 2010 18:03:02 +0100 (CET)

> On Tuesday 2010-03-09 17:48, Lutz Jaenicke wrote:
> 
>>On some platforms (here: Intel IXP4xx ARM big endian)
>>sizeof(struct nf_ct_tcp_flags) evaluates to 4 bytes while in the user
>>space code 2 bytes is hard coded.
> 
> Why does it evaluate to 4 bytes? That seems to go against all good C 
> practice.

It's just what the ARM ABI does.

We have to do something similar in the IPV6 stack for
the same reason.

struct nd_opt_hdr {
	__u8		nd_opt_type;
	__u8		nd_opt_len;
} __attribute__((__packed__));

