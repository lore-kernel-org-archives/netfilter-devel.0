From: Jan Engelhardt <jengelh@inai.de>
Subject: Re: [PATCH] netfilter: Parse ICMPv6 redirects
Date: Wed, 1 Mar 2017 16:41:13 +0100 (CET)
Message-ID: <alpine.LSU.2.20.1703011640440.12969@n3.vanv.qr>
References: <1488378767-32479-1-git-send-email-alin.nastac@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Cc: netfilter-devel@vger.kernel.org
To: Alin Nastac <alin.nastac@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from a3.inai.de ([88.198.180.161]:45902 "EHLO a3.inai.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751243AbdCAPwA (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 1 Mar 2017 10:52:00 -0500
In-Reply-To: <1488378767-32479-1-git-send-email-alin.nastac@gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


On Wednesday 2017-03-01 15:32, Alin Nastac wrote:

>Extract IPv6 packet that triggered the sending of redirect message from
>ICMPv6 Redirected Header option and check if conntrack table contain such
>connection. Mark redirect packet as RELATED if a matching connection is found.
>
>Signed-off-by: Alin Nastac <alin.nastac@gmail.com>
>---
> net/ipv6/netfilter/nf_conntrack_proto_icmpv6.c | 77 ++++++++++++++++++++++++--
> 1 file changed, 72 insertions(+), 5 deletions(-)
> 	/* is not error message ? */
>-	if (icmp6h->icmp6_type >= 128)
>+	if (icmp6h->icmp6_type == NDISC_REDIRECT) {

That should most likely become a new subfunction for the size that it is.
