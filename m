From: Patrick McHardy <kaber@trash.net>
Subject: [NETFILTER 00/02]: Netfilter fixes
Date: Thu, 18 Oct 2007 12:12:22 +0200 (MEST)
Message-ID: <20071018101159.28424.36079.sendpatchset@localhost.localdomain>
Cc: Patrick McHardy <kaber@trash.net>, netfilter-devel@vger.kernel.org
To: davem@davemloft.net
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:33478 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755279AbXJRKMY (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 18 Oct 2007 06:12:24 -0400
Sender: netfilter-devel-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

Hi Dave,

these two patches contain a follow-up fix to the TCP conntrack connection
reopening problem and a fix for the sctp match, which uses ARRAY_SIZE on
a pointer instead of an array.

Please apply, thanks.


 include/linux/netfilter/xt_sctp.h      |   13 +++++--------
 net/netfilter/nf_conntrack_proto_tcp.c |   11 +++++++----
 net/netfilter/xt_sctp.c                |   18 ++++++++----------
 3 files changed, 20 insertions(+), 22 deletions(-)

Jozsef Kadlecsik (1):
      [NETFILTER]: nf_conntrack_tcp: fix connection reopening fix

Li Zefan (1):
      [NETFILTER]: xt_sctp: fix mistake to pass a pointer where array is required
