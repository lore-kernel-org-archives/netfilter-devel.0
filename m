Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C736CC433F5
	for <netfilter-devel@archiver.kernel.org>; Mon, 31 Jan 2022 18:27:33 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350839AbiAaS1c convert rfc822-to-8bit (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 31 Jan 2022 13:27:32 -0500
Received: from mail.redfish-solutions.com ([45.33.216.244]:33796 "EHLO
        mail.redfish-solutions.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1351103AbiAaS1b (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 31 Jan 2022 13:27:31 -0500
Received: from smtpclient.apple (macbook3.redfish-solutions.com [192.168.3.4])
        (authenticated bits=0)
        by mail.redfish-solutions.com (8.16.1/8.16.1) with ESMTPSA id 20VIRPaV275912
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 31 Jan 2022 11:27:26 -0700
Content-Type: text/plain;
        charset=us-ascii
Mime-Version: 1.0 (Mac OS X Mail 15.0 \(3693.40.0.1.81\))
Subject: Re: [PATCH v2 1/1] xt_ECHO, xt_TARPIT: make properly conditional on
 IPv6
From:   Philip Prindeville <philipp_subx@redfish-solutions.com>
In-Reply-To: <Yfe48T7Nxpzp20wL@azazel.net>
Date:   Mon, 31 Jan 2022 11:27:25 -0700
Cc:     Jan Engelhardt <jengelh@inai.de>, netfilter-devel@vger.kernel.org
Content-Transfer-Encoding: 8BIT
Message-Id: <E7F7FB17-246B-4EFF-9449-FE1764F9816E@redfish-solutions.com>
References: <20210926195734.702772-1-philipp@redfish-solutions.com>
 <5s32r847-4op5-70s2-7o9n-4968n7rso321@vanv.qr>
 <05A51779-4B94-49BA-B1B8-6CA5BE695D80@redfish-solutions.com>
 <Yfe48T7Nxpzp20wL@azazel.net>
To:     Jeremy Sowden <jeremy@azazel.net>
X-Mailer: Apple Mail (2.3693.40.0.1.81)
X-Scanned-By: MIMEDefang 2.85 on 192.168.4.3
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org



> On Jan 31, 2022, at 3:24 AM, Jeremy Sowden <jeremy@azazel.net> wrote:
> 
> On 2022-01-30, at 21:53:26 -0700, Philip Prindeville wrote:
>> On Sep 28, 2021, at 3:43 AM, Jan Engelhardt <jengelh@inai.de> wrote:
>>> On Sunday 2021-09-26 21:57, Philip Prindeville wrote:
>>>> From: Philip Prindeville <philipp@redfish-solutions.com>
>>>> 
>>>> Not all modules compile equally well when CONFIG_IPv6 is disabled.
>>>> 
>>>> 	{
>>>> 		.name       = "ECHO",
>>>> 		.revision   = 0,
>>>> -		.family     = NFPROTO_IPV6,
>>>> +		.family     = NFPROTO_IPV4,
>>>> 		.proto      = IPPROTO_UDP,
>>>> 		.table      = "filter",
>>>> -		.target     = echo_tg6,
>>>> +		.target     = echo_tg4,
>>>> 		.me         = THIS_MODULE,
>>>> 	},
>>>> +#ifdef WITH_IPV6
>>> 
>>> I put the original order back, makes the diff smaller.
>>> So added.
>> 
>> Did this get merged?
> 
> It did.  It's currently at the tip of master.


Did we change repo sites?  I'm not seeing it here:

https://sourceforge.net/p/xtables-addons/xtables-addons/ci/e3ae438e2e23f0849c756604a4518315e097ad62/log/?path=/extensions/xt_ECHO.c


> 
>> Last commit I saw was:
>> 
>> commit c90ecf4320289e2567f2b6dee0c6c21d9d51b145
>> Author: Jeff Carlson <jeff@ultimateevil.org>
>> Date:   Sun Aug 15 18:59:25 2021 -0700
>> 
>>    pknock:  added UDP options to help and made whitespace consistent
> 
> J.

