From: Florian Westphal <fw@strlen.de>
Subject: Re: [PATCH v4 11/18] nfnetlink_log: exit_net cleanup check added
Date: Sun, 12 Nov 2017 09:53:34 +0100
Message-ID: <20171112085334.GK5512@breakpoint.cc>
References: <9dfa013e-9098-e155-9c47-a73753338288@virtuozzo.com>
 <9702fe4f-6b5d-bd5c-de87-6bf7ded4fbf2@virtuozzo.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netdev@vger.kernel.org, Pablo Neira Ayuso <pablo@netfilter.org>,
        Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>,
        Florian Westphal <fw@strlen.de>,
        netfilter-devel@vger.kernel.org, coreteam@netfilter.org
To: Vasily Averin <vvs@virtuozzo.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([146.0.238.67]:43142 "EHLO
        Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1753052AbdKLIyS (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Sun, 12 Nov 2017 03:54:18 -0500
Content-Disposition: inline
In-Reply-To: <9702fe4f-6b5d-bd5c-de87-6bf7ded4fbf2@virtuozzo.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Vasily Averin <vvs@virtuozzo.com> wrote:
> Be sure that instance_table array initialized in net_init hook
> was return to initial state.

Acked-by: Florian Westphal <fw@strlen.de>
