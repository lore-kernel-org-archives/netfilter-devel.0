From: "Hans Schillstrom" <hans@schillstrom.com>
Subject: Re: [PATCH 0/2] revamped HMARK extension
Date: Thu, 12 Jul 2012 09:23:03 +0200 (CEST)
Message-ID: <tqndgm6.23f1276381432a66ca0c0b14a521e44a@obelix.schillstrom.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="utf-8"
Content-Transfer-Encoding: 8BIT
Cc: netfilter-devel@vger.kernel.org
To: pablo@netfilter.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from smtp-gw21.han.skanova.net ([81.236.55.21]:45308 "EHLO
	smtp-gw21.han.skanova.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757053Ab2GLHXH convert rfc822-to-8bit (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 12 Jul 2012 03:23:07 -0400
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hi Pablo,
I'm on Vacation right now but I will give this a test round today.

>Hi Hans,
>
>I'm taking over your initial HMARK extension for iptables and took the freedom
>to revamp it.
>
>It now provides a shortcut for easy configuration:
>
>iptables -I PREROUTING -t mangle -j HMARK \
>	--hmark-tuple src,dst,proto \
>	--hmark-mod 2 \
>	--hmark-rnd 0xfeedcafe
        --hmark-offs 0x100

I think offset is more important, i.e. when doing policy routing  you can't  normally
start at table 0

the --hmark-tuple looks real good, much easier to use !

>
>Where --hmark-tuple can be src,dst,proto,sport,dport,spi,ct
>
>Of course, you cannot set spi and sport/dport at the same time and ct must be
>used all alone.
>
>You can still use the advanced options for fine tweaking --hmark-*-prefix
>and --hmark-*-mask.
>
>I also needed to add some new functions to libxtables to obtain the network
>prefix a.k.a CIDR notation. Also reworked xtables_ip[6]mask_to_numeric.
>Frankly, I think they now look better from the string handling perspective.
>
>Note that the --hmark-rnd and --hmark-mod are mandatory. Specifically, I don't
>want any assumption on --hmark-rnd, users are lazy, they don't set what is not
>mandatory (and I believe this parameter is important).

As I wrote, offset is important and should be mandatory.
Random has a default value, I don't think it should be mandatory.

>
>Please, test and report any issue with this asap. I'd like to integrate this
>into iptables' master branch by when 3.5 is out so people upgrading to that
>kernel can enjoy it.

I'll be back with a test result later today.

>I'm respecting your authorship in the HMARK extension, as you started this
>code.
>
>You can also find these two patches in the hmark branch of the iptables git tree.
>
>Hans Schillstrom (1):
>  extensions: add HMARK target
>
>Pablo Neira Ayuso (1):
>  libxtables: add xtables_ip[6]mask_to_cidr
>
> extensions/libxt_HMARK.c           |  441 ++++++++++++++++++++++++++++++++++++
> extensions/libxt_HMARK.man         |   60 +++++
> include/linux/netfilter/xt_HMARK.h |   50 ++++
> include/xtables.h.in               |    2 +
> libxtables/xtables.c               |   33 ++-
> 5 files changed, 577 insertions(+), 9 deletions(-)
> create mode 100644 extensions/libxt_HMARK.c
> create mode 100644 extensions/libxt_HMARK.man
> create mode 100644 include/linux/netfilter/xt_HMARK.h
>
>-- 
>1.7.10

