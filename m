From: Pierre Chifflier <chifflier@inl.fr>
Subject: [ULOGD2] UNIXSOCK plugin (v3)
Date: Sun,  1 Nov 2009 11:53:46 +0100
Message-ID: <1257072828-11028-1-git-send-email-chifflier@inl.fr>
Cc: eleblond@inl.fr
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from smtp1-g21.free.fr ([212.27.42.1]:51876 "EHLO smtp1-g21.free.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751693AbZKAKyZ (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Sun, 1 Nov 2009 05:54:25 -0500
Received: from smtp1-g21.free.fr (localhost [127.0.0.1])
	by smtp1-g21.free.fr (Postfix) with ESMTP id B06869400BE
	for <netfilter-devel@vger.kernel.org>; Sun,  1 Nov 2009 11:54:25 +0100 (CET)
Received: from fydelkass.edenwall.com (fydelkass.inl.fr [88.171.131.12])
	by smtp1-g21.free.fr (Postfix) with ESMTP id 977C094007C
	for <netfilter-devel@vger.kernel.org>; Sun,  1 Nov 2009 11:54:22 +0100 (CET)
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


Hi,

Here is an updated version of the UNIXSOCK plugin.

Changes since last version:
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

