Return-Path: <SRS0=em6Q=62=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E5641C2D0F7
	for <netfilter-devel@archiver.kernel.org>; Tue, 12 May 2020 20:51:01 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id BB5B820747
	for <netfilter-devel@archiver.kernel.org>; Tue, 12 May 2020 20:51:01 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726324AbgELUvB (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 12 May 2020 16:51:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41046 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1725938AbgELUvB (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 12 May 2020 16:51:01 -0400
Received: from a3.inai.de (a3.inai.de [IPv6:2a01:4f8:10b:45d8::f5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 06411C061A0C
        for <netfilter-devel@vger.kernel.org>; Tue, 12 May 2020 13:51:00 -0700 (PDT)
Received: by a3.inai.de (Postfix, from userid 25121)
        id 6EB8658725880; Tue, 12 May 2020 22:50:59 +0200 (CEST)
Received: from localhost (localhost [127.0.0.1])
        by a3.inai.de (Postfix) with ESMTP id 6A3FE60D314BF;
        Tue, 12 May 2020 22:50:59 +0200 (CEST)
Date:   Tue, 12 May 2020 22:50:59 +0200 (CEST)
From:   Jan Engelhardt <jengelh@inai.de>
To:     Philip Prindeville <philipp_subx@redfish-solutions.com>
cc:     netfilter-devel@vger.kernel.org
Subject: Re: [PATCH v1 1/1] xtables-addons: geoip: update scripts for DBIP
 names, etc.
In-Reply-To: <BC0C3307-DA4C-405E-8B3D-98A752B87EFC@redfish-solutions.com>
Message-ID: <nycvar.YFH.7.77.849.2005122250300.12285@n3.vanv.qr>
References: <20200512002747.2108-1-philipp@redfish-solutions.com> <nycvar.YFH.7.77.849.2005121118260.6562@n3.vanv.qr> <BC0C3307-DA4C-405E-8B3D-98A752B87EFC@redfish-solutions.com>
User-Agent: Alpine 2.22 (LSU 394 2020-01-19)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org


On Tuesday 2020-05-12 18:51, Philip Prindeville wrote:
>>> Also change the default destination directory to /usr/share/xt_geoip
>>> as most distros use this now.  Update the documentation.
>> 
>> Maybe there are some "nicer" approaches? I'm calling for further inspirations.
>
>I’m open to suggestions.

This has been floating around my mind.

 geoip/xt_geoip_build   | 1 +
 geoip/xt_geoip_build.1 | 8 ++++++--
 2 files changed, 7 insertions(+), 2 deletions(-)

diff --git a/geoip/xt_geoip_build b/geoip/xt_geoip_build
index 750bf98..7bafa5f 100755
--- a/geoip/xt_geoip_build
+++ b/geoip/xt_geoip_build
@@ -24,6 +24,7 @@ my $target_dir = ".";
 &GetOptions(
 	"D=s" => \$target_dir,
 	"i=s" => \$input_file,
+	"s" => sub { $target_dir = "/usr/share/xt_geoip"; },
 );
 
 if (!-d $target_dir) {
diff --git a/geoip/xt_geoip_build.1 b/geoip/xt_geoip_build.1
index ac3e6d3..598177f 100644
--- a/geoip/xt_geoip_build.1
+++ b/geoip/xt_geoip_build.1
@@ -27,11 +27,15 @@ Specifies the target directory into which the files are to be put. Defaults to "
 \fB\-i\fP \fIinput_file\fP
 Specifies the source location of the DBIP CSV file. Defaults to
 "dbip-country-lite.csv". Use "-" to read from stdin.
+.TP
+\fB\-s\fP
+"System mode". Equivalent to \fB\-D /usr/share/xt_geoip\fP.
 .SH Application
 .PP
-Shell commands to build the databases and put them to where they are expected:
+Shell commands to build the databases and put them to where they are expected
+(usually run as root):
 .PP
-xt_geoip_build \-D /usr/share/xt_geoip
+xt_geoip_build \-s
 .SH See also
 .PP
 xt_geoip_dl(1)
-- 
2.26.2

