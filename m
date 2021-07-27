Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 40289C4338F
	for <netfilter-devel@archiver.kernel.org>; Tue, 27 Jul 2021 11:19:11 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 113BE6054F
	for <netfilter-devel@archiver.kernel.org>; Tue, 27 Jul 2021 11:19:11 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236326AbhG0LTJ (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 27 Jul 2021 07:19:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60814 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236284AbhG0LTI (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 27 Jul 2021 07:19:08 -0400
Received: from mail-lj1-x229.google.com (mail-lj1-x229.google.com [IPv6:2a00:1450:4864:20::229])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AB50DC061757;
        Tue, 27 Jul 2021 04:19:08 -0700 (PDT)
Received: by mail-lj1-x229.google.com with SMTP id e5so15438361ljp.6;
        Tue, 27 Jul 2021 04:19:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:from:date:message-id:subject:to;
        bh=1JX+ZuxpFYJrHa2C/X3TLcDrsbZOOIKz4FHeTxuU2/k=;
        b=kwk6OU2heV4rRnyasqjIsQ69eFLv9M2vvZ/jDt4lHvD3Fk+UiOn86sH7RCKRG8tfN9
         sNMwFlJOWbFA6scJNdLHO2aq0jKBABLAGIBl63VEefqDwZHaTUFvpg5Z46qqeT3b8NmN
         qncw1cg/2hufOVdC3Dl2I4FjX9eZmR9W+IhxCZEbx4ZJ5Qta5Fli0jQGTsc6hiDyigQF
         M682vwa6AajPtVVPtQSOagCd6yI0W3uk3xkKO63jBLaTSHNMOnIp+7VSaME16mKe8EE+
         7uckdGSvCJpWV2ps6cFQ/a6apUKsd69qg29yJq4zAo50CSg6CkpUJ8HUnPQf4wEunuEJ
         XocQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to;
        bh=1JX+ZuxpFYJrHa2C/X3TLcDrsbZOOIKz4FHeTxuU2/k=;
        b=faAG6PT7WChtpSQQEbPOTu73qEpgBQmJyrNcI8j3/1trM5AXx2V9l/Mge8hk3sYDuf
         wuxPychfd4zp9aNdwaQ1vnvCcw9mvOvQTygV/9MpkCRYcToqTR/lPVD+YCp6i3vjD1Ms
         qXxdCBGNQHyYGaBepwzAx98jpWD8QgJINDq6tkFIkV2jhXjqfA/2HXDl81Xygo94vJL+
         DxBglsLOPY8BmIdcLgGQJHjclbyeofEhVX4i0hr0cs2CEkT1LU48GtDjQGlmjGLvBAHK
         W1awahrKt+FIX4aCraoXAL/dP+zKA7JnpVeAG3nYQg6kHj9gPr4FHNFp6Og6RL59Zu7F
         crzA==
X-Gm-Message-State: AOAM533ewpyHz2FXuzoZSjC+MwobmAb2Fdl29C4U370dLtq64jJTLUtd
        fo6GJ2db1GQFge7PtInD8MTMDp3b+e/yYQ287eFUqHcQroF+HA==
X-Google-Smtp-Source: ABdhPJwn8vcjiWXzipe41ro8SRuckcaXGs1Q2QWjqodFlnrqJwk3ghht43mrnmBJbIa3zYJDTgd0NKfpAXlCYYn+7IM=
X-Received: by 2002:a05:651c:896:: with SMTP id d22mr15434670ljq.242.1627384746360;
 Tue, 27 Jul 2021 04:19:06 -0700 (PDT)
MIME-Version: 1.0
From:   Tom Yan <tom.ty89@gmail.com>
Date:   Tue, 27 Jul 2021 19:18:55 +0800
Message-ID: <CAGnHSEkt4xLAO_T9KNw2xGjjvC4y=E0LjX-iAACUktuCy0J7gw@mail.gmail.com>
Subject: [nft] Regarding `tcp flags` (and a potential bug)
To:     netfilter@vger.kernel.org, netfilter-devel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Hi all,

I'm a bit uncertain how `tcp flags` works exactly. I once thought `tcp
flags syn` checks whether "syn and only syn is set", but after tests,
it looks more like it checks only whether "syn is set" (and it appears
that the right expression for the former is `tcp flags == syn`):

# nft add rule meh tcp_flags 'tcp flags syn'
# nft add rule meh tcp_flags 'tcp flags ! syn'
# nft add rule meh tcp_flags 'tcp flags == syn'
# nft add rule meh tcp_flags 'tcp flags != syn'
# nft list table meh
table ip meh {
    chain tcp_flags {
        tcp flags syn
        tcp flags ! syn
        tcp flags == syn
        tcp flags != syn
    }
}

Then I test the above respectively with a flag mask:

# nft add rule meh tcp_flags 'tcp flags & (fin | syn | rst | ack) syn'
# nft add rule meh tcp_flags 'tcp flags & (fin | syn | rst | ack) ! syn'
# nft add rule meh tcp_flags 'tcp flags & (fin | syn | rst | ack) == syn'
# nft add rule meh tcp_flags 'tcp flags & (fin | syn | rst | ack) != syn'
# nft list table meh
table ip meh {
    chain tcp_flags {
        tcp flags & (fin | syn | rst | ack) syn
        tcp flags & (fin | syn | rst | ack) ! syn
        tcp flags syn / fin,syn,rst,ack
        tcp flags syn / fin,syn,rst,ack
    }
}

I don't suppose the mask in the first two rules would matter. And with
`tcp flags syn / fin,syn,rst,ack`, I assume it would be false when
"syn is cleared and/or any/all of fin/rst/ack is/are set"?

Also, as you can see, for the last two rules, `nft` interpreted them
as an identical rule, which I assume to be a bug. These does NOT seem
to workaround it either:

# nft flush chain meh tcp_flags
# nft add rule meh tcp_flags 'tcp flags == syn / fin,syn,rst,ack'
# nft add rule meh tcp_flags 'tcp flags != syn / fin,syn,rst,ack'
# nft list table meh
table ip meh {
    chain tcp_flags {
        tcp flags syn / fin,syn,rst,ack
        tcp flags syn / fin,syn,rst,ack
    }
}

I'm not sure if `! --syn` in iptables (legacy) is affected by this as
well. Anyway, I'm doing the following for now as a workaround:

# nft flush chain meh tcp_flags
# nft add rule meh tcp_flags 'tcp flags ! syn reject with tcp reset'
# nft add rule meh tcp_flags 'tcp flags { fin, rst, ack } reject with tcp reset'
# nft list table meh
table ip meh {
    chain tcp_flags {
        tcp flags ! syn reject with tcp reset
        # syn: 1, other bits: not checked
        tcp flags { fin, rst, ack } reject with tcp reset
        # syn: 1, fin: 0, rst: 0, ack: 0, other bits: not checked
        ct state != invalid accept
    }
}

Are the comments in above correct? Are any of the assumptions in this
email incorrect?

As a side question, is it even possible that any packet will be
considered `invalid` with (syn: 1, fin: 0, rst: 0, ack: 0)?

Thanks in advance!

Regards,
Tom
