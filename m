Return-Path: <SRS0=TR/Z=U2=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.7 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_NEOMUTT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 15B82C48BD6
	for <netfilter-devel@archiver.kernel.org>; Thu, 27 Jun 2019 12:52:15 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id E21B62085A
	for <netfilter-devel@archiver.kernel.org>; Thu, 27 Jun 2019 12:52:14 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727030AbfF0MwN (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 27 Jun 2019 08:52:13 -0400
Received: from mx1.redhat.com ([209.132.183.28]:57644 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727000AbfF0MwM (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 27 Jun 2019 08:52:12 -0400
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id C8B71300BCE9;
        Thu, 27 Jun 2019 12:52:12 +0000 (UTC)
Received: from egarver.localdomain (ovpn-120-117.rdu2.redhat.com [10.10.120.117])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 10B9160856;
        Thu, 27 Jun 2019 12:52:11 +0000 (UTC)
Date:   Thu, 27 Jun 2019 08:52:10 -0400
From:   Eric Garver <eric@garver.life>
To:     Shekhar Sharma <shekhar250198@gmail.com>
Cc:     netfilter-devel@vger.kernel.org
Subject: Re: [PATCH nft v9] tests: py: add netns feature
Message-ID: <20190627125210.7lim5znivu3i2oxn@egarver.localdomain>
Mail-Followup-To: Eric Garver <eric@garver.life>,
        Shekhar Sharma <shekhar250198@gmail.com>,
        netfilter-devel@vger.kernel.org
References: <20190621174053.4087-1-shekhar250198@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190621174053.4087-1-shekhar250198@gmail.com>
User-Agent: NeoMutt/20180716
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.47]); Thu, 27 Jun 2019 12:52:12 +0000 (UTC)
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Fri, Jun 21, 2019 at 11:10:53PM +0530, Shekhar Sharma wrote:
> This patch adds the netns feature to the nft-test.py file.
> 
> Signed-off-by: Shekhar Sharma <shekhar250198@gmail.com>
> ---
> The global variable 'netns' stores the value of args.netns
> which is used as an argument in various functions.
>  
> The version history of the patch is :
> v1: add the netns feature
> v2: use format() method to simplify print statements.
> v3: updated the shebang
> v4: resent the same with small changes
> v5&v6: resent with small changes
> v7: netns commands changed for passing the netns name via netns argument.
> v8: correct typo error
> v9: use tempfile, replace cmp() and add a global variable 'netns' 
>     and store the args.netns value in it.
> 

There should be a separator (---) after the revision history and before
the actual patch.
i.e.

---

This patch has hunks from your other patch "[PATCH nft v9]tests: py: fix
pyhton3". Please keep the changes separate.
