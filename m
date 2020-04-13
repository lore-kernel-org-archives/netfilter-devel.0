Return-Path: <SRS0=78bk=55=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 64523C2BA2B
	for <netfilter-devel@archiver.kernel.org>; Mon, 13 Apr 2020 19:00:27 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 2AA02206DA
	for <netfilter-devel@archiver.kernel.org>; Mon, 13 Apr 2020 19:00:27 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="vTxl851G"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728084AbgDMTA1 (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 13 Apr 2020 15:00:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53198 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1727828AbgDMTA0 (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 13 Apr 2020 15:00:26 -0400
Received: from mail-oi1-x235.google.com (mail-oi1-x235.google.com [IPv6:2607:f8b0:4864:20::235])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E47C6C0A3BDC
        for <netfilter-devel@vger.kernel.org>; Mon, 13 Apr 2020 12:00:25 -0700 (PDT)
Received: by mail-oi1-x235.google.com with SMTP id v141so3769980oie.1
        for <netfilter-devel@vger.kernel.org>; Mon, 13 Apr 2020 12:00:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=to:from:subject:message-id:date:user-agent:mime-version
         :content-language:content-transfer-encoding;
        bh=3jr8Kvt6QAGnCitIQNCy0br4xgifmpWeogrGqy+Fsds=;
        b=vTxl851Gd4G2z/bbkcjeFV/aKRIcbkrMFaeqzRG7pE2nhbvMAj9hdBa42aYDsJDus6
         d0Y0eu7uSq8NMp1SDWjZM6nac4UuhhcFR1/J9L9XtdvX6kJjlvhUuEgFqa9eMku901E2
         0ie5my5hfsuCE1xcHvFZsQvoqYTwq/aGuFhZuASD2LJ1ERWlvoFDimz0nqwK0OY7zGyR
         hNvd3pD76/HNZtsbqbIFBKbEFuk0t9m+xAI0yABApRngJ5JVLw0gFY301/MI8dXzl0NO
         OrW++3okZOkfz5A95fVI41Qg/eP1Bb9m+lD+Qn5SjuUUPxnpGPfwVpTv8lBTmG85+aHf
         9HlQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:to:from:subject:message-id:date:user-agent
         :mime-version:content-language:content-transfer-encoding;
        bh=3jr8Kvt6QAGnCitIQNCy0br4xgifmpWeogrGqy+Fsds=;
        b=Lmy9VieRrkjjQX61F8kMPX5Av++b1Y29Y3j39HO26dQByGZhnia7tYAAM3crYKLhmu
         bbP8TQAhzB4CFKbZBWlqC2U1EQBr8BumOC4ARbWmrrtJranAuR1Lp7dAvQfZ9bBdakXW
         4K96aVQwpn/Yvof9FiV6XXtbdWybOuxB2W/IoLgWFcrqOUbANYjdeQh8KA0rgGLNcft6
         ByOTcyCJ4p4VN1PEf46iL8YtKoLG7b/6BcxgR8KnphhKghqDTEqxw1PUh0YvIxVeFtUL
         xNmltBnoc6BsTLTdnXpat1kEcrEdQZMcDaJgiqOmSr8+2wI5Ju0zJRtqMvq/qo0xQlem
         JLdA==
X-Gm-Message-State: AGi0Pua169VhLg3K6N+jBxAGm0PNo/6AqNEjWRuGhhOuHXJQmvfo3YUf
        p2sfE57GLnbeyx6qj4a0D0DGtWrTAQA=
X-Google-Smtp-Source: APiQypKdTEBmiz2A4t8LVbS7llgcji9389To4HXGlL5be9VbRFPv19KqmHqzmGK2CVGAPOgol0GH0A==
X-Received: by 2002:aca:f3c2:: with SMTP id r185mr1790586oih.163.1586804424772;
        Mon, 13 Apr 2020 12:00:24 -0700 (PDT)
Received: from ian.penurio.us ([2605:6000:8c8b:a4fa:222:4dff:fe4f:c7ed])
        by smtp.gmail.com with ESMTPSA id h11sm5510037ooj.17.2020.04.13.12.00.23
        for <netfilter-devel@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 13 Apr 2020 12:00:23 -0700 (PDT)
To:     netfilter-devel@vger.kernel.org
From:   Ian Pilcher <arequipeno@gmail.com>
Subject: libmnl & rtnetlink questions
Message-ID: <223164bb-40f0-d1c7-3793-c56c85127f3c@gmail.com>
Date:   Mon, 13 Apr 2020 14:00:22 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.6.0
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

First off, please let me know if this list isn't an appropriate place
for these sorts of questions.

With that out of the way, I'm trying to understand the sample program
at:

   http://git.netfilter.org/libmnl/tree/examples/rtnl/rtnl-link-dump.c

I've been able to puzzle most of it out, but I'm confused by the
use of the struct rtgenmsg (declared on line 88 and used on lines
95-96).

* Based on rtnetlink(7), shouldn't this more properly be a struct
   ifinfomsg (even though only rtgen_family/ifi_family is set)?

* More importantly, why is setting this to AF_PACKET required at all?
   Testing the program without setting it reveals that it definitely is
   required, but I haven't been able to find anything that explains *why*
   that is the case.

Thanks!

-- 
========================================================================
                  In Soviet Russia, Google searches you!
========================================================================
