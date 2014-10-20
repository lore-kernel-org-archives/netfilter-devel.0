From: Florian Westphal <fw@strlen.de>
Subject: Re: NAT dropping FIN ACK from remote server
Date: Mon, 20 Oct 2014 23:35:02 +0200
Message-ID: <20141020213502.GA26557@breakpoint.cc>
References: <CAC=w+U4bYSJ8d=0GmgmM3miVrd54sN1y0_ppsvs97gd7gLo+2g@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: vDev <vijaypas@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([80.244.247.6]:43397 "EHLO
	Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753163AbaJTVfE (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 20 Oct 2014 17:35:04 -0400
Content-Disposition: inline
In-Reply-To: <CAC=w+U4bYSJ8d=0GmgmM3miVrd54sN1y0_ppsvs97gd7gLo+2g@mail.gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

vDev <vijaypas@gmail.com> wrote:
> I am experiencing a problem with Linux as a NAT router. A host/client
> on the private LAN establishes a TCP connection to a server on the WAN
> (Internet) through the Linux/NAT router. Here's what happens when
> client attempts to tear down the socket.
> 
> 1. Client on private LAN opens a TCP connection to the remote server
> on the public network through Linux/NAT router.
> 2. Client exchanges data with the remote server.
> 3. The server closes the TCP connection by sending a FIN to the
> client. Linux/NAT router successfully forwards the FIN to the client.
> 4. The client now sends an ACK to FIN to the remote host, which is
> forwarded by the Linux/NAT router to the server.
> 5. The client then sends a FIN to the remote host, which is forwarded
> by the Linux/NAT router to the remote server.
> 6. The server now sends an ACK to the client. THE Linux/NAT router
> DOES NOT FORWARD THE ACK TO THE CLIENT. GETS DROPPED!

Any chance to get a tcpdump of such a connection?
(Dumping on the interface in direction of the server, so we can see
 the server ACK that is being dropped).
