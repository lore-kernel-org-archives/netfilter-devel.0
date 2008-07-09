From: Jan Engelhardt <jengelh@medozas.de>
Subject: Re: Netfilter module help
Date: Thu, 10 Jul 2008 01:27:45 +0200 (CEST)
Message-ID: <alpine.LNX.1.10.0807100127040.27323@fbirervta.pbzchgretzou.qr>
References: <13f1ba4c0807091558m5fff70ear7515557278001922@mail.gmail.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: netfilter-devel@vger.kernel.org
To: tung tran <tunghack@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from sovereign.computergmbh.de ([85.214.69.204]:45053 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751049AbYGIX1q (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 9 Jul 2008 19:27:46 -0400
In-Reply-To: <13f1ba4c0807091558m5fff70ear7515557278001922@mail.gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


On Thursday 2008-07-10 00:58, tung tran wrote:

>Hi all,
>I am writing a kernel module that hooks into netfilter.
>netfilter_ops.hook              =       main_hook;
>netfilter_ops.pf                =       PF_INET;
>netfilter_ops.hooknum           =       NF_IP_PRE_ROUTING;
>netfilter_ops.priority          =       NF_IP_PRI_FIRST;
>nf_register_hook(&netfilter_ops);
>
>In the main_hook function, I needs to put the process to sleep and
>will be woken up by another process because the decision to Accept or
>Deny a packet depends on a process running in the user space. However,
>all sleeping mechanism I tried  cause the kernel hang.

You cannot sleep in an interrupt handler.
