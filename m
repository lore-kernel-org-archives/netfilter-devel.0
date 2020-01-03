Return-Path: <SRS0=aqP0=2Y=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.7 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,
	SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6470FC2D0C2
	for <netfilter-devel@archiver.kernel.org>; Fri,  3 Jan 2020 18:09:31 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 297642085B
	for <netfilter-devel@archiver.kernel.org>; Fri,  3 Jan 2020 18:09:31 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="LsC/46BG"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728225AbgACSJa (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Fri, 3 Jan 2020 13:09:30 -0500
Received: from mail-io1-f67.google.com ([209.85.166.67]:43853 "EHLO
        mail-io1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728201AbgACSJa (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 3 Jan 2020 13:09:30 -0500
Received: by mail-io1-f67.google.com with SMTP id n21so40544544ioo.10
        for <netfilter-devel@vger.kernel.org>; Fri, 03 Jan 2020 10:09:30 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:from:date:message-id:subject:to;
        bh=TUC5xVgfnnl70DfFwx5tW6a3R2gIX2Rz5WybyXMhdQM=;
        b=LsC/46BGYKiQBLReiHP0nOsCDKcd7+B7HKvIltSLN5bNZzdfwWU3GI3NbfLFbB1C3R
         Afjq0zLdw8MnHrsRQPr5mRQraNg0hjdUMQ/gxyEwjK2heCjuIvdbjmhSGHn7lpCWOuVX
         JGbKFThyFHKeCEIYrgcEOI+x2QMd5CX+K0rE9NXF5ZHQwWPVnladgPZDqA9BwrHvtsJV
         8v+CZ7TQR8ltQo+ntmdOcdCxdiXx291LDfeQHkqc4H5/2SEGvdx1aLWztTs/Sy78fyPH
         EK8yGw6uLCfv6SamqNOfTRFiA9R9tdte6lIInLyV/SSWURM5ryA9OjNn8YLCpPakHbJx
         p+Gw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to;
        bh=TUC5xVgfnnl70DfFwx5tW6a3R2gIX2Rz5WybyXMhdQM=;
        b=rQeldp/LRjM6laXuE/NVkXVBZ9zM49w1Xgysh4otcftWWqQuRxi+QSonvRHmWfW1wp
         dW0cbAupFAtKH0LxbGIC/WCx9ZtpfwEFka5fIae93VWWha3yVQBvwworNdjnCItAVXN4
         oVwLoVxbruQKAy8vt0+g41zgcZyUEG0MRzhI2j6LZ/Kao74nbtnm10z+6mBxAjEaCFpc
         +YHlJTu7OlvPwwpR8hILEuvUnqXGQAMmi2XgSFZQ/GI3tBRD5CraKR+NVLtRpmwmJOQi
         Zu++vrg/03n4dtRh6VIFGFHDliqOB2urrsue7en5TVDyQtsQqBQHerwIIq39rcfDLZM3
         GH6w==
X-Gm-Message-State: APjAAAX/lqYZdbGtsi6n9HtOoesoQ0TcY7uPxWAwVndSIF6BKng+1WBZ
        5K3cawZ4thuwbBVSoJoiCYPVMci6p8r0YnzuFUynFFef
X-Google-Smtp-Source: APXvYqymT56RBUKYdnJgrqim94H0La3d5iWtCe0DWZz8SYXtzGv7Cs0UkUoAIey2c82EmZ47lW8cIL2UsNFALgbnMo8=
X-Received: by 2002:a5e:8813:: with SMTP id l19mr62157357ioj.261.1578074969887;
 Fri, 03 Jan 2020 10:09:29 -0800 (PST)
MIME-Version: 1.0
From:   Alberto Leiva <ydahhrk@gmail.com>
Date:   Fri, 3 Jan 2020 12:09:19 -0600
Message-ID: <CAA0dE=UFhDmAnoOQpR33S59dP_v3UVrkX29YMJyqOYc3YF1FPA@mail.gmail.com>
Subject: Adding NAT64 to Netfilter
To:     netfilter-devel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Hello

I've been working on Jool, an open source IP/ICMP translator for a
while ([0]). It currently implements SIIT, NAT64 and (if everything
goes according to plan) will later this year also support MAP-T. It
currently works both as a Netfilter module (hooking itself to
PREROUTING) or as an xtables target, and I'm soon going to start
integrating it into nftables.

Actually, it's the same software once advertised by this guy: [1]

Several people have approached me over the years expressing their
desire to have it integrated into the kernel by default. The intent of
this mail is to query whether a merge of Jool into the Netfilter
project woud be well-received. Of course, I'm willing to make
adjustments if needed.

Here are some justifications that have been listed to me. For the sake
of credit, these are all stolen from [2]:

1. IPv6 is getting significantly more exposure
2. NAT64 is getting more required / will be a default thing to do,
along with MAP-E/T
3. OpenBSD already has the functionality in pf
4. Enabling it upstream can potentially help IPv6 migration world wide

Thoughts?

[0] https://jool.mx
[1] https://marc.info/?l=netfilter-devel&m=136271576812278&w=2
[2] https://github.com/NICMx/Jool/issues/273#issuecomment-568721875
