From: Jan Engelhardt <jengelh@medozas.de>
Subject: Re: [PATCH] libxtables: change option precedence order to be
 intuitive
Date: Mon, 15 Nov 2010 14:13:27 +0100 (CET)
Message-ID: <alpine.LNX.2.01.1011151413200.30546@obet.zrqbmnf.qr>
References: <1289824097-27337-1-git-send-email-jengelh@medozas.de> <4CE12DF3.8050108@trash.net>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: netfilter-devel@vger.kernel.org
To: Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from borg.medozas.de ([188.40.89.202]:57938 "EHLO borg.medozas.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756186Ab0KONN2 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 15 Nov 2010 08:13:28 -0500
In-Reply-To: <4CE12DF3.8050108@trash.net>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Monday 2010-11-15 13:56, Patrick McHardy wrote:

>On 15.11.2010 13:28, Jan Engelhardt wrote:
>> The following changes since commit 648fd1ad68ae2ec675ac07efee80783912535404:
>>                                    ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
>> 
>>   libxt_TOS: avoid an undesired overflowing computation (2010-11-02 09:17:09 +0100)
>> 
>> are available in the git repository at:
>>   git://dev.medozas.de/iptables master
>
>Well, as I'm sure you're aware this doesn't apply to the
>current tree, so please rebase.

Revert the revert and merge?
