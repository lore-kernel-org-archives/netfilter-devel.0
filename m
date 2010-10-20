From: Pierre Chifflier <chifflier@edenwall.com>
Subject: [ULOGD2] UNIXSOCK plugin (v5b)
Date: Wed, 20 Oct 2010 13:44:50 +0200
Message-ID: <1287575092-454-1-git-send-email-chifflier@edenwall.com>
Cc: Eric Leblond <eleblond@edenwall.com>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from smtp3-g21.free.fr ([212.27.42.3]:42492 "EHLO smtp3-g21.free.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751159Ab0JTLpE (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 20 Oct 2010 07:45:04 -0400
Received: from fydelkass.edenwall.com (unknown [88.171.131.12])
	by smtp3-g21.free.fr (Postfix) with ESMTP id 34C53A62A0
	for <netfilter-devel@vger.kernel.org>; Wed, 20 Oct 2010 13:44:56 +0200 (CEST)
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


Hi,

First of all, sorry for the long time with no updates on this patch.
This is a resend of the patches for the UNIXSOCK input plugin for ulogd2.

Please let me know if there are any issues.

PS: hope you enjoyed the oowall presentation :)



Changes for v5:
- align all structures on 64 bits instead of 32
  This has been tested on a sparc64 (thanks to Jan)
- update pcap2ulog to handle different pcap formats

Changes for v4:
- use structures instead of reading integers directly
- all structures and fields are now aligned (4 bytes)
- update pcap2ulog script to use aligned data as well

Changes for v3:
- if the bufsize value (from conf) is 0, try to guess the buffer size
  using getsockopt(SOL_SOCKET, SO_RCVBUF ..)
- set default path to /var/run/ulogd/ulogd2.sock with mode 0600
- add new configuration options perms, owner and group to be able
  to set these parameters on the created socket
- change the input algorithm to make it more robust against junk data (which
  can happen if the client is desynchronized)
- fixed a few bugs

Description:

[1] add new input plugin UNISOCK, using a unix socket. This allows userspace
applications to send packets to ulogd, for example to send packets offline.
It uses a key-length-value protocol to handle optional fields or extensions.

[2] is a Perl script to load a PCAP file and send it to ulogd using the
UNIXSOCK plugin.

Pierre
