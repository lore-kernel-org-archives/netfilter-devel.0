Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DB4F7C433FE
	for <netfilter-devel@archiver.kernel.org>; Thu, 16 Dec 2021 12:24:04 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234262AbhLPMYC (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 16 Dec 2021 07:24:02 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41630 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236123AbhLPMYB (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 16 Dec 2021 07:24:01 -0500
Received: from mail-pg1-x52c.google.com (mail-pg1-x52c.google.com [IPv6:2607:f8b0:4864:20::52c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 83E19C061574
        for <netfilter-devel@vger.kernel.org>; Thu, 16 Dec 2021 04:24:01 -0800 (PST)
Received: by mail-pg1-x52c.google.com with SMTP id q16so22904959pgq.10
        for <netfilter-devel@vger.kernel.org>; Thu, 16 Dec 2021 04:24:01 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=sender:from:date:to:cc:subject:message-id:mail-followup-to
         :references:mime-version:content-disposition:in-reply-to;
        bh=H3tC897UHG6QXvIlos5XngOrSNPnjMx9q9dhAqydDXM=;
        b=LwMUssFWHpwYWuaisdIY4/h8EtX7QIwYdzI1DIpzYyeGC/3IDZNJtx6CSnzOu/YR1c
         pteyWHqFnVIK0RAxWOjDd88RmI88XX0NCgyS04IJ/8arbh7MWJrrsv8XqZJwstVGt7oc
         nPdEDJzrmQG6pk9ug84VoMtKWwQt/b94Jn0lcl10c51tiynANuHd8QNS0SZMBIMdajhq
         S2kusgqxg8R+K5CfLLMdOZQyDZGXQJC8PIIhOB6iEG4fZHn5DDAykfFKiwujLPbV4n+O
         +rWt67ySXCSoUiF+RdXzVAsoHT0mIUxt+rvaYfboP8GNWhV9M/m7YIPcb2NllSQQdSid
         bWZA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:sender:from:date:to:cc:subject:message-id
         :mail-followup-to:references:mime-version:content-disposition
         :in-reply-to;
        bh=H3tC897UHG6QXvIlos5XngOrSNPnjMx9q9dhAqydDXM=;
        b=mLty/YBUkhp4QoQ/0dGaV/tdMYs3NV2ZnBn3eQSNBzZL1+m94U6kQDAJDbCpHs/IZj
         8pn7w6UjnRPkbdzXuiCn17pduTgHgHK0hkcUDBmdlzARKw+/9M8w8Rx+M1SM7C0GqJrR
         /qcaqS+4Miq6kQnpMBT1b3Po9tGrPltjVO6jHGiyfO969cftpFTtpYqzqjx9KVmeUE7t
         gmuq5xcM98t9WqqVyabZXGH4Yvplyf75V6JBxrmaZ/JtDnm3QoQ3+7NUY88gsV+2zstN
         ai1EA25a5etcfcC6Caal0eH0ykP8eVSm8UZ6mpyDoVj5jQDoOCQh+vVniA76BOLHBkkR
         CsMg==
X-Gm-Message-State: AOAM532xxftLNP72wrJ3hKJv2Hid13i1S+ZBPQFkLbc7yKcTVjXvcDVo
        tssyPqB6QQB+l+QSnyqfNutxq/L9Eos=
X-Google-Smtp-Source: ABdhPJx9tg1gnWXiazqrq/FCVp2RSLdHr+2JpDKzryjyCCv/JY9mjNIV1phrarz3A2VeA8iie8/bkg==
X-Received: by 2002:aa7:8d0a:0:b0:4a2:82d7:1695 with SMTP id j10-20020aa78d0a000000b004a282d71695mr13909117pfe.86.1639657440964;
        Thu, 16 Dec 2021 04:24:00 -0800 (PST)
Received: from slk1.local.net (n110-23-108-30.sun3.vic.optusnet.com.au. [110.23.108.30])
        by smtp.gmail.com with ESMTPSA id bt2sm5445905pjb.57.2021.12.16.04.23.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 16 Dec 2021 04:24:00 -0800 (PST)
Sender: Duncan Roe <duncan.roe2@gmail.com>
From:   Duncan Roe <duncan_roe@optusnet.com.au>
X-Google-Original-From: Duncan Roe <dunc@slk1.local.net>
Date:   Thu, 16 Dec 2021 23:23:56 +1100
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     Netfilter Development <netfilter-devel@vger.kernel.org>
Subject: Re: [PATCH libnetfilter_queue] build: doc: Update build_man.sh for
 doxygen 1.9.2
Message-ID: <Ybsv3Hkk93EEYqSr@slk1.local.net>
Mail-Followup-To: Pablo Neira Ayuso <pablo@netfilter.org>,
        Netfilter Development <netfilter-devel@vger.kernel.org>
References: <20211207224502.16008-1-duncan_roe@optusnet.com.au>
 <Ybp6IlQAlAFVSdjQ@salvia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Ybp6IlQAlAFVSdjQ@salvia>
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Hi Pablo,

On Thu, Dec 16, 2021 at 12:28:34AM +0100, Pablo Neira Ayuso wrote:
> A bit more details on this one? It's just a cosmetic issue?
>
> On Wed, Dec 08, 2021 at 09:45:02AM +1100, Duncan Roe wrote:
> > Cater for bold line number in del_def_at_lines()
> >
> > Signed-off-by: Duncan Roe <duncan_roe@optusnet.com.au>
> > ---
> >  doxygen/build_man.sh | 2 +-
> >  1 file changed, 1 insertion(+), 1 deletion(-)
> >
> > diff --git a/doxygen/build_man.sh b/doxygen/build_man.sh
> > index 852c7b8..c68876c 100755
> > --- a/doxygen/build_man.sh
> > +++ b/doxygen/build_man.sh
> > @@ -96,7 +96,7 @@ fix_double_blanks(){
> >  del_def_at_lines(){
> >    linnum=1
> >    while [ $linnum -ne 0 ]
> > -  do mygrep "^Definition at line [[:digit:]]* of file" $target
> > +  do mygrep '^Definition at line (\\fB)?[[:digit:]]*(\\fP)? of file' $target
> >      [ $linnum -eq 0 ] || delete_lines $(($linnum - 1)) $linnum
> >    done
> >  }
> > --
> > 2.17.5
> >
No, not cosmetic. The regexp has to be updated to recognise a line with bold
line numbering. Without the patch, the unwanted line appears in the man page.

I thought that was obvious. Will submit a v2 explaining a bit more, unless you
apply the patch in the meantime.

Cheers ... Duncan.
