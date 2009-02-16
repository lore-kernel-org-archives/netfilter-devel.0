From: Jan Engelhardt <jengelh@medozas.de>
Subject: Re: [PATCH 3/4] netfilter: print the list of register loggers.
Date: Mon, 16 Feb 2009 18:01:54 +0100 (CET)
Message-ID: <alpine.LSU.2.00.0902161753530.26651@fbirervta.pbzchgretzou.qr>
References: <49980BA7.2040108@inl.fr> <1234701437-2754-3-git-send-email-eric@inl.fr>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: kaber@trash.net, netfilter-devel@vger.kernel.org
To: Eric Leblond <eric@inl.fr>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from sovereign.computergmbh.de ([85.214.69.204]:36287 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751551AbZBPRB4 (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 16 Feb 2009 12:01:56 -0500
In-Reply-To: <1234701437-2754-3-git-send-email-eric@inl.fr>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


On Sunday 2009-02-15 13:37, Eric Leblond wrote:
>--- a/net/netfilter/nf_log.c
>+++ b/net/netfilter/nf_log.c
>@@ -168,13 +168,37 @@ static int seq_show(struct seq_file *s, void *v)
> {
> 	loff_t *pos = v;
> 	const struct nf_logger *logger;
>+	struct nf_logger *t;
>+	int ret;
> 
> 	logger = rcu_dereference(nf_loggers[*pos]);
> 
> 	if (!logger)
>-		return seq_printf(s, "%2lld NONE\n", *pos);
>+		ret = seq_printf(s, "%2lld NONE (", *pos);
>+	else
>+		ret = seq_printf(s, "%2lld %s (", *pos, logger->name);
>+
>+	if (ret < 0)
>+		return ret;
>+
>+	mutex_lock(&nf_log_mutex);
>+	list_for_each_entry(t, &nf_loggers_l[*pos], list[*pos]) {
>+		ret = seq_printf(s, "%s", t->name);

The seqprinting (knowingly that I suggested it) has a bit of a drawback
the way you use it -- if userspace passes a buffer of, say, size 11,
then the first seq_printf will succeed in stuffing " 1 NONE (" into
the buffer; it then has 2 left. Because t->name is probably more descriptive
than that, the second seq_printf will fail, breaking out of the loop,
calling seq_stop, etc. and userspace gets 9 as the return value for
the read() it attempted. However, when userspace now tries to read()
again, as it is absolutely entitled to, the " 1 NONE (" will be printed
again into the buffer -- which is rather undesirable.

I see zero ways around this:

 a. use snprintf to build the string, and then do a single
    final seq_printf
    Drawback: determine size of buffer to use for snprintf -
    we do not want it too large not too small

 b. rework the *pos logic in a way so that it is checkpointed after
    every seq_printf.
    Drawback: It could become ugly, much like the regression fix
    I've sent in.

Maybe the authors of seq_file can offer some better function that
takes care of this?
