Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 94278C433EF
	for <netfilter-devel@archiver.kernel.org>; Mon, 27 Sep 2021 15:05:35 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 6B9296108E
	for <netfilter-devel@archiver.kernel.org>; Mon, 27 Sep 2021 15:05:35 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234917AbhI0PHM (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 27 Sep 2021 11:07:12 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:25834 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S234975AbhI0PHL (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 27 Sep 2021 11:07:11 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1632755133;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding;
        bh=s4G2O1nJFkNJ8gZZwP18XCjwQfh2FfR8MZUb9ilZ8P0=;
        b=I6pJqbCYyXB9D11STBFFVMPMV0TBh4B7D/Z0SOQOWeUFXaQSHOx8K+l7d+bd+dZAcRPfth
        aQh8BVizg7Gk2ZW0/9DycWOAtWw/r6tvWOsxVS3Lp9OwvgOMuaLSgiqZ+ZzleeFpm9AGLA
        VYqskMqOk8Pv6/5Ch6sQ3iCU9wVXobM=
Received: from mail-ed1-f72.google.com (mail-ed1-f72.google.com
 [209.85.208.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-359-JFjBAFhUN46HjmAyyn42ig-1; Mon, 27 Sep 2021 11:05:31 -0400
X-MC-Unique: JFjBAFhUN46HjmAyyn42ig-1
Received: by mail-ed1-f72.google.com with SMTP id m20-20020aa7c2d4000000b003d1add00b8aso18194378edp.0
        for <netfilter-devel@vger.kernel.org>; Mon, 27 Sep 2021 08:05:31 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=s4G2O1nJFkNJ8gZZwP18XCjwQfh2FfR8MZUb9ilZ8P0=;
        b=yBD4aFTHrssMeZCva1DRrj05HysBCM8KfEwdMOTJHkLsx3mN/0Boq0oxwV7xLowGDe
         1FdmNw+U8klcppPo5yngCCwHYgEjIXg8/Yj/MD3O565NN5/f4dQUFC2yBWSJGGGLra07
         txIcKoAB98Bj9H8k5RTTvQ0bkWVEFyvkGU+HV4dMFHm5ymbK0kcrnewV3aX+G6MzCrDn
         4hWvGpZclUK1DIoY2Yd09qia9ALYLwvR6mwfCnxY4/pxPtl0Yvfum4wGRQQb1lbCq56h
         okXtw5E3xWCdPeb6ixPBrrT54L8iCKkDHtdRZRgBemWXz2iDHLbNq+M9FZDSdvyh9nC6
         JcHA==
X-Gm-Message-State: AOAM5331h9t017v2TYY0l7Nz0CUGvJhw/oHUBF4KPBbf0PPAfFnR5+cW
        y1Lm9VZkcxWrjBd2ry8p2mZPNUFoXfaub491xaOTf9X/BFlWpEgouf3mUAPriQt3UZTr+wtov72
        OW8LkWCcTo8FeEASVHFQZrJsNEuvwMmrJmx44BcXCypENHcgFca8C3rvOKlm2jEqvcqOOLVfuZX
        ZHag==
X-Received: by 2002:a17:906:c18d:: with SMTP id g13mr545526ejz.518.1632755130312;
        Mon, 27 Sep 2021 08:05:30 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJxJFB8kUv946Z9sMxEQhsnVNAQ7n1vitNgtARk6dX6VUN38B51c9Iz8WB8hEF4KZEqhWjXLrQ==
X-Received: by 2002:a17:906:c18d:: with SMTP id g13mr545500ejz.518.1632755130064;
        Mon, 27 Sep 2021 08:05:30 -0700 (PDT)
Received: from localhost ([185.112.167.40])
        by smtp.gmail.com with ESMTPSA id w11sm11051386edl.12.2021.09.27.08.05.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 27 Sep 2021 08:05:29 -0700 (PDT)
From:   =?UTF-8?q?=C5=A0t=C4=9Bp=C3=A1n=20N=C4=9Bmec?= <snemec@redhat.com>
To:     netfilter-devel@vger.kernel.org,
        Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH conntrack-tools] conntrack.8: minor copy edit
Date:   Mon, 27 Sep 2021 17:06:01 +0200
Message-Id: <20210927150601.3131400-1-snemec@redhat.com>
X-Mailer: git-send-email 2.33.0
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Signed-off-by: Štěpán Němec <snemec@redhat.com>
---
 conntrack.8 | 23 +++++++++++------------
 1 file changed, 11 insertions(+), 12 deletions(-)

diff --git a/conntrack.8 b/conntrack.8
index a14cca6f6480..de1cac2bebac 100644
--- a/conntrack.8
+++ b/conntrack.8
@@ -26,7 +26,7 @@ conntrack \- command line interface for netfilter connection tracking
 .br
 .BR "conntrack -R file"
 .SH DESCRIPTION
-The \fBconntrack\fP utilty provides a full featured userspace interface to the
+The \fBconntrack\fP utility provides a full-featured userspace interface to the
 Netfilter connection tracking system that is intended to replace the old
 /proc/net/ip_conntrack interface. This tool can be used to search, list,
 inspect and maintain the connection tracking subsystem of the Linux kernel.
@@ -121,12 +121,12 @@ timestamp available since 2.6.38 (you can enable it via the \fBsysctl(8)\fP
 key \fBnet.netfilter.nf_conntrack_timestamp\fP).
 The labels output option tells \fBconntrack\fP to show the names of connection
 tracking labels that might be present.
-The userspace output options tells if the event has been triggered by a process.
+The userspace output option tells if the event has been triggered by a process.
 .TP
 .BI "-e, --event-mask " "[ALL|NEW|UPDATES|DESTROY][,...]"
 Set the bitmask of events that are to be generated by the in-kernel ctnetlink
 event code.  Using this parameter, you can reduce the event messages generated
-by the kernel to those types to those that you are actually interested in.
+by the kernel to the types that you are actually interested in.
 .
 This option can only be used in conjunction with "\-E, \-\-event".
 .TP
@@ -135,7 +135,7 @@ Set the Netlink socket buffer size in bytes. This option is useful if the
 command line tool reports ENOBUFS errors. If you do not pass this option, the
 default value available at \fBsysctl(8)\fP key \fBnet.core.rmem_default\fP is
 used. The tool reports this problem if your process is too slow to handle all
-the event messages or, in other words, if the amount of events are big enough
+the event messages or, in other words, if the amount of events is big enough
 to overrun the socket buffer. Note that using a big buffer reduces the chances
 to hit ENOBUFS, however, this results in more memory consumption.
 .
@@ -163,7 +163,7 @@ one specified as argument.
 Specify layer four (TCP, UDP, ...) protocol.
 .TP
 .BI "-f, --family " "PROTO"
-Specify layer three (ipv4, ipv6) protocol
+Specify layer three (ipv4, ipv6) protocol.
 This option is only required in conjunction with "\-L, \-\-dump". If this
 option is not passed, the default layer 3 protocol will be IPv4.
 .TP
@@ -181,12 +181,11 @@ comparision. In "\-\-create" mode, the mask is ignored.
 Specify a conntrack label.
 This option is only available in conjunction with "\-L, \-\-dump",
 "\-E, \-\-event", "\-U \-\-update" or "\-D \-\-delete".
-Match entries whose labels match at least those specified.
-Use multiple \-l commands to specify multiple labels that need to be set.
-Match entries whose labels matches at least those specified as arguments.
+Match entries whose labels include those specified as arguments.
+Use multiple \-l options to specify multiple labels that need to be set.
 .TP
 .BI "--label-add " "LABEL"
-Specify the conntrack label to add to to the selected conntracks.
+Specify the conntrack label to add to the selected conntracks.
 This option is only available in conjunction with "\-I, \-\-create" or
 "\-U, \-\-update".
 .TP
@@ -395,7 +394,7 @@ Show source NAT connections
 Show connection events together with the timestamp
 .TP
 .B conntrack \-D \-s 1.2.3.4
-Delete all flow whose source address is 1.2.3.4
+Delete all flows whose source address is 1.2.3.4
 .TP
 .B conntrack \-U \-s 1.2.3.4 \-m 1
 Set connmark to 1 of all the flows whose source address is 1.2.3.4
@@ -417,8 +416,8 @@ See
 Jay Schulist, Patrick McHardy, Harald Welte and Pablo Neira Ayuso wrote the
 kernel-level "ctnetlink" interface that is used by the conntrack tool.
 .PP
-Pablo Neira Ayuso wrote and maintain the conntrack tool, Harald Welte added
-support for conntrack based accounting counters.
+Pablo Neira Ayuso wrote and maintains the conntrack tool, Harald Welte added
+support for conntrack-based accounting counters.
 .PP
 Man page written by Harald Welte <laforge@netfilter.org> and
 Pablo Neira Ayuso <pablo@netfilter.org>.

base-commit: ee2d35899a2768489c8705fe1a9e72731813e6d2
-- 
2.33.0

