Return-Path: <SRS0=0f1v=RX=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.5 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,USER_AGENT_MUTT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 631F2C43381
	for <netfilter-devel@archiver.kernel.org>; Wed, 20 Mar 2019 08:09:37 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 3C1EA2146E
	for <netfilter-devel@archiver.kernel.org>; Wed, 20 Mar 2019 08:09:37 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727663AbfCTIJg (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 20 Mar 2019 04:09:36 -0400
Received: from orbyte.nwl.cc ([151.80.46.58]:36752 "EHLO orbyte.nwl.cc"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727304AbfCTIJg (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 20 Mar 2019 04:09:36 -0400
Received: from n0-1 by orbyte.nwl.cc with local (Exim 4.91)
        (envelope-from <n0-1@orbyte.nwl.cc>)
        id 1h6WHt-00036R-LG; Wed, 20 Mar 2019 09:09:25 +0100
Date:   Wed, 20 Mar 2019 09:09:25 +0100
From:   Phil Sutter <phil@nwl.cc>
To:     Jan Engelhardt <jengelh@inai.de>
Cc:     Pablo Neira Ayuso <pablo@netfilter.org>,
        Thomas Graf <tgraf@infradead.org>,
        James Czyzak <czyzak2@linux.vnet.ibm.com>,
        Tom Callaway <spot@fedoraproject.org>,
        Netfilter Developer Mailing List 
        <netfilter-devel@vger.kernel.org>
Subject: Re: [ebtables PATCH 3/3] extensions: Add AUDIT target
Message-ID: <20190320080925.GY4851@orbyte.nwl.cc>
Mail-Followup-To: Phil Sutter <phil@nwl.cc>,
        Jan Engelhardt <jengelh@inai.de>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        Thomas Graf <tgraf@infradead.org>,
        James Czyzak <czyzak2@linux.vnet.ibm.com>,
        Tom Callaway <spot@fedoraproject.org>,
        Netfilter Developer Mailing List <netfilter-devel@vger.kernel.org>
References: <20190319190938.20751-1-phil@nwl.cc>
 <20190319190938.20751-4-phil@nwl.cc>
 <nycvar.YFH.7.76.1903192026550.7166@n3.vanv.qr>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <nycvar.YFH.7.76.1903192026550.7166@n3.vanv.qr>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Hi Jan,

On Tue, Mar 19, 2019 at 08:44:12PM +0100, Jan Engelhardt wrote:
> On Tuesday 2019-03-19 20:09, Phil Sutter wrote:
> 
> >This is a barn find from Fedora package, actually spooking around in
> >various places in the internet. No idea who wrote it, but it seems to be
> >used. So add it for the time being.
> 
> Not sure, but I added some people in the Cc that may know more (and the 
> hope is that the ibm address still delivers).
> 
> 
>  * xt_AUDIT made its appearance around January 2011 
>    https://lwn.net/Articles/423402/ (tgraf@)
> 
>  * "ebtables --audit-type" made an appearence in the audit-test code 
>    repository https://sourceforge.net/p/audit-test/code/ref/master/ in 
>    June 2011 (czyzak@). This means that ebt_audit existed in some form
>    at that time already.
> 
>  * Fedora ebtables (only) gained the patch 2013-March-21 (spot@)

Thanks a lot for your historic research. In RHEL, ebtables got AUDIT
support with bz#642394 (private). Thomas provided the patch, so
hopefully he either wrote it or knows where it came from.

Thanks, Phil

