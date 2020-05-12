Return-Path: <SRS0=em6Q=62=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.7 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C246ECA90AF
	for <netfilter-devel@archiver.kernel.org>; Tue, 12 May 2020 16:51:07 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 96CFF206B9
	for <netfilter-devel@archiver.kernel.org>; Tue, 12 May 2020 16:51:07 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728934AbgELQvH convert rfc822-to-8bit (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 12 May 2020 12:51:07 -0400
Received: from mail.redfish-solutions.com ([45.33.216.244]:41976 "EHLO
        mail.redfish-solutions.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728396AbgELQvG (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 12 May 2020 12:51:06 -0400
Received: from macbook2.redfish-solutions.com (macbook2.redfish-solutions.com [192.168.1.39])
        (authenticated bits=0)
        by mail.redfish-solutions.com (8.15.2/8.15.2) with ESMTPSA id 04CGp2Eg030553
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 12 May 2020 10:51:02 -0600
Content-Type: text/plain;
        charset=utf-8
Mime-Version: 1.0 (Mac OS X Mail 13.4 \(3608.80.23.2.2\))
Subject: Re: [PATCH v1 1/1] xtables-addons: geoip: update scripts for DBIP
 names, etc.
From:   Philip Prindeville <philipp_subx@redfish-solutions.com>
In-Reply-To: <nycvar.YFH.7.77.849.2005121118260.6562@n3.vanv.qr>
Date:   Tue, 12 May 2020 10:51:02 -0600
Cc:     netfilter-devel@vger.kernel.org
Content-Transfer-Encoding: 8BIT
Message-Id: <BC0C3307-DA4C-405E-8B3D-98A752B87EFC@redfish-solutions.com>
References: <20200512002747.2108-1-philipp@redfish-solutions.com>
 <nycvar.YFH.7.77.849.2005121118260.6562@n3.vanv.qr>
To:     Jan Engelhardt <jengelh@inai.de>
X-Mailer: Apple Mail (2.3608.80.23.2.2)
X-Scanned-By: MIMEDefang 2.84 on 192.168.1.3
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org



> On May 12, 2020, at 3:30 AM, Jan Engelhardt <jengelh@inai.de> wrote:
> 
> 
> On Tuesday 2020-05-12 02:27, Philip Prindeville wrote:
>> 
>> Also change the default destination directory to /usr/share/xt_geoip
>> as most distros use this now.  Update the documentation.
> 
> This would break the current expectation that an unprivileged user,
> using an unmodified incantation of the command, can run the program
> and not run into a permission error.
> 
> Maybe there are some "nicer" approaches? I'm calling for further inspirations.


I’m open to suggestions.

We could default it to a system path only when running as root, for instance.


> 
>> -my $target_dir = ".";
>> +my $target_dir = "/usr/share/xt_geoip";

