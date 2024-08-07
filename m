Received: from mail.netfilter.org (mail.netfilter.org [217.70.188.207])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A90D3282FB
	for <netfilter-devel@vger.kernel.org>; Wed,  7 Aug 2024 14:24:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.188.207
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723040652; cv=none; b=MRKqhmx1ZuMuhnPGUxxm3zib/qtkVsw57xJsSxzNfzo1eU6RvazK61x02HMDieeg7p1bvR+f+VgZrkgOBm5Jq82WxaTIqNMZSZk5MlePR2t5fjdCElnNHaov691I5EMaaZ+9Mhos7pJPNVMR/PD+IysdayIV4jwJ7idwSBRPvUs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723040652; c=relaxed/simple;
	bh=sUYlBJ/EvtWMCKe1K901vTJynRJoetjWopoj3WXF2wI=;
	h=From:To:Subject:Date:Message-Id:MIME-Version; b=TeM3twRL5uRoFPWzTP/X13xQGP3akeK7Sb/Hv30JGgNyWNcdRwrN44GzgYwAy0VDI/QnDol3lJ4JKdAl9m2/NczO+cMK+dd2ysyOD0FwBm2Wpz8+bv1dbpOVxiOCoBHVd/GiNWOzv0Dv9YbwBmzdRwVXba0SfQaoU7p3aDXD94I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; arc=none smtp.client-ip=217.70.188.207
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Subject: [PATCH nf-next 0/8] nf_tables: support for updating set element timeout
Date: Wed,  7 Aug 2024 16:23:49 +0200
Message-Id: <20240807142357.90493-1-pablo@netfilter.org>
X-Mailer: git-send-email 2.30.2
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Hi,

This patchset adds support for updating set element timeouts. This
includes 5 fixes, then one patch to consolidate set element timeout
extensions, and finally the new marker for elements that never expire
and support for element timeout updates.

Patch #1 fixes a bug with timeouts less than HZ/10, assuming CONFIG_HZ=100

        add element ip x y { 1.2.3.4 timeout 9ms)

   results in an element that never expires. This happens because this
   timeout results in jiffies64 == 0, hence, the timeout extension is not
   allocated.

Patch #2 rejects element expiration with no timeout, this is currently
   silently ignore in case no default set timeout is specified, e.g.

        table ip x {
        	set y {
			typeof ip saddr
			flags timeout
			elements = { 1.2.3.4 expires 30s }
		}
        }

Patch #3 remove unnecessary read_once notation when accessing default
   set timeout while holding mutex.

Patch #4 adds read-write_once notations for lockless access to default set
   timeout policy that are missing in dynset.

Patch #5 adds read-write_once notations for element expiration, again dynset
   could update this while netlink dump is in progress.

Patch #6 consolidates the timeout extensions: timeout and expiration
   are tightly coupled, use a single extension for both. This simplifies
   set element timeout updates coming in the next patches.

Patch #7 adds a marker for elements that never update.

        table ip x {
        	set y {
			typeof ip saddr
			timeout 1h
			elements = { 1.2.3.4 timeout never, 1.2.3.5 }
		}
        }

   In this case, 1.2.3.4 never expires and 1.2.3.5 gets a timeout of 1h
   as per the default set timeout.

   Note that it is already possible to define set elements that never
   expire by declaring a set with the timeout flag set on, but with no
   default set policy. In this case, no timeout extension is allocated.

        table ip x {
        	set y {
			typeof ip saddr
			flags timeout
			elements = { 1.2.3.4, 1.2.3.5 timeout 1h }
		}
        }

   In this example above, 1.2.3.4 never expires [*]. The new marker prepares
   for set element timeout updates, where the timeout extension needs to
   be allocated. This marker also allows for elements that never expire
   when default timeout policy is specified, which was not supported.

   [*] Note that sets with no default timeout do not display timeout
   never to retain backward compatibility in the listing.

Patch #8 allows to update set timeout/expiration.

        table ip x {
        	set y {
			typeof ip saddr
			timeout 1h
			elements = { 1.2.3.4, 1.2.3.5 }
		}
        }

   which use default 1h set timeout. Then, updating timeout is possible via:

        add element x y { 1.2.3.4 timeout 30s }
        add element x y { 1.2.3.5 timeout 25s }

No tests/shell yet available, still working on this.

Pablo Neira Ayuso (8):
  netfilter: nf_tables: elements with timeout less than HZ/10 never expire
  netfilter: nf_tables: reject element expiration with no timeout
  netfilter: nf_tables: remove annotation to access set timeout while holding lock
  netfilter: nft_dynset: annotate data-races around set timeout
  netfilter: nf_tables: annotate data-races around element expiration
  netfilter: nf_tables: consolidate timeout extension for elements
  netfilter: nf_tables: add never expires marker to elements
  netfilter: nf_tables: set element timeout update support

 include/net/netfilter/nf_tables.h        |  32 +++--
 include/uapi/linux/netfilter/nf_tables.h |   3 +
 net/netfilter/nf_tables_api.c            | 144 ++++++++++++++++-------
 net/netfilter/nft_dynset.c               |  21 ++--
 net/netfilter/nft_last.c                 |   3 +-
 5 files changed, 139 insertions(+), 64 deletions(-)

--
2.30.2

