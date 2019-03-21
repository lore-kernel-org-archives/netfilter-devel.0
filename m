Return-Path: <SRS0=rW9L=RY=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D3F32C43381
	for <netfilter-devel@archiver.kernel.org>; Thu, 21 Mar 2019 23:23:01 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 93BA9218D3
	for <netfilter-devel@archiver.kernel.org>; Thu, 21 Mar 2019 23:23:01 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="iRtgRI2M"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727047AbfCUXXB (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 21 Mar 2019 19:23:01 -0400
Received: from mail-lf1-f41.google.com ([209.85.167.41]:47041 "EHLO
        mail-lf1-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726374AbfCUXXB (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 21 Mar 2019 19:23:01 -0400
Received: by mail-lf1-f41.google.com with SMTP id r25so80434lfn.13
        for <netfilter-devel@vger.kernel.org>; Thu, 21 Mar 2019 16:22:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:from:date:message-id:subject:to;
        bh=NXt3ueMq5TM4LT4nMA7k95VunIQYUEQ/YwXMAXKeM9o=;
        b=iRtgRI2MFa43q1GsSmRx0BugDz9HDnpAMbc8/Y/L2Kn5R13ratTR/XUJCy/dCOYVjH
         lSGEWtZF0o6V77ysY271F2SO9dx6w1SjH1BDbfa69yXZQY3jIzGzRyDyh6RUe+AmqpiP
         JLfiyWRJFIEZvPBDSp1NKgd4nWqZK8GP3ij5bu77tWmhMWW3EB38aqaxgTUgqojFsItA
         PFYn4MAVfyuIR/uOj21BnUBRag4XeUyFuWdiIa1MnV0jOTUYykZcvm8Iwg5JZ4lz34lc
         G8H8nkabZZtl1OFK3F6ZNxQxrtq0+wzCEGsHpcCQcW/vDZVpb9PlvN8VxXkey1odgWX4
         G8TQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to;
        bh=NXt3ueMq5TM4LT4nMA7k95VunIQYUEQ/YwXMAXKeM9o=;
        b=V/vGkveHvUAFwXjjaLwTiNW07xPAiwkyEe4cW7029REf8xqhPZMRnFSuXk+DwBtZFy
         W7n1b02YLJBJbbOtitnXXosiE0RzNSALd0+6lAxKpNEJLCkYorIfnDkrK25EamB5QDb5
         RCsba6P2l4QugcmcZyTfT54S4+A5bLoEFjklJ9EUSK1Z45fAnYzVer0M/vCVI/0A6YJw
         rbwIykNk0RJqZ9ahNrYgEtcLcoyHY1MUlwRe7H9f2bnwapoi+jukjplL/HdJUhZUwamT
         /vqIgelpk5q7HmdRKoxADZMEi7We+I9vx9VyfLPHP/KQKL+8cDrtH44TAC24UfGY0I1F
         lsgQ==
X-Gm-Message-State: APjAAAV+PqIMji8jQD3aJrpQjK+v1JrMgnXEuRG7SN7Fq6Mg77sy7pGu
        xLQP5+8u6v3qO861KqdGCR+2IQWbbIGO71N4xgrTYQvo
X-Google-Smtp-Source: APXvYqw9fqW6DYBC2Bg2uQu7VccNAUSPu66zr8p2SjWXkd+FY6uI/lxqWaMptemwI2uDmSN8ryB+pLA9XwUpovsFnms=
X-Received: by 2002:a19:9145:: with SMTP id y5mr3642786lfj.35.1553210578637;
 Thu, 21 Mar 2019 16:22:58 -0700 (PDT)
MIME-Version: 1.0
From:   Sam Banks <sam.banks.nz@gmail.com>
Date:   Fri, 22 Mar 2019 12:22:47 +1300
Message-ID: <CAMbLQsynsgPK_yue8BusSU6k7-NXgD2=9VaUMwPuVzR9G+ri2w@mail.gmail.com>
Subject: Typo in extensions/libxt_osf.man
To:     netfilter-devel@vger.kernel.org
Content-Type: multipart/mixed; boundary="000000000000cd37f60584a304ce"
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

--000000000000cd37f60584a304ce
Content-Type: text/plain; charset="UTF-8"

Hi,

I was browsing the iptables-extensions man page and spotted a typo in
the osf section. I've attached a patch which corrects it.

Cheers,

Sam.

--000000000000cd37f60584a304ce
Content-Type: text/x-patch; charset="US-ASCII"; name="libxt_osf.man.patch"
Content-Disposition: attachment; filename="libxt_osf.man.patch"
Content-Transfer-Encoding: base64
Content-ID: <f_jtj9djkf0>
X-Attachment-Id: f_jtj9djkf0

ZGlmZiAtLWdpdCBhL2V4dGVuc2lvbnMvbGlieHRfb3NmLm1hbiBiL2V4dGVuc2lvbnMvbGlieHRf
b3NmLm1hbgppbmRleCBmM2E4NWZiLi41YmE5MmNlIDEwMDY0NAotLS0gYS9leHRlbnNpb25zL2xp
Ynh0X29zZi5tYW4KKysrIGIvZXh0ZW5zaW9ucy9saWJ4dF9vc2YubWFuCkBAIC00MSw1ICs0MSw1
IEBAIFRvIHJlbW92ZSB0aGVtIGFnYWluLAogLlBQCiBcZkJuZm5sX29zZiAtZiAvdXNyL3NoYXJl
L3h0YWJsZXMvcGYub3MgLWRcZlAKIC5QUAotVGhlIGZpbmdlcnByaW50IGRhdGFiYXNlIGNhbiBi
ZSBkb3dubGFvZGVkIGZyb20KK1RoZSBmaW5nZXJwcmludCBkYXRhYmFzZSBjYW4gYmUgZG93bmxv
YWRlZCBmcm9tCiBodHRwOi8vd3d3Lm9wZW5ic2Qub3JnL2NnaS1iaW4vY3Zzd2ViL3NyYy9ldGMv
cGYub3MgLgo=
--000000000000cd37f60584a304ce--
