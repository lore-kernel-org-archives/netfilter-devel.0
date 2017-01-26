From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH] iptables: fix the wrong appending of jump verdict after
 the comment.
Date: Thu, 26 Jan 2017 17:13:18 +0100
Message-ID: <20170126161318.GA5403@salvia>
References: <1485422390-3938-1-git-send-email-mayhs11saini@gmail.com>
 <CAKHNQQFhjicOr4dkPkAkx7N6_v802t=aici9BEU5cMmeip=i+g@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Shyam Saini <mayhs11saini@gmail.com>,
        Netfilter Development Mailing list
        <netfilter-devel@vger.kernel.org>
To: Shivani Bhardwaj <shivanib134@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:42064 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752734AbdAZQW3 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 26 Jan 2017 11:22:29 -0500
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 389FF7646
        for <netfilter-devel@vger.kernel.org>; Thu, 26 Jan 2017 17:13:21 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 2985AA7DB4
        for <netfilter-devel@vger.kernel.org>; Thu, 26 Jan 2017 17:13:21 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id EE7EF1B300B
        for <netfilter-devel@vger.kernel.org>; Thu, 26 Jan 2017 17:13:18 +0100 (CET)
Content-Disposition: inline
In-Reply-To: <CAKHNQQFhjicOr4dkPkAkx7N6_v802t=aici9BEU5cMmeip=i+g@mail.gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Thu, Jan 26, 2017 at 05:06:56PM +0530, Shivani Bhardwaj wrote:
> On Thu, Jan 26, 2017 at 2:49 PM, Shyam Saini <mayhs11saini@gmail.com> wrote:
> > Fix wrong appending of jump verdict after the comment
> >
> > For example:
> > $ iptables-translate -A INPUT -p tcp -m tcp --sport http -s  192.168.0.0/16 -d 192.168.0.0/16 -j LONGNACCEPT -m comment --comment "foobar"
> > nft add rule ip filter INPUT ip saddr 192.168.0.0/16 ip daddr 192.168.0.0/16 tcp sport 80 counter comment \"foobar\"jump LONGNACCEPT
> >
> > Note that even without comment with double-quotes (i.e. --comment
> > "foobar"), it will add quotes:
> >
> > $ iptables-translate -A FORWARD -p tcp -m tcp --sport http -s 192.168.0.0/16 -d 192.168.0.0/16 -j DROP -m comment --comment singlecomment
> > nft add rule ip filter FORWARD ip saddr 192.168.0.0/16 ip daddr 192.168.0.0/16 tcp sport 80 counter comment \"singlecomment\"drop
> >
> > Attempting to apply the translated/generated rule will result to:
> >
> > $ nft add rule ip filter INPUT ip saddr 192.168.0.0/16 ip daddr  192.168.0.0/16 tcp sport 80 counter comment \"foobar\"jump LONGNACCEPT
> > <cmdline>:1:111-114: Error: syntax error, unexpected jump, expecting endof file or newline or semicolon
> > add rule ip filter INPUT ip saddr 192.168.0.0/16 ip daddr 192.168.0.0/16 tcp sport 80 counter comment "foobar"jump LONGNACCEPT
> >
> > After this patch
> > $ iptables-translate -A INPUT -p tcp -m tcp --sport http -s 192.168.0.0/16 -d 192.168.0.0/16 -j LONGNACCEPT -m comment --comment "foobar"
> > nft add rule ip filter INPUT ip saddr 192.168.0.0/16 ip daddr 192.168.0.0/16 tcp sport 80 counter jump LONGNACCEPT comment \"foobar\"
> > which is correct translation
> >
> > Signed-off-by: Shyam Saini <mayhs11saini@gmail.com>
> 
> Reviewed-by: Shivani Bhardwaj <shivanib134@gmail.com>
> 
> It does get accepted by nft. Sorry about the last mail.
> You could probably send out similar patch for ip6 too.

I have mangled your patch to include the missing IPv6 chunk.

So this patch has been applied, thanks!
