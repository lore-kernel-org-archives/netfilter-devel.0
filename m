From: Jan Engelhardt <jengelh@medozas.de>
Subject: Re: XT_CONTINUE/EBT_CONTINUE for universal modules
Date: Tue, 8 Mar 2011 14:53:14 +0100 (CET)
Message-ID: <alpine.LNX.2.01.1103081443350.32577@obet.zrqbmnf.qr>
References: <20110308120815.GA28673@canuck.infradead.org>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: netfilter-devel@vger.kernel.org
To: Thomas Graf <tgraf@infradead.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from borg.medozas.de ([188.40.89.202]:59661 "EHLO borg.medozas.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755003Ab1CHNxQ (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 8 Mar 2011 08:53:16 -0500
In-Reply-To: <20110308120815.GA28673@canuck.infradead.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Tuesday 2011-03-08 13:08, Thomas Graf wrote:
>
>xt_AUDIT.c currently returns XT_CONTINUE. The module is universal and would
>be useable from ebtables if it wasn't for ebtables to expect EBT_CONTINUE.
>
>Is the only way around this cloning xt_AUDIT.c to ebt_audit.c?

You could make all ebt targets ust XT_* values, provided that they are 
translated from/to EBT_* when reading/writing the table from/to 
userspace.

>I've seen some patches from Jan converting ebtables to use xtables 
>infrastucture but they haven't been merged.

>From what I remember, they have become
v2.6.28-rc1~717^2~109^2~29..v2.6.28-rc1~717^2~109^2~18 .
If not, which patches would you be referring to?
