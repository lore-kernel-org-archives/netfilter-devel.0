From: Eric Dumazet <eric.dumazet@gmail.com>
Subject: Re: [PATCH nf] netfilter: nf_tables: Ensure u8 attributes are
 loaded from u32 within the bounds
Date: Thu, 22 Sep 2016 09:16:07 -0700
Message-ID: <1474560967.23058.125.camel@edumazet-glaptop3.roam.corp.google.com>
References: <20160914125959.GA3020@sonyv> <20160922145836.GA15625@salvia>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Cc: Laura Garcia Liebana <nevola@gmail.com>,
        netfilter-devel@vger.kernel.org
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-pa0-f51.google.com ([209.85.220.51]:36027 "EHLO
        mail-pa0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751125AbcIVQQJ (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 22 Sep 2016 12:16:09 -0400
Received: by mail-pa0-f51.google.com with SMTP id qn7so13266207pac.3
        for <netfilter-devel@vger.kernel.org>; Thu, 22 Sep 2016 09:16:08 -0700 (PDT)
In-Reply-To: <20160922145836.GA15625@salvia>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Thu, 2016-09-22 at 16:58 +0200, Pablo Neira Ayuso wrote:
> attributes")
> 
> Always use 12 bytes commit-ids. 4da449a is too short, given the number
> of changes we're getting in the kernel tree, this may become ambiguous
> at some point so it won't be unique.
> 
> You can achieve this via: git log --oneline --abbrev=12

and Documentation/SubmittingPatches has these tips :


You should also be sure to use at least the first twelve characters of the
SHA-1 ID.  The kernel repository holds a *lot* of objects, making
collisions with shorter IDs a real possibility.  Bear in mind that, even if
there is no collision with your six-character ID now, that condition may
change five years from now.

If your patch fixes a bug in a specific commit, e.g. you found an issue using
git-bisect, please use the 'Fixes:' tag with the first 12 characters of the
SHA-1 ID, and the one line summary.  For example:

        Fixes: e21d2170f366 ("video: remove unnecessary platform_set_drvdata()")

The following git-config settings can be used to add a pretty format for
outputting the above style in the git log or git show commands

        [core]
                abbrev = 12
        [pretty]
                fixes = Fixes: %h (\"%s\")


