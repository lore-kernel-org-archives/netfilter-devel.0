From: Jan Engelhardt <jengelh@medozas.de>
Subject: Re: change to max length of jump target
Date: Mon, 13 Sep 2010 15:51:25 +0200 (CEST)
Message-ID: <alpine.LNX.2.01.1009131550370.12482@obet.zrqbmnf.qr>
References: <4C87D4BC.8090802@vyatta.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: netfilter-devel@vger.kernel.org
To: Stig Thormodsrud <stig@vyatta.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from borg.medozas.de ([188.40.89.202]:47956 "EHLO borg.medozas.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751708Ab0IMNv0 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 13 Sep 2010 09:51:26 -0400
In-Reply-To: <4C87D4BC.8090802@vyatta.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Wednesday 2010-09-08 20:23, Stig Thormodsrud wrote:

>
>I'm in the process of upgrading to iptables 1.4.9 and noticed that the
>max jump target has changed from 30 characters to 28 characters.  For
>example I can still create a 29 character chain but can't create a jump
>target to it:
>
>root@r1:~# iptables -t filter --new-chain A2345678901234567890123456789

An oversight. Will post once I've addressed some more bugreports.

