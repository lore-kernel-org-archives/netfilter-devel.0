From: Jan Engelhardt <jengelh@inai.de>
Subject: Re: [PATCH iptables 2/2] libxtables: pass AI_ADDRCONFIG flag to
 getaddrinfo()
Date: Wed, 8 Mar 2017 14:56:24 +0100 (CET)
Message-ID: <alpine.LSU.2.20.1703081453420.4389@n3.vanv.qr>
References: <1488978970-30802-1-git-send-email-pablo@netfilter.org> <1488978970-30802-2-git-send-email-pablo@netfilter.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Cc: netfilter-devel@vger.kernel.org, alexander@alemayhu.com
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from a3.inai.de ([88.198.180.161]:35596 "EHLO a3.inai.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750744AbdCHO2j (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 8 Mar 2017 09:28:39 -0500
In-Reply-To: <1488978970-30802-2-git-send-email-pablo@netfilter.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


On Wednesday 2017-03-08 14:16, Pablo Neira Ayuso wrote:
>
>If hints.ai_flags includes the AI_ADDRCONFIG flag, then IPv4 addresses
>are returned in the list pointed to by res only if the local system has
>at least one IPv4 address configured, and IPv6 addresses are only
>returned if the local system has at least one IPv6 address configured.

But even if a system has no IPv4 address - think of a bridge -, you may
want to resolve an `iptables -A FORWARD -s ... ` request.

IMO the more proper approach is to filter duplicates instead of trying to
massage the hints structure.
