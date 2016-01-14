From: =?UTF-8?B?QWxpbiBOxINzdGFj?= <alin.nastac@gmail.com>
Subject: Re: [PATCH] netfilter: nf_conntrack_icmpv6: find conntrack related to
 ICMPv6 redirect packet
Date: Thu, 14 Jan 2016 08:41:25 +0100
Message-ID: <CAF1oqRDd-oOCSh46QPs7_gNzLzyVqCTaKp2P4ow=wD15QbpbRQ@mail.gmail.com>
References: <1452692577-31719-1-git-send-email-alin.nastac@gmail.com>
	<20160113164341.GA2764@salvia>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: netfilter-devel <netfilter-devel@vger.kernel.org>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-wm0-f45.google.com ([74.125.82.45]:34796 "EHLO
	mail-wm0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750885AbcANHl1 (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 14 Jan 2016 02:41:27 -0500
Received: by mail-wm0-f45.google.com with SMTP id u188so332392471wmu.1
        for <netfilter-devel@vger.kernel.org>; Wed, 13 Jan 2016 23:41:26 -0800 (PST)
In-Reply-To: <20160113164341.GA2764@salvia>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Wed, Jan 13, 2016 at 5:43 PM, Pablo Neira Ayuso <pablo@netfilter.org> wrote:
> I'd suggest you submit this patch with a proper description.
>
> Thanks.

This patch will modify the conntrack state created by ICMPv6 redirect
packets from INVALID (as it is implemented now, skb->nfct remains
NULL) to RELATED (like in ICMPv6 errors case). In IPv4 case, ICMP
redirects are treated the same way as ICMP errors, so there is no
issue. Probably ICMPv6 redirects were not handled because their
parsing is not as straightforward as ICMPv6 errors.

I tested it on an older version of kernel, but since
nf_conntrack_proto_icmpv6.c remained basically the same, I think the
issue would be reproducible even on latest version of kernel.

Cheers,
Alin
