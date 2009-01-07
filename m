From: Jan Engelhardt <jengelh@medozas.de>
Subject: Re: [PATCH 4/6] netfilter: convert logger modules to new API.
Date: Thu, 8 Jan 2009 00:53:45 +0100 (CET)
Message-ID: <alpine.LSU.2.00.0901080053110.29344@fbirervta.pbzchgretzou.qr>
References: <1231312622.4137.7.camel@ice-age> <1231358734-20958-4-git-send-email-eric@inl.fr>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: kaber@trash.net, netfilter-devel@vger.kernel.org
To: Eric Leblond <eric@inl.fr>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from sovereign.computergmbh.de ([85.214.69.204]:35318 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758336AbZAGXxq (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 7 Jan 2009 18:53:46 -0500
In-Reply-To: <1231358734-20958-4-git-send-email-eric@inl.fr>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


On Wednesday 2009-01-07 21:05, Eric Leblond wrote:

>This patch converts the logging modules to the new API. For nfnetlink_log,
>it simply switchs call to register functions to call to bind function and
>adds a call to nf_log_register() during init. For other modules, it just
>remove a const flag from the logger structure.
> 
>-static const struct nf_logger ipt_log_logger ={
>+static struct nf_logger ipt_log_logger ={

But maybe add __read_mostly, then?
