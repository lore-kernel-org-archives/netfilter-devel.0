From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH nf-next] netfilter: nf_tables: validate the expr
 explicitly after init successfully
Date: Mon, 6 Mar 2017 18:21:41 +0100
Message-ID: <20170306172141.GA6509@salvia>
References: <1488718943-43346-1-git-send-email-zlpnobody@163.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org, Liping Zhang <zlpnobody@gmail.com>
To: Liping Zhang <zlpnobody@163.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:42864 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752782AbdCFTBT (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 6 Mar 2017 14:01:19 -0500
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id E49D4170DAC
        for <netfilter-devel@vger.kernel.org>; Mon,  6 Mar 2017 18:22:02 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id D4E28DA818
        for <netfilter-devel@vger.kernel.org>; Mon,  6 Mar 2017 18:22:02 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id A28F3DA818
        for <netfilter-devel@vger.kernel.org>; Mon,  6 Mar 2017 18:22:00 +0100 (CET)
Content-Disposition: inline
In-Reply-To: <1488718943-43346-1-git-send-email-zlpnobody@163.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Sun, Mar 05, 2017 at 09:02:23PM +0800, Liping Zhang wrote:
> From: Liping Zhang <zlpnobody@gmail.com>
> 
> When we want to validate the expr's dependency or hooks, we must do two
> things to accomplish it. First, write a X_validate callback function
> and point ->validate to it. Second, call X_validate in init routine.
> This is very common, such as fib, nat, reject expr and so on ...
> 
> It is a little ugly, since we will call X_validate in the expr's init
> routine, it's better to do it in nf_tables_newexpr. So we can avoid to
> do this again and again. After doing this, the second step listed above
> is not useful anymore, remove them now.

Applied, thanks Liping.
