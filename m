From: Jan Engelhardt <jengelh@medozas.de>
Subject: Re: pull request
Date: Wed, 11 Feb 2009 16:45:53 +0100 (CET)
Message-ID: <alpine.LSU.2.00.0902111644260.20223@fbirervta.pbzchgretzou.qr>
References: <1234364616-19974-1-git-send-email-jengelh@medozas.de> <4992E97C.5050508@trash.net>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: netfilter-devel@vger.kernel.org
To: Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from sovereign.computergmbh.de ([85.214.69.204]:58049 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755473AbZBKPpz (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 11 Feb 2009 10:45:55 -0500
In-Reply-To: <4992E97C.5050508@trash.net>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


On Wednesday 2009-02-11 16:06, Patrick McHardy wrote:
> jengelh@medozas.de wrote:
>> Please pull from
>> 	git://dev.medozas.de/iptables master
>> to recive
>> Jan Engelhardt (8):
>>      libxtables: recognize IP6TABLES_LIB_DIR old-style environment variable
>>      build: move -ldl to proper LDADD
>>      libxtables: remove unused XT_LIB_DIR macro
>>      libxtables: decouple non-xtables parts from header
>>      src: remove iptables_rule_match indirection macro
>>      src: remove unused ipt_tryload macro
>>      libxtables: move compat defines to xtables.c
>>      src: consolidate duplicate code in iptables/internal.h
>
> How do these interact with the Jamal's pending changes?

I think it should be fine as I am changing just the periphery here.
If it merges without git-pull stopping, after you applied his,
it's probably ok :)
