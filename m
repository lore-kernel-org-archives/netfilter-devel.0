From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH nf 1/2,v3] netfilter: nfnetlink_cthelper: fix runtime
 expectation policy updates
Date: Wed, 22 Mar 2017 13:04:21 +0100
Message-ID: <20170322120421.GA14162@salvia>
References: <1490108275-19537-1-git-send-email-pablo@netfilter.org>
 <CAML_gOfHxD6ScxARXJBMtE0SvVDioKBUvipY9Hyk8hLQt0edqw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Netfilter Developer Mailing List
        <netfilter-devel@vger.kernel.org>, jeffy.chen@rock-chips.com,
        briannorris@chromium.org, dianders@chromium.org
To: Liping Zhang <zlpnobody@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:59438 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1758666AbdCVMFN (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 22 Mar 2017 08:05:13 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 5192F11480F
        for <netfilter-devel@vger.kernel.org>; Wed, 22 Mar 2017 13:04:27 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 421D3DA793
        for <netfilter-devel@vger.kernel.org>; Wed, 22 Mar 2017 13:04:27 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 37ACEDA865
        for <netfilter-devel@vger.kernel.org>; Wed, 22 Mar 2017 13:04:25 +0100 (CET)
Content-Disposition: inline
In-Reply-To: <CAML_gOfHxD6ScxARXJBMtE0SvVDioKBUvipY9Hyk8hLQt0edqw@mail.gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Wed, Mar 22, 2017 at 01:38:08PM +0800, Liping Zhang wrote:
> Hi Pablo,
> 
> 2017-03-21 22:57 GMT+08:00 Pablo Neira Ayuso <pablo@netfilter.org>:
> > We only allow runtime updates of expectation policies for timeout and
> > maximum number of expectations, otherwise reject the update.
> >
> > Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
> > ---
> > v3: Fixed expect_class_max semantics. Compile-tested only.
> 
> Acked-by: Liping Zhang <zlpnobody@gmail.com>

OK, I have pushed it out now. You can proceed now with your rebase.

Thanks!
