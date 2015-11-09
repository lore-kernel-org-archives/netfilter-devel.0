From: Jan Engelhardt <jengelh@inai.de>
Subject: Re: [RFC PATCH nf-next 0/1] payload mangling support
Date: Mon, 9 Nov 2015 16:22:35 +0100 (CET)
Message-ID: <alpine.LSU.2.20.1511091613300.8566@nerf40.vanv.qr>
References: <1447078234-21628-1-git-send-email-kaber@trash.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Cc: pablo@netfilter.org, netfilter-devel@vger.kernel.org
To: Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from ares41.inai.de ([46.4.122.207]:41930 "EHLO ares41.inai.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751302AbbKIPWg (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 9 Nov 2015 10:22:36 -0500
In-Reply-To: <1447078234-21628-1-git-send-email-kaber@trash.net>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


On Monday 2015-11-09 15:10, Patrick McHardy wrote:

>The following patch adds support for payload mangling. It supports updating
>all fields except those included in pseudo headers since it only supports a
>single checksum update operation. So it can not be used for stateless NAT.
>
>Checksum updates currently only support internet checksums and assume the
>mangled data is actually covered by the checksum. Userspace only allows use
>for these protocols.
>
>So the main questions is basically, do we want to support stateless NAT?

Some people ask for that sort of thing every now and then, so it
depends on whether you want to please them. On the upside, they only
seem to request L3 address editing and L3addrs-inside-ICMP(v6), so
the amount of protocol handlers needed is small.
