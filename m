Return-Path: <SRS0=SqQQ=RB=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A2C7AC43381
	for <netfilter-devel@archiver.kernel.org>; Tue, 26 Feb 2019 00:27:56 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 7BCE02184E
	for <netfilter-devel@archiver.kernel.org>; Tue, 26 Feb 2019 00:27:56 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729403AbfBZA1z (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 25 Feb 2019 19:27:55 -0500
Received: from mail.ngtech.co.il ([84.95.212.160]:48986 "EHLO
        mail.ngtech.co.il" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728953AbfBZA1z (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 25 Feb 2019 19:27:55 -0500
X-Greylist: delayed 422 seconds by postgrey-1.27 at vger.kernel.org; Mon, 25 Feb 2019 19:27:54 EST
Received: from ELIEZERLAP1 (unknown [10.0.0.75])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.ngtech.co.il (Postfix) with ESMTPSA id D23F3607B1F0;
        Tue, 26 Feb 2019 02:20:51 +0200 (IST)
From:   <eliezer@ngtech.co.il>
To:     "'Jozsef Kadlecsik'" <kadlec@blackhole.kfki.hu>
Cc:     <netfilter@vger.kernel.org>, <netfilter-devel@vger.kernel.org>
References: <alpine.DEB.2.20.1812111334220.25036@blackhole.kfki.hu>
In-Reply-To: <alpine.DEB.2.20.1812111334220.25036@blackhole.kfki.hu>
Subject: RE: [ANNOUNCE] ipset 7.1 released
Date:   Tue, 26 Feb 2019 02:20:50 +0200
Message-ID: <01cd01d4cd69$20d81800$62884800$@ngtech.co.il>
MIME-Version: 1.0
Content-Type: text/plain;
        charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Microsoft Outlook 16.0
Content-Language: en-us
Thread-Index: AQFsYD5OTZeF5i0g5D9yG98D1m+qNqbCEVKw
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Can you refer me to an example to what it would be usefull fo
ansible,chef,puppet?
Do you mean that it would be easier to configure ipset with them?

Thanks,
Eliezer

----
Eliezer Croitoru
Linux System Administrator
Mobile: +972-5-28704261
Email: eliezer@ngtech.co.il


-----Original Message-----
From: netfilter-owner@vger.kernel.org <netfilter-owner@vger.kernel.org> On
Behalf Of Jozsef Kadlecsik
Sent: Tuesday, December 11, 2018 14:44
To: netfilter@vger.kernel.org; netfilter-devel@vger.kernel.org
Subject: [ANNOUNCE] ipset 7.1 released

Hi,

I'm happy to announce ipset 7.1. Besides the usual bugfixes there's a new 
feature: sorting is implemented for the hash types of the sets, which is 
useful for config management systems (ansible, chef, puppet, etc.).

Userspace changes:
  - Add compatibility support for strscpy()
  - Correct the manpage about the sort option
  - Add missing functions to libipset.map
  - configure.ac: Fix build regression on RHEL/CentOS/SL
    (Serhey Popovych)
  - Implement sorting for hash types in the ipset tool
  - Fix to list/save into file specified by option
    (reported by Isaac Good)
Kernel part changes:
  - netfilter/ipset: replace a strncpy() with strscpy() (Qian Cai)
  - netfilter: ipset: fix ip_set_byindex function (Florent Fourcot)
  - netfilter: ipset: do not call ipset_nest_end after nla_nest_cancel
    (Pan Bian)
  - Correct workaround in patch "Fix calling ip_set() macro at dumping"

You can download the source code of ipset from:
        http://ipset.netfilter.org
        ftp://ftp.netfilter.org/pub/ipset/
        git://git.netfilter.org/ipset.git

Best regards,
Jozsef
-
E-mail  : kadlec@blackhole.kfki.hu, kadlecsik.jozsef@wigner.mta.hu
PGP key : http://www.kfki.hu/~kadlec/pgp_public_key.txt
Address : Wigner Research Centre for Physics, Hungarian Academy of Sciences
          H-1525 Budapest 114, POB. 49, Hungary

