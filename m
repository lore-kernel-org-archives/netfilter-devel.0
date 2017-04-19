From: Florian Westphal <fw@strlen.de>
Subject: Re: [PATCH] netfilter: xt_socket: Fix broken IPv6 handling
Date: Wed, 19 Apr 2017 18:02:01 +0200
Message-ID: <20170419160201.GA17294@breakpoint.cc>
References: <alpine.LNX.2.00.1704181234010.5224@wolfie.lan.tirsek.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
To: Peter Tirsek <peter@tirsek.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([146.0.238.67]:42890 "EHLO
        Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S937162AbdDSQDS (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 19 Apr 2017 12:03:18 -0400
Content-Disposition: inline
In-Reply-To: <alpine.LNX.2.00.1704181234010.5224@wolfie.lan.tirsek.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Peter Tirsek <peter@tirsek.com> wrote:
> Commit 834184b1f3a4 ("netfilter: defrag: only register defrag
> functionality if needed") used the outdated XT_SOCKET_HAVE_IPV6 macro
> which was removed earlier in commit 8db4c5be88f6 ("netfilter: move
> socket lookup infrastructure to nf_socket_ipv{4,6}.c"). With that macro
> never being defined, the xt_socket match emits an "Unknown family 10"
> warning when used with IPv6:
> 
> WARNING: CPU: 0 PID: 1377 at net/netfilter/xt_socket.c:160 socket_mt_enable_defrag+0x47/0x50 [xt_socket]
> Unknown family 10

Right, this was missed during forward-port.

Acked-by: Florian Westphal <fw@strlen.de>
