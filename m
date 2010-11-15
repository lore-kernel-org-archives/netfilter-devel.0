From: Jan Engelhardt <jengelh@medozas.de>
Subject: Re: [PATCH] libxtables: change option precedence order to be
 intuitive
Date: Mon, 15 Nov 2010 14:41:59 +0100 (CET)
Message-ID: <alpine.LNX.2.01.1011151440520.30546@obet.zrqbmnf.qr>
References: <1289824097-27337-1-git-send-email-jengelh@medozas.de> <4CE12DF3.8050108@trash.net> <alpine.LNX.2.01.1011151413200.30546@obet.zrqbmnf.qr> <4CE13264.3010104@trash.net>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: netfilter-devel@vger.kernel.org
To: Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from borg.medozas.de ([188.40.89.202]:37560 "EHLO borg.medozas.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756409Ab0KONmB (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 15 Nov 2010 08:42:01 -0500
In-Reply-To: <4CE13264.3010104@trash.net>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Monday 2010-11-15 14:15, Patrick McHardy wrote:
>>>>
>>>> are available in the git repository at:
>>>>   git://dev.medozas.de/iptables master
>> 
>> Revert the revert and merge?
>
>Yes please.

git://dev.medozas.de/iptables master

 include/xtables.h.in |    5 +++--
 ip6tables.c          |    6 +++---
 iptables.c           |   12 +++++++++---
 xtables.c            |   49 ++++++++++++++++++++++++++++---------------------
 4 files changed, 43 insertions(+), 29 deletions(-)
