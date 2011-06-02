From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH 08/12] netfilter: ipset: Add xt_action_param to the variant
 level kadt functions
Date: Thu, 02 Jun 2011 14:56:32 +0200
Message-ID: <4DE78880.6090804@netfilter.org>
References: <1306964151-4686-1-git-send-email-kadlec@blackhole.kfki.hu> <1306964151-4686-2-git-send-email-kadlec@blackhole.kfki.hu> <1306964151-4686-3-git-send-email-kadlec@blackhole.kfki.hu> <1306964151-4686-4-git-send-email-kadlec@blackhole.kfki.hu> <1306964151-4686-5-git-send-email-kadlec@blackhole.kfki.hu> <1306964151-4686-6-git-send-email-kadlec@blackhole.kfki.hu> <1306964151-4686-7-git-send-email-kadlec@blackhole.kfki.hu> <1306964151-4686-8-git-send-email-kadlec@blackhole.kfki.hu> <1306964151-4686-9-git-send-email-kadlec@blackhole.kfki.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@vger.kernel.org, Patrick McHardy <kaber@trash.net>
To: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:59549 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933510Ab1FBM4i (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 2 Jun 2011 08:56:38 -0400
In-Reply-To: <1306964151-4686-9-git-send-email-kadlec@blackhole.kfki.hu>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On 01/06/11 23:35, Jozsef Kadlecsik wrote:
> With the change the sets can use any parameter available for the match
> and target extensions, like input/output interface. It's required for
> the hash:net,iface set type.
> 
> Signed-off-by: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>

applied. thanks
