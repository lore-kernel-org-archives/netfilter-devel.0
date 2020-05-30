Return-Path: <SRS0=Ebef=7M=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 45577C433E0
	for <netfilter-devel@archiver.kernel.org>; Sat, 30 May 2020 23:16:07 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 2E14020774
	for <netfilter-devel@archiver.kernel.org>; Sat, 30 May 2020 23:16:07 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729529AbgE3XQC (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Sat, 30 May 2020 19:16:02 -0400
Received: from smtprelay0054.hostedemail.com ([216.40.44.54]:59144 "EHLO
        smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1729314AbgE3XQC (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Sat, 30 May 2020 19:16:02 -0400
Received: from filter.hostedemail.com (clb03-v110.bra.tucows.net [216.40.38.60])
        by smtprelay03.hostedemail.com (Postfix) with ESMTP id DCE5F837F24A;
        Sat, 30 May 2020 23:16:00 +0000 (UTC)
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-HE-Tag: baby31_280098b26d70
X-Filterd-Recvd-Size: 2370
Received: from XPS-9350.home (unknown [47.151.136.130])
        (Authenticated sender: joe@perches.com)
        by omf11.hostedemail.com (Postfix) with ESMTPA;
        Sat, 30 May 2020 23:15:58 +0000 (UTC)
Message-ID: <1a655e27fe1ac348ca98dd3f703270741311e458.camel@perches.com>
Subject: Re: [PATCH] checkpatch/coding-style: Allow 100 column lines
From:   Joe Perches <joe@perches.com>
To:     Andreas Dilger <adilger@dilger.ca>
Cc:     Linus Torvalds <torvalds@linux-foundation.org>,
        David Laight <David.Laight@aculab.com>,
        Casey Schaufler <casey@schaufler-ca.com>,
        David Howells <dhowells@redhat.com>,
        Christoph Hellwig <hch@lst.de>,
        Al Viro <viro@zeniv.linux.org.uk>, Ian Kent <raven@themaw.net>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        LSM List <linux-security-module@vger.kernel.org>,
        NetFilter <netfilter-devel@vger.kernel.org>
Date:   Sat, 30 May 2020 16:15:57 -0700
In-Reply-To: <F5AE90A2-1661-4B8E-A884-C3CBAB0F603F@dilger.ca>
References: <CAHk-=wj3iGQqjpvc+gf6+C29Jo4COj6OQQFzdY0h5qvYKTdCow@mail.gmail.com>
         <20200528054043.621510-1-hch@lst.de>
         <22778.1590697055@warthog.procyon.org.uk>
         <f89f0f7f-83b4-72c6-7d08-cb6eaeccd443@schaufler-ca.com>
         <3aea7a1c10e94ea2964fa837ae7d8fe2@AcuMS.aculab.com>
         <CAHk-=wjR0H3+2ba0UUWwoYzYBH0GX9yTf5dj2MZyo0xvyzvJnA@mail.gmail.com>
         <9c360bfa43580ce7726dd3d9d247f1216a690ef0.camel@perches.com>
         <F5AE90A2-1661-4B8E-A884-C3CBAB0F603F@dilger.ca>
Content-Type: text/plain; charset="ISO-8859-1"
User-Agent: Evolution 3.36.2-0ubuntu1 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Sat, 2020-05-30 at 16:14 -0600, Andreas Dilger wrote:
> On May 29, 2020, at 5:12 PM, Joe Perches <joe@perches.com> wrote:
> > Change the maximum allowed line length to 100 from 80.
> 
> What is the benefit/motivation for changing this?  The vast majority
> of files are wrapped at 80 columns, and if some files start being
> wrapped at 100 columns they will either display poorly on 80-column
> terminals, or a lot of dead space will show in 100-column terminals.

YA Linus bleat in this thread.
I don't much care one way or any other.

https://lore.kernel.org/lkml/CAHk-=wj3iGQqjpvc+gf6+C29Jo4COj6OQQFzdY0h5qvYKTdCow@mail.gmail.com/

and

https://lore.kernel.org/lkml/CAHk-=wjR0H3+2ba0UUWwoYzYBH0GX9yTf5dj2MZyo0xvyzvJnA@mail.gmail.com/


