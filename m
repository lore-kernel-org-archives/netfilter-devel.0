From: Pierre Chifflier <chifflier@edenwall.com>
Subject: [ULOGD2] UNIXSOCK plugin (v5)
Date: Fri, 26 Feb 2010 21:54:38 +0100
Message-ID: <1267217680-22677-1-git-send-email-chifflier@edenwall.com>
Cc: eleblond@edenwall.com
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from smtp1-g21.free.fr ([212.27.42.1]:45261 "EHLO smtp1-g21.free.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S966090Ab0BZUyw (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 26 Feb 2010 15:54:52 -0500
Received: from smtp1-g21.free.fr (localhost [127.0.0.1])
	by smtp1-g21.free.fr (Postfix) with ESMTP id 3BAFD940019
	for <netfilter-devel@vger.kernel.org>; Fri, 26 Feb 2010 21:54:46 +0100 (CET)
Received: from fydelkass.edenwall.com (fydelkass.inl.fr [88.171.131.12])
	by smtp1-g21.free.fr (Postfix) with ESMTP id 5572E94014C
	for <netfilter-devel@vger.kernel.org>; Fri, 26 Feb 2010 21:54:44 +0100 (CET)
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hi,

Here is an updated version of the UNIXSOCK plugin.

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

