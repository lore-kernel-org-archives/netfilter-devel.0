From: vDev <vijaypas@gmail.com>
Subject: NAT dropping FIN ACK from remote server
Date: Thu, 16 Oct 2014 16:57:25 -0500
Message-ID: <CAC=w+U4bYSJ8d=0GmgmM3miVrd54sN1y0_ppsvs97gd7gLo+2g@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-wi0-f182.google.com ([209.85.212.182]:57802 "EHLO
	mail-wi0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751345AbaJPV50 (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 16 Oct 2014 17:57:26 -0400
Received: by mail-wi0-f182.google.com with SMTP id n3so576560wiv.15
        for <netfilter-devel@vger.kernel.org>; Thu, 16 Oct 2014 14:57:25 -0700 (PDT)
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

I am experiencing a problem with Linux as a NAT router. A host/client
on the private LAN establishes a TCP connection to a server on the WAN
(Internet) through the Linux/NAT router. Here's what happens when
client attempts to tear down the socket.

1. Client on private LAN opens a TCP connection to the remote server
on the public network through Linux/NAT router.
2. Client exchanges data with the remote server.
3. The server closes the TCP connection by sending a FIN to the
client. Linux/NAT router successfully forwards the FIN to the client.
4. The client now sends an ACK to FIN to the remote host, which is
forwarded by the Linux/NAT router to the server.
5. The client then sends a FIN to the remote host, which is forwarded
by the Linux/NAT router to the remote server.
6. The server now sends an ACK to the client. THE Linux/NAT router
DOES NOT FORWARD THE ACK TO THE CLIENT. GETS DROPPED!
7. The client keeps sending FIN to the remote host for a period of time.
8. The client times out and send a RST to the remote host.

I am trying to find out why Linux/NAT router dropped the ACK. This
seems like a problem where connection tracking is prematurely tearing
down the mapping and does not forward the ACK back to the client.

Is there a way to resolve this?

Also, any debugging techniques will be helpful.
