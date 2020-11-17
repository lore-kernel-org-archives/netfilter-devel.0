Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.6 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,URI_HEX autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9B9FBC5519F
	for <netfilter-devel@archiver.kernel.org>; Tue, 17 Nov 2020 18:08:49 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 59F1B2465E
	for <netfilter-devel@archiver.kernel.org>; Tue, 17 Nov 2020 18:08:49 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728517AbgKQSI3 convert rfc822-to-8bit (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 17 Nov 2020 13:08:29 -0500
Received: from mail.redfish-solutions.com ([45.33.216.244]:42960 "EHLO
        mail.redfish-solutions.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725808AbgKQSI2 (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 17 Nov 2020 13:08:28 -0500
Received: from [192.168.3.4] (174-27-108-50.bois.qwest.net [174.27.108.50] (may be forged))
        (authenticated bits=0)
        by mail.redfish-solutions.com (8.15.2/8.15.2) with ESMTPSA id 0AHI8Ooq318121
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 17 Nov 2020 11:08:24 -0700
Content-Type: text/plain;
        charset=utf-8
Mime-Version: 1.0 (Mac OS X Mail 14.0 \(3654.20.0.2.21\))
Subject: Re: Issues w/ db-ip country database
From:   Philip Prindeville <philipp_subx@redfish-solutions.com>
In-Reply-To: <2qp4q17-pqpo-2q0-24r0-q466sro3pp44@vanv.qr>
Date:   Tue, 17 Nov 2020 11:08:23 -0700
Cc:     netfilter-devel@vger.kernel.org
Content-Transfer-Encoding: 8BIT
Message-Id: <B6D36DF0-178A-4985-AB85-4BEE2AAD9116@redfish-solutions.com>
References: <8B419AF6-031F-4F6A-A3FB-3118780F6119@redfish-solutions.com>
 <2qp4q17-pqpo-2q0-24r0-q466sro3pp44@vanv.qr>
To:     Jan Engelhardt <jengelh@inai.de>
X-Mailer: Apple Mail (2.3654.20.0.2.21)
X-Scanned-By: MIMEDefang 2.84 on 192.168.1.3
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org


> On Nov 17, 2020, at 1:06 AM, Jan Engelhardt <jengelh@inai.de> wrote:
> 
> 
> On Tuesday 2020-11-17 04:36, Philip Prindeville wrote:
>> 
>> Many known blocks owned by Chinanet for instance, don’t show up as /11 or /13
>> networks, but as dozens of /23 networks instead in China, the US, Japan, and
>> Canada. Clearly not correct.
> 
> Do you have some sample netnumbers so that we can look at it from our side?


Okay, sure.

212.174.0.0/15 supposedly is a single block of TurkTelecom, but the database shows it as being 296 subnets, mostly /23’s.

183.128.0.0/11 is supposedly a single block of Chinanet, but the database shows it as being 329 subnets (164 supposedly in the US), again mostly /23’s and /22’s:

...
183.136.192.0,183.136.193.99,CN
183.136.193.100,183.136.193.255,US
...

I picked one of those US subnets and did a traceroute to it:

% traceroute 183.136.193.100
traceroute to 183.136.193.100 (183.136.193.100), 30 hops max, 60 byte packets
 1  openwrt.redfish-solutions.com (192.168.1.252)  0.397 ms  0.225 ms  0.355 ms
 2  172.18.216.1 (172.18.216.1)  3.111 ms  2.756 ms  2.429 ms
 3  ip-66-232-69-145.syringanetworks.net (66.232.69.145)  2.158 ms  1.897 ms  2.316 ms
 4  * * *
 5  be5991.rcr51.boi01.atlas.cogentco.com (38.122.5.5)  3.117 ms be4798.rcr51.boi01.atlas.cogentco.com (38.122.5.161)  2.688 ms be5991.rcr51.boi01.atlas.cogentco.com (38.122.5.5)  3.680 ms
 6  be2541.ccr32.slc01.atlas.cogentco.com (154.54.3.121)  10.118 ms be2539.ccr21.slc01.atlas.cogentco.com (154.54.3.129)  10.236 ms  10.734 ms
 7  be3110.ccr22.sfo01.atlas.cogentco.com (154.54.44.141)  25.536 ms  25.243 ms be3109.ccr21.sfo01.atlas.cogentco.com (154.54.44.137)  25.049 ms
 8  be3670.ccr41.sjc03.atlas.cogentco.com (154.54.43.14)  27.162 ms  26.952 ms  26.714 ms
 9  38.104.138.106 (38.104.138.106)  34.213 ms  33.847 ms  33.635 ms
10  202.97.50.73 (202.97.50.73)  29.346 ms  29.148 ms  29.460 ms
11  202.97.50.125 (202.97.50.125)  162.534 ms  162.206 ms  161.807 ms
12  202.97.90.30 (202.97.90.30)  157.568 ms  156.878 ms  156.387 ms
13  202.97.50.133 (202.97.50.133)  183.191 ms  182.953 ms  182.695 ms
14  202.97.82.18 (202.97.82.18)  183.290 ms  183.048 ms  182.813 ms
15  61.153.82.134 (61.153.82.134)  187.541 ms 222.4.175.61.dial.nb.zj.dynamic.163data.com.cn (61.175.4.222)  188.273 ms 61.153.82.134 (61.153.82.134)  188.029 ms
16  * * *
17  * * *
18  * * *
^C

