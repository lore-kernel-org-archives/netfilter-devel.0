From: Laszlo Attila Toth <panther@balabit.hu>
Subject: Socket match with transparent option, take 2
Date: Thu,  4 Jun 2009 14:37:23 +0200
Message-ID: <1244119045-10614-1-git-send-email-panther@balabit.hu>
Cc: kaber@trash.net, Laszlo Attila Toth <panther@balabit.hu>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from support.balabit.hu ([195.70.41.86]:58993 "EHLO lists.balabit.hu"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753723AbZFDMhZ (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 4 Jun 2009 08:37:25 -0400
Received: from balabit.hu (unknown [10.80.0.254])
	by lists.balabit.hu (Postfix) with ESMTP id 2D90213A257
	for <netfilter-devel@vger.kernel.org>; Thu,  4 Jun 2009 14:37:26 +0200 (CEST)
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hi,

this is the latest version of the new socket match option, '--transparent':
if this option is used, only sockets with enabled transparent socket option
are matched.

As I wrote earlier, the original, default behaviour of the match is unwanted,
because not only a transparent socket, but also any socket can be matched,
such as a simple SSH or web server's.

The kernel part is on the top net-next-2.6.

The match info is type contains the revision of the socket match,
struct xt_socket_match_info1 which was missing from the previous patches.

Regards,
Attila
