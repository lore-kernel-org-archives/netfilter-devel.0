From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [ANNOUNCE] nft-sync: nftables ruleset synchronization software
Date: Mon, 12 May 2014 19:49:51 +0200
Message-ID: <20140512174951.GA13725@localhost>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Michiel Leenaars <michiel@nlnet.nl>,
	Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>,
	kaber@trash.net
To: Netfilter Development Mailinglist
	<netfilter-devel@vger.kernel.org>,
	"netfilter@vger.kernel.org" <netfilter@vger.kernel.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:50844 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759019AbaELRuA (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 12 May 2014 13:50:00 -0400
Content-Disposition: inline
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hi!

We just finished the initial codebase for a new Netfilter project in
the frame of the nftables subproject, its name is nft-sync [1].

Basically, this software aims to support two different setups:

1) Rule-set repository server. The software serves the nft rule-set to
   clients that request the ruleset. Basically from the system that acts
   as repository, you have to run:

 # nft-sync -c ../contrib/nft-sync.conf.server

Then, from the client:

 # nft-sync -c ../contrib/nft-sync.conf.client --fetch

Which displays the nft rule-set in the standard output, so you can
inspect the nft rule-set.  Alternatively, the client can also retrieve
and apply the nft rule-set using the pull command instead:

 # nft-sync -c ../contrib/nft-sync.conf.client --pull

[ Note that this command above does not work in this bootstrap yet ]

2) Rule-set synchronization: In case of primary-backup and
   multiprimary firewall configurations, the software makes sure that the
   firewall cluster is deploying the same filtering policy. In this case,
   you have to launch the process:

 # nft-sync -c ../contrib/nft-sync.conf --sync

[ Note that this command above does not work in this bootstrap yet ]

This bootstrap provides the basic infrastructure as a
proof-of-concept. Many of the necessary features are still lacking:

* Implement --sync and --pull commands.
* SSL support, specifically the repository mode needs it to make sure
  nobody can evesdrop your filtering policy from the network too
  easily.
* IPv6 support.
* Allow to serve different rule-sets in the repository mode.

And many others that will be added progressively.

I would like to thank the NLnet Foundation [2] for sponsoring the
bootstrap of nft-sync.

[1] http://git.netfilter.org/nft-sync/
[2] http://nlnet.nl
