From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [nft] all chains of a table are listed
Date: Wed, 23 Sep 2015 11:58:08 +0200
Message-ID: <20150923095808.GA4432@salvia>
References: <CAOkSjBiSbL1sJ268dL-6n1upXNW=5c0j864dTubu8FKMSxQruw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Netfilter Development Mailing list
	<netfilter-devel@vger.kernel.org>, kaber@trash.net,
	jp.pozzi@izzop.net
To: Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:58319 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752954AbbIWJvW (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 23 Sep 2015 05:51:22 -0400
Content-Disposition: inline
In-Reply-To: <CAOkSjBiSbL1sJ268dL-6n1upXNW=5c0j864dTubu8FKMSxQruw@mail.gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hi Arturo,

Cc'ing JP Pozzi, he also filed a bug into netfilter bugzilla that is
related to this.

Several comments below.

On Tue, Sep 22, 2015 at 02:06:25PM +0200, Arturo Borrero Gonzalez wrote:
> Hi!
> 
> It seems all chains of a given table are always listed. Is this the
> intended behaviour?
> 
> % sudo nft list table test
> table ip test {
>   chain test1 {
>   }
> 
>   chain test2 {
>   }
> }
> 
> % sudo nft list chain test test1
> table ip test {
>   chain test1 {
>   }
> 
>   chain test2 {
>   }
> }
> 
> % sudo nft list chain test test2
> table ip test {
>   chain test1 {
>   }
> 
>   chain test2 {
>   }
> }

I went back to the bugzilla report I thought it was indicating exactly
the same thing. However, it's actually pointing to a different
(related) thing:

http://bugzilla.netfilter.org/show_bug.cgi?id=1014

JP suggests that the chain listing only displays the chain content,
ie. only the rules. I understand he wants to use the list command to
filter out things when the ruleset contains *many things* which sounds
quite reasonable, something like:

# nft list chain test test1
chain test1 {
        type filter hook input priority 0; policy drop;
        counter accept
}
# nft list chain test test2
chain test2 {
        type filter hook input priority 0; policy drop;
        counter accept
}

To get things aligned with what we have, we should also have a some
way to list the chain definitions only:

# nft list chains
table ip filter {
        chain test1 {
                type filter hook input priority 0; policy drop;
        }
        chain test2 {
                type filter hook input priority 0; policy drop;
        }
}
table ip6 filter {
        chain test1 {
                type filter hook input priority 0; policy drop;
        }
}

The listing shows *no content*, only the chain declarations, no rules.
Then, if you want to zoom in into the chain content, you can do:

# nft list chain test test1
chain test1 {
        type filter hook input priority 0; policy drop;
        counter accept
}

We should also get this aligned with 'nft list ruleset' so:

# nft list chains ip6
table ip6 filter {
        chain test1 {
                type filter hook input priority 0; policy drop;
        }
}

Only shows the chains under the ip6 family.

Then, we can fix `nft list sets' to display things like this:

# nft list sets
table ip filter {
        set test {
                type ipv4_addr
        }
        set test2 {
                type ipv4_addr
        }
}
table ip6 filter {
        set test {
                type ipv6_addr
        }
}

Again, with no content (no elements), so you have to use:

# nft list set ip filter test

to zoom in and get the element listing.

Then, also support to filter out by family:

# nft list sets ip6
table ip6 filter {
        set test {
                type ipv6_addr
        }
}

Does this look good to you?

Thanks.
