From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH 0/2] netfilter updates for nf_ct_tcp
Date: Wed, 02 Feb 2011 16:42:38 +0100
Message-ID: <4D497B6E.4080306@netfilter.org>
References: <20110202140007.12173.41157.stgit@decadence>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Cc: kaber@trash.net, kadlec@blackhole.kfki.hu
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:51098 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754420Ab1BBPmq (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 2 Feb 2011 10:42:46 -0500
In-Reply-To: <20110202140007.12173.41157.stgit@decadence>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On 02/02/11 15:03, Pablo Neira Ayuso wrote:
[...]
>       netfilter: nf_ct_tcp: disable pick by default for first ACK packet seen
>       netfilter: nf_ct_tcp: fix missing TCP protocol information during pickup

Please, drop these patches.

I found them in a pile of old patches but it seems that the latter is
not finished. The former was actually fixed in 2.6.30.

Sorry.
