Return-Path: <SRS0=sEEs=Z2=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9B1A9C2BD09
	for <netfilter-devel@archiver.kernel.org>; Wed,  4 Dec 2019 18:18:13 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 7A06A205ED
	for <netfilter-devel@archiver.kernel.org>; Wed,  4 Dec 2019 18:18:13 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731843AbfLDSSM (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 4 Dec 2019 13:18:12 -0500
Received: from mail-wm1-f68.google.com ([209.85.128.68]:40265 "EHLO
        mail-wm1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731786AbfLDSSL (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 4 Dec 2019 13:18:11 -0500
Received: by mail-wm1-f68.google.com with SMTP id t14so769772wmi.5
        for <netfilter-devel@vger.kernel.org>; Wed, 04 Dec 2019 10:18:10 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:from:to:date:message-id:in-reply-to
         :references:user-agent:mime-version:content-transfer-encoding;
        bh=zP8V5PfYV+g0heajVNx7u2GpX48SZa/UXXZgRNeW7xI=;
        b=YLykceTN64DifintBgr/6qnY0YtCFGaQH1NrSJfXSeJRv+jS4l2qn+9SlALKWC85vL
         90UKMzj4ElO2aHhBQs7hlHJm8TtWf04oEm0h5hNyqRlIe18Y7URDA5QhU0uBKpHxm+ck
         H6H9OA3SSpuKBj2LJ550LSgG6OVaB9DoJJbe2FSsB5kYkUm8SC/KFoDP8tXWep6el2V9
         zQA2cJ2wphXiVEZvbn4v+psDjBgByydsjIWwHMAUAa+TQmp0JzF8aNN4ocF5dxod+6LC
         tBp68JwxoNF+7QM8NW0FDU7AAJn1YPRIUuvfvv6JO+SLsTMZseflv9VjP00qpd6v6sLt
         SL9Q==
X-Gm-Message-State: APjAAAU58ZBKCae29ulm0hN8Q7Y4Ap720XPJAq1dTtPFHC20XBbCbldJ
        05VLiJkbK3sN2QnrddMrY3uBDTGBTiw=
X-Google-Smtp-Source: APXvYqynZeMnJ3gRYq4FhsB/+jB4rU7scGLSSait1nYYXQKZBN92kj9tg4w8BlONMKf3w/zmdEhmYw==
X-Received: by 2002:a7b:c956:: with SMTP id i22mr877310wml.65.1575483489384;
        Wed, 04 Dec 2019 10:18:09 -0800 (PST)
Received: from localhost (static.68.138.194.213.ibercom.com. [213.194.138.68])
        by smtp.gmail.com with ESMTPSA id a186sm7542787wmd.41.2019.12.04.10.18.08
        for <netfilter-devel@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 04 Dec 2019 10:18:08 -0800 (PST)
Subject: [iptables PATCH 3/7] extensions: manpages: cleanup hyphens
From:   Arturo Borrero Gonzalez <arturo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Date:   Wed, 04 Dec 2019 19:18:07 +0100
Message-ID: <157548348778.125234.14968882486427385674.stgit@endurance>
In-Reply-To: <157548347377.125234.12163057581146113349.stgit@endurance>
References: <157548347377.125234.12163057581146113349.stgit@endurance>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

From: Laurence J. Lane <ljlane@debian.org>

Cleanup, scape hyphens so they are not interpreted by the manpage generator.

Arturo says:
 This patch is forwarded from the iptables Debian package, where it has been
 around for many years now.

Signed-off-by: Laurence J. Lane <ljlane@debian.org>
Signed-off-by: Arturo Borrero Gonzalez <arturo@netfilter.org>
---
 extensions/libip6t_DNPT.man  |    2 +-
 extensions/libip6t_SNPT.man  |    2 +-
 extensions/libxt_HMARK.man   |    2 +-
 extensions/libxt_SET.man     |    2 +-
 extensions/libxt_TOS.man     |    2 +-
 extensions/libxt_bpf.man     |    2 +-
 extensions/libxt_cluster.man |    2 +-
 extensions/libxt_osf.man     |    4 ++--
 extensions/libxt_set.man     |    2 +-
 9 files changed, 10 insertions(+), 10 deletions(-)

diff --git a/extensions/libip6t_DNPT.man b/extensions/libip6t_DNPT.man
index 61beeee8..9b060f5b 100644
--- a/extensions/libip6t_DNPT.man
+++ b/extensions/libip6t_DNPT.man
@@ -23,7 +23,7 @@ ip6tables \-t mangle \-I PREROUTING \-i wlan0 \-d 2001:e20:2000:40f::/64
 .PP
 You may need to enable IPv6 neighbor proxy:
 .IP
-sysctl -w net.ipv6.conf.all.proxy_ndp=1
+sysctl \-w net.ipv6.conf.all.proxy_ndp=1
 .PP
 You also have to use the
 .B NOTRACK
diff --git a/extensions/libip6t_SNPT.man b/extensions/libip6t_SNPT.man
index 78d644a7..97e0071b 100644
--- a/extensions/libip6t_SNPT.man
+++ b/extensions/libip6t_SNPT.man
@@ -23,7 +23,7 @@ ip6tables \-t mangle \-I PREROUTING \-i wlan0 \-d 2001:e20:2000:40f::/64
 .PP
 You may need to enable IPv6 neighbor proxy:
 .IP
-sysctl -w net.ipv6.conf.all.proxy_ndp=1
+sysctl \-w net.ipv6.conf.all.proxy_ndp=1
 .PP
 You also have to use the
 .B NOTRACK
diff --git a/extensions/libxt_HMARK.man b/extensions/libxt_HMARK.man
index e7b5426d..cd7ffd54 100644
--- a/extensions/libxt_HMARK.man
+++ b/extensions/libxt_HMARK.man
@@ -56,5 +56,5 @@ iptables \-t mangle \-A PREROUTING \-m conntrack \-\-ctstate NEW
  \-j HMARK \-\-hmark-tuple ct,src,dst,proto \-\-hmark-offset 10000
 \-\-hmark\-mod 10 \-\-hmark\-rnd 0xfeedcafe
 .PP
-iptables \-t mangle \-A PREROUTING -j HMARK \-\-hmark\-offset 10000
+iptables \-t mangle \-A PREROUTING \-j HMARK \-\-hmark\-offset 10000
 \-\-hmark-tuple src,dst,proto \-\-hmark-mod 10 \-\-hmark\-rnd 0xdeafbeef
diff --git a/extensions/libxt_SET.man b/extensions/libxt_SET.man
index 78a9ae0f..c4713378 100644
--- a/extensions/libxt_SET.man
+++ b/extensions/libxt_SET.man
@@ -42,5 +42,5 @@ and
 \fB\-\-map\-queue\fP
 flags can be used in the OUTPUT, FORWARD and POSTROUTING chains.
 .PP
-Use of -j SET requires that ipset kernel support is provided, which, for
+Use of \-j SET requires that ipset kernel support is provided, which, for
 standard kernels, is the case since Linux 2.6.39.
diff --git a/extensions/libxt_TOS.man b/extensions/libxt_TOS.man
index 58118ec2..de2d22dc 100644
--- a/extensions/libxt_TOS.man
+++ b/extensions/libxt_TOS.man
@@ -32,5 +32,5 @@ longterm releases 2.6.32 (>=.42), 2.6.33 (>=.15), and 2.6.35 (>=.14), there is
 a bug whereby IPv6 TOS mangling does not behave as documented and differs from
 the IPv4 version. The TOS mask indicates the bits one wants to zero out, so it
 needs to be inverted before applying it to the original TOS field. However, the
-aformentioned kernels forgo the inversion which breaks --set-tos and its
+aformentioned kernels forgo the inversion which breaks \-\-set\-tos and its
 mnemonics.
diff --git a/extensions/libxt_bpf.man b/extensions/libxt_bpf.man
index 1d2aa9e6..d6da2043 100644
--- a/extensions/libxt_bpf.man
+++ b/extensions/libxt_bpf.man
@@ -17,7 +17,7 @@ iptables \-A OUTPUT \-m bpf \-\-object\-pinned ${BPF_MOUNT}/{PINNED_PATH} \-j AC
 \fB\-\-bytecode\fP \fIcode\fP
 Pass the BPF byte code format as generated by the \fBnfbpf_compile\fP utility.
 .PP
-The code format is similar to the output of the tcpdump -ddd command: one line
+The code format is similar to the output of the tcpdump \-ddd command: one line
 that stores the number of instructions, followed by one line for each
 instruction. Instruction lines follow the pattern 'u16 u8 u8 u32' in decimal
 notation. Fields encode the operation, jump offset if true, jump offset if
diff --git a/extensions/libxt_cluster.man b/extensions/libxt_cluster.man
index 94b4b205..23448e26 100644
--- a/extensions/libxt_cluster.man
+++ b/extensions/libxt_cluster.man
@@ -27,7 +27,7 @@ iptables \-A PREROUTING \-t mangle \-i eth1 \-m cluster
 iptables \-A PREROUTING \-t mangle \-i eth2 \-m cluster
 \-\-cluster\-total\-nodes 2 \-\-cluster\-local\-node 1
 \-\-cluster\-hash\-seed 0xdeadbeef
-\-j MARK -\-set\-mark 0xffff
+\-j MARK \-\-set\-mark 0xffff
 .IP
 iptables \-A PREROUTING \-t mangle \-i eth1
 \-m mark ! \-\-mark 0xffff \-j DROP
diff --git a/extensions/libxt_osf.man b/extensions/libxt_osf.man
index 5ba92ce0..ecb6ee5f 100644
--- a/extensions/libxt_osf.man
+++ b/extensions/libxt_osf.man
@@ -35,11 +35,11 @@ Windows [2000:SP3:Windows XP Pro SP1, 2000 SP3]: 11.22.33.55:4024 ->
 OS fingerprints are loadable using the \fBnfnl_osf\fP program. To load
 fingerprints from a file, use:
 .PP
-\fBnfnl_osf -f /usr/share/xtables/pf.os\fP
+\fBnfnl_osf \-f /usr/share/xtables/pf.os\fP
 .PP
 To remove them again,
 .PP
-\fBnfnl_osf -f /usr/share/xtables/pf.os -d\fP
+\fBnfnl_osf \-f /usr/share/xtables/pf.os \-d\fP
 .PP
 The fingerprint database can be downloaded from
 http://www.openbsd.org/cgi-bin/cvsweb/src/etc/pf.os .
diff --git a/extensions/libxt_set.man b/extensions/libxt_set.man
index dbc1586b..5c6f64e3 100644
--- a/extensions/libxt_set.man
+++ b/extensions/libxt_set.man
@@ -61,5 +61,5 @@ when the set was defined without counter support.
 The option \fB\-\-match\-set\fP can be replaced by \fB\-\-set\fP if that does 
 not clash with an option of other extensions.
 .PP
-Use of -m set requires that ipset kernel support is provided, which, for
+Use of \-m set requires that ipset kernel support is provided, which, for
 standard kernels, is the case since Linux 2.6.39.

