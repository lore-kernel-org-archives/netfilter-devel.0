Return-Path: <SRS0=lkya=TV=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_NEOMUTT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5EC5FC04AAF
	for <netfilter-devel@archiver.kernel.org>; Tue, 21 May 2019 17:35:59 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 351A221019
	for <netfilter-devel@archiver.kernel.org>; Tue, 21 May 2019 17:35:59 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728127AbfEURf7 (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 21 May 2019 13:35:59 -0400
Received: from mx1.redhat.com ([209.132.183.28]:60594 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726900AbfEURf6 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 21 May 2019 13:35:58 -0400
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 98926307D86F;
        Tue, 21 May 2019 17:35:53 +0000 (UTC)
Received: from egarver.localdomain (ovpn-124-103.rdu2.redhat.com [10.10.124.103])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 07C291001F5B;
        Tue, 21 May 2019 17:35:50 +0000 (UTC)
Date:   Tue, 21 May 2019 13:35:45 -0400
From:   Eric Garver <eric@garver.life>
To:     Shekhar Sharma <shekhar250198@gmail.com>
Cc:     netfilter-devel@vger.kernel.org
Subject: Re: [PATCH nft v2] tests: py: fix python3.
Message-ID: <20190521173545.s3wjzuyydnkhwfd3@egarver.localdomain>
Mail-Followup-To: Eric Garver <eric@garver.life>,
        Shekhar Sharma <shekhar250198@gmail.com>,
        netfilter-devel@vger.kernel.org
References: <20190518200841.67944-1-shekhar250198@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190518200841.67944-1-shekhar250198@gmail.com>
User-Agent: NeoMutt/20180716
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.48]); Tue, 21 May 2019 17:35:58 +0000 (UTC)
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Sun, May 19, 2019 at 01:38:41AM +0530, Shekhar Sharma wrote:
> The '__future__' package has been added to nft-test.py in this patch. 
> The file runs in python 2 but when I try to run it in python 3, there is a error in argparse.ArgumentParser() in line 1325 with an option '-version' , 
> I suspect that '-version' is not valid in python 3 but I am not sure.

argparse was/is semi compatible with optparse. optparse allowed the
"version" argument as part of the constructor. Apparently python3's
argparse is less compatible. It's best to replace this entirely with the
"version" action as that'll work in both python2 and python3.

    https://docs.python.org/3/library/argparse.html#action

> 
> Signed-off-by: Shekhar Sharma <shekhar250198@gmail.com>
> ---
[..]
