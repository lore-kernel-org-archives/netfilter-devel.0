From: Jan Engelhardt <jengelh@medozas.de>
Subject: Re: [PATCH] DHCPv6 connection tracker helper
Date: Wed, 15 Feb 2012 18:13:12 +0100 (CET)
Message-ID: <alpine.LNX.2.01.1202151758290.15357@frira.zrqbmnf.qr>
References: <CAFntDkx2SUkCkSbU7sO4OrWqypWQpY-KNgrD-_DgqRSXAGvJZQ@mail.gmail.com> <alpine.LNX.2.01.1202130940390.30851@frira.zrqbmnf.qr> <CAFntDkw0sN=j+mKm0s=kac+mMWnQqdyUviGj0_puj0bqSobR=Q@mail.gmail.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Netfilter Developer Mailing List
	<netfilter-devel@vger.kernel.org>,
	Pablo Neira Ayuso <pablo@netfilter.org>
To: Darren Willis <djw@google.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from seven.medozas.de ([188.40.89.202]:39945 "EHLO seven.medozas.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753103Ab2BORNS (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 15 Feb 2012 12:13:18 -0500
In-Reply-To: <CAFntDkw0sN=j+mKm0s=kac+mMWnQqdyUviGj0_puj0bqSobR=Q@mail.gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


On Wednesday 2012-02-15 10:00, Darren Willis wrote:
>
>For checking the validity of a DHCP packet, there's not really very
>much that can be done without parsing the DHCPv6 options. I've added a
>length check to make sure the outgoing message has at least a message
>type and transaction ID, and the timeout setting-code implicitly
>checks that the message has a known DHCPv6 message type.

Seems sufficient indeed.

>It would be possible to capture outgoing messages' transaction IDs and
>require that incoming advertise/reply responses match it, but I'm not
>sure that's really going to be a big help (the clients are surely
>doing this already).

Certainly would be on my wishlist if such an extension does not look
too ugly.

>> Thirdly, your module does not seem to make any attempt (yet) to handle
>> the DHCP v6 RECONFIGURE message.
>
>Right. I'm not sure of a good way to handle this; I suppose I could
>check initial ADVERTISE messages for the 'accept reconfigure' option,
>and allow the source of that advertise to have access to port 546.
>There's no time limit on reconfigure messages,[...]

Irk. I would suggest doing like the ICMPv6 tracker does,
marking it unconditionally as INVALID to indicate that the
implementation chose to not track RECONFIGURE on purpose.

>+static int dhcpv6_help(struct sk_buff *skb,
>+		       unsigned int protoff,
>+		       struct nf_conn *ct,
>+		       enum ip_conntrack_info ctinfo)
>+{
>...
>+	unsigned char *type = 0;
= NULL.

>+static struct nf_conntrack_helper helper __read_mostly = {
>+	.name                   = "dhcpv6",
>+	.tuple.src.l3num        = AF_INET6,

This should be NFPROTO_IPV6 actually.
