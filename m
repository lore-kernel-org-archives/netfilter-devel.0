From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: NFNETLINK answers: No such file or directory
Date: Fri, 20 Jun 2008 13:43:35 +0200
Message-ID: <485B97E7.4000501@netfilter.org>
References: <7b0a40830806181538s40efbd70s66aec17d5c04933@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@vger.kernel.org
To: "Adelson O. Junior" <jroliv@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:44998 "EHLO us.es"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752073AbYFTLno (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 20 Jun 2008 07:43:44 -0400
In-Reply-To: <7b0a40830806181538s40efbd70s66aec17d5c04933@mail.gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Adelson O. Junior wrote:
> Hi netfiltel mail list,
> it's my first time here.
> 
> My question is:
> I'm trying to delete a entry in the conntrack and an Error is shown:
> 
> "NFNETLINK answers: No such file or directory"
> 
> I did a "small" search on the Internet, mail list and I saw that this
> is a bug and is already fixed.
> Can you tell if this is true, and if is, what the version of
> libnfnetlink, libnetfilter_conntrack or
> conntrack packets (and witch of them have a problem) that the bug is fixed?

Could you post the command line invocation of `conntrack' that you're
using? It seems to me that you're omitting some required values. Old
versions require source and destination IP plus port source and
destination to work, ie.

conntrack -D -s 140.x.x.90 -d 213.x.x.117 -p tcp --sport 34075 --dport 993

As said, probably you're omitting any of those parameters. Some old
versions of the tool do not perform strict checking on the input
parameters. Thus, leading to this sort of errors.

The current version (0.9.7) supports more flexible conntrack deletion, eg.

conntrack -D -d 213.x.x.117

This invocation destroys all entries that match that.

-- 
"Los honestos son inadaptados sociales" -- Les Luthiers
