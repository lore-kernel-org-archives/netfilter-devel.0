From: Jan Engelhardt <jengelh@computergmbh.de>
Subject: Re: [PATCH 8/8] [NETFILTER]: xt_length match, revision 1
Date: Sat, 12 Apr 2008 08:38:52 +0200 (CEST)
Message-ID: <alpine.LNX.1.10.0804120833430.8405@fbirervta.pbzchgretzou.qr>
References: <1207664257-1927-1-git-send-email-jengelh@computergmbh.de> <9e46f22a9f7950b9f924d7918be23da9127e7eef.1207664141.git.jengelh@computergmbh.de> <47FB8F0F.3010702@trash.net> <alpine.LNX.1.10.0804091818350.3866@fbirervta.pbzchgretzou.qr>
 <47FCEDEE.2020309@trash.net>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: netfilter-devel@vger.kernel.org
To: Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from sovereign.computergmbh.de ([85.214.69.204]:38289 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753249AbYDLGiy (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Sat, 12 Apr 2008 02:38:54 -0400
In-Reply-To: <47FCEDEE.2020309@trash.net>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


On Wednesday 2008-04-09 18:25, Patrick McHardy wrote:
>
> In my opinion all the kernel should needs to be able to do
> is to deal with variable length headers, everything else can
> be calculated by userspace(/the user).
>
> So for example if you can match on the IP payload length,
> you *know* the UDP data length is that value - 8.

Well that _is_ what we do:

        case IPPROTO_UDPLITE:
                *length = skb->len - offset - sizeof(struct udphdr);

and then it already returns to

        return (len >= info->min && len <= info->max) ^
               !!(info->flags & XT_LENGTH_INVERT);


> Whats that SCTP thing about?

It only counts the SCTP DATA substreams. In TCP this is not necessary
because all tcp control data is in the tcphdr already, but in
sctp this does not seem to be the case.
