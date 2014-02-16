From: Patrick McHardy <kaber@trash.net>
Subject: Re: [RFC PATCH nft userspace] nft: connlabel matching support
Date: Sun, 16 Feb 2014 17:53:33 +0000
Message-ID: <544ec23c-621a-456c-9e65-ea67703f7aee@email.android.com>
References: <1392504432-20918-1-git-send-email-fw@strlen.de> <20140216085319.GA26751@macbook.localnet> <20140216110152.GD28751@breakpoint.cc> <20140216111252.GA29491@macbook.localnet> <20140216165957.GA2408@breakpoint.cc> <20140216172339.GA18357@macbook.localnet> <20140216175132.GB2408@breakpoint.cc>
Mime-Version: 1.0
Content-Type: text/plain;
 charset=UTF-8
Content-Transfer-Encoding: 8bit
Cc: netfilter-devel@vger.kernel.org
To: Florian Westphal <fw@strlen.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:41558 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752718AbaBPRxj (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Sun, 16 Feb 2014 12:53:39 -0500
In-Reply-To: <20140216175132.GB2408@breakpoint.cc>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On 16. Februar 2014 17:51:32 GMT+00:00, Florian Westphal <fw@strlen.de> wrote:
>Patrick McHardy <kaber@trash.net> wrote:
>> > So, same problem there: EXPR_LIST == cmp neq.  Is that intentional?
>> > It seems wrong to me, e.g.  "tcp flags fin,syn" will match
>virtually all
>> > tcp packets.
>> > 
>> > Maybe netlink_gen_flagcmp() should generate NFT_CMP_GT i.e.:
>> >  [ bitwise reg 1 = (reg=1 & 0x00000012 ) ^ 0x00000000 ]
>> >  [ cmp gt reg 1 0x00000000 ]
>> > 
>> > At least that would be what I would have expected :-}
>> > 
>> > Am I wrong?
>> 
>> It should actually generate a NEQ 0. Seems this was broken in commit
>> aae836a7 (src: use libnftables).
>> 
>> Try the attached patch please.
>
>Thanks, 'tcp flags syn,fin' now behaves as expected.

I'll push the patch, thanks.

>> > As a side note, experimenting a bit with tcp flags:
>> > 
>> > add rule filter output tcp flags & (syn|ack) == (syn|ack)
>> > 
>> > works fine with current master branch.  But list shows
>> > 
>> > "tcp flags & 18 == 18", i.e. no symbol translation.
>> > 
>> > Shouldn't it restore the symbolic names?
>> > I think this is the very same problem that I had with my connlabel
>> > dabbling, so it would be nice if it could be solved in generic way.
>> 
>> Most likely. Please see if the attached patch solves this.
>
>No:
>add rule filter output tcp flags & (syn|ack) == (syn|ack)
>list table filter
>tcp flags & 18 == 18
>
>The expression works.

I'll look into it in about an hour.

