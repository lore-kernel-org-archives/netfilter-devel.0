From: Patrick McHardy <kaber@trash.net>
Subject: Re: [NEW SOFTWARE] FIRO - Iptables optimization
Date: Thu, 09 Jun 2011 15:23:40 +0200
Message-ID: <4DF0C95C.5070207@trash.net>
References: <BANLkTinGcunf22dZQr1mX6omuB88eAZZ6A@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@vger.kernel.org
To: Tihomir Katic <tihomir.katic@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:38925 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757849Ab1FINXm (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 9 Jun 2011 09:23:42 -0400
In-Reply-To: <BANLkTinGcunf22dZQr1mX6omuB88eAZZ6A@mail.gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On 09.06.2011 15:18, Tihomir Katic wrote:
> Hi
> 
> I developed some firewall optimizer for iptables optimization.
> 
> FIRO is parsing output of iptables-save command and removes redundant
> rules from it. Rules in each chain and table are optimized separately.
> Optimization procedure continues until there are no more rules to
> remove or to modify. As a result, FIRO generates new file with new set
> of rules for every successful optimization procedure. Also, it logs
> all actions and changes in separated files.
> 
> List of optimization procedures:
>  -  Remove irrelevant rules
>  -  Remove redundant "shadowed after" rules
>  -  Remove redundant "shadowed before" rules
>  -  Remove last rules with same action as chain
>  -  Merge rules
>  -  Remove redundant parameters from rules
>  -  Remove redundant elements from parameters
>  -  Reposition of "logging" rules in chain
> 
> This is free software, 1st published version, and I would appreciate
> every download, every test, every reported bug, suggestion, etc.
> 
> Link to FIRO:
> http://valeria.zesoi.fer.hr/~tkatic

Sounds interesting, but I can't unpack that rar, every file
fails. Please provide a tar.gz/bz2 or something similar.
