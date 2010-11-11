From: Jan Engelhardt <jengelh@medozas.de>
Subject: Re: [PATCH 5/5] attr: avoid multiple definition of hidden variable
Date: Thu, 11 Nov 2010 21:53:01 +0100 (CET)
Message-ID: <alpine.LNX.2.01.1011112150280.30863@obet.zrqbmnf.qr>
References: <1289430485-16467-1-git-send-email-jengelh@medozas.de> <1289430485-16467-6-git-send-email-jengelh@medozas.de> <4CDBEAD6.9030505@netfilter.org> <alpine.LNX.2.01.1011111424370.22995@obet.zrqbmnf.qr> <4CDC2C3C.5060708@netfilter.org>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: netfilter-devel@vger.kernel.org
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from borg.medozas.de ([188.40.89.202]:38561 "EHLO borg.medozas.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756736Ab0KKUxC (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 11 Nov 2010 15:53:02 -0500
In-Reply-To: <4CDC2C3C.5060708@netfilter.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Thursday 2010-11-11 18:47, Pablo Neira Ayuso wrote:
>
>mnl_attr_for_each() in your patch is OK, sorry. But, here:
>
>+#define mnl_attr_for_each_nested(attr, nest) \
>+	for ((attr) = mnl_attr_get_payload(nest); \
>+	     mnl_attr_ok((attr), mnl_attr_get_payload(attr) +
>mnl_attr_get_payload_len(attr) - (void *)(attr)); \
>+	     (attr) = mnl_attr_next(attr))
>
>Once we iterate over the last attribute in the nest, we iterate again to
>check if there's any next. Then, mnl_attr_get_payload may access
>attr->len for an attribute that doesn't belong the nest or (if the nest
>is in the end of the message) an out of bound message access.

Indeed. Should have been

mnl_attr_ok((attr), mnl_attr_get_payload(nest) +
	mnl_attr_get_payload_len(nest) - (void *)(attr))

>I think that we can add mnl_attr_get_payload_tail to make tail minus
>attr, like in mnl_attr_for_each().

