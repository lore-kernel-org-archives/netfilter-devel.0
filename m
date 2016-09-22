From: Laura Garcia <nevola@gmail.com>
Subject: Re: [PATCH nf] netfilter: nf_tables: Ensure u8 attributes are loaded
 from u32 within the bounds
Date: Thu, 22 Sep 2016 20:33:21 +0200
Message-ID: <20160922183320.GB8434@sonyv>
References: <20160914125959.GA3020@sonyv>
 <20160922145836.GA15625@salvia>
 <1474560967.23058.125.camel@edumazet-glaptop3.roam.corp.google.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Pablo Neira Ayuso <pablo@netfilter.org>,
        netfilter-devel@vger.kernel.org
To: Eric Dumazet <eric.dumazet@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-wm0-f66.google.com ([74.125.82.66]:34848 "EHLO
        mail-wm0-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S965982AbcIVSd0 (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 22 Sep 2016 14:33:26 -0400
Received: by mail-wm0-f66.google.com with SMTP id 133so15490541wmq.2
        for <netfilter-devel@vger.kernel.org>; Thu, 22 Sep 2016 11:33:25 -0700 (PDT)
Content-Disposition: inline
In-Reply-To: <1474560967.23058.125.camel@edumazet-glaptop3.roam.corp.google.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Thu, Sep 22, 2016 at 09:16:07AM -0700, Eric Dumazet wrote:
> On Thu, 2016-09-22 at 16:58 +0200, Pablo Neira Ayuso wrote:
> > attributes")
> > 
> > Always use 12 bytes commit-ids. 4da449a is too short, given the number
> > of changes we're getting in the kernel tree, this may become ambiguous
> > at some point so it won't be unique.
> > 
> > You can achieve this via: git log --oneline --abbrev=12
> 
> and Documentation/SubmittingPatches has these tips :
> 
> 
> You should also be sure to use at least the first twelve characters of the
> SHA-1 ID.  The kernel repository holds a *lot* of objects, making
> collisions with shorter IDs a real possibility.  Bear in mind that, even if
> there is no collision with your six-character ID now, that condition may
> change five years from now.
> 
> If your patch fixes a bug in a specific commit, e.g. you found an issue using
> git-bisect, please use the 'Fixes:' tag with the first 12 characters of the
> SHA-1 ID, and the one line summary.  For example:
> 
>         Fixes: e21d2170f366 ("video: remove unnecessary platform_set_drvdata()")
> 
> The following git-config settings can be used to add a pretty format for
> outputting the above style in the git log or git show commands
> 
>         [core]
>                 abbrev = 12
>         [pretty]
>                 fixes = Fixes: %h (\"%s\")
> 
> 

Duly noted, thanks.

In this case, it was not referred to a fix but an extension of the
older patch to other files with the same problem.


