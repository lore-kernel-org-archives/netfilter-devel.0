Return-Path: <SRS0=37vH=RQ=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.5 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,USER_AGENT_MUTT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E9221C43381
	for <netfilter-devel@archiver.kernel.org>; Wed, 13 Mar 2019 09:44:26 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id BED242147C
	for <netfilter-devel@archiver.kernel.org>; Wed, 13 Mar 2019 09:44:26 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727395AbfCMJo0 (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 13 Mar 2019 05:44:26 -0400
Received: from orbyte.nwl.cc ([151.80.46.58]:47486 "EHLO orbyte.nwl.cc"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726163AbfCMJo0 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 13 Mar 2019 05:44:26 -0400
Received: from n0-1 by orbyte.nwl.cc with local (Exim 4.91)
        (envelope-from <n0-1@orbyte.nwl.cc>)
        id 1h40Qy-0003hj-6I; Wed, 13 Mar 2019 10:44:24 +0100
Date:   Wed, 13 Mar 2019 10:44:24 +0100
From:   Phil Sutter <phil@nwl.cc>
To:     Fernando Fernandez Mancera <ffmancera@riseup.net>
Cc:     netfilter-devel@vger.kernel.org
Subject: Re: [PATCH nft v2 1/6] osf: add version fingerprint support
Message-ID: <20190313094424.GA11433@orbyte.nwl.cc>
Mail-Followup-To: Phil Sutter <phil@nwl.cc>,
        Fernando Fernandez Mancera <ffmancera@riseup.net>,
        netfilter-devel@vger.kernel.org
References: <20190311151417.17772-1-ffmancera@riseup.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190311151417.17772-1-ffmancera@riseup.net>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Hi Fernando,

On Mon, Mar 11, 2019 at 04:14:12PM +0100, Fernando Fernandez Mancera wrote:
> Add support for version fingerprint in "osf" expression. Example:
> 
> table ip foo {
> 	chain bar {
> 		type filter hook input priority filter; policy accept;
> 		osf ttl skip name "Linux"
> 		osf ttl skip name version "Linux:4.20"
> 	}
> }

The syntax seems overly complicated to me, although I'm not really
familiar with OSF so may lack background knowledge. Any reason why you
didn't go with 'osf ttl skip name "Linux" version "4.20"' instead?

Also with regards to your patch to json_parser, I guess you should
introduce an enum for flag values, something like:

| enum osf_flags {
| 	OSF_FLAG_INVALID = 0x0,
| 	OSF_FLAG_VERSION = 0x1
| };
| 
| const char *osf_flag_names[] = {
| 	[OSF_VERSION] = "version"
| };

What do you think?

Cheers, Phil
