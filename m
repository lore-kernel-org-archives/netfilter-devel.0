Return-Path: <SRS0=I0Q5=UL=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 287DCC31E46
	for <netfilter-devel@archiver.kernel.org>; Wed, 12 Jun 2019 08:06:55 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id F067620684
	for <netfilter-devel@archiver.kernel.org>; Wed, 12 Jun 2019 08:06:54 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="CEplX94Z"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729801AbfFLIGy (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 12 Jun 2019 04:06:54 -0400
Received: from mail-oi1-f193.google.com ([209.85.167.193]:44817 "EHLO
        mail-oi1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726716AbfFLIGy (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 12 Jun 2019 04:06:54 -0400
Received: by mail-oi1-f193.google.com with SMTP id e189so11002536oib.11
        for <netfilter-devel@vger.kernel.org>; Wed, 12 Jun 2019 01:06:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to;
        bh=DDhtR8I1iAhz9d3XARjFnXP/03Wc7Vhow6II+JIZ48Y=;
        b=CEplX94Z4JPiciVeMU5o+qrDJ1CR3F7qOXN/fHyaSkF1vgIMd4K0WE9C6YZWD06+0N
         JVkH1foS4y6tYdz+ToLwxvbPvwamYYUBOYSU1u01D8eAm0t14IZ4ZStj1aIKT8I/xCHS
         O0ipDziKBkt3b8k4ZDEm3iEpdaql5A1QxD2sOZxaXhzQMTIEG7irxcoimeDw6wMv8LfX
         gUlK17EtvutKX4HB8nkmTlSfD8xR8zrayH9lbHM00IZH8meA3htC5vQa4OjNpXWIXkJY
         o/5ocgrH3SuDLgSTKSyXGhlhBU+7yxUgcSTKmRtD4DelMy+1rGz+/Oplqf+6+yLF+qKE
         GAAw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to;
        bh=DDhtR8I1iAhz9d3XARjFnXP/03Wc7Vhow6II+JIZ48Y=;
        b=Hv5QtW5NIhisdDylC4NP/L/RcuQdREta7LfdjCeov/wz3V2KcAUVnOFwP9p7R5HkyM
         RpZh+gqtKucvbxdx5pgw5ZugrduDhQEDzqVV+rBkNIx627t1PJ17Xqj3BFqeGjimVWrO
         mMmNtpjJhhgJSC7WoWTYdn6MQqbO9cceHePfwKIX962+5TaimPUotgGl8O0EAS+UEnDN
         eC0FQz8iMhyQ3MDe4m6/YsJN62vAcSEKwDPVUeu/gA6pwzCMyJYldfMMx95u88q4T2T6
         +gRN3BZU0fteKctXHTWXKGZyS1coQ1KAtlA2TuHnK1KYyFIb3OleV2dOfHo+f+Rz1x2k
         GFjQ==
X-Gm-Message-State: APjAAAUvRPjLx2Oebt6CDskNQxUQ4jDyzEfgy87YrM9WmwVN+4v+hEaZ
        +WVbJM3FryYx+iMWYQcMMrSb8EjyV4RmEHrw0NwL7+YN
X-Google-Smtp-Source: APXvYqwZuL1gNLx8mPNDyTPeWqiJcyWvz8WveNmzc+UcoNNsXibVYGv9cMefTAh85oN05r74bdNC/LcBgbstTffpPm0=
X-Received: by 2002:aca:4202:: with SMTP id p2mr18583225oia.85.1560326813559;
 Wed, 12 Jun 2019 01:06:53 -0700 (PDT)
MIME-Version: 1.0
References: <20190606195058.4411-1-shekhar250198@gmail.com> <20190611185909.lxxmgw5zbmqgq2ek@egarver.localdomain>
In-Reply-To: <20190611185909.lxxmgw5zbmqgq2ek@egarver.localdomain>
From:   shekhar sharma <shekhar250198@gmail.com>
Date:   Wed, 12 Jun 2019 13:36:42 +0530
Message-ID: <CAN9XX2qUAYXer1fmi1ksiiu1LC-WjtiTJ3xGBqKF2B+7OAv_9Q@mail.gmail.com>
Subject: Re: [PATCH iptables v1] iptables-test: fix python3
To:     Eric Garver <eric@garver.life>,
        Shekhar Sharma <shekhar250198@gmail.com>,
        Netfilter Development Mailing list 
        <netfilter-devel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Wed, Jun 12, 2019 at 12:29 AM Eric Garver <eric@garver.life> wrote:
>
> On Fri, Jun 07, 2019 at 01:20:58AM +0530, Shekhar Sharma wrote:
> > This patch converts the 'iptables-test.py' file (iptables/iptables-test.py) to run on
> > both python 2 and python3.
> >
> >
> > Signed-off-by: Shekhar Sharma <shekhar250198@gmail.com>
> > ---
> >  iptables-test.py | 43 ++++++++++++++++++++++---------------------
> >  1 file changed, 22 insertions(+), 21 deletions(-)
> >
> > diff --git a/On Sun, Jun 09, 2019 at 11:48:49PM +0530, Shekhar Sharma wrote:
> This patch adds the netns feature to the 'nft-test.py' file.
>
> Signed-off-by: Shekhar Sharma <shekhar250198@gmail.com>
> ---
> The version history of the patch is :
> v1: add the netns feature
> v2: use format() method to simplify print statements.
> v3: updated the shebang
> v4: resent the same with small changes
>
>  tests/py/nft-test.py | 98 ++++++++++++++++++++++++++++++++++++--------
>  1 file changed, 80 insertions(+), 18 deletions(-)
>
> diff --git a/tests/py/nft-test.py b/tests/py/nft-test.py
> index 4e18ae54..c9f65dc5 100755
> --- a/tests/py/nft-test.py
> +++ b/tests/py/nft-test.py
[..]
iptables-test.py b/iptables-test.py
> > index 532dee7..8018b65 100755
> > --- a/iptables-test.py
> > +++ b/iptables-test.py
> [..]
> > @@ -79,7 +80,7 @@ def run_test(iptables, rule, rule_save, res, filename, lineno, netns):
> >
> >      cmd = iptables + " -A " + rule
> >      if netns:
> > -            cmd = "ip netns exec ____iptables-container-test " + EXECUTEABLE + " " + cmd
> > +            cmd = "ip netns exec ____iptables-container-test " + EXECUTEABLE + "  {}".format(cmd)
>
> This is a bogus change. No reason to switch to format() when we're just
> concatenating strings. Many occurrences of this in the patch.
>
> I think you only need to fix the print statements.
>

Okay, i will change it and resend the patch.
> >
> >      ret = execute_cmd(cmd, filename, lineno)
> >
> [..]
> > @@ -365,9 +366,9 @@ def main():
> >              passed += file_passed
> >              test_files += 1
> >
> > -    print ("%d test files, %d unit tests, %d passed" %
> > -           (test_files, tests, passed))
> > +    print("{} test files, {} unit tests, {} passed".format(test_files, tests, passed))
> >
> >
> >  if __name__ == '__main__':
> >      main()
> > +
>
> Bogus new line.

Should i change the shebang to this here as well?
#!/usr/bin/env python


Thanks!
Shekhar
