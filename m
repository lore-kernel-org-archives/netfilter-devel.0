Return-Path: <SRS0=8tM5=3J=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2A22DC2D0DB
	for <netfilter-devel@archiver.kernel.org>; Mon, 20 Jan 2020 11:23:12 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 0808520882
	for <netfilter-devel@archiver.kernel.org>; Mon, 20 Jan 2020 11:23:12 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726590AbgATLXL (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 20 Jan 2020 06:23:11 -0500
Received: from orbyte.nwl.cc ([151.80.46.58]:60256 "EHLO orbyte.nwl.cc"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726451AbgATLXL (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 20 Jan 2020 06:23:11 -0500
Received: from n0-1 by orbyte.nwl.cc with local (Exim 4.91)
        (envelope-from <n0-1@orbyte.nwl.cc>)
        id 1itV9B-0001kz-H8; Mon, 20 Jan 2020 12:23:09 +0100
Date:   Mon, 20 Jan 2020 12:23:09 +0100
From:   Phil Sutter <phil@nwl.cc>
To:     sbezverk <sbezverk@gmail.com>
Cc:     "netfilter-devel@vger.kernel.org" <netfilter-devel@vger.kernel.org>
Subject: Re: load balancing between two chains
Message-ID: <20200120112309.GG19873@orbyte.nwl.cc>
Mail-Followup-To: Phil Sutter <phil@nwl.cc>, sbezverk <sbezverk@gmail.com>,
        "netfilter-devel@vger.kernel.org" <netfilter-devel@vger.kernel.org>
References: <011F145A-C830-444E-A9AD-DB45178EBF78@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <011F145A-C830-444E-A9AD-DB45178EBF78@gmail.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Hi Serguei,

On Sun, Jan 19, 2020 at 09:46:11PM -0500, sbezverk wrote:
> While doing some performance test, btw the results are awesome so far, I came across an issue. It is kubernetes environment, there is a Cluster scope service with 2 backends, 2 pods. The rule for this service program a load balancing between 2 chains representing each backend pod.  When I curl the service, only 1 backend pod replies, second times out. If I delete pod which was working, then second pod starts replying to curl requests. Here are some logs and packets captures. Appreciate if you could take a look at it and share your thoughts.

Please add counters to your rules to check if both dnat statements are
hit. You may also switch 'jump' in vmap to 'goto' and add a final rule
in k8s-nfproxy-svc-M53CN2XYVUHRQ7UB (which should never see packets).

Did you provide a dump of traffic between load-balancer and pod2? (No
traffic is relevant info, too!) A dump of /proc/net/nf_conntrack in
error situation might reveal something, too.

Cheers, Phil
