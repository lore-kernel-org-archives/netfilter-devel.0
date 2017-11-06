From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH] netfilter: conntrack: use power efficient workqueue
Date: Mon, 6 Nov 2017 15:31:55 +0100
Message-ID: <20171106143155.GA8738@salvia>
References: <1509635767-12253-1-git-send-email-vincent.guittot@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Vincent Guittot <vincent.guittot@linaro.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:52542 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752425AbdKFOcK (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 6 Nov 2017 09:32:10 -0500
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id EC5261B8419
        for <netfilter-devel@vger.kernel.org>; Mon,  6 Nov 2017 15:32:08 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id C6322DA793
        for <netfilter-devel@vger.kernel.org>; Mon,  6 Nov 2017 15:32:08 +0100 (CET)
Content-Disposition: inline
In-Reply-To: <1509635767-12253-1-git-send-email-vincent.guittot@linaro.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Thu, 2 Nov 2017 15:16:07 +0100 Vincent Guittot <vincent.guittot@linaro.org> wrote:
> conntrack uses the bounded system_long_wq workqueue for its works that
> don't have to run on the cpu they have been queued.  Using bounded
> workqueue prevents the scheduler to make smart decision about the best
> place to schedule the work.
>
> This patch replaces system_long_wq with system_power_efficient_wq.
> the work stays bounded to a cpu by default unless the
> CONFIG_WQ_POWER_EFFICIENT is enable. In the latter case, the work can
> be scheduled on the best cpu from a power or a performance point of
> view.

Applied, thanks.
