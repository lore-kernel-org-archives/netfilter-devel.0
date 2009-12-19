From: Kevin Locke <kevin@kevinlocke.name>
Subject: [xtables-addons][PATCH 0/2] Misc ipset issues
Date: Sat, 19 Dec 2009 13:50:45 -0700
Message-ID: <1261255847-16395-1-git-send-email-kevin@kevinlocke.name>
Cc: Kevin Locke <kevin@kevinlocke.name>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from cluster2.bresnan.net ([69.145.248.57]:40548 "EHLO
	blnmtdc2svavs.cluster1.bresnan.net" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753501AbZLSVGK (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Sat, 19 Dec 2009 16:06:10 -0500
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hello All,

I just wanted to express my thanks for writing/maintaining ipset and
xtables-addons.  I have found them to be very useful.

I ran across a few issues getting ipset to work on my system and
wanted to bring them up here for consideration.

The first is that in 2.6.33-rc1, sk_buff->iff was renamed to
sk_buff->skb_iif, which breaks compilation on kernels going forward.

The second issue is that the setlist module is currently not being
built which results in "ipset v4.1: Unknown set type" when attempting
to create a set of this type (as documented in the man page).  I'm not
sure if this is intentional (if it is, feel free to ignore that
patch), but in my experience it has worked quite well with the
exception of -T not working as expected (or at all AFAICT).

Another issue, for which I did not include a patch, is how automatic
resizing of hash tables is handled.  If I restore a file (created
outside ipset) which contains somewhere near (but less than) 65000
entries which do not hash to unique values I start getting log
messages like the following:

/usr/src/modules/xtables-addons/ipset/ip_set_nethash.c: nethash_retry: rehashing of set setname triggered: hashsize grows from 44319 to 66478
/usr/src/modules/xtables-addons/ipset/ip_set_nethash.c: nethash_retry: rehashing of set setname triggered: hashsize grows from 66478 to 99717

and ipset -R silently fails to restore the rest of the file (returning
exit code 0).  I realize that there may be some code to deal with this
during save (or when adding entries using -A), but it would be very
helpful if the user could be warned about the failure during -R as
well.  As a side note:  One use case is when building a large set it
is significantly (on the order of 1000 times on my test system) faster
to build the list and use -R than individually with -A).

Thanks again for all of your work,
Kevin

P.S.  Please CC me in replies as I am not subscribed to this list.

Kevin Locke (2):
  Rename skb->iif to skb->skb_iif for after 2.6.32
  Build ip_set_setlist.ko module

 extensions/compat_skbuff.h |    5 ++++-
 extensions/ipset/Kbuild    |    2 +-
 2 files changed, 5 insertions(+), 2 deletions(-)

