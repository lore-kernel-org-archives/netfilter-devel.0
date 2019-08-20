Return-Path: <SRS0=ly5L=WQ=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9B76BC3A59D
	for <netfilter-devel@archiver.kernel.org>; Tue, 20 Aug 2019 13:46:51 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 71D9B2087E
	for <netfilter-devel@archiver.kernel.org>; Tue, 20 Aug 2019 13:46:51 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730453AbfHTNqv (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 20 Aug 2019 09:46:51 -0400
Received: from Chamillionaire.breakpoint.cc ([193.142.43.52]:34950 "EHLO
        Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1730430AbfHTNlo (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 20 Aug 2019 09:41:44 -0400
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
        (envelope-from <fw@strlen.de>)
        id 1i04ON-00051t-8g; Tue, 20 Aug 2019 15:41:43 +0200
Date:   Tue, 20 Aug 2019 15:41:43 +0200
From:   Florian Westphal <fw@strlen.de>
To:     Ander Juaristi <a@juaristi.eus>
Cc:     netfilter-devel@vger.kernel.org
Subject: Re: [PATCH nft v7 2/2] meta: Introduce new conditions 'time', 'day'
 and 'hour'
Message-ID: <20190820134143.GR2588@breakpoint.cc>
References: <20190818182013.6765-1-a@juaristi.eus>
 <20190818182013.6765-2-a@juaristi.eus>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190818182013.6765-2-a@juaristi.eus>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Ander Juaristi <a@juaristi.eus> wrote:
> These keywords introduce new checks for a timestamp, an absolute date (which is converted to a timestamp),
> an hour in the day (which is converted to the number of seconds since midnight) and a day of week.

This patch breaks test case:

ip6/sets.t: ERROR: line 11: add set ip6 test-ip6 z { type time; }: I cannot add the set z

Fix appears to be:

     4  diff --git a/src/parser_bison.y b/src/parser_bison.y
     5  index 4b953029..088a857b 100644
     6  --- a/src/parser_bison.y
     7  +++ b/src/parser_bison.y
     8  @@ -1828,6 +1828,11 @@ data_type_atom_expr      :       type_identifier
     9                                                           dtype->size, NULL);
    10                                  xfree($1);
    11                          }
    12  +                       |       TIME
    13  +                       {
    14  +                               $$ = constant_expr_alloc(&@1, &time_type, time_type.byteorder,
    15  +                                                        time_type.size, NULL);
    16  +                       }
    17                          ;
    18

i.e., the test case breaks because "time" is now a keyword, so we need
to tell the datatype parsing part that TIME is also a type.

Other than this, I found no other problems.
