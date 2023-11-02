Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 125EEC4332F
	for <netfilter-devel@archiver.kernel.org>; Thu,  2 Nov 2023 11:34:21 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229556AbjKBLeV (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 2 Nov 2023 07:34:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54072 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229483AbjKBLeV (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 2 Nov 2023 07:34:21 -0400
Received: from ganesha.gnumonks.org (ganesha.gnumonks.org [IPv6:2001:780:45:1d:225:90ff:fe52:c662])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 139E1130
        for <netfilter-devel@vger.kernel.org>; Thu,  2 Nov 2023 04:34:19 -0700 (PDT)
Received: from [78.30.35.151] (port=55192 helo=gnumonks.org)
        by ganesha.gnumonks.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <pablo@gnumonks.org>)
        id 1qyVxm-008fKz-PV; Thu, 02 Nov 2023 12:34:16 +0100
Date:   Thu, 2 Nov 2023 12:34:14 +0100
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Phil Sutter <phil@nwl.cc>,
        Arturo Borrero Gonzalez <arturo@debian.org>,
        Jeremy Sowden <jeremy@azazel.net>,
        netfilter-devel@vger.kernel.org, fw@strlen.de
Subject: Re: [RFC] nftables 1.0.6 -stable backports
Message-ID: <ZUOJNnKJRKwj379J@calendula>
References: <ZSPZiekbEmjDfIF2@calendula>
 <ZSZWS7StJ9nSP6cK@calendula>
 <ZSa+h18/ZNRxLpzq@orbyte.nwl.cc>
 <ZSbD9fPv2Ltx8Cx2@calendula>
 <ZTE8xaZfFJoQRhjY@calendula>
 <ZTFJ4yXd7nZxjAJz@orbyte.nwl.cc>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <ZTFJ4yXd7nZxjAJz@orbyte.nwl.cc>
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Thu, Oct 19, 2023 at 05:23:15PM +0200, Phil Sutter wrote:
> Kindly find attached my collect_backports.sh. I keep it in an unused
> sub-directory (~/git/nftables/stable_tooling), but it's not necessary.
> It creates $(dirname $0)/backports directory containing a list of
> potential backports for each tag in the range defined by the variables
> in the script's header.

I have integrated the pending fixes identified by your script. I have
refreshed 1.0.6.y branch and pushed it out.

If anyone find more candidates to be merged into 1.0.6, Let me know.

Thanks.
