Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3253DC433EF
	for <netfilter-devel@archiver.kernel.org>; Fri,  4 Feb 2022 04:40:34 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236289AbiBDEkc (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 3 Feb 2022 23:40:32 -0500
Received: from mail.netfilter.org ([217.70.188.207]:48988 "EHLO
        mail.netfilter.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231887AbiBDEkb (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 3 Feb 2022 23:40:31 -0500
Received: from netfilter.org (unknown [78.30.32.163])
        by mail.netfilter.org (Postfix) with ESMTPSA id 9E08C60195;
        Fri,  4 Feb 2022 05:40:25 +0100 (CET)
Date:   Fri, 4 Feb 2022 05:40:27 +0100
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Florian Westphal <fw@strlen.de>
Cc:     netfilter-devel@vger.kernel.org,
        Vivek Thrivikraman <vivek.thrivikraman@est.tech>
Subject: Re: [PATCH nf] netfilter: conntrack: don't refresh sctp entries in
 closed state
Message-ID: <YfyuO0Gbwno661sl@salvia>
References: <20220128121332.16103-1-fw@strlen.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20220128121332.16103-1-fw@strlen.de>
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Fri, Jan 28, 2022 at 01:13:32PM +0100, Florian Westphal wrote:
> Vivek Thrivikraman reported:
>  An SCTP server application which is accessed continuously by client
>  application.
>  When the session disconnects the client retries to establish a connection.
>  After restart of SCTP server application the session is not established
>  because of stale conntrack entry with connection state CLOSED as below.
> 
>  (removing this entry manually established new connection):
> 
>  sctp 9 CLOSED src=10.141.189.233 [..]  [ASSURED]
> 
> Just skip timeout update of closed entries, we don't want them to
> stay around forever.

Applied
