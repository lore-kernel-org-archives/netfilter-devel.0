Return-Path: <SRS0=O4lm=UX=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5D83EC43613
	for <netfilter-devel@archiver.kernel.org>; Mon, 24 Jun 2019 03:52:59 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id A4878208C3
	for <netfilter-devel@archiver.kernel.org>; Mon, 24 Jun 2019 03:52:58 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=kaechele.ca header.i=@kaechele.ca header.b="SngurjsH"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727639AbfFXDw6 (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Sun, 23 Jun 2019 23:52:58 -0400
Received: from mail.fetzig.org ([54.39.219.108]:55016 "EHLO mail.fetzig.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726476AbfFXDw6 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Sun, 23 Jun 2019 23:52:58 -0400
X-Greylist: delayed 527 seconds by postgrey-1.27 at vger.kernel.org; Sun, 23 Jun 2019 23:52:57 EDT
Received: from authenticated-user (PRIMARY_HOSTNAME [PUBLIC_IP])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-384) server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        (Authenticated sender: felix@fetzig.org)
        by mail.fetzig.org (Postfix) with ESMTPSA id B7598804C7;
        Sun, 23 Jun 2019 23:44:09 -0400 (EDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kaechele.ca;
        s=kaechele.ca-201608; t=1561347849;
        bh=JBumEzucJwLjxOLCFOKdRPvpUpfocNNuY8epnKOYUes=;
        h=Subject:To:References:From:Date:In-Reply-To:From;
        b=SngurjsH1aHBs/nWLX8xwaxUNcX1dSe2PUYjddWymKztfkhUDttDE+W1UP/22fGPR
         oJrhDCK1uwOAXhIfnTJgWNvAo3uTs0DoZcc0OrnOV9yWC6Jm5NWW2x0evOGPpSbBW9
         yocYYBkoV1qbFSuT0n/lSo0u1eZpp+DPqAdcvG7D49SNP6GL62IuZS+Xb1O/LouMzW
         WAR3dC/Fuur7bIurLRL9gXGvFk7hMLcq7N0MoN0sfapoipDOONuZWxKHfCM7si6/WX
         4siGkJsVYOFW5G1KxiXIQsILSHnq0LSW8Xge6xXvKetsPgMfnkbRPrPpDQHFSJsyVQ
         QLUeMoAzd6WLg==
Subject: Re: [PATCH 08/13] netfilter: ctnetlink: Resolve conntrack L3-protocol
 flush regression
To:     Pablo Neira Ayuso <pablo@netfilter.org>,
        netfilter-devel@vger.kernel.org
References: <20190513095630.32443-1-pablo@netfilter.org>
 <20190513095630.32443-9-pablo@netfilter.org>
From:   Felix Kaechele <felix@kaechele.ca>
Message-ID: <0a4e3cd2-82f7-8ad6-2403-9852e34c8ac3@kaechele.ca>
Date:   Sun, 23 Jun 2019 23:44:09 -0400
MIME-Version: 1.0
In-Reply-To: <20190513095630.32443-9-pablo@netfilter.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-CA
Content-Transfer-Encoding: 7bit
X-Virus-Scanned: clamav-milter 0.101.2 at pandora.fk.cx
X-Virus-Status: Clean
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Hi there,

this patch is giving me some trouble as it breaks deletion of conntrack 
entries in software that doesn't set the version flag to anything else 
but 0.

I'm not entirely sure what is going on here but a piece of software I am 
using is now unable to delete conntrack entries and is therefor not 
functioning.
Specifically this piece of code seems to fail:
https://github.com/wlanslovenija/tunneldigger/blob/master/broker/src/tunneldigger_broker/conntrack.py#L112

That software relies heavily on libnetfilter_conntrack, which itself, 
with this patch, seems to be broken as well:

   [felix@x1 utils]$ sudo ./conntrack_create

   TEST: create conntrack (OK)

   [felix@x1 utils]$ sudo ./conntrack_delete

   TEST: delete conntrack (-1)(No such file or directory)


If in libnetfilter_conntrack I edit utils/conntrack_delete.c and change 
the line

   nfct_set_attr_u8(ct, ATTR_L3PROTO, AF_INET);


to read

   nfct_set_attr_u8(ct, ATTR_L3PROTO, AF_UNSPEC);


it starts working again.

As I said, I haven't entirely figured out why this patch breaks 
previously working software and what I need to do on my end to unbreak 
my software that is using libnetfilter_conntrack. I haven't found a way 
to make libnetfilter_conntrack set any other version than NFNETLINK_V0 
for the messages it sends, which I presume would fix my problem.

Any hints would be greatly appreciated.

Regards,
   Felix


