From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH nft] tests: shell: make testcases which using tcp/udp
 port more rubost
Date: Wed, 15 Jun 2016 13:58:31 +0200
Message-ID: <20160615115831.GA30852@salvia>
References: <1465621514-25589-1-git-send-email-zlpnobody@163.com>
 <CAOkSjBj03cgzEr4b+y8suT65iGBVX61O8GzAh=HgRObNw1DCMg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Liping Zhang <zlpnobody@163.com>,
	Netfilter Development Mailing list
	<netfilter-devel@vger.kernel.org>,
	Liping Zhang <liping.zhang@spreadtrum.com>
To: Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:44022 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753234AbcFOL6o (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 15 Jun 2016 07:58:44 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
	by mail.us.es (Postfix) with ESMTP id 085D09BF2C3
	for <netfilter-devel@vger.kernel.org>; Wed, 15 Jun 2016 13:58:43 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id EB5081B3277
	for <netfilter-devel@vger.kernel.org>; Wed, 15 Jun 2016 13:58:42 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id 301DA1B3275
	for <netfilter-devel@vger.kernel.org>; Wed, 15 Jun 2016 13:58:40 +0200 (CEST)
Content-Disposition: inline
In-Reply-To: <CAOkSjBj03cgzEr4b+y8suT65iGBVX61O8GzAh=HgRObNw1DCMg@mail.gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Sat, Jun 11, 2016 at 12:04:57PM +0200, Arturo Borrero Gonzalez wrote:
> On 11 June 2016 at 07:05, Liping Zhang <zlpnobody@163.com> wrote:
> > From: Liping Zhang <liping.zhang@spreadtrum.com>
> >
> > In my mechain, port 12345 is mapped to italk in /etc/services:
> >   italk           12345/tcp               # Italk Chat System
> >
> > So when we add nft rule with udp port "12345", nft list ruleset
> > will displayed it as "italk", that cause the result is not same
> > with expected, then testcase fail.
> >
> > Add "-nn" option when dump the rulesets from the kernel, make
> > testcases which using tcp/udp port more rubost.
> >
> > Signed-off-by: Liping Zhang <liping.zhang@spreadtrum.com>
> > ---
> >  tests/shell/testcases/netns/0001nft-f_0         | 2 +-
> >  tests/shell/testcases/netns/0002loosecommands_0 | 2 +-
> >  tests/shell/testcases/netns/0003many_0          | 2 +-
> >  tests/shell/testcases/nft-f/0002rollback_rule_0 | 2 +-
> >  tests/shell/testcases/nft-f/0003rollback_jump_0 | 2 +-
> >  tests/shell/testcases/nft-f/0004rollback_set_0  | 2 +-
> >  tests/shell/testcases/nft-f/0005rollback_map_0  | 2 +-
> >  7 files changed, 7 insertions(+), 7 deletions(-)
> >
> 
> Acked-by: Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>

Applied, thanks.
