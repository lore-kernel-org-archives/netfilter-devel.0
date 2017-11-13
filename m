From: Florian Westphal <fw@strlen.de>
Subject: [PATCH nf-next 0/4] netfilter: reduce hook sizes in struct net
Date: Mon, 13 Nov 2017 17:41:03 +0100
Message-ID: <20171113164107.11259-1-fw@strlen.de>
To: <netfilter-devel@vger.kernel.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([146.0.238.67]:48578 "EHLO
        Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1753802AbdKMQlY (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 13 Nov 2017 11:41:24 -0500
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

struct net contains:

struct nf_hook_entries __rcu *hooks[NFPROTO_NUMPROTO][NF_MAX_HOOKS];

which store the hook entry point locations for the various protocol
families and the hooks.
This can be compacted a lot by only storing the families and hooks
that are actually implemented.

struct net before:
/* size: 5184, cachelines: 81, members: 46 */
after:
/* size: 4544, cachelines: 71, members: 46 */

In case this is too late just ignore this thing, I will resubmit
once next opens again.
