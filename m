Return-Path: <SRS0=Me6e=UC=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D72C4C282CE
	for <netfilter-devel@archiver.kernel.org>; Mon,  3 Jun 2019 16:01:42 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id B138F2768A
	for <netfilter-devel@archiver.kernel.org>; Mon,  3 Jun 2019 16:01:42 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=paul-moore-com.20150623.gappssmtp.com header.i=@paul-moore-com.20150623.gappssmtp.com header.b="RAknaK6H"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728963AbfFCQBi (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 3 Jun 2019 12:01:38 -0400
Received: from mail-lf1-f66.google.com ([209.85.167.66]:46829 "EHLO
        mail-lf1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728364AbfFCQBh (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 3 Jun 2019 12:01:37 -0400
Received: by mail-lf1-f66.google.com with SMTP id l26so14000604lfh.13
        for <netfilter-devel@vger.kernel.org>; Mon, 03 Jun 2019 09:01:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=paul-moore-com.20150623.gappssmtp.com; s=20150623;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=wwAb+fjZakb4SE3XBU2vDo+/FsY9YcZ27a86p6XEaAs=;
        b=RAknaK6HJEQ5zkQCebN0zIeweiFarG87mqZWgTXpU/mJYEt/DEie3H3GUrpMAkizhf
         DAjrek0lkfPev895ypNRKOioKwTHoHppJhQCGVAq+NcSFX9QQKad4aQE4NgXUszbotod
         HpqE5XLtyZaVR5/qdNcdgb7ceGwsUQvR666euqtSsqc3OmniQ2styCZ5A6fa8wFzmYab
         XQWs/R8Zv9uWMeeBYycMepmlBwpgKHulJsqz5096zetgsMifJSoInjVF+zauJ7Lcd+ZK
         poQFphqqutbXYOSTji0TJpFkZiZboByLaWGvrwJDqBIG4csRSA2uepIebTq5Rhzk3wDG
         LSOw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=wwAb+fjZakb4SE3XBU2vDo+/FsY9YcZ27a86p6XEaAs=;
        b=KR8yfvcyfQkA4Ksvat5VtHaGd6kwRLf9/ND4eQUoxqMPBkeOdMwC6tsbEZVh/NHF8n
         NC75CBcwv8mEh/kNWCVLDEwujyQHz9sT7SxQi4zwgEi4kXxM8VM8LLESBzWJ6EVuML37
         ymYceQ9RZWxgV6ix8nJJMUHhMSMhdFrM4pJh/Rlxsqme9cxi8xSuqjnofRqNTLWphW5O
         6yw+5ivhzZjLdMKsfTuMVZsQjmYs6bHBDdM770pr91YU3aGa3SDPN/4YB9x88akxSp39
         1N7wpp71f6db9RQ4ntD880WRl4yMXE6BorqNi+v2eAfxLTwtHXzQi5cSRZzXWN4/1ZR2
         qu7Q==
X-Gm-Message-State: APjAAAVIwbcTsYpQ4gacsz4QFLW++U2jtlEHw9RAikn3Nahps/4NSUFZ
        3PFsQrMCc5yb1wb9GQ9QhyI2uWPSOVbu/gwQ9V8K
X-Google-Smtp-Source: APXvYqzF84jTm/2bsJE8Z7872PStSoK3LKry51awtLL9AllXtZ9eS6eWxt9+Bys/+Qo1UsfILlV7LgRg51RsyxVhV98=
X-Received: by 2002:ac2:446b:: with SMTP id y11mr9514878lfl.158.1559577695379;
 Mon, 03 Jun 2019 09:01:35 -0700 (PDT)
MIME-Version: 1.0
References: <fadb320e38a899441fcc693bbbc822a3b57f1a46.1559239558.git.rgb@redhat.com>
In-Reply-To: <fadb320e38a899441fcc693bbbc822a3b57f1a46.1559239558.git.rgb@redhat.com>
From:   Paul Moore <paul@paul-moore.com>
Date:   Mon, 3 Jun 2019 12:01:24 -0400
Message-ID: <CAHC9VhQZuOXiK4yj4xeRwGF_qepeg7qDL02GDdYhwTNRLRdmPA@mail.gmail.com>
Subject: Re: [PATCH ghak90 V6] fixup! audit: add containerid filtering
To:     Richard Guy Briggs <rgb@redhat.com>
Cc:     containers@lists.linux-foundation.org, linux-api@vger.kernel.org,
        Linux-Audit Mailing List <linux-audit@redhat.com>,
        linux-fsdevel@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
        netdev@vger.kernel.org, netfilter-devel@vger.kernel.org,
        sgrubb@redhat.com, omosnace@redhat.com, dhowells@redhat.com,
        simo@redhat.com, Eric Paris <eparis@parisplace.org>,
        Serge Hallyn <serge@hallyn.com>, ebiederm@xmission.com,
        nhorman@tuxdriver.com
Content-Type: text/plain; charset="UTF-8"
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Fri, May 31, 2019 at 1:54 PM Richard Guy Briggs <rgb@redhat.com> wrote:
>
> Remove the BUG() call since we will never have an invalid op value as
> audit_data_to_entry()/audit_to_op() ensure that the op value is a a
> known good value.
>
> Signed-off-by: Richard Guy Briggs <rgb@redhat.com>
> ---
>  kernel/auditfilter.c | 1 -
>  1 file changed, 1 deletion(-)

Thanks for sending this out.  However, in light of the discussion in
the patchset's cover letter it looks like we need to better support
nested container orchestrators which is likely going to require some
non-trivial changes to the kernel/userspace API.  Because of this I'm
going to hold off pulling these patches into a "working" branch,
hopefully the next revision of these patches will solve the nested
orchestrator issue enough that we can continue to move forward with
testing.

> diff --git a/kernel/auditfilter.c b/kernel/auditfilter.c
> index 407b5bb3b4c6..385a114a1254 100644
> --- a/kernel/auditfilter.c
> +++ b/kernel/auditfilter.c
> @@ -1244,7 +1244,6 @@ int audit_comparator64(u64 left, u32 op, u64 right)
>         case Audit_bittest:
>                 return ((left & right) == right);
>         default:
> -               BUG();
>                 return 0;
>         }
>  }
> --
> 1.8.3.1
>


-- 
paul moore
www.paul-moore.com
