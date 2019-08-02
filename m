Return-Path: <SRS0=xWIb=V6=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id ADE15C32750
	for <netfilter-devel@archiver.kernel.org>; Fri,  2 Aug 2019 04:20:30 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 714E22073D
	for <netfilter-devel@archiver.kernel.org>; Fri,  2 Aug 2019 04:20:30 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=cloudflare.com header.i=@cloudflare.com header.b="dyKqag01"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731372AbfHBEUa (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Fri, 2 Aug 2019 00:20:30 -0400
Received: from mail-qt1-f193.google.com ([209.85.160.193]:35420 "EHLO
        mail-qt1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731359AbfHBEUa (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 2 Aug 2019 00:20:30 -0400
Received: by mail-qt1-f193.google.com with SMTP id d23so72667532qto.2
        for <netfilter-devel@vger.kernel.org>; Thu, 01 Aug 2019 21:20:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cloudflare.com; s=google;
        h=mime-version:from:date:message-id:subject:to;
        bh=eqnicDfGf0dQKKt1jU8gwdO73pHw7L4fwxISKDMieuw=;
        b=dyKqag01UMk3+Ea/RorgJVQBosLJQT50Ok1hXUyMYgD2VPmSgiKbjRnP9ZeSgoT+HU
         LIU1wtU8188+OFSCYJRM4PQIlHbVigODh6Z+bCE5K4Ifn+qd9V1QyONJBv+LbuUMLw3g
         O1vSLuVslQ4ILQuZtzeJs1seJpVnKucZQvnTg=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to;
        bh=eqnicDfGf0dQKKt1jU8gwdO73pHw7L4fwxISKDMieuw=;
        b=iYin8gWsr9HG6anv/kFAMrvJj9UR9hwOEYDEo8mfwChkM9ca/NvrS6yCT7NpiGMzJK
         m0uNmn0F3QZoOBgotimavIoUhSjBb/aZCnec9EKhTHYzjAKOpLzLvGuZ8FT65UwteKbm
         mQb63alMNKKDjNa3qR0DGDlMZ6cuSECta8mDsosnkJI5c8N0XP92eW8TUgMiD3TKODU6
         RDM7nwgMbTDO57K2Ev8WyLcbjo8M6w0nO5uRlqUId585F9p/41wJgfAcpXGkxEAlAA43
         pDZgsTL2w+ABBTZ+mwsvGvMLB/F0tQxqgGfFXzgYJ8pzlvJbwEAgi9JX8PJx6PcZKPn6
         oCtA==
X-Gm-Message-State: APjAAAU3mSkAQvd6sEocI3auJBvN/2FqWI8huW0wjnhYTfFZpV15OltQ
        MS26IZmX3OodtTIdiwG/B9YBDcdYXx0LacrwGj/jLCiEL5yNBw==
X-Google-Smtp-Source: APXvYqxmpSV4z1A8wMboTHXeOlzHy+TDu+W5grHiIEnTPGnGlM0CsrIm2jSpq9Ica5w6wPg2Wac6DbGA9uNJEixM7GQ=
X-Received: by 2002:ac8:4252:: with SMTP id r18mr33179490qtm.357.1564719628630;
 Thu, 01 Aug 2019 21:20:28 -0700 (PDT)
MIME-Version: 1.0
From:   Ivan Babrou <ivan@cloudflare.com>
Date:   Thu, 1 Aug 2019 21:20:17 -0700
Message-ID: <CABWYdi0aifR5EDAMVJ2vh6nURXwc0ED75hOkkWvU6-8icmvM_A@mail.gmail.com>
Subject: [PATCH] expr: allow export of notrack expr
To:     netfilter-devel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Currently it's impossible to export notrack expr as json,
as it lacks snprintf member and triggers segmentation fault.

There are no parameters to notrack, so there's nothing
to do, but it should be an explicit function that does nothing.

Signed-off-by: Ivan Babrou <ivan@cloudflare.com>
---
 src/expr_ops.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/src/expr_ops.c b/src/expr_ops.c
index 3538dd6..a2e1dd3 100644
--- a/src/expr_ops.c
+++ b/src/expr_ops.c
@@ -42,8 +42,16 @@ extern struct expr_ops expr_ops_tunnel;
 extern struct expr_ops expr_ops_osf;
 extern struct expr_ops expr_ops_xfrm;

+static int
+nftnl_expr_notrack_snprintf(char *buf, size_t len, uint32_t type,
+   uint32_t flags, const struct nftnl_expr *e)
+{
+ return -1;
+}
+
 static struct expr_ops expr_ops_notrack = {
  .name = "notrack",
+ .snprintf = nftnl_expr_notrack_snprintf,
 };

 static struct expr_ops *expr_ops[] = {
--
2.22.0
