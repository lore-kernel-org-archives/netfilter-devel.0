Return-Path: <SRS0=I0Q5=UL=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6CE28C31E46
	for <netfilter-devel@archiver.kernel.org>; Wed, 12 Jun 2019 08:01:17 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 3E76920684
	for <netfilter-devel@archiver.kernel.org>; Wed, 12 Jun 2019 08:01:17 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="j16n253R"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729611AbfFLIBR (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 12 Jun 2019 04:01:17 -0400
Received: from mail-ot1-f67.google.com ([209.85.210.67]:33274 "EHLO
        mail-ot1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726554AbfFLIBQ (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 12 Jun 2019 04:01:16 -0400
Received: by mail-ot1-f67.google.com with SMTP id p4so11337366oti.0
        for <netfilter-devel@vger.kernel.org>; Wed, 12 Jun 2019 01:01:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to;
        bh=J2cAogpfaPGIaHRHN0xoOE0K2iJA5JOX/TpIZv8P7zk=;
        b=j16n253RyC13xPEnnOJcRG7WJRGc9g72tQH1luNnX/xDVjyRskZmknLlxWlcQAmyWt
         PFYJ5QAEXHZvuHD6PKVd8lu1pl67/WJ4mEQXULMziqBi5c0a/lKq0UHVpE7NnwwrW7Yc
         zAe3u9VKB0HYcao5hgWjbO586SzDuov3DHsj8q6jOqc9Shx0Zx7tuZuyz5aoBU/pATy/
         obB3D8iXQKDEXnx/vvEUz2NP966lfMkXPjNhJeDMgW7SS2OTMVW5G6OZ3BF4YtZsxokD
         BxrvjjvLGxdPVDcQk6MkznvWJhC2p42k2B4qLiQV8ERDJ4hkyQOTZBEMPo8AiQGoR4/4
         azdA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to;
        bh=J2cAogpfaPGIaHRHN0xoOE0K2iJA5JOX/TpIZv8P7zk=;
        b=DXtEq9YAPeuMWaeHIixBvcKVrduHDikES/fSuB7OuBYWyJZWeTOKpZDs/bRuq+/zR6
         ZuGrFXmCBjz11begf7JNpdM2d+HE8cgt4+2X7auScsdT8o/90NRD9ns8ybvGDJnv4KUN
         dYZ5bPSoSQJdS80wUZxlPcVKtDG0aa3wkEym67nPOVpTLRliW58Qkm4e/RwblY9Ffg3j
         C7zpDw0ag+pc+K4xutoOcf/4C6cozTm5watqTEnNtKJBxU0EAAjOvIMnHL85ngAniAgI
         jTIK9mwfc0q1FTvrVmYrBX+bw3jY3IBrrAmqKiwiRDBOFcd1OdhCa+dRzDpMfsmvYPTZ
         drBA==
X-Gm-Message-State: APjAAAVTlaSDhPAww2GXtwq+NaaFKxJufOVldnO7ZzHQJXjjAfmrWX/C
        IaybV2A5bLVheLFeU7c+sEybzh5lHnkL2dLEwYE62w==
X-Google-Smtp-Source: APXvYqwbXcEI0c3yyNWg3FlvFDPVO6O7Svb6bAPVjrWG3LMewAMb0LxlLRo4IYXIffUltprKTfNRTxnXbl+S8qwQ2Tc=
X-Received: by 2002:a9d:2f26:: with SMTP id h35mr39458232otb.183.1560326475912;
 Wed, 12 Jun 2019 01:01:15 -0700 (PDT)
MIME-Version: 1.0
References: <20190609181849.10131-1-shekhar250198@gmail.com> <20190611184746.i5sg64gr4u2quiw5@egarver.localdomain>
In-Reply-To: <20190611184746.i5sg64gr4u2quiw5@egarver.localdomain>
From:   shekhar sharma <shekhar250198@gmail.com>
Date:   Wed, 12 Jun 2019 13:31:04 +0530
Message-ID: <CAN9XX2odx5Anac9wjWRvwz84XJ4ES_8QFRUgtS7dWiKW=gdHrw@mail.gmail.com>
Subject: Re: [PATCH nft v6 2/2]tests: py: add netns feature
To:     Eric Garver <eric@garver.life>,
        Shekhar Sharma <shekhar250198@gmail.com>,
        Netfilter Development Mailing list 
        <netfilter-devel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Wed, Jun 12, 2019 at 12:17 AM Eric Garver <eric@garver.life> wrote:
>
> On Sun, Jun 09, 2019 at 11:48:49PM +0530, Shekhar Sharma wrote:
> > This patch adds the netns feature to the 'nft-test.py' file.
> >
> > Signed-off-by: Shekhar Sharma <shekhar250198@gmail.com>
> > ---
> > The version history of the patch is :
> > v1: add the netns feature
> > v2: use format() method to simplify print statements.
> > v3: updated the shebang
> > v4: resent the same with small changes
> >
> >  tests/py/nft-test.py | 98 ++++++++++++++++++++++++++++++++++++--------
> >  1 file changed, 80 insertions(+), 18 deletions(-)
> >
> > diff --git a/tests/py/nft-test.py b/tests/py/nft-test.py
> > index 4e18ae54..c9f65dc5 100755
> > --- a/tests/py/nft-test.py
> > +++ b/tests/py/nft-test.py
> [..]
> > @@ -245,6 +251,8 @@ def table_delete(table, filename=None, lineno=None):
> >          return -1
> >
> >      cmd = "delete table %s" % table
> > +    if netns:
> > +        cmd = "ip netns exec ___nftables-container-test {}".format(cmd)
>
> Can we pass the netns name via the netns argument? Then we don't have to
> have instances of ___nftables-container-test in the command literals.
OK.

> Just make netns part of your string format. You can also change the
> default arg value to "".
>
Should i keep the default value in all the occurrences (in those
functions as well where no other default arguments are used? )

> Please fix all occurrences.
>
> >      ret = execute_cmd(cmd, filename, lineno)
> >      if ret != 0:
> >          reason = "%s: I cannot delete table %s. Giving up!" % (cmd, table)
> [..]
> > @@ -1208,6 +1262,9 @@ def run_test_file(filename, force_all_family_option, specific_file):
> >      filename_path = os.path.join(TESTS_PATH, filename)
> >      f = open(filename_path)
> >      tests = passed = total_unit_run = total_warning = total_error = 0
> > +    if netns:
> > +        execute_cmd("ip netns add ___nftables-container-test", filename, 0)
> > +
>
> netns is not defined here.
>
> >
> >      for lineno, line in enumerate(f):
> >          sys.stdout.flush()
> > @@ -1327,6 +1384,8 @@ def run_test_file(filename, force_all_family_option, specific_file):
> >      else:
> >          if tests == passed and tests > 0:
> >              print(filename + ": " + Colors.GREEN + "OK" + Colors.ENDC)
> > +        if netns:
> > +            execute_cmd("ip netns del ___nftables-container-test", filename, 0)
>
> netns is not defined here.

Sorry, will correct that.

Thanks!
Shekhar
