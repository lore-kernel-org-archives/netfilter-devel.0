Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 59392C433EF
	for <netfilter-devel@archiver.kernel.org>; Tue, 12 Apr 2022 18:28:27 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236905AbiDLSan convert rfc822-to-8bit (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 12 Apr 2022 14:30:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38202 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231543AbiDLSan (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 12 Apr 2022 14:30:43 -0400
X-Greylist: delayed 607 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Tue, 12 Apr 2022 11:28:24 PDT
Received: from localhost.localdomain (mail.redfish-solutions.com [45.33.216.244])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EFF2851331
        for <netfilter-devel@vger.kernel.org>; Tue, 12 Apr 2022 11:28:24 -0700 (PDT)
Received: from smtpclient.apple (macbook3.redfish-solutions.com [192.168.3.4])
        (authenticated bits=0)
        by localhost.localdomain (8.16.1/8.16.1) with ESMTPSA id 23CIIA1g721895
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 12 Apr 2022 12:18:10 -0600
Content-Type: text/plain;
        charset=us-ascii
Mime-Version: 1.0 (Mac OS X Mail 16.0 \(3696.80.82.1.1\))
Subject: Re: [PATCH v2 1/1] xt_ECHO, xt_TARPIT: make properly conditional on
 IPv6
From:   Philip Prindeville <philipp_subx@redfish-solutions.com>
In-Reply-To: <E3987215-778D-416E-B692-4C0C5C6FE536@redfish-solutions.com>
Date:   Tue, 12 Apr 2022 12:18:09 -0600
Cc:     Jeremy Sowden <jeremy@azazel.net>, netfilter-devel@vger.kernel.org
Content-Transfer-Encoding: 8BIT
Message-Id: <6B9350FD-9052-460F-8AA2-7211B1DF3DAF@redfish-solutions.com>
References: <20210926195734.702772-1-philipp@redfish-solutions.com>
 <5s32r847-4op5-70s2-7o9n-4968n7rso321@vanv.qr>
 <05A51779-4B94-49BA-B1B8-6CA5BE695D80@redfish-solutions.com>
 <Yfe48T7Nxpzp20wL@azazel.net>
 <E7F7FB17-246B-4EFF-9449-FE1764F9816E@redfish-solutions.com>
 <Yfgq6qWKgTV9NEkg@azazel.net>
 <6961516B-8252-404F-B302-33E39EEBC9F3@redfish-solutions.com>
 <o9236r6-q17s-4p97-r8o0-rnr66543s30@vanv.qr>
 <E3987215-778D-416E-B692-4C0C5C6FE536@redfish-solutions.com>
To:     Jan Engelhardt <jengelh@inai.de>
X-Mailer: Apple Mail (2.3696.80.82.1.1)
X-Scanned-By: MIMEDefang 2.85 on 192.168.4.3
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org



> On Feb 1, 2022, at 11:22 AM, Philip Prindeville <philipp_subx@redfish-solutions.com> wrote:
> 
> 
> 
>> On Feb 1, 2022, at 10:32 AM, Jan Engelhardt <jengelh@inai.de> wrote:
>> 
>> 
>> On Monday 2022-01-31 19:35, Philip Prindeville wrote:
>>> 
>>> That would do it.
>>> When is 3.19 or 4.0 due out?
>> 
>> No particular plans, therefore I tagged 3.19 for your enjoyment.
> 
> 
> Cheers.
> 
> Rebuilding the packaging for openwrt now.
> 


Update: stalled on getting the package maintainer for openwrt to approve my version bump PR.

