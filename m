From: Jan Engelhardt <jengelh@medozas.de>
Subject: Re: [NEW SOFTWARE] FIRO - Iptables optimization
Date: Thu, 9 Jun 2011 15:44:52 +0200 (CEST)
Message-ID: <alpine.LNX.2.01.1106091530110.22244@frira.zrqbmnf.qr>
References: <BANLkTinGcunf22dZQr1mX6omuB88eAZZ6A@mail.gmail.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: netfilter-devel@vger.kernel.org
To: Tihomir Katic <tihomir.katic@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from seven.medozas.de ([188.40.89.202]:34052 "EHLO seven.medozas.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757515Ab1FINox (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 9 Jun 2011 09:44:53 -0400
In-Reply-To: <BANLkTinGcunf22dZQr1mX6omuB88eAZZ6A@mail.gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Thursday 2011-06-09 15:18, Tihomir Katic wrote:
>
>I developed some firewall optimizer for iptables optimization.
>
>FIRO is parsing output of iptables-save command and removes redundant
>rules from it. Rules in each chain and table are optimized separately.
>Optimization procedure continues until there are no more rules to
>remove or to modify. As a result, FIRO generates new file with new set
>of rules for every successful optimization procedure. Also, it logs
>all actions and changes in separated files.
>
>List of optimization procedures:
> -  Remove irrelevant rules
> -  Remove redundant "shadowed after" rules
> -  Remove redundant "shadowed before" rules
> -  Remove last rules with same action as chain
> -  Merge rules
> -  Remove redundant parameters from rules
> -  Remove redundant elements from parameters
> -  Reposition of "logging" rules in chain
>
>This is free software, 1st published version, and I would appreciate
>every download, every test, every reported bug, suggestion, etc.
>
>Link to FIRO:
>http://valeria.zesoi.fer.hr/~tkatic

Great idea. Consider 
http://jengelh.medozas.de/documents/Perfect_Ruleset.pdf for more things 
to do in rulesets.

Some of the suggestions are not a 1:1 conversion, such as replacing -s 
127.0.0.0/8 by -i lo. In this case, a warning is the most one can do in 
an automated fashion, and actually sufficient. -- in the spirit of 
checkpatch.pl.


Inbetween, I have created a git repo with Makefiles. If I feel lucky, 
I'll also fix the build in a minute.

	git://dev.medozas.de/firo
