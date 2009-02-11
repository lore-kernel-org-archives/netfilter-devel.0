From: Patrick McHardy <kaber@trash.net>
Subject: Re: pull request
Date: Wed, 11 Feb 2009 16:06:36 +0100
Message-ID: <4992E97C.5050508@trash.net>
References: <1234364616-19974-1-git-send-email-jengelh@medozas.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@vger.kernel.org
To: jengelh@medozas.de
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:52786 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750958AbZBKPGj (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 11 Feb 2009 10:06:39 -0500
In-Reply-To: <1234364616-19974-1-git-send-email-jengelh@medozas.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

jengelh@medozas.de wrote:
> Please pull from
> 	git://dev.medozas.de/iptables master
> to recive
> Jan Engelhardt (8):
>       libxtables: recognize IP6TABLES_LIB_DIR old-style environment variable
>       build: move -ldl to proper LDADD
>       libxtables: remove unused XT_LIB_DIR macro
>       libxtables: decouple non-xtables parts from header
>       src: remove iptables_rule_match indirection macro
>       src: remove unused ipt_tryload macro
>       libxtables: move compat defines to xtables.c
>       src: consolidate duplicate code in iptables/internal.h

How do these interact with the Jamal's pending changes?
