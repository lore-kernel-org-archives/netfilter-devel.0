From: Florian Westphal <fw@strlen.de>
Subject: Re: [PATCH nf] netfilter: nf_tables: set pktinfo->thoff at AH header
 if found
Date: Sat, 4 Mar 2017 20:43:42 +0100
Message-ID: <20170304194342.GA6457@breakpoint.cc>
References: <1488653627-4815-1-git-send-email-pablo@netfilter.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org, phil@nwl.cc
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([146.0.238.67]:49734 "EHLO
        Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1752234AbdCDTnq (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Sat, 4 Mar 2017 14:43:46 -0500
Content-Disposition: inline
In-Reply-To: <1488653627-4815-1-git-send-email-pablo@netfilter.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Pablo Neira Ayuso <pablo@netfilter.org> wrote:
> Phil Sutter reports that IPv6 AH header matching is broken. From
> userspace, nft generates bytecode that expects to find the AH header at
> NFT_PAYLOAD_TRANSPORT_HEADER both for IPv4 and IPv6. However,
> pktinfo->thoff is set to the inner header after the AH header in IPv6,
> while in IPv4 pktinfo->thoff points to the AH header indeed. This
> behaviour is inconsistent. This patch fixes this problem by updating
> ipv6_find_hdr() to get the IP6_FH_F_AUTH flag so this function stops at
> the AH header, so both IPv4 and IPv6 pktinfo->thoff point to the AH
> header.

This looks wrong.  We need to search until we find a l4 header,
after this patch "tcp dort 22" won't match anymore if an AH header
exists.
