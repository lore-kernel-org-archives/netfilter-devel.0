From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [ULOGD PATCH] rework, fill MAC address in ULOG for ethernet.
Date: Wed, 09 Jul 2008 12:50:28 +0200
Message-ID: <487497F4.8070004@netfilter.org>
References: <486B88F4.7060704@trash.net> <1215554219-13763-1-git-send-email-eric@inl.fr>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@vger.kernel.org, Patrick McHardy <kaber@trash.net>
To: Eric Leblond <eric@inl.fr>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:36450 "EHLO us.es"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1756766AbYGIKuj (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 9 Jul 2008 06:50:39 -0400
In-Reply-To: <1215554219-13763-1-git-send-email-eric@inl.fr>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Eric Leblond wrote:
> This patch introduces a parsing of the hardware header field based on
> the length of the field. It currently only detects ethernet header and
> fill mac.saddr and mac.daddr properly.
> 
> With this behaviour it may be impossible to support all kind of devices
> but ULOG will soon be deprecated in favor of NFLOG.

Since we do not have more information in ULOG, I see this as a best try
to detect what kind of layer 2 header is there. The other choice is not
to include layer 2 information at all if we use ulog as input which also
seems reasonable to me. If users want new features they have to migrate
from ulog to nflog IMO.

I'm willing to finish the compatibility layer in libnetfilter_queue,
this could probably help to deprecate it.

If Patrick does not have any objection, I'll apply this and the previous
layer 2 related patches.

-- 
"Los honestos son inadaptados sociales" -- Les Luthiers
