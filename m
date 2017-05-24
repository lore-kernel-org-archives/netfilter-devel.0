From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH 1/6 RFC] netfilter: normalize x_table function
 declarations
Date: Wed, 24 May 2017 19:37:31 +0200
Message-ID: <20170524173731.GC7439@salvia>
References: <cover.1495124188.git.rgb@redhat.com>
 <d7a00d229e93586d0aed5950d79e95f3d552dae6.1495124188.git.rgb@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Netfilter Developer Mailing List
        <netfilter-devel@vger.kernel.org>, linux-audit@redhat.com,
        Florian Westphal <fw@strlen.de>,
        Thomas Woerner <twoerner@redhat.com>,
        Thomas Graf <tgraf@infradead.org>,
        Eric Paris <eparis@redhat.com>, Paul Moore <pmoore@redhat.com>,
        Steve Grubb <sgrubb@redhat.com>
To: Richard Guy Briggs <rgb@redhat.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:48588 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753880AbdEXRhj (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 24 May 2017 13:37:39 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id BEF42DFF26
        for <netfilter-devel@vger.kernel.org>; Wed, 24 May 2017 19:37:30 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 9A9051021A6
        for <netfilter-devel@vger.kernel.org>; Wed, 24 May 2017 19:37:30 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 07BFD1021A4
        for <netfilter-devel@vger.kernel.org>; Wed, 24 May 2017 19:37:26 +0200 (CEST)
Content-Disposition: inline
In-Reply-To: <d7a00d229e93586d0aed5950d79e95f3d552dae6.1495124188.git.rgb@redhat.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Thu, May 18, 2017 at 01:21:47PM -0400, Richard Guy Briggs wrote:
> Git context diffs were being produced with unhelpful declaration types in the
> place of function names to help identify the funciton in which changes were
> made.
> 
> Normalize x_table function declarations so that git context diff function
> labels work as expected.

I know of people that usually complain on this cleanups, since they
just add extra work to backports.

But I have no major objection to this if you want to push it forward.
