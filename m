From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: question about UNDEFINE/REDEFINE
Date: Fri, 26 Jan 2018 14:45:49 +0100
Message-ID: <20180126134549.t5wjq63x7vw7efcw@salvia>
References: <3622208.jy4NlOniyd@voxel>
 <20180123110728.i7hujeyz6224atd2@salvia>
 <1993002.08LkLsM8EI@voxel>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8bit
Cc: netfilter-devel@vger.kernel.org
To: David Fabian <david.fabian@cldn.cz>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:36798 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752261AbeAZNpy (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 26 Jan 2018 08:45:54 -0500
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 7BCB11B6941
        for <netfilter-devel@vger.kernel.org>; Fri, 26 Jan 2018 14:45:52 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 633A7DA80C
        for <netfilter-devel@vger.kernel.org>; Fri, 26 Jan 2018 14:45:52 +0100 (CET)
Content-Disposition: inline
In-Reply-To: <1993002.08LkLsM8EI@voxel>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hi David,

On Tue, Jan 23, 2018 at 01:40:03PM +0100, David Fabian wrote:
> Hello Pablo,
> 
> Dne úterý 23. ledna 2018 12:07:28 CET, Pablo Neira Ayuso napsal(a):
> > I'm asking here because I would need to understand better how you've
> > structured your scripts, if you could explain a bit more, we would
> > appreciate.
> 
> I have packed an excerpt of a playground FW with two VLANs 3 and 54. The 
> configuration already uses my redefine keyword.
> 
> ftp://ftp.bosson.eu/pub/tmp/nftables_excerpt.tar.gz

Thanks for this example ruleset.

> The intended use case is to call nft -f fw-on and reload the firewall from 
> scratch every time there is a config change. I don't know how a cmdline 
> parameter would help us with it.

Yes, command line won't help in this case.

> Maybe if we would wrap nft calls with bash scripts but that would
> defeat the purpose of using the nft scripting capabilities in the
> first place.

No bash, we don't want more shell scripts in place, the goal is indeed
to add scripting capabilities to nftables.

> The most important for us is to have the FW logically structured for every 
> customer and every FW rule related to a customer should be in his/her VLAN 
> config file.

Variables are bound to their scope, so the following example works
fine:

 # cat example.nft
 table ip xxx {
        define IP1 = 1.1.1.1
 }

 table ip yyy {
        define IP1 = 2.2.2.2
 }

Given IP1 is bound to the table definitions.

In your ruleset, you're using the flat ruleset notation, ie.

 add rule x y ip saddr $IP1 counter drop

I see another
three choices, apart from your 'redefine' proposal:

1) Add some explicit scoping, so you can do this, eg.

 begin-scope fw-vlan1
 define IP1 = 1.1.1.1

 add rule filter INPUT x y ip saddr $IP1 counter drop
 end-scope

 begin-scope fw-vlan32
 define IP1 = 2.2.2.2
 ...
 add rule filter INPUT x y ip saddr $IP1 counter drop
 end-scope

Hm, but this doesn't look very nice...

2) Probably even cleaner is to look at 'local' scopes like in bash.

 define local IP1 = 1.1.1.1

so the symbol is bound to this file - consider the content of a file
determines a given scope. This can be also useful to the nested
notation.

3) You rework your ruleset to use the notation with nesting :-). But I
think 2) can be useful for both the flat and nested notation.

I'm not asking you to do 2), but I would like to see how a patch that
adds explicit scoping for the flat ruleset representation looks like.
