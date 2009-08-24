From: Patrick McHardy <kaber@trash.net>
Subject: Re: [PATCH 1/6] netfilter: xtables: consolidate table hook functions
Date: Mon, 24 Aug 2009 14:53:14 +0200
Message-ID: <4A928D3A.1000502@trash.net>
References: <1249931992-18761-1-git-send-email-jengelh@medozas.de> <1249931992-18761-2-git-send-email-jengelh@medozas.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: netfilter-devel@vger.kernel.org
To: Jan Engelhardt <jengelh@medozas.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:51358 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752349AbZHXMxP (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 24 Aug 2009 08:53:15 -0400
In-Reply-To: <1249931992-18761-2-git-send-email-jengelh@medozas.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Jan Engelhardt wrote:
> For a following patch in this series ("generate nf hook ops on
> demand"), we will be requiring that a single hook entry function per
> table does the processing. Would this not be done would I need to
> pass multiple hook functions as arguments in that later patch, which
> would have been not so nice.
>=20
> This also removes exact duplicates of some hook functions =E2=80=94
> ipt_pre_routing_hook, ipt_local_in_hook and ipt_forward_hook in
> iptable_mangle.c all did the same.

Removing duplicates is fine of course, but I don't like the
"consolidation" of multiple different hook functions very much.
You're trading more runtime overhead (admittedly not that much,
but those functions are heavily used) for a small "unification",
which doesn't seem like a good trade to me.

The second problem is that your automatically generated hook ops
can't even represent all the cases we have since some tables
actually do use different priorities for the different hooks.
And I'm not sure where the memory savings you claim should come
from, the hook ops are still required at runtime.

So please explain the benefit of these patches (1-3) in more
detail.
--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
