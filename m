From: Jan Engelhardt <jengelh@medozas.de>
Subject: Re: [RFC,PATCH] netfilter: SNMP conntrack module
Date: Fri, 14 Jan 2011 22:18:37 +0100 (CET)
Message-ID: <alpine.LNX.2.01.1101142200510.6525@obet.zrqbmnf.qr>
References: <20110114201805.GC4546@jolsa.brq.redhat.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Patrick McHardy <kaber@trash.net>, Tim Waugh <twaugh@redhat.com>,
	netfilter-devel@vger.kernel.org
To: Jiri Olsa <jolsa@redhat.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from borg.medozas.de ([188.40.89.202]:44578 "EHLO borg.medozas.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752178Ab1ANVSl (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 14 Jan 2011 16:18:41 -0500
In-Reply-To: <20110114201805.GC4546@jolsa.brq.redhat.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


On Friday 2011-01-14 21:18, Jiri Olsa wrote:
>+
>+MODULE_AUTHOR("Jiri Olsa <jolsa@redhat.com>");
>+MODULE_DESCRIPTION("SNMP service broadcast connection tracking helper");
>+MODULE_LICENSE("GPL");
>+MODULE_ALIAS("ip_conntrack_snmp");

This alias looks redundant given it's a new module, and there being
no autoloading by prefix like there currently is for iptables extensions.

>+static unsigned int timeout __read_mostly = 30;
>+module_param(timeout, uint, 0400);

400 -> S_IRUSR. We have the mnemonic constants, so should make use of them.

>+static struct nf_conntrack_helper helper __read_mostly = {
>+	.name			= "snmp",
>+	.tuple.src.l3num	= AF_INET,

 = NFPROTO_IPV4,

>+	.tuple.src.u.udp.port	= cpu_to_be16(SNMP_PORT),
>+	.tuple.dst.protonum	= IPPROTO_UDP,
>+	.me			= THIS_MODULE,
>+	.help			= help,
>+	.expect_policy		= &exp_policy,
>+};

I think it would a good idea to give the help function a better
name than "help". You know, when a stack trace comes up, it'll be
much more enlightening.

