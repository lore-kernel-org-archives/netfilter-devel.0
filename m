Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6E363C433F5
	for <netfilter-devel@archiver.kernel.org>; Mon, 27 Sep 2021 15:12:22 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 51F2B60F44
	for <netfilter-devel@archiver.kernel.org>; Mon, 27 Sep 2021 15:12:22 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235019AbhI0PN7 (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 27 Sep 2021 11:13:59 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:27364 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S234976AbhI0PN6 (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 27 Sep 2021 11:13:58 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1632755540;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding;
        bh=xG/RRjSPhfCweSdXtrBUGiA5VU2JM3/56cNN3A0t8Sw=;
        b=G9ZufO6XM14nx4oJH440kRJIPQeBD3KIZqkiTLHVYHTuMe5N4S6IpWZvz7JOEDBzGFz/Xr
        UT73cHPZGhXwnS8R8PcXUxE3yfMXEktXqFrjD3XH+EnaqK3lI9nw+sRxf+FKf67+oNBTJm
        1r4WxeMugtY6DU77FFlephrTrplg1uk=
Received: from mail-ed1-f70.google.com (mail-ed1-f70.google.com
 [209.85.208.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-584-Uf7MlqChMRKgUjROflHkmw-1; Mon, 27 Sep 2021 11:12:19 -0400
X-MC-Unique: Uf7MlqChMRKgUjROflHkmw-1
Received: by mail-ed1-f70.google.com with SMTP id z6-20020a50cd06000000b003d2c2e38f1fso18182644edi.1
        for <netfilter-devel@vger.kernel.org>; Mon, 27 Sep 2021 08:12:19 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=xG/RRjSPhfCweSdXtrBUGiA5VU2JM3/56cNN3A0t8Sw=;
        b=ry9ILPXEu36iIgMvYHZhqBmyoZb/raCU4cyK8iekiuFI4tlFPx7RnttEYAIc8lQIuT
         7BXOkcuyM8mUu1JrLUupuUiLNO7Ls/AljhvEwVJCoU+nM+2IK96kJzsuYmX0ACZ1u5N3
         +uqT/AhyfDg48qlhfxf+u7fRsp9OiIW3pTdoORjOyKwE+8m0mNro6/eRK1bSBMrhBUbv
         JFhVuvHtaw+AdVsdit8GEfHsST28b/fsgWUmYTpLyRwgMigaZZu6ds/PwM+TCbyThB3i
         VUfH0ilJFrmaFTOc7/jvzAEFJsjD5DQnnQedjvExlOrm9PefjqC+iCw7OPZGTO+tGGWV
         U/HA==
X-Gm-Message-State: AOAM531brBK9lke1pFR1CtpJrXRWCRnO+bwVdtSTPS+vslxDxFnM0QNR
        hY8JX5SXr9JLjnPuupNiyFYFmZuo1iVwmKgkHxtuiU/xF2mwMUPAERC59fdG4X8M0ETtX7ASRxc
        xDEuQQpWehHAzv/ft9oYc9D7vNY4SldRHhdmxvWTH0Fah4Q+igOWy1oiyNlc3kCnTw7doP5/dqa
        hkgA==
X-Received: by 2002:a17:906:fa8a:: with SMTP id lt10mr616860ejb.320.1632755537297;
        Mon, 27 Sep 2021 08:12:17 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJwCOj6lpiYfMmUN9jHRSlwFgZroCzMTyOEUuBaOldsv2BKmhvKTEerO4KXEcHVeZkGTncGnfg==
X-Received: by 2002:a17:906:fa8a:: with SMTP id lt10mr616824ejb.320.1632755536978;
        Mon, 27 Sep 2021 08:12:16 -0700 (PDT)
Received: from localhost ([185.112.167.40])
        by smtp.gmail.com with ESMTPSA id p5sm8676331eju.30.2021.09.27.08.12.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 27 Sep 2021 08:12:16 -0700 (PDT)
From:   =?UTF-8?q?=C5=A0t=C4=9Bp=C3=A1n=20N=C4=9Bmec?= <snemec@redhat.com>
To:     netfilter-devel@vger.kernel.org,
        Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH conntrack-tools v2] conntrack.8: minor copy edit
Date:   Mon, 27 Sep 2021 17:12:47 +0200
Message-Id: <20210927151247.3133748-1-snemec@redhat.com>
X-Mailer: git-send-email 2.33.0
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Signed-off-by: Štěpán Němec <snemec@redhat.com>
---
v2: Forgot to escape the dashes, sorry.

 conntrack.8 | 23 +++++++++++------------
 1 file changed, 11 insertions(+), 12 deletions(-)

diff --git a/conntrack.8 b/conntrack.8
index a14cca6f6480..c3214ee0c886 100644
--- a/conntrack.8
+++ b/conntrack.8
@@ -26,7 +26,7 @@ conntrack \- command line interface for netfilter connection tracking
 .br
 .BR "conntrack -R file"
 .SH DESCRIPTION
-The \fBconntrack\fP utilty provides a full featured userspace interface to the
+The \fBconntrack\fP utility provides a full\-featured userspace interface to the
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
+support for conntrack\-based accounting counters.
 .PP
 Man page written by Harald Welte <laforge@netfilter.org> and
 Pablo Neira Ayuso <pablo@netfilter.org>.

base-commit: ee2d35899a2768489c8705fe1a9e72731813e6d2
-- 
2.33.0

