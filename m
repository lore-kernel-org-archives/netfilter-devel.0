Return-Path: <SRS0=WbMd=5D=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8F6C4C4332D
	for <netfilter-devel@archiver.kernel.org>; Wed, 18 Mar 2020 21:08:51 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 657A720409
	for <netfilter-devel@archiver.kernel.org>; Wed, 18 Mar 2020 21:08:51 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=paul-moore-com.20150623.gappssmtp.com header.i=@paul-moore-com.20150623.gappssmtp.com header.b="KblwfDmt"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728266AbgCRVIq (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 18 Mar 2020 17:08:46 -0400
Received: from mail-ed1-f67.google.com ([209.85.208.67]:35468 "EHLO
        mail-ed1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728033AbgCRVIp (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 18 Mar 2020 17:08:45 -0400
Received: by mail-ed1-f67.google.com with SMTP id a20so32730542edj.2
        for <netfilter-devel@vger.kernel.org>; Wed, 18 Mar 2020 14:08:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=paul-moore-com.20150623.gappssmtp.com; s=20150623;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=WatAKLuqZtZlRLQCbRzYpTXRz9maWKDE4hUEG0f7NDw=;
        b=KblwfDmtszqt/poiiBnkGj80+eqtrRyKNLWAFKJyI2lM8X5PpTIHIUIc65zJhoEnEF
         WjcKc+bfilJdpRhIjI1m71RTPdnfUYwaMNgrlZfogSYuI3TKBJzAzVhAyAtHoPrdVKGp
         DLDa+hQ2FiF/ZRAW6YOkmNlRuau5tixJsAn5jRDu0LNFpGvf4mGlYW9x2j+4ybOULNy7
         eW1S/z/G2JKD/YF0c0IywP5jL7tjCmAMSfYHwjw2Mgd+8lo0HY2apy//ZlP3q1BuFweg
         kxv1DBMAmhdBV9qGqhU7t4qHJxKuYe+4PrnuMPBj6LktzBpmvLYwxL6iqDAV7QAmJ5iL
         I9pg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=WatAKLuqZtZlRLQCbRzYpTXRz9maWKDE4hUEG0f7NDw=;
        b=Z4A3BCd0FEq0zCa5+otUycPHnn86M848Gf4nU+wdB4NV8954q+iINIjOsuFVjk67Vn
         ZnL4+BT2WzlLXNRgAWxuffJ0WYTlNak4I9mDbd+JBN/deerHtK/jDGlbnKOw3mVzZQxH
         c13MdPaptvuQHsZc+85KkmEsqEfn7VMkzBRambV+sLsRMWjnC85GB34TZO+gIwPUgP1E
         hVB6e+NvnYlXqg4IaJ/4k0RbfwXg+EPnMOlmo+QqaObKsKueLkPkVI+W9HXUxZc9z4vy
         4gEhxFA78HAbFiGu1uAyEItaZ2jtrl4u1ewXIIe5/Z6jDOGR1c+6GFdq9arJWDDfA70e
         Z4Xg==
X-Gm-Message-State: ANhLgQ0Y3qIKPUTUA7eM9j/czFl7vqC++qy0t0bhXkUloVnGg4WPvDBT
        zWDyIl4bpS84+zKw7Let32xDhMTAGj/W8fkdmLAK
X-Google-Smtp-Source: ADFU+vvbYGHqEIZHFDpAJYIn0BKyhX1aU7rGbDTvr2tbcPYmEgbd2Lwck7tUApGNIqLuzMQYQdyQBqa6eqOf1oPvVLM=
X-Received: by 2002:aa7:d051:: with SMTP id n17mr5727973edo.196.1584565722903;
 Wed, 18 Mar 2020 14:08:42 -0700 (PDT)
MIME-Version: 1.0
References: <cover.1577736799.git.rgb@redhat.com> <6452955c1e038227a5cd169f689f3fd3db27513f.1577736799.git.rgb@redhat.com>
 <CAHC9VhRkH=YEjAY6dJJHSp934grHnf=O4RiqLu3U8DzdVQOZkg@mail.gmail.com>
 <20200130192753.n7jjrshbhrczjzoe@madcap2.tricolour.ca> <CAHC9VhSVN3mNb5enhLR1hY+ekiAyiYWbehrwd_zN7kz13dF=1w@mail.gmail.com>
 <20200205235056.e5365xtgz7rbese2@madcap2.tricolour.ca> <CAHC9VhTM6MDHLcBfwJ_9DCroG0VA-meO770ihjn1sVy6=0JrHw@mail.gmail.com>
 <20200312205147.plxs4czjeuu4davj@madcap2.tricolour.ca> <CAHC9VhTqWdXMsbSbsWJzRRvVbSaaFBmnFFsVutM7XSx5NT_FJA@mail.gmail.com>
 <20200314224203.ncyx3rgwwe6zet4e@madcap2.tricolour.ca>
In-Reply-To: <20200314224203.ncyx3rgwwe6zet4e@madcap2.tricolour.ca>
From:   Paul Moore <paul@paul-moore.com>
Date:   Wed, 18 Mar 2020 17:08:31 -0400
Message-ID: <CAHC9VhTy2ou-vadeMjgTaw-T9mW+nBjbqapA7RSW3EFNJ44JLw@mail.gmail.com>
Subject: Re: [PATCH ghak90 V8 13/16] audit: track container nesting
To:     Richard Guy Briggs <rgb@redhat.com>
Cc:     nhorman@tuxdriver.com, linux-api@vger.kernel.org,
        containers@lists.linux-foundation.org,
        LKML <linux-kernel@vger.kernel.org>, dhowells@redhat.com,
        Linux-Audit Mailing List <linux-audit@redhat.com>,
        netfilter-devel@vger.kernel.org, ebiederm@xmission.com,
        simo@redhat.com, netdev@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, Eric Paris <eparis@parisplace.org>,
        mpatel@redhat.com, Serge Hallyn <serge@hallyn.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Sat, Mar 14, 2020 at 6:42 PM Richard Guy Briggs <rgb@redhat.com> wrote:
> On 2020-03-13 12:47, Paul Moore wrote:

...

> > It has been a while since I last looked at the patchset, but my
> > concern over the prefered use of the ACID number vs the ACID object is
> > that the number offers no reuse protection where the object does.  I
> > really would like us to use the object everywhere it is possible.
>
> Ok, so I take it from this that I go ahead with the dual format since
> the wrapper funciton to convert from object to ID strips away object
> information negating any benefit of favouring the object pointer.  I'll
> look at the remaining calls that use a contid (rather than contobj) and
> convert all that I can over to storing an object using the dual counters
> that track process exits versus signal2 and trace references.

Well, as I said in the other thread, I'm not sure we need a full two
counters; I think one counter and a simple flag should suffice.
Otherwise that sounds good for the next iteration.

-- 
paul moore
www.paul-moore.com
