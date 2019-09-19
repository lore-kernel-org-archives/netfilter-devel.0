Return-Path: <SRS0=X33E=XO=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 50585C3A5A6
	for <netfilter-devel@archiver.kernel.org>; Thu, 19 Sep 2019 21:43:59 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 2A20021920
	for <netfilter-devel@archiver.kernel.org>; Thu, 19 Sep 2019 21:43:59 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2393067AbfISVn6 (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 19 Sep 2019 17:43:58 -0400
Received: from mx1.redhat.com ([209.132.183.28]:42640 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2393063AbfISVn6 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 19 Sep 2019 17:43:58 -0400
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 94139C057F20
        for <netfilter-devel@vger.kernel.org>; Thu, 19 Sep 2019 21:43:58 +0000 (UTC)
Received: from ovpn-112-60.rdu2.redhat.com (ovpn-112-60.rdu2.redhat.com [10.10.112.60])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 1DDA519C68
        for <netfilter-devel@vger.kernel.org>; Thu, 19 Sep 2019 21:43:57 +0000 (UTC)
Message-ID: <56cbe55d401f89d632278f3aad79f26402d1837f.camel@redhat.com>
Subject: netfilter.org HTTPS certificate expired today (Sept 19)
From:   Dan Williams <dcbw@redhat.com>
To:     netfilter-devel@vger.kernel.org
Date:   Thu, 19 Sep 2019 16:43:57 -0500
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.32.4 (3.32.4-1.fc30) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.32]); Thu, 19 Sep 2019 21:43:58 +0000 (UTC)
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Hi,

Just a heads-up to whoever controls the certs on netfilter.org.

Dan

