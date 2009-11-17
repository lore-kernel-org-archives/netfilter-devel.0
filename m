From: Nils Rennebarth <Nils.Rennebarth@web.de>
Subject: Sending packets from netfilter modules
Date: Tue, 17 Nov 2009 16:13:36 +0100
Message-ID: <932717060@web.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Transfer-Encoding: QUOTED-PRINTABLE
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from fmmailgate04.web.de ([217.72.192.242]:52232 "EHLO
	fmmailgate04.web.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754258AbZKQPNc convert rfc822-to-8bit (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 17 Nov 2009 10:13:32 -0500
Received: from web.de
	by fmmailgate04.web.de (Postfix) with SMTP id 53BC36211725
	for <netfilter-devel@vger.kernel.org>; Tue, 17 Nov 2009 16:13:37 +0100 (CET)
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hi,

I want to send a new packet that was created from scratch from within a=
 netfilter module.

There are already examples in the kernel tree, e.g. in net/ipv4/netfilt=
er/ipt_REJECT.c, so I modeled my code after these and got it working: T=
he packets appear on the wire and are received by other hosts.

However, the packet is finally sent using ip_local_out, so from a firew=
all perspective, the packet appears out of thin air and then travels th=
rough the OUTPUT chain and out to the network device. What I want inste=
ad, is for the packet to take the same way as an incoming packet, i.e. =
travel through the PREROUTING chain, gets routed, travels through FORWA=
RD, routed again travels through POSTROUTING and be sent out.

The reason is that my netfilter module acts as a man-in-the-middle in a=
 router, and the self-generated packets should not circumvent the firew=
all or need a duplicated ruleset in the OUTPUT chain, etc.

I thought, something like netif_receive_skb or netif_rx may do what I w=
ant, but those rely on a prepared skb. Can someone point me into the ri=
ght direction?
______________________________________________________
GRATIS f=FCr alle WEB.DE-Nutzer: Die maxdome Movie-FLAT!
Jetzt freischalten unter http://movieflat.web.de

--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
