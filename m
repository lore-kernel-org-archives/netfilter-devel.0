From: Jan Engelhardt <jengelh@medozas.de>
Subject: Re: Modifying ebtables to read the commands from a file
Date: Sun, 28 Mar 2010 15:00:10 +0200 (CEST)
Message-ID: <alpine.LSU.2.01.1003281457380.22298@obet.zrqbmnf.qr>
References: <1269770877.2563.9.camel@qed>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: netfilter-devel@vger.kernel.org
To: Peter Gordon <peter@pg-consultants.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from borg.medozas.de ([188.40.89.202]:32976 "EHLO borg.medozas.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754543Ab0C1NAL (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Sun, 28 Mar 2010 09:00:11 -0400
In-Reply-To: <1269770877.2563.9.camel@qed>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Sunday 2010-03-28 12:07, Peter Gordon wrote:

>I need to add a number of rules to the ebtables and I cannot afford the
>fork overhead for each line.

The larger part of the overhead is due to the tables recomputed (dumped, 
rule added, restored) every time you call it. That's why one should use 
xx-restore.

>So what I want to do is to read each line
>from a file and have the program iterate over the file. 
>
>ebtables-save and ebtables-restore is not good enough for my
>application, because I can't add rules incrementally.

Dump the rules with ebtables-save to a buffer, add your rules,
and use -restore. That's sort of incrementally, and the fastest
way to put a ruleset in atomic fashion into place.
