From: Jan Engelhardt <jengelh@medozas.de>
Subject: Re: netfilter moving to git
Date: Wed, 21 May 2008 18:40:03 +0200 (CEST)
Message-ID: <alpine.LNX.1.10.0805211803020.15136@fbirervta.pbzchgretzou.qr>
References: <48299680.7020808@trash.net> <alpine.LNX.1.10.0805131614570.448@fbirervta.pbzchgretzou.qr> <4829A316.2080402@trash.net> <alpine.LNX.1.10.0805170930120.15590@fbirervta.pbzchgretzou.qr> <482F938D.3060405@trash.net>
 <alpine.LNX.1.10.0805210031520.15136@fbirervta.pbzchgretzou.qr> <4833EEC7.2080503@trash.net>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Netfilter Development Mailinglist
	<netfilter-devel@vger.kernel.org>
To: Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from sovereign.computergmbh.de ([85.214.69.204]:37508 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934467AbYEUQkF (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 21 May 2008 12:40:05 -0400
In-Reply-To: <4833EEC7.2080503@trash.net>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


On Wednesday 2008-05-21 11:43, Patrick McHardy wrote:
>> well would you accept a script that filters the repository
>> to put proper committer/author in place?
>
> Mhh .. I guess I would if its soon, before too many people
> have started using that tree.
>

http://dev.medozas.de/iptables-rw.tar.bz2

cd into the working directory, run `git status` (really necessary,
can't be automated in the script for some stupid reason),
and then run ../path/to/runme3.
It also fixes the tags; be sure to remove the svn_t_ pseudobranchtagswhatever
afterwards.
