From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: Every other char with LOG netfilter output (bug?)
Date: Thu, 30 Oct 2008 16:02:22 +0100
Message-ID: <4909CC7E.7070801@netfilter.org>
References: <rlujt5-k63.ln1@tux.abusar.org.br>	<49074E81.6010207@trash.net>	<49075276.2686460a.0b00.ffff9f09@mx.google.com>	<4907564D.5090103@trash.net> <49094b22.0f87460a.09d2.55b6@mx.google.com> <49095F02.7040104@trash.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Patrick McHardy <kaber@trash.net>, netfilter-devel@vger.kernel.org
To: =?ISO-8859-15?Q?D=E2niel_Fraga?= <fragabr@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:43525 "EHLO us.es"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1755150AbYJ3PDV (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 30 Oct 2008 11:03:21 -0400
In-Reply-To: <49095F02.7040104@trash.net>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Patrick McHardy wrote:
> D=E2niel Fraga wrote:
>> On Tue, 28 Oct 2008 19:13:33 +0100
>> Patrick McHardy <kaber@trash.net> wrote:
>>
>>> I'm not familiar with ftrace, but you could manually instrument it
>>> (net/ipv4/netfilter/ipt_LOG.c). I'd try nfnetlink_log first though.
>>
>>     Hi Patrick, I installed ulogd2 with all necessary stuff. The
>> normal log is working (with the default ulogd.conf), but how can I
>> configure it to log the full packets? If you can provide me a sample
>> configuration, I'll appreciate!
>=20
> One thing you need is to specify the amount of bytes you want transfe=
red
> to userspace:
>=20
> iptables ... -j NFLOG --nflog-range 65535
>=20
> The printpkt output plugin doesn't log the full packet, but I'm not
> sure how to configure the pcap plugin (or whether it works at all
> in ulogd2, which is still somewhere between alpha and beta).
> Pablo (CCed) might be able to help.

The plugin works fine here. Uncomment the following lines:

# plugin=3D"/usr/lib/ulogd/ulogd_output_PCAP.so

# this is a stack for NFLOG packet-based logging to PCAP
# stack=3Dlog1:NFLOG,base1:BASE,pcap1:PCAP

And make sure you have the appropriate section:

[pcap1]
file=3D"/var/log/ulogd.pcap"
sync=3D1

--=20
"Los honestos son inadaptados sociales" -- Les Luthiers
--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
