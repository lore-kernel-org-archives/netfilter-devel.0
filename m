Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.2 required=3.0 tests=BAYES_00,
	FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9F251C433B4
	for <netfilter-devel@archiver.kernel.org>; Thu, 15 Apr 2021 14:58:36 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 86E1D613FA
	for <netfilter-devel@archiver.kernel.org>; Thu, 15 Apr 2021 14:58:36 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234211AbhDOO66 (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 15 Apr 2021 10:58:58 -0400
Received: from forward101j.mail.yandex.net ([5.45.198.241]:54346 "EHLO
        forward101j.mail.yandex.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S234238AbhDOO44 (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 15 Apr 2021 10:56:56 -0400
Received: from iva6-6aa4ee7025da.qloud-c.yandex.net (iva6-6aa4ee7025da.qloud-c.yandex.net [IPv6:2a02:6b8:c0c:6106:0:640:6aa4:ee70])
        by forward101j.mail.yandex.net (Yandex) with ESMTP id 636B41BE0F93;
        Thu, 15 Apr 2021 17:56:31 +0300 (MSK)
Received: from iva6-2d18925256a6.qloud-c.yandex.net (iva6-2d18925256a6.qloud-c.yandex.net [2a02:6b8:c0c:7594:0:640:2d18:9252])
        by iva6-6aa4ee7025da.qloud-c.yandex.net (mxback/Yandex) with ESMTP id 05tJ1gQzvs-uVJ4C634;
        Thu, 15 Apr 2021 17:56:31 +0300
Authentication-Results: iva6-6aa4ee7025da.qloud-c.yandex.net; dkim=pass
Received: by iva6-2d18925256a6.qloud-c.yandex.net (smtp/Yandex) with ESMTPSA id FgieCsGGCy-uTKSNC7W;
        Thu, 15 Apr 2021 17:56:30 +0300
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits))
        (Client certificate not present)
From:   Michal Soltys <msoltyspl@yandex.pl>
Subject: Re: [PATCH nf-next] netfilter: Dissect flow after packet mangling
To:     Ido Schimmel <idosch@idosch.org>
Cc:     David Ahern <dsahern@gmail.com>, netfilter-devel@vger.kernel.org,
        coreteam@netfilter.org, pablo@netfilter.org, kadlec@netfilter.org,
        fw@strlen.de, dsahern@kernel.org, roopa@nvidia.com,
        nikolay@nvidia.com, mlxsw@nvidia.com,
        Ido Schimmel <idosch@nvidia.com>
References: <20210411193251.1220655-1-idosch@idosch.org>
 <be90fae7-f634-1f54-992e-226c442fb894@gmail.com>
 <YHPt5nyML4I51COy@shredder.lan>
 <c1c83fb7-d074-a0a8-0766-f8844c1e7e23@yandex.pl>
 <YHSO+ieteZ6XHnjT@shredder.lan>
Message-ID: <cecee118-0c1b-c36d-cb0b-f130c3d94b7f@yandex.pl>
Date:   Thu, 15 Apr 2021 16:56:27 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.9.0
MIME-Version: 1.0
In-Reply-To: <YHSO+ieteZ6XHnjT@shredder.lan>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US-large
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On 4/12/21 8:18 PM, Ido Schimmel wrote:
> On Mon, Apr 12, 2021 at 03:28:21PM +0200, Michal Soltys wrote:
>> On 4/12/21 8:51 AM, Ido Schimmel wrote:
>>> On Sun, Apr 11, 2021 at 06:18:05PM -0700, David Ahern wrote:
>>>> On 4/11/21 1:32 PM, Ido Schimmel wrote:
>>>>> From: Ido Schimmel <idosch@nvidia.com>
>>>>> <cut>
>>>>>
>>>>
>>>> Once this goes in, can you add tests to one of the selftest scripts
>>>> (e.g., fib_rule_tests.sh)?
>>>
>>> Yes. I used Michal's scripts from here [1] to test. Will try to simplify
>>> it for a test case.
>>>
>>> [1] https://lore.kernel.org/netdev/6b707dde-c6f0-ca3e-e817-a09c1e6b3f00@yandex.pl/
>>>
>>
>> Regarding those scripts:
>>
>> - the commented out `-j TOS --set-tos 0x02` falls into ECN bits, so it's
>> somewhat incorrect/obsolete
>> - the uidrange selector (that was also ignored) is missing in the sequence
>> of ip rules
> 
> I verified that with the patch, after adding mangling rules with
> ip{,6}tables, packets continue to flow via right2. Can you test the
> patch and verify it works as you expect?
> 

Tested today - all recently added selectors are working correctly. Thanks.
