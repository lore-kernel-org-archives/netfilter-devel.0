From: Pierre Chifflier <chifflier@inl.fr>
Subject: [ULOGD2] UNIXSOCK plugin (v4)
Date: Thu, 14 Jan 2010 20:41:26 +0100
Message-ID: <1263498088-32555-1-git-send-email-chifflier@inl.fr>
Cc: eleblond@inl.fr
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from smtp1-g21.free.fr ([212.27.42.1]:53130 "EHLO smtp1-g21.free.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757521Ab0ANTlo (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 14 Jan 2010 14:41:44 -0500
Received: from smtp1-g21.free.fr (localhost [127.0.0.1])
	by smtp1-g21.free.fr (Postfix) with ESMTP id A1B879400BE
	for <netfilter-devel@vger.kernel.org>; Thu, 14 Jan 2010 20:41:39 +0100 (CET)
Received: from fydelkass.edenwall.com (fydelkass.inl.fr [88.171.131.12])
	by smtp1-g21.free.fr (Postfix) with ESMTP id BE736940105
	for <netfilter-devel@vger.kernel.org>; Thu, 14 Jan 2010 20:41:36 +0100 (CET)
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


Hi,

Here is an updated version of the UNIXSOCK plugin.

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

