Return-Path: <SRS0=LRZR=3U=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.7 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1E3ADC35240
	for <netfilter-devel@archiver.kernel.org>; Fri, 31 Jan 2020 03:17:46 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id E659320CC7
	for <netfilter-devel@archiver.kernel.org>; Fri, 31 Jan 2020 03:17:45 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=paul-moore-com.20150623.gappssmtp.com header.i=@paul-moore-com.20150623.gappssmtp.com header.b="jrkCIayf"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727913AbgAaDRp (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 30 Jan 2020 22:17:45 -0500
Received: from mail-ed1-f67.google.com ([209.85.208.67]:37995 "EHLO
        mail-ed1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727739AbgAaDRo (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 30 Jan 2020 22:17:44 -0500
Received: by mail-ed1-f67.google.com with SMTP id p23so6235757edr.5
        for <netfilter-devel@vger.kernel.org>; Thu, 30 Jan 2020 19:17:42 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=paul-moore-com.20150623.gappssmtp.com; s=20150623;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=oIg4izJ3dY0xBGHn3X1cuTzljmHGk0vFwMx8ad4w19E=;
        b=jrkCIayfH2CK8HceNhz9wMOG52M88EbYtjRjCrEHVAtiKxCEmkyk/ZivE2K8qKvnOP
         HiKlStkoa44zoxtKztVQKgk2LAIEkXfl2sGUbZRd/rcz/up0Q6G7HLb8vsgcaxt9uOY9
         aYUflFB+ekOmAtRwng+VLIOSqXxa52B5DqgIqnb4MZOtYIgZfS6+iD1qDIBWDAl+GAAb
         lH0vns5J8GHXg/fYr7nOIVnhQBcdvD2p4tjjbbJcw1Ih+6RAdvgtGnOqrbSSgvqC422/
         X+egx8zvpsjnWhJQegjGuqgQlg06uBZaDaQ5Djy0/WnQzk9KMCQ0AV4FEDi967Pl8i++
         THiA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=oIg4izJ3dY0xBGHn3X1cuTzljmHGk0vFwMx8ad4w19E=;
        b=BOhuP02qzZIWMXw7Frj+1t8gHPM6YDYfHOY2hcWAyXAK+u3PcHDrssfXG27F+PYPec
         p17yfIiuXS1rwgRdQli4+0p0hvCwOU5TizJd+xwv00hg35qQ/IFm5rh379RLBeMUTWiw
         6R4fW+vB9m+CmNj1EpysttnXF3dh55Jy0iYY4NIJ5ZpD7lPofR9A00AHQ6H0LdVU8mUZ
         ve+1xkcQpcUXTE1TNztrnfwcxCqFt3hi14a2EncKsZ6fx3+t0uWrtmd73xpH+ogSYkhj
         t1hQOxEdTOB7V5FTVOZE9KWpkMYQgtSoDs1KTHWNppY6nT22jYLq+zYoF5COHtCFwpbY
         aCRQ==
X-Gm-Message-State: APjAAAUVBq3o/qvH+LlGwp9XNJ9GpsxRsPTe8wGdxQFYG2ijcfQXxA04
        e2+3STKVQKh5/xeizMVbnvVgtUTe0rTlSOaL1eli
X-Google-Smtp-Source: APXvYqzzdWfnLzyByQcFVGmQCzqJhEsT1dBRVturw9d61zDsL2ZmJkMBe/HXMeV5fccEH2eEGkyfWfY/Ux/vDgbn3ec=
X-Received: by 2002:a17:906:9352:: with SMTP id p18mr6813461ejw.95.1580440661314;
 Thu, 30 Jan 2020 19:17:41 -0800 (PST)
MIME-Version: 1.0
References: <cover.1577830902.git.rgb@redhat.com> <194bdc565d548a14e12357a7c1a594605b7fdf0f.1577830902.git.rgb@redhat.com>
In-Reply-To: <194bdc565d548a14e12357a7c1a594605b7fdf0f.1577830902.git.rgb@redhat.com>
From:   Paul Moore <paul@paul-moore.com>
Date:   Thu, 30 Jan 2020 22:17:30 -0500
Message-ID: <CAHC9VhT9T-UMnu6bWdd733XB6QaP+Sm3KWhdy828RN_FVWBMmw@mail.gmail.com>
Subject: Re: [PATCH ghak25 v2 1/9] netfilter: normalize x_table function declarations
To:     Richard Guy Briggs <rgb@redhat.com>
Cc:     Linux-Audit Mailing List <linux-audit@redhat.com>,
        LKML <linux-kernel@vger.kernel.org>,
        netfilter-devel@vger.kernel.org, sgrubb@redhat.com,
        omosnace@redhat.com, fw@strlen.de, twoerner@redhat.com,
        Eric Paris <eparis@parisplace.org>, ebiederm@xmission.com,
        tgraf@infradead.org
Content-Type: text/plain; charset="UTF-8"
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Mon, Jan 6, 2020 at 1:54 PM Richard Guy Briggs <rgb@redhat.com> wrote:
> Git context diffs were being produced with unhelpful declaration types
> in the place of function names to help identify the funciton in which
                                                      ^^^^^^^^
                                                      function
> changes were made.
>
> Normalize x_table function declarations so that git context diff
> function labels work as expected.
>
> Signed-off-by: Richard Guy Briggs <rgb@redhat.com>
> ---
>  net/netfilter/x_tables.c | 43 ++++++++++++++++++-------------------------
>  1 file changed, 18 insertions(+), 25 deletions(-)

Considering that this patch is a style change in code outside of
audit, and we want to merge this via the audit tree, I think it is
best if you drop the style changes from this patchset.  You can always
submit them later to the netfilter developers.

--
paul moore
www.paul-moore.com
