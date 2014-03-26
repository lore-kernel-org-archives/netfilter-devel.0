From: =?UTF-8?B?QWxpbiBOxINzdGFj?= <alin.nastac@gmail.com>
Subject: Re: [helper PATCH] Preserve conntrack helper bound through CT rule
Date: Wed, 26 Mar 2014 14:18:58 +0100
Message-ID: <CAF1oqRAg8Xi+JwL_ErzuwF1TFWHCMcV6pGasUfFQ5_RaDNMBOQ@mail.gmail.com>
References: <CAF1oqRC4LDjjq2X1EjRSJr0g0oQk45UMZBviLz0mziTwM8WbRQ@mail.gmail.com>
	<20140326130445.GD21741@breakpoint.cc>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: netfilter-devel@vger.kernel.org
To: Florian Westphal <fw@strlen.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-la0-f42.google.com ([209.85.215.42]:43362 "EHLO
	mail-la0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751616AbaCZNS7 (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 26 Mar 2014 09:18:59 -0400
Received: by mail-la0-f42.google.com with SMTP id ec20so1502535lab.1
        for <netfilter-devel@vger.kernel.org>; Wed, 26 Mar 2014 06:18:58 -0700 (PDT)
In-Reply-To: <20140326130445.GD21741@breakpoint.cc>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hi Florian,

Quite the contrary, the new code would be
    if (ct->master || help)
        return;
This will relax the if statement condition, which will decrease the
__nf_ct_try_assing_helper() call count.

Anyway, I use a Broadcom patched 3.4.11, but I checked the origin of
the call, it does not originate from their patches, in comes from
nf_nat_setup_info(ct, &newrange, NF_NAT_MANIP_SRC) call found in
masquerade_tg().
Helper auto assignments are enabled (in that version is not possible
to inhibit them outside loading nf_conntrack_ftp with ports=0).
