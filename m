From: pablo@netfilter.org
Subject: [PATCH 0/2] revamped HMARK extension
Date: Wed, 11 Jul 2012 01:17:25 +0200
Message-ID: <1341962247-16217-1-git-send-email-pablo@netfilter.org>
Cc: Hans Schillstrom <hans@schillstrom.com>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:51046 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754931Ab2GJXSZ (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 10 Jul 2012 19:18:25 -0400
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

From: Pablo Neira Ayuso <pablo@netfilter.org>

Hi Hans,

I'm taking over your initial HMARK extension for iptables and took the freedom
to revamp it.

It now provides a shortcut for easy configuration:

iptables -I PREROUTING -t mangle -j HMARK \
	--hmark-tuple src,dst,proto \
	--hmark-mod 2 \
	--hmark-rnd 0xfeedcafe

Where --hmark-tuple can be src,dst,proto,sport,dport,spi,ct

Of course, you cannot set spi and sport/dport at the same time and ct must be
used all alone.

You can still use the advanced options for fine tweaking --hmark-*-prefix
and --hmark-*-mask.

I also needed to add some new functions to libxtables to obtain the network
prefix a.k.a CIDR notation. Also reworked xtables_ip[6]mask_to_numeric.
Frankly, I think they now look better from the string handling perspective.

Note that the --hmark-rnd and --hmark-mod are mandatory. Specifically, I don't
want any assumption on --hmark-rnd, users are lazy, they don't set what is not
mandatory (and I believe this parameter is important).

Please, test and report any issue with this asap. I'd like to integrate this
into iptables' master branch by when 3.5 is out so people upgrading to that
kernel can enjoy it.

I'm respecting your authorship in the HMARK extension, as you started this
code.

You can also find these two patches in the hmark branch of the iptables git tree.

Hans Schillstrom (1):
  extensions: add HMARK target

Pablo Neira Ayuso (1):
  libxtables: add xtables_ip[6]mask_to_cidr

 extensions/libxt_HMARK.c           |  441 ++++++++++++++++++++++++++++++++++++
 extensions/libxt_HMARK.man         |   60 +++++
 include/linux/netfilter/xt_HMARK.h |   50 ++++
 include/xtables.h.in               |    2 +
 libxtables/xtables.c               |   33 ++-
 5 files changed, 577 insertions(+), 9 deletions(-)
 create mode 100644 extensions/libxt_HMARK.c
 create mode 100644 extensions/libxt_HMARK.man
 create mode 100644 include/linux/netfilter/xt_HMARK.h

-- 
1.7.10

