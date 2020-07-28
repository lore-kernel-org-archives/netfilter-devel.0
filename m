Return-Path: <SRS0=tHxH=BH=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.0 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 757B9C433DF
	for <netfilter-devel@archiver.kernel.org>; Tue, 28 Jul 2020 23:02:04 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5FBAC2083B
	for <netfilter-devel@archiver.kernel.org>; Tue, 28 Jul 2020 23:02:04 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729865AbgG1XCE (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 28 Jul 2020 19:02:04 -0400
Received: from mail.redfish-solutions.com ([45.33.216.244]:51160 "EHLO
        mail.redfish-solutions.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1729824AbgG1XCE (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 28 Jul 2020 19:02:04 -0400
X-Greylist: delayed 376 seconds by postgrey-1.27 at vger.kernel.org; Tue, 28 Jul 2020 19:02:03 EDT
Received: from macbook3.redfish-solutions.com (macbook3.redfish-solutions.com [192.168.1.18])
        (authenticated bits=0)
        by mail.redfish-solutions.com (8.15.2/8.15.2) with ESMTPSA id 06SMuDUt101901
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 28 Jul 2020 16:56:13 -0600
Content-Type: text/plain;
        charset=us-ascii
Mime-Version: 1.0 (Mac OS X Mail 13.4 \(3608.120.23.2.1\))
Subject: Re: Xtables-addons 3.10 (Re: [PATCH 1/1] geoip: add quiet flag to
 xt_geoip_build)
From:   Philip Prindeville <philipp_subx@redfish-solutions.com>
In-Reply-To: <nycvar.YFH.7.77.849.2007281355020.19722@n3.vanv.qr>
Date:   Tue, 28 Jul 2020 16:56:13 -0600
Cc:     netfilter-devel@vger.kernel.org
Content-Transfer-Encoding: 7bit
Message-Id: <5262D0D7-8F79-46FA-B2FC-CE28F746A8E3@redfish-solutions.com>
References: <20200525200542.29000-1-philipp@redfish-solutions.com>
 <nycvar.YFH.7.77.849.2005261459250.6469@n3.vanv.qr>
 <52068C27-7A75-4F28-8DE2-C13CF196E2B5@redfish-solutions.com>
 <nycvar.YFH.7.77.849.2007281355020.19722@n3.vanv.qr>
To:     Jan Engelhardt <jengelh@inai.de>
X-Mailer: Apple Mail (2.3608.120.23.2.1)
X-Scanned-By: MIMEDefang 2.84 on 192.168.1.3
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org



> On Jul 28, 2020, at 6:01 AM, Jan Engelhardt <jengelh@inai.de> wrote:
> 
> On Sunday 2020-07-26 19:32, Philip Prindeville wrote:
>>> On May 26, 2020, at 6:59 AM, Jan Engelhardt <jengelh@inai.de> wrote:
>>> On Monday 2020-05-25 22:05, Philip Prindeville wrote:
>> 
>>>> Conceivably someone might want to run a refresh of the geoip database
>>>> from within a script, particularly an unattended script such as a cron
>>>> job.  Don't generate output in that case.
>> 
>> BTW, when is 3.10 due out?
> 
> I have tagged 3.10 and produced the tarballs.
> Take note that the homepage etc. has moved to
> 
> 	https://inai.de/projects/xtables-addons/
> 
> Downloads, new git location, and redirects from sf.net
> should be all there.


Awesome. Thanks!

