From: Pierre Chifflier <chifflier@inl.fr>
Subject: Remove debian directory, and add new UNIXSOCK input plugin
Date: Sun, 23 Aug 2009 21:36:05 +0200
Message-ID: <1251056168-7073-1-git-send-email-chifflier@inl.fr>
Cc: eleblond@inl.fr
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from smtp1-g21.free.fr ([212.27.42.1]:45350 "EHLO smtp1-g21.free.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933820AbZHWTgX (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Sun, 23 Aug 2009 15:36:23 -0400
Received: from smtp1-g21.free.fr (localhost [127.0.0.1])
	by smtp1-g21.free.fr (Postfix) with ESMTP id 23D759400CB
	for <netfilter-devel@vger.kernel.org>; Sun, 23 Aug 2009 21:36:19 +0200 (CEST)
Received: from fydelkass.edenwall.com (fydelkass.inl.fr [88.171.131.12])
	by smtp1-g21.free.fr (Postfix) with ESMTP id 4810B94014D
	for <netfilter-devel@vger.kernel.org>; Sun, 23 Aug 2009 21:36:17 +0200 (CEST)
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hi,

[1] remove debian directory: the packaging is outdated, and not used in
Debian anyway. It is easier to maintain it outside sources, so delete it.

(These patches are not related)

[2] add new input plugin UNISOCK, using a unix socket. This allows userspace
applications to send packets to ulogd, for example to send packets offline.
It uses a key-length-value protocol to handle optional fields or extensions.
[3] is a Perl script to load a PCAP file and send it to ulogd using the
UNIXSOCK plugin.

Regards,
Pierre

