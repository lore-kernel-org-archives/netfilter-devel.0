Return-Path: <SRS0=aW9c=VA=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.5 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F356BC5B578
	for <netfilter-devel@archiver.kernel.org>; Wed,  3 Jul 2019 06:54:14 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id D0DFA21882
	for <netfilter-devel@archiver.kernel.org>; Wed,  3 Jul 2019 06:54:14 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726998AbfGCGyO (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 3 Jul 2019 02:54:14 -0400
Received: from mx1.emlix.com ([188.40.240.192]:32990 "EHLO mx1.emlix.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726327AbfGCGyO (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 3 Jul 2019 02:54:14 -0400
X-Greylist: delayed 440 seconds by postgrey-1.27 at vger.kernel.org; Wed, 03 Jul 2019 02:54:13 EDT
Received: from mailer.emlix.com (unknown [81.20.119.6])
        (using TLSv1.2 with cipher ADH-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mx1.emlix.com (Postfix) with ESMTPS id 071C360AC4
        for <netfilter-devel@vger.kernel.org>; Wed,  3 Jul 2019 08:46:52 +0200 (CEST)
To:     netfilter-devel@vger.kernel.org
From:   Stefan Laufmann <stefan.laufmann@emlix.com>
Subject: Ease usage of libnetfilter_log with C++ applications
Message-ID: <784d6af7-9530-f2f3-6c46-5ae989b82838@emlix.com>
Date:   Wed, 3 Jul 2019 08:46:51 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.0
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Hello,

thanks for your work on the netfilter project.

I just recently came across libnetfilter_log and used it inside a C++ 
application. When compiling/linking the project I ran into problems and 
discovered that libnetfilter_log in contrast to e.g. libnetfilter_queue 
and libnetfilter_conntrack lacks `extern "C"` statements in the header 
files.

Are their reasons for that? I would like to suggest to add these 
statements so the library can be easily used from a C++ context.

Kind Regards
Stefan Laufmann

--
emlix GmbH, http://www.emlix.com
Fon +49 551 30664-0, Fax +49 551 30664-11
Gothaer Platz 3, 37083 Göttingen, Germany
Sitz der Gesellschaft: Goettingen, Amtsgericht Goettingen HR B 3160
Geschaeftsfuehrung: Heike Jordan, Dr. Uwe Kracke
Ust-IdNr.: DE 205 198 055

emlix - smart embedded open source
