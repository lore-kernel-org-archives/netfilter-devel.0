From: Jan Engelhardt <jengelh@medozas.de>
Subject: Re: Are pre- postrouting states device independent ?
Date: Mon, 2 May 2011 12:07:44 +0200 (CEST)
Message-ID: <alpine.LNX.2.01.1105021207290.28373@obet.zrqbmnf.qr>
References: <4DBE7B58.6000800@mediadesign-fh.de>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: netfilter-devel@vger.kernel.org
To: Falk Nisius <f.nisius@mediadesign-fh.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from borg.medozas.de ([188.40.89.202]:38139 "EHLO borg.medozas.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755616Ab1EBKHp (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 2 May 2011 06:07:45 -0400
In-Reply-To: <4DBE7B58.6000800@mediadesign-fh.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Monday 2011-05-02 11:37, Falk Nisius wrote:

>I have a box with some virtual machines.
>One of them has a firewalling function without any natting,
>like the following scheme.
>
>+--------+
>|        |192.168.11.42/30
>| guest1 |------------------+
>|        |       br11       |
>+--------+                  |  192.168.11.41/30  +---------+
>                            +--------------------|         |
>                                                 | guest3  |
>+--------+                  +--------------------| (fw)    |
>|        |192.168.11.46/30  |  192.168.11.45/30  +---------+
>| guest2 |------------------+                         | 192.168.10.2/30
>|        |       br12                                 | hostnet
>+--------+
> 
>The traffic on the br11 and br12 is allowed.
>There is an rule to SNAT guest1 to extern-IP-one
>There is an rule to SNAT guest2 to extern-IP-two
>There is an rule to SNAT guest3 to extern-IP-three

You will have to post the entire rules, not some fragment, and in 
iptable-save -c format.
