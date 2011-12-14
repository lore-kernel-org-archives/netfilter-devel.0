From: Jan Engelhardt <jengelh@medozas.de>
Subject: Re: [PATCH 1/2] netfilter: add extended accounting infrastructure
 over nfnetlink
Date: Wed, 14 Dec 2011 14:43:40 +0100 (CET)
Message-ID: <alpine.LNX.2.01.1112141439180.16886@frira.zrqbmnf.qr>
References: <1323860443-7129-1-git-send-email-pablo@netfilter.org> <1323860443-7129-2-git-send-email-pablo@netfilter.org>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: netfilter-devel@vger.kernel.org, kadlec@blackhole.kfki.hu,
	kaber@trash.net, thomas.jarosch@intra2net.com
To: pablo@netfilter.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from seven.medozas.de ([188.40.89.202]:40189 "EHLO seven.medozas.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755058Ab1LNNnm (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 14 Dec 2011 08:43:42 -0500
In-Reply-To: <1323860443-7129-2-git-send-email-pablo@netfilter.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Wednesday 2011-12-14 12:00, pablo@netfilter.org wrote:

>Then, you can use one of this accounting objects in several iptables
>rules using the new NFACCT target (which comes in a follow-up patch):
>
> # iptables -I INPUT -p tcp --sport 80 -j NFACCT --nfacct-name http-traffic
> # iptables -I OUTPUT -p tcp --dport 80 -j NFACCT --nfacct-name http-traffic
>
>The idea is simple: if one packet matches the rule, the NFACCT target
>updates the counters.

This smells a lot like -m quota2 --grow, except that yours uses 
netlink instead of procfs and can only update the counters.

I suggest to turn -j NFACCT into -m nfacct instead, so that we can add 
counting-down mode and matching capabilities, so as to replace 
xt_quota*.

