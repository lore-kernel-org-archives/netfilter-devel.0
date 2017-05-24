From: Richard Guy Briggs <rgb@redhat.com>
Subject: Re: [PATCH 1/6 RFC] netfilter: normalize x_table function
 declarations
Date: Wed, 24 May 2017 18:30:03 -0400
Message-ID: <20170524223003.GN6203@madcap2.tricolour.ca>
References: <cover.1495124188.git.rgb@redhat.com>
 <d7a00d229e93586d0aed5950d79e95f3d552dae6.1495124188.git.rgb@redhat.com>
 <20170524173731.GC7439@salvia>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Netfilter Developer Mailing List
        <netfilter-devel@vger.kernel.org>, linux-audit@redhat.com,
        Florian Westphal <fw@strlen.de>,
        Thomas Woerner <twoerner@redhat.com>,
        Thomas Graf <tgraf@infradead.org>,
        Eric Paris <eparis@redhat.com>, Paul Moore <pmoore@redhat.com>,
        Steve Grubb <sgrubb@redhat.com>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:34122 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1164439AbdEXWaP (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 24 May 2017 18:30:15 -0400
Content-Disposition: inline
In-Reply-To: <20170524173731.GC7439@salvia>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On 2017-05-24 19:37, Pablo Neira Ayuso wrote:
> On Thu, May 18, 2017 at 01:21:47PM -0400, Richard Guy Briggs wrote:
> > Git context diffs were being produced with unhelpful declaration types in the
> > place of function names to help identify the funciton in which changes were
> > made.
> > 
> > Normalize x_table function declarations so that git context diff function
> > labels work as expected.
> 
> I know of people that usually complain on this cleanups, since they
> just add extra work to backports.

Arguably all cleanups add work on backports, including spelling fixes.  ;-)

> But I have no major objection to this if you want to push it forward.

Thanks.

- RGB

--
Richard Guy Briggs <rgb@redhat.com>
Sr. S/W Engineer, Kernel Security, Base Operating Systems
Remote, Ottawa, Red Hat Canada
IRC: rgb, SunRaycer
Voice: +1.647.777.2635, Internal: (81) 32635
