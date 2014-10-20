From: Marcelo Ricardo Leitner <mleitner@redhat.com>
Subject: Re: NAT dropping FIN ACK from remote server
Date: Mon, 20 Oct 2014 19:18:33 -0200
Message-ID: <54457C29.7040802@redhat.com>
References: <CAC=w+U4bYSJ8d=0GmgmM3miVrd54sN1y0_ppsvs97gd7gLo+2g@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
To: vDev <vijaypas@gmail.com>, netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:34500 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753125AbaJTVSg (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 20 Oct 2014 17:18:36 -0400
In-Reply-To: <CAC=w+U4bYSJ8d=0GmgmM3miVrd54sN1y0_ppsvs97gd7gLo+2g@mail.gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On 16-10-2014 18:57, vDev wrote:
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
> 7. The client keeps sending FIN to the remote host for a period of time.
> 8. The client times out and send a RST to the remote host.
>
> I am trying to find out why Linux/NAT router dropped the ACK. This
> seems like a problem where connection tracking is prematurely tearing
> down the mapping and does not forward the ACK back to the client.
>
> Is there a way to resolve this?
>
> Also, any debugging techniques will be helpful.

Try checking if this ignored ack is being marked as invalid by conntrack with 
something like iptables -I FORWARD -m conntrack --ctstate INVALID -j LOG

If it's marked as INVALID, for whatever reason, we won't NAT it.. (and you 
probably have another rule that ends up dropping the not-NATed packet, if 
that's the case)

Marcelo

