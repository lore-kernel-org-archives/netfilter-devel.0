Return-Path: <SRS0=ZKiM=DX=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: **
X-Spam-Status: No, score=2.1 required=3.0 tests=BAYES_40,DEAR_SOMETHING,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B9B25C433DF
	for <netfilter-devel@archiver.kernel.org>; Fri, 16 Oct 2020 06:45:22 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 26811207C4
	for <netfilter-devel@archiver.kernel.org>; Fri, 16 Oct 2020 06:45:22 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=ruhr-uni-bochum.de header.i=@ruhr-uni-bochum.de header.b="nYWt9A0T"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2394360AbgJPGpV (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Fri, 16 Oct 2020 02:45:21 -0400
Received: from out3.mail.ruhr-uni-bochum.de ([134.147.53.155]:46019 "EHLO
        out3.mail.ruhr-uni-bochum.de" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2389811AbgJPGpV (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 16 Oct 2020 02:45:21 -0400
X-Greylist: delayed 532 seconds by postgrey-1.27 at vger.kernel.org; Fri, 16 Oct 2020 02:45:20 EDT
Received: from mx3.mail.ruhr-uni-bochum.de (localhost [127.0.0.1])
        by out3.mail.ruhr-uni-bochum.de (Postfix mo-ext) with ESMTP id 4CCGdJ6C91z8SJW
        for <netfilter-devel@vger.kernel.org>; Fri, 16 Oct 2020 08:36:20 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=ruhr-uni-bochum.de;
        s=mail-2017; t=1602830180;
        bh=uEp+7Q05lW9n/D32M21eqG1/5kxtS1jDhuLqSVT17E4=;
        h=Date:To:From:Subject:From;
        b=nYWt9A0Te7JXnWJ39UxTvRdY3wXy5IcGt4JjIaVVUm8pkYUDVJkwRyWF/GGTdltpW
         FN69F+ZVuXvcvxAPkBKKyvJommhfuAFNJNTSltqdEl1hK8+/wJdJYUPAucB+ERgKvH
         8BvLjC5XGKCKvucsWFrKfgK0nYSIozsIQTuCIZ5Q=
Received: from out3.mail.ruhr-uni-bochum.de (localhost [127.0.0.1])
        by mx3.mail.ruhr-uni-bochum.de (Postfix idis) with ESMTP id 4CCGdJ4fjmz8ScZ
        for <netfilter-devel@vger.kernel.org>; Fri, 16 Oct 2020 08:36:20 +0200 (CEST)
X-Envelope-Sender: <syssecsurvey@ruhr-uni-bochum.de>
X-Auto-Response-Suppress: All
X-RUB-Notes: Internal Noautoreply origin=134.147.203.182
Received: from survey.syssec.ruhr-uni-bochum.de (survey.syssec.ruhr-uni-bochum.de [134.147.203.182])
        by out3.mail.ruhr-uni-bochum.de (Postfix mi-int) with ESMTP id 4CCGdJ25lKz8Sdp
        for <netfilter-devel@vger.kernel.org>; Fri, 16 Oct 2020 08:36:20 +0200 (CEST)
X-Virus-Status: Clean
X-Virus-Scanned: clamav-milter 0.102.1 at mx3.mail.ruhr-uni-bochum.de
Received: by survey.syssec.ruhr-uni-bochum.de (Postfix, from userid 33)
        id 1EC2F1FA81; Fri, 16 Oct 2020 08:36:21 +0200 (CEST)
Date:   Fri, 16 Oct 2020 08:36:21 +0200
To:     netfilter-devel@vger.kernel.org
From:   "Thorsten Holz, Ruhr University Bochum" 
        <syssecsurvey@ruhr-uni-bochum.de>
Auto-Submitted: auto-generated
Subject: University study about the use of web technologies on websites
Message-ID: <cRDhBH9H3evN6kG5KOAVkwh1mQlqux21SfzRDw2KSNg@survey.syssec.rub.de>
X-Mailer: PHPMailer 6.0.7 (https://github.com/PHPMailer/PHPMailer)
X-surveyid: 218135
X-tokenid: 6jvwOdc1rfhPWsq
X-Surveymailer: SysSec LimeSurvey Emailer (LimeSurvey.org)
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Dear web professional,

We invite you to participate in a research study conducted at Ruhr University Bochum (Germany) in cooperation with Leibniz University Hannover (Germany) and the University of Michigan (USA). We found your email address (netfilter-devel@vger.kernel.org) on the website netfilter.org.

We are interested in understanding how web technologies are integrated into and used by websites. We are looking for perspectives from a wide variety of people working on or with websites, such as developers, content creators, marketing, customer service, legal, and others. Our research relies on the generous help of interested web professionals like you!

This online survey will take about 20-25 minutes to complete.

You are eligible to participate in the study if you

(1) are at least 18 years old,
(2) are involved with websites in some capacity (e. g., their design, development, deployment, maintenance, and / or management), and
(3) are comfortable completing the survey in English.

In case you do not meet these requirements, you can still help us by forwarding this email to someone involved with the website netfilter.org.

Participate!
To participate, please use this link to access our survey: https://survey.syssec.ruhr-uni-bochum.de/index.php?r=survey/index&sid=218135&token=6jvwOdc1rfhPWsq&lang=en

Other Options:
* If you do not want to participate in this survey and do not want us to send you any further emails, please click the following link: https://survey.syssec.ruhr-uni-bochum.de/index.php?r=optout/tokens&surveyid=218135&langcode=en&token=6jvwOdc1rfhPWsq
* If you would like to reverse your opt-out decision, please click the following link: https://survey.syssec.ruhr-uni-bochum.de/index.php?r=optin/tokens&surveyid=218135&langcode=en&token=6jvwOdc1rfhPWsq

If you have any further questions, please contact us at syssecsurvey@ruhr-uni-bochum.de.

Thank you for helping our research!

Sincerely,

Prof. Thorsten Holz (Ruhr University Bochum)
Prof. Sascha Fahl (Leibniz University Hannover)
Prof. Florian Schaub (University of Michigan)
