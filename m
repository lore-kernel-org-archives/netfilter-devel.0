From: John Haxby <john.haxby@oracle.com>
Subject: [PATCH 0/2] Security improvements for xt_SYSRQ
Date: Fri, 24 Jun 2011 14:14:12 +0100
Message-ID: <cover.1308920081.git.john.haxby@oracle.com>
Cc: prarit@redhat.com, John Haxby <john.haxby@oracle.com>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from rcsinet10.oracle.com ([148.87.113.121]:42878 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753655Ab1FXNOd (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 24 Jun 2011 09:14:33 -0400
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hello All,

These two patches are something I promised a long time ago and never
actually got around to.

The first patch is just housekeeping: it uses %pI4 and %pI6c for
address formatting in when the debug option is turned on.  Actually,
it's not just housekeeping: the IPv6 sysrq trigger never worked
because of some bad pointer arithmetic.  I also show the destination
IP (or IPv6) address in the debug output because that helps you when
debugging the remote sysrq script for the second patch.

The second patch removed a long standing issue I have had with
xt_SYSRQ.  Someone who doesn't carefully make sure all the hosts with
xt_SYSRQ rules have different, difficult to guess passwords runs the
risk of an attacker replaying a request to every host on the network
"just on the off chance".  The hash now includes the destination IP
address to make this kind of opportunistic hack less likely.

jch

John Haxby (2):
  Use %pI4/%pI6c instead of NIPQUAD_FMT/NIP6_FMT and make IPv6 work
  Improve security for xt_SYSRQ

 extensions/libxt_SYSRQ.man |   17 +++++++++++------
 extensions/xt_SYSRQ.c      |   27 ++++++++++++++++-----------
 2 files changed, 27 insertions(+), 17 deletions(-)

-- 
1.7.5.4

