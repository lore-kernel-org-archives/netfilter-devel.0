From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH] extensions: libipt_LOG: Avoid to print the default log
 level in the translation
Date: Thu, 10 Mar 2016 19:37:57 +0100
Message-ID: <20160310183757.GB10249@salvia>
References: <20160310181537.GA16699@sonyv>
 <CAKHNQQGPvSmQP9R3omAuo1hbnOHPrsWhxkmsB7npxKM97v++Fw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Laura Garcia Liebana <nevola@gmail.com>,
	Netfilter Development Mailing list
	<netfilter-devel@vger.kernel.org>,
	outreachy-kernel <outreachy-kernel@googlegroups.com>
To: Shivani Bhardwaj <shivanib134@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:47992 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750867AbcCJSiB (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 10 Mar 2016 13:38:01 -0500
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
	by mail.us.es (Postfix) with ESMTP id 55C00C9ED8
	for <netfilter-devel@vger.kernel.org>; Thu, 10 Mar 2016 19:37:58 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id 456FCDA8FA
	for <netfilter-devel@vger.kernel.org>; Thu, 10 Mar 2016 19:37:58 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id 666DFDA380
	for <netfilter-devel@vger.kernel.org>; Thu, 10 Mar 2016 19:37:56 +0100 (CET)
Content-Disposition: inline
In-Reply-To: <CAKHNQQGPvSmQP9R3omAuo1hbnOHPrsWhxkmsB7npxKM97v++Fw@mail.gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Fri, Mar 11, 2016 at 12:02:25AM +0530, Shivani Bhardwaj wrote:
> On Thu, Mar 10, 2016 at 11:45 PM, Laura Garcia Liebana <nevola@gmail.com> wrote:
> > Avoid to print the log level in the translation when the level is the
> > default value.
> >
> > Example:
> >
> > $ sudo iptables-translate -t filter -A INPUT -m icmp ! --icmp-type 10 -j LOG
> > nft add rule ip filter INPUT icmp type != router-solicitation counter log
> >
> 
> Looks good. Don't forget to send a patch for libip6t_LOG too.

Yes please, send a patch for libip6t_LOG too.

> Same is the case with reject as well. When I did the translations, I
> left its default nature intact.
> $ sudo ip6tables-translate -A FORWARD -p TCP --dport 22 -j REJECT
> nft add rule ip6 filter FORWARD tcp dport 22 counter reject with
> icmpv6 type port-unreachable
> 
> Pablo, should this be corrected too?

It would be good to translate this to the more compact syntax, if
possible.

> Laura, may be you can send more patches depending on his response.

Yes please. Thanks for commenting on this Shivani.
