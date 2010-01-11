From: Nils Rennebarth <nils.rennebarth@funkwerk-ec.com>
Subject: Kernel generated packets and ipsec policies
Date: Mon, 11 Jan 2010 17:49:13 +0100
Message-ID: <4B4B5689.502@funkwerk-ec.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
To: Netfilter Devel List <netfilter-devel@vger.kernel.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from virgo.stuttgart.de.funkwerk-ec.com ([85.93.77.62]:56714 "EHLO
	virgo.stuttgart.de.funkwerk-ec.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751560Ab0AKQyk convert rfc822-to-8bit
	(ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 11 Jan 2010 11:54:40 -0500
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hi,

I am writing a netfilter module which is supposed to run on a firewall,
and protect some servers behind it.

The module is manipulating TCP connections that are routed through the
box, i.e. passing through the FORWARD chain. Occasionally it needs to
generate and send a packets itself, pretending to come from the other
end of the connection.

To send a packet itself, it allocates an skb, puts together ip and tcp
header, a fake mac header, and then calls netif_rx(skb)
It does not use ip_local_out like in the other places in the kernel
(e.g. send_reset in ipt_REJECT.c) that send out kernel generated
packets, because to the rest of the firewall, the packet should appear
as much as possible to be part of the original connection.

Now the actual question:

Normally this works well, except if the connection passes through an
ipsec tunnel, which ends on the firewall. In this case, the following
code in net/ipv4/ip_forward.c

        if (!xfrm4_policy_check(NULL, XFRM_POLICY_FWD, skb))
                goto drop;

will drop the packet.

Is there some way to prevent the xfrm4_policy_check from rejecting
the packet? The only way I could think of was to somehow mark the
skb and then check the marker in ip_forward:

       if (marker_present(skb) || !xfrm4_policy_check(NULL, XFRM_POLICY=
_FWD, skb))
               goto drop;

but that seems too much ad hoc, besides I want to keep the number of
changes to the kernel at a minimum.


--=20

Mit freundlichen Gr=FC=DFen / with kind regards

Nils Rennebarth, Software Developer

--
=46unkwerk IP-Appliances GmbH
M=F6nchhaldenstra=DFe 28
D-70191 Stuttgart

Tel: +49 711 900300 - 0
=46ax: +49 711 900300 - 90

E-Mail: Nils.Rennebarth@funkwerk-ec.com

Location: GmbH Nuernberg, Local Court Nuernberg, HRB 25481
Managing Directors: Torsten Urban
--------------------------------
The information contained in this e-mail has been carefully researched,
but the possibility of it being inapplicable in individual cases cannot
be ruled out. We therefore regret that we cannot accept responsibility
or liability of any kind whatsoever for the correctness of the
information given. Please notify us if you discover that information is
inapplicable.

--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
