From: Bart De Schuymer <bdschuym@pandora.be>
Subject: [PATCH 0/3] bridge-netfilter fixes
Date: Wed, 14 Apr 2010 15:14:09 +0200
Message-ID: <4BC5BFA1.3050204@pandora.be>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: Stephen Hemminger <shemminger@linux-foundation.org>
To: Netfilter Developer Mailing List <netfilter-devel@vger.kernel.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from gerard.telenet-ops.be ([195.130.132.48]:36407 "EHLO
	gerard.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755271Ab0DNNON (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 14 Apr 2010 09:14:13 -0400
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hello,

The following three patches are a rediff versus nf-next of my previous
patches 3/5 and 4/5. I've split up the previous [PATCH 3/5] into the new
patches 1/3 and 2/3. The previous patch 4/5 is the same as the new patch
3/3.
Patrick's comment about packet statistics in br_device.c has been taken
into account.
Please apply or comment.

[PATCH 1/3] bridge-netfilter: simplify IP DNAT

 include/linux/netfilter_bridge.h |   17 ++++-
 net/bridge/br_device.c           |    9 ++-
 net/bridge/br_netfilter.c        |  114
++++++---------------------------------
 3 files changed, 40 insertions(+), 100 deletions(-)

[PATCH 2/3] bridge-netfilter: Fix MAC header handling with IP DNAT

 include/linux/netfilter_bridge.h |    5 +-
 include/net/neighbour.h          |   14 ++++++
 net/bridge/br_netfilter.c        |   90
++++++++++++++++++++++++++++-----------
 3 files changed, 83 insertions(+), 26 deletions(-)

[PATCH 3/3] bridge-netfilter: fix refragmenting IP traffic encapsulated
in PPPoE traffic

 bridge/br_netfilter.c |    4 +++-
 ipv4/ip_output.c      |    4 ++++
 2 files changed, 7 insertions(+), 1 deletion(-)


cheers,
Bart

-- 
Bart De Schuymer
www.artinalgorithms.be
