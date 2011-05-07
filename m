From: Jan Engelhardt <jengelh@medozas.de>
Subject: Re: [PATCH] Fix reversed logic when implictly loading protocol
 matches
Date: Sat, 7 May 2011 16:52:34 +0200 (CEST)
Message-ID: <alpine.LNX.2.01.1105071650590.31190@obet.zrqbmnf.qr>
References: <1304772414-17294-1-git-send-email-ljaenicke@innominate.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: netfilter-devel@vger.kernel.org
To: Lutz Jaenicke <ljaenicke@innominate.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from borg.medozas.de ([188.40.89.202]:38495 "EHLO borg.medozas.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755289Ab1EGOwg (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Sat, 7 May 2011 10:52:36 -0400
In-Reply-To: <1304772414-17294-1-git-send-email-ljaenicke@innominate.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Saturday 2011-05-07 14:46, Lutz Jaenicke wrote:

>If the protocol module has already been loaded (find_proto()
>is succesfull) would but has not yet been activated for this command
>(proto_used is not yet set), we have to activate the protocol
>specific match for this command.
>Without the modification iptables-restore will fail if an
>implicitly loaded protocol match is used for the second time.
>  ...
>  -A somechain -p udp --dport 500 -j ACCEPT
>  -A somechain -p udp --dport 4500 -j ACCEPT
>  ...
>will fail for the "4500" line with '--dport" being an unknown option.

It was here previously:
http://www.spinics.net/lists/netfilter-devel/msg17530.html

But it was not picked up.. [maintenance needs to be reevaluated I 
suppose]
