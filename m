From: Patrick McHardy <kaber@trash.net>
Subject: Re: Every other char with LOG netfilter output (bug?)
Date: Thu, 30 Oct 2008 08:15:14 +0100
Message-ID: <49095F02.7040104@trash.net>
References: <rlujt5-k63.ln1@tux.abusar.org.br>	<49074E81.6010207@trash.net>	<49075276.2686460a.0b00.ffff9f09@mx.google.com>	<4907564D.5090103@trash.net> <49094b22.0f87460a.09d2.55b6@mx.google.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15;
	format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: netfilter-devel@vger.kernel.org,
	Pablo Neira Ayuso <pablo@netfilter.org>
To: =?ISO-8859-15?Q?D=E2niel_Fraga?= <fragabr@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:53164 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752712AbYJ3HPR (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 30 Oct 2008 03:15:17 -0400
In-Reply-To: <49094b22.0f87460a.09d2.55b6@mx.google.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

D=E2niel Fraga wrote:
> On Tue, 28 Oct 2008 19:13:33 +0100
> Patrick McHardy <kaber@trash.net> wrote:
>=20
>> I'm not familiar with ftrace, but you could manually instrument it
>> (net/ipv4/netfilter/ipt_LOG.c). I'd try nfnetlink_log first though.
>=20
> 	Hi Patrick, I installed ulogd2 with all necessary stuff. The
> normal log is working (with the default ulogd.conf), but how can I
> configure it to log the full packets? If you can provide me a sample
> configuration, I'll appreciate!

One thing you need is to specify the amount of bytes you want transfere=
d
to userspace:

iptables ... -j NFLOG --nflog-range 65535

The printpkt output plugin doesn't log the full packet, but I'm not
sure how to configure the pcap plugin (or whether it works at all
in ulogd2, which is still somewhere between alpha and beta).
Pablo (CCed) might be able to help.

--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
