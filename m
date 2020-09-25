Return-Path: <SRS0=avf6=DC=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.9 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9AC1AC4363D
	for <netfilter-devel@archiver.kernel.org>; Fri, 25 Sep 2020 12:58:05 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5BBA0206DB
	for <netfilter-devel@archiver.kernel.org>; Fri, 25 Sep 2020 12:58:05 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=cloud.ionos.com header.i=@cloud.ionos.com header.b="gHCP6Vh2"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729244AbgIYM6F (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Fri, 25 Sep 2020 08:58:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38370 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728956AbgIYMtt (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 25 Sep 2020 08:49:49 -0400
Received: from mail-ed1-x542.google.com (mail-ed1-x542.google.com [IPv6:2a00:1450:4864:20::542])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2AAA3C0613D4
        for <netfilter-devel@vger.kernel.org>; Fri, 25 Sep 2020 05:49:49 -0700 (PDT)
Received: by mail-ed1-x542.google.com with SMTP id t16so2356842edw.7
        for <netfilter-devel@vger.kernel.org>; Fri, 25 Sep 2020 05:49:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cloud.ionos.com; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=BaP/yAUC/Npei5i+kGiKdvFxDxDOUjpCIz+C+7VvWnU=;
        b=gHCP6Vh2C4r3zfQa8WfoidB1q9sZZ8qYMaDp7CigmEjhq66PmX0jCxo11ps6CFGCBS
         9jB+LT6wqnWaFwT2vSaw4Rt6TmxqxkufopPXmdhAMPuKL87Wz7KTEhBeoofKrB4MXdy5
         yiIpk1Yy81ij6v3EdtNVV54D6sWau184i5YigWkbaV3VgyjJ/Sp7zgFJ6/IZkX7A1sZF
         pR+j1X28IF90PeaFZFdFW0jzG1In+wWmlnaoeyqWFIHYNk2dgcSpGxUfcdFeMwTWSOro
         IRJSLNxmp1NyA07FvG6FQy6IcINmW9744sAoTx+408FT97yTxc/ipsafI9TnYsJR98fk
         9DDw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=BaP/yAUC/Npei5i+kGiKdvFxDxDOUjpCIz+C+7VvWnU=;
        b=UhBzyx0YQuqpYlbMQV5LQbYWzhdH8LlzhPlavUh1aI86AjDzSB9lL59R+whrWo8Kcr
         QPSEjpZhdDkQAQ9XOl8XqRd5NGyUsHtYkO6ZVvLcSEsU6sfQ344oLa6MJpNJXW3DY7oi
         CUqxsJ6hhuUkXbfqWUNA4xXBkX+9292VTF7dQ07WL2vuznpap0NGZV65MEIR98u/S/C8
         RAoUzCwJ4UEm6dcBWUs3yayLXWgKXAxsoeSYecpyNKcXcLqeOWiTwpNCKoWwZafSvfdH
         34k286zqw9NJ1TvsDYRrwYGgftqQ8vofla566lHkFPI7UVeY1X/PLgsSstTUAhkDDoXw
         j2iA==
X-Gm-Message-State: AOAM532/rMrfdsQ9X5Ue4ENPIZpLKwUetVgicuCusSHsIQ37f5/pMcct
        n/oK/BYPbKDgSoXKh4BBg2T7UhN0bZORVA==
X-Google-Smtp-Source: ABdhPJzowvCYnBkMeIpdHIcZa5QCiOXtlQMEVf+MFu76fXnKZWza5ewMdLhhVEOSbxcOidURkqwgpA==
X-Received: by 2002:a50:ce06:: with SMTP id y6mr1118939edi.273.1601038187616;
        Fri, 25 Sep 2020 05:49:47 -0700 (PDT)
Received: from localhost.localdomain (dynamic-046-114-037-141.46.114.pool.telefonica.de. [46.114.37.141])
        by smtp.gmail.com with ESMTPSA id t3sm1761642edv.59.2020.09.25.05.49.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 25 Sep 2020 05:49:47 -0700 (PDT)
From:   Mikhail Sennikovsky <mikhail.sennikovskii@cloud.ionos.com>
To:     netfilter-devel@vger.kernel.org
Cc:     Mikhail Sennikovsky <mikhail.sennikovskii@cloud.ionos.com>
Subject: [PATCH 7/8] conntrack.8: man update for opts format support
Date:   Fri, 25 Sep 2020 14:49:18 +0200
Message-Id: <20200925124919.9389-8-mikhail.sennikovskii@cloud.ionos.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200925124919.9389-1-mikhail.sennikovskii@cloud.ionos.com>
References: <20200925124919.9389-1-mikhail.sennikovskii@cloud.ionos.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Signed-off-by: Mikhail Sennikovsky <mikhail.sennikovskii@cloud.ionos.com>
---
 conntrack.8 | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/conntrack.8 b/conntrack.8
index 3db4849..2d354a7 100644
--- a/conntrack.8
+++ b/conntrack.8
@@ -109,7 +109,7 @@ Show the in-kernel connection tracking system statistics.
 Atomically zero counters after reading them.  This option is only valid in
 combination with the "\-L, \-\-dump" command options.
 .TP
-.BI "-o, --output [extended,xml,timestamp,id,ktimestamp,labels,userspace] "
+.BI "-o, --output [extended,xml,opts,timestamp,id,ktimestamp,labels,userspace] "
 Display output in a certain format. With the extended output option, this tool
 displays the layer 3 information. With ktimestamp, it displays the in-kernel
 timestamp available since 2.6.38 (you can enable it via the \fBsysctl(8)\fP
@@ -399,6 +399,9 @@ Delete all flow whose source address is 1.2.3.4
 .TP
 .B conntrack \-U \-s 1.2.3.4 \-m 1
 Set connmark to 1 of all the flows whose source address is 1.2.3.4
+.TP
+.B conntrack -L -w 15 -o opts | sed 's/-w 15/-w 9915/g' | conntrack -I -
+Copy all ct entries from one ct zone 15 to ct zone 9915
 
 .SH BUGS
 Please, report them to netfilter-devel@vger.kernel.org or file a bug in
-- 
2.25.1

