From: Jan Engelhardt <jengelh@medozas.de>
Subject: Re: [PATCH 4/4] netfilter: xtables: remove old comments about
 reentrancy
Date: Tue, 20 Apr 2010 14:29:49 +0200 (CEST)
Message-ID: <alpine.LSU.2.01.1004201426330.20518@obet.zrqbmnf.qr>
References: <1271373909-6959-1-git-send-email-jengelh@medozas.de> <1271373909-6959-5-git-send-email-jengelh@medozas.de> <4BCC63E1.6080808@trash.net> <4BCD9CEB.3040801@trash.net>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: netfilter-devel@vger.kernel.org
To: Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from borg.medozas.de ([188.40.89.202]:57303 "EHLO borg.medozas.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754444Ab0DTM3v (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 20 Apr 2010 08:29:51 -0400
In-Reply-To: <4BCD9CEB.3040801@trash.net>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Tuesday 2010-04-20 14:24, Patrick McHardy wrote:

>Patrick McHardy wrote:
>> Also applied, thanks Jan. I'll push everything out after
>> some more intensive testing.
>
>Not using oif was broken due to an incorrect check for a device
>name, there also was a device reference leak. I took the
>opportunity to convert it to notifier based device resolving.
>
>If a oif is given, we register a netdevice notifier to resolve
>the name on NETDEV_REGISTER or NETDEV_CHANGE and unresolve it
>again on NETDEV_UNREGISTER or NETDEV_CHANGE (to a different name).
>The behaviour should be equivalent to the runtime resolving.
>
>Please review, if things are fine I'll commit the patch and
>push everything out.

Seems good to me.

>+		priv = kmalloc(sizeof(*priv), GFP_KERNEL);
>+		if (priv == NULL)
>+			return -ENOMEM;
>+
>+		priv->tginfo  = info;
>+		priv->oif     = -1;
>+		priv->notifier.notifier_call = tee_netdev_event;
>+
>+		register_netdevice_notifier(&priv->notifier);

I take it tee_tg_event gets immediately called after the registration.
