Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A0B17C433EF
	for <netfilter-devel@archiver.kernel.org>; Mon, 31 Jan 2022 05:11:06 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231447AbiAaFLF (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 31 Jan 2022 00:11:05 -0500
Received: from mail.redfish-solutions.com ([45.33.216.244]:33794 "EHLO
        mail.redfish-solutions.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230185AbiAaFLF (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 31 Jan 2022 00:11:05 -0500
X-Greylist: delayed 1055 seconds by postgrey-1.27 at vger.kernel.org; Mon, 31 Jan 2022 00:11:05 EST
Received: from smtpclient.apple (macbook3.redfish-solutions.com [192.168.3.4])
        (authenticated bits=0)
        by mail.redfish-solutions.com (8.16.1/8.16.1) with ESMTPSA id 20V4rQmv271807
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Sun, 30 Jan 2022 21:53:26 -0700
Content-Type: text/plain;
        charset=us-ascii
Mime-Version: 1.0 (Mac OS X Mail 15.0 \(3693.40.0.1.81\))
Subject: Re: [PATCH v2 1/1] xt_ECHO, xt_TARPIT: make properly conditional on
 IPv6
From:   Philip Prindeville <philipp_subx@redfish-solutions.com>
In-Reply-To: <5s32r847-4op5-70s2-7o9n-4968n7rso321@vanv.qr>
Date:   Sun, 30 Jan 2022 21:53:26 -0700
Cc:     netfilter-devel@vger.kernel.org
Content-Transfer-Encoding: 7bit
Message-Id: <05A51779-4B94-49BA-B1B8-6CA5BE695D80@redfish-solutions.com>
References: <20210926195734.702772-1-philipp@redfish-solutions.com>
 <5s32r847-4op5-70s2-7o9n-4968n7rso321@vanv.qr>
To:     Jan Engelhardt <jengelh@inai.de>
X-Mailer: Apple Mail (2.3693.40.0.1.81)
X-Scanned-By: MIMEDefang 2.85 on 192.168.4.3
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Did this get merged?

Last commit I saw was:

commit c90ecf4320289e2567f2b6dee0c6c21d9d51b145
Author: Jeff Carlson <jeff@ultimateevil.org>
Date:   Sun Aug 15 18:59:25 2021 -0700

    pknock:  added UDP options to help and made whitespace consistent


Thanks


> On Sep 28, 2021, at 3:43 AM, Jan Engelhardt <jengelh@inai.de> wrote:
> 
> On Sunday 2021-09-26 21:57, Philip Prindeville wrote:
> 
>> From: Philip Prindeville <philipp@redfish-solutions.com>
>> 
>> Not all modules compile equally well when CONFIG_IPv6 is disabled.
>> 
>> 	{
>> 		.name       = "ECHO",
>> 		.revision   = 0,
>> -		.family     = NFPROTO_IPV6,
>> +		.family     = NFPROTO_IPV4,
>> 		.proto      = IPPROTO_UDP,
>> 		.table      = "filter",
>> -		.target     = echo_tg6,
>> +		.target     = echo_tg4,
>> 		.me         = THIS_MODULE,
>> 	},
>> +#ifdef WITH_IPV6
> 
> I put the original order back, makes the diff smaller.
> So added.
> 

