Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4806DC433EF
	for <netfilter-devel@archiver.kernel.org>; Mon, 31 Jan 2022 18:35:57 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238324AbiAaSf4 convert rfc822-to-8bit (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 31 Jan 2022 13:35:56 -0500
Received: from mail.redfish-solutions.com ([45.33.216.244]:33798 "EHLO
        mail.redfish-solutions.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1356632AbiAaSf4 (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 31 Jan 2022 13:35:56 -0500
Received: from smtpclient.apple (macbook3.redfish-solutions.com [192.168.3.4])
        (authenticated bits=0)
        by mail.redfish-solutions.com (8.16.1/8.16.1) with ESMTPSA id 20VIZp39275976
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 31 Jan 2022 11:35:51 -0700
Content-Type: text/plain;
        charset=us-ascii
Mime-Version: 1.0 (Mac OS X Mail 15.0 \(3693.40.0.1.81\))
Subject: Re: [PATCH v2 1/1] xt_ECHO, xt_TARPIT: make properly conditional on
 IPv6
From:   Philip Prindeville <philipp_subx@redfish-solutions.com>
In-Reply-To: <Yfgq6qWKgTV9NEkg@azazel.net>
Date:   Mon, 31 Jan 2022 11:35:51 -0700
Cc:     Jan Engelhardt <jengelh@inai.de>, netfilter-devel@vger.kernel.org
Content-Transfer-Encoding: 8BIT
Message-Id: <6961516B-8252-404F-B302-33E39EEBC9F3@redfish-solutions.com>
References: <20210926195734.702772-1-philipp@redfish-solutions.com>
 <5s32r847-4op5-70s2-7o9n-4968n7rso321@vanv.qr>
 <05A51779-4B94-49BA-B1B8-6CA5BE695D80@redfish-solutions.com>
 <Yfe48T7Nxpzp20wL@azazel.net>
 <E7F7FB17-246B-4EFF-9449-FE1764F9816E@redfish-solutions.com>
 <Yfgq6qWKgTV9NEkg@azazel.net>
To:     Jeremy Sowden <jeremy@azazel.net>
X-Mailer: Apple Mail (2.3693.40.0.1.81)
X-Scanned-By: MIMEDefang 2.85 on 192.168.4.3
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org



> On Jan 31, 2022, at 11:31 AM, Jeremy Sowden <jeremy@azazel.net> wrote:
> 
> On 2022-01-31, at 11:27:25 -0700, Philip Prindeville wrote:
>> On Jan 31, 2022, at 3:24 AM, Jeremy Sowden <jeremy@azazel.net> wrote:
>>> On 2022-01-30, at 21:53:26 -0700, Philip Prindeville wrote:
>>>> On Sep 28, 2021, at 3:43 AM, Jan Engelhardt <jengelh@inai.de> wrote:
>>>>> [snip]
>>>> 
>>>> Did this get merged?
>>> 
>>> It did.  It's currently at the tip of master.
>> 
>> Did we change repo sites?  I'm not seeing it here:
>> 
>> https://sourceforge.net/p/xtables-addons/xtables-addons/ci/e3ae438e2e23f0849c756604a4518315e097ad62/log/?path=/extensions/xt_ECHO.c
> 
> Yes:
> 
>  https://inai.de/projects/xtables-addons/
> 
> J.


That would do it.

When is 3.19 or 4.0 due out?

Thanks,

-Philip

