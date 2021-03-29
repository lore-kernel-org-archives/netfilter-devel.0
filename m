Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.9 required=3.0 tests=BAYES_50,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,HK_SCAM,LOTS_OF_MONEY,
	MAILING_LIST_MULTI,MILLION_USD,SPF_HELO_NONE,SPF_PASS autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1DFF9C433C1
	for <netfilter-devel@archiver.kernel.org>; Mon, 29 Mar 2021 14:47:42 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E19C461864
	for <netfilter-devel@archiver.kernel.org>; Mon, 29 Mar 2021 14:47:41 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229628AbhC2OrK (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 29 Mar 2021 10:47:10 -0400
Received: from secservnett.com ([62.173.139.46]:47878 "EHLO
        host.secservnett.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231334AbhC2OrG (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 29 Mar 2021 10:47:06 -0400
X-Greylist: delayed 3072 seconds by postgrey-1.27 at vger.kernel.org; Mon, 29 Mar 2021 10:47:06 EDT
Received: from secservnett.com (ec2-18-218-163-80.us-east-2.compute.amazonaws.com [18.218.163.80])
        by host.secservnett.com (Postfix) with ESMTPA id 51BE810C6EC0
        for <netfilter-devel@vger.kernel.org>; Mon, 29 Mar 2021 16:47:07 +0300 (MSK)
DKIM-Filter: OpenDKIM Filter v2.11.0 host.secservnett.com 51BE810C6EC0
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=secservnett.com;
        s=default; t=1617025627;
        bh=8TmItn+cxRzt7hgTnS7zinr9gyY46RNS/wowQAcy4HU=;
        h=Reply-To:From:To:Subject:Date:From;
        b=TaNAuG6d/rhdobnJlh920bVmWn6A1KUQQZtUQDe3YplyncY9p6HsnuZElVkviR3BW
         RoPgdLcZXjTHH9Ww8p4Inx37gjry7U9bOAglnjdDQJWOi7DNKNjF7hWfqQY88vnylQ
         GR+tSdVc6r9LSpgZR57w6nRbSMEctodjZCkeGDNQ=
DKIM-Filter: OpenDKIM Filter v2.11.0 host.secservnett.com 51BE810C6EC0
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=secservnett.com;
        s=default; t=1617025627;
        bh=8TmItn+cxRzt7hgTnS7zinr9gyY46RNS/wowQAcy4HU=;
        h=Reply-To:From:To:Subject:Date:From;
        b=TaNAuG6d/rhdobnJlh920bVmWn6A1KUQQZtUQDe3YplyncY9p6HsnuZElVkviR3BW
         RoPgdLcZXjTHH9Ww8p4Inx37gjry7U9bOAglnjdDQJWOi7DNKNjF7hWfqQY88vnylQ
         GR+tSdVc6r9LSpgZR57w6nRbSMEctodjZCkeGDNQ=
Reply-To: yusufhassan185@secsuremail.com
From:   Yusuf <yusufhassan185@secservnett.com>
To:     netfilter-devel@vger.kernel.org
Subject: Proposal
Date:   29 Mar 2021 13:47:06 +0000
Message-ID: <20210329134706.0BE0ADDADBBF2243@secservnett.com>
Mime-Version: 1.0
Content-Type: text/plain;
        charset="utf-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Good day.

I got your contact from a business director online and I am=20
contacting you because I have a proposition that could be of=20
great interest to you. I represent the interest of my brother in-
law who was a minister in the Syrian Government. As you probably=20
know, there is a lot of crisis and war going on currently in=20
Syria and my brother in-law has been one of the few people to=20
publicly oppose the Government's policy on this senseless war and=20
killings of innocent citizens that has been going on for a long=20
time. Due to his support for the opposition to put an end to this=20
war and install a more peaceful regime, the current Government=20
are now out to unlawfully arrest and seize all of his assets.=20
Their plan is to incapacitate and frustrate my brother in-law so=20
that he would not have the resources needed to continue his=20
campaign towards peace and justice in the country.

In the midst of all these problems he is facing and in order to=20
secure the future of his family, he has asked me to help him find=20
a foreigner with good business acumen that can help him invest=20
the total sum of $100 Million USD that he has secured with a=20
financial institution in Europe. Fortunately, at this time, the=20
Government of his country do not know of the existence of the=20
funds and he wants to move it out and invest it in a stable and=20
neutral country. I am contacting you mainly to see if you if will=20
be interested in this opportunity to help accomodate these funds=20
and invest it on our behalf. We will handle the logistics=20
involved in the movement of the funds to you and you will also be=20
greatly compensated for your efforts. Please note that this=20
transaction will be executed in a legal way and will not bring=20
any harm to you or your family.

If this proposal interests you, kindly respond so that I can give=20
you more details and we can also negotiate your compensation.

Regards,

Hassan.
