From: Florian Westphal <fw@strlen.de>
Subject: Re: [PATCH v2] nfnetlink_queue: add security context information
Date: Tue, 26 May 2015 15:06:23 +0200
Message-ID: <20150526130623.GD7817@breakpoint.cc>
References: <5562F661.5000503@samsung.com>
 <20150525131319.GA3529@salvia>
 <55634935.4020100@samsung.com>
 <20150525205210.GG3629@breakpoint.cc>
 <55646731.9040803@samsung.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Florian Westphal <fw@strlen.de>, netfilter-devel@vger.kernel.org,
	=?utf-8?B?UmFmYcWC?= Krypa <r.krypa@samsung.com>
To: Roman Kubiak <r.kubiak@samsung.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from [80.244.247.6] ([80.244.247.6]:42894 "EHLO
	Chamillionaire.breakpoint.cc" rhost-flags-FAIL-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752825AbbEZNHQ (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 26 May 2015 09:07:16 -0400
Content-Disposition: inline
In-Reply-To: <55646731.9040803@samsung.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Roman Kubiak <r.kubiak@samsung.com> wrote:
> I was wondering, assuming i remove the NULL termination and SMACK sends a piece of data that's not null terminated,
> how, on the userland side, can i find out about that size ?

The size of netlink attribute is stored in netlink header.
For old libnfnetlink based api, see nfq_get_payload() in
libnetfilter_queue.

> Please notice that i send a libnetfilter_queue patch:
> [PATCH] libnetfitler_queue: receive security context info
> 
> it uses
> *secdata = (unsigned char *)nfnl_get_pointer_to_data(nfad->data, NFQA_SECCTX, char);
> to get the security context data, but there is no info about the size, where can i find that not to go over bounds and read beyond what i should ?

NFQ_PAYLOAD(nfad->data[NFQA_SECCTX - 1])

For libmnl based api (preferred), you'd use

mnl_nlmsg_get_payload_len(attr[NFQA_SECCTX])
