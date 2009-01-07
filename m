From: Jan Engelhardt <jengelh@medozas.de>
Subject: Re: [PATCH 5/6] netfilter: print the list of register loggers.
Date: Thu, 8 Jan 2009 00:56:00 +0100 (CET)
Message-ID: <alpine.LSU.2.00.0901080054080.29344@fbirervta.pbzchgretzou.qr>
References: <1231312622.4137.7.camel@ice-age> <1231358734-20958-5-git-send-email-eric@inl.fr>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: kaber@trash.net, netfilter-devel@vger.kernel.org
To: Eric Leblond <eric@inl.fr>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from sovereign.computergmbh.de ([85.214.69.204]:48741 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750843AbZAGX4B (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 7 Jan 2009 18:56:01 -0500
In-Reply-To: <1231358734-20958-5-git-send-email-eric@inl.fr>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


On Wednesday 2009-01-07 21:05, Eric Leblond wrote:
>--- a/net/netfilter/nf_log.c
>+++ b/net/netfilter/nf_log.c
>@@ -172,13 +172,26 @@ static int seq_show(struct seq_file *s, void *v)
> {
> 	loff_t *pos = v;
> 	const struct nf_logger *logger;
>+	struct nf_logger *t;
>+	char loggers_string[256];
>+	int len = 256;

An array this big is likely to upset the guys who try to reduce
stack usage.
<mumble> there ought to be some way to figure out how much
space there is left in a seq... </mumble> and if there is
enough, just always use seq_printf.

