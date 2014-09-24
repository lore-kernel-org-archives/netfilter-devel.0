From: Eric Leblond <eric@regit.org>
Subject: Re: [PATCH] parser: simplify monitor command parsing
Date: Wed, 24 Sep 2014 10:46:46 +0200
Message-ID: <1411548406.10103.1.camel@regit.org>
References: <1410939907-10180-1-git-send-email-kaber@trash.net>
	 <CAOkSjBgHZ4aG7Qog1pOtCHS=YDmLiJi11eXPxdY20oDNgPE1bA@mail.gmail.com>
	 <20140917080115.GB10380@acer.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-15"
Content-Transfer-Encoding: 7bit
Cc: Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	Netfilter Development Mailing list
	<netfilter-devel@vger.kernel.org>
To: Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from ks28632.kimsufi.com ([91.121.96.152]:36154 "EHLO
	ks28632.kimsufi.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751435AbaIXJ3W (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 24 Sep 2014 05:29:22 -0400
In-Reply-To: <20140917080115.GB10380@acer.localdomain>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hi,

On Wed, 2014-09-17 at 10:01 +0200, Patrick McHardy wrote:
> On Wed, Sep 17, 2014 at 09:52:11AM +0200, Arturo Borrero Gonzalez wrote:
> > On 17 September 2014 09:45, Patrick McHardy <kaber@trash.net> wrote:
> > > Add tokens for "new" and "destroy". Split up the monitor flags into an
> > > event and an object to avoid lots of duplicated code.
> > >
> > > Signed-off-by: Patrick McHardy <kaber@trash.net>
> > > ---
> > 
> > I think the 'new' keyword may clash with 'ct new', don't you?. That's
> > why Pablo did the parser that way.
> 
> Right. The split into event and object still saves a lot of code, I'll
> add back the strcmp if I can't think of a nicer way to fix this.
> 
> I'm working on command line completion based on the bison grammar, so
> I'd prefer to only use strings for identifiers, not for keywords.

I confirm that 102c300 "parser: simplify monitor command parsing" breaks
the "ct state new" filter so current nftables git is not usable. 

For the record the error is the following:
 nft> add rule inet filter input ct state new
 <cli>:1:37-39: Error: syntax error, unexpected new
 add rule inet filter input ct state new
                                     ^^^ 

And this is also caught by regression tests:
nftables/tests/regression# ./nft-test.py any/ct.t 
any/ct.t: ERROR: line 10: nft add rule -nnn ip test-ip4 output ct state new,established, related, untracked: This rule should not have failed.
any/ct.t: ERROR: line 12: nft add rule -nnn ip test-ip4 output ct state {new,established, related, untracked}: This rule should not have failed.

Patrick, let me know if you can look into it. If not I will try to have
a look this week end or next week.

BR,
-- 
Eric Leblond <eric@regit.org>

