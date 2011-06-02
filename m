From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH 10/12] netfilter: ipset: Use the stored first cidr value
 instead of '1'
Date: Thu, 02 Jun 2011 14:56:51 +0200
Message-ID: <4DE78893.5050402@netfilter.org>
References: <1306964151-4686-1-git-send-email-kadlec@blackhole.kfki.hu> <1306964151-4686-2-git-send-email-kadlec@blackhole.kfki.hu> <1306964151-4686-3-git-send-email-kadlec@blackhole.kfki.hu> <1306964151-4686-4-git-send-email-kadlec@blackhole.kfki.hu> <1306964151-4686-5-git-send-email-kadlec@blackhole.kfki.hu> <1306964151-4686-6-git-send-email-kadlec@blackhole.kfki.hu> <1306964151-4686-7-git-send-email-kadlec@blackhole.kfki.hu> <1306964151-4686-8-git-send-email-kadlec@blackhole.kfki.hu> <1306964151-4686-9-git-send-email-kadlec@blackhole.kfki.hu> <1306964151-4686-10-git-send-email-kadlec@blackhole.kfki.hu> <1306964151-4686-11-git-send-email-kadlec@blackhole.kfki.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@vger.kernel.org, Patrick McHardy <kaber@trash.net>
To: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:59657 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933510Ab1FBM5G (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 2 Jun 2011 08:57:06 -0400
In-Reply-To: <1306964151-4686-11-git-send-email-kadlec@blackhole.kfki.hu>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On 01/06/11 23:35, Jozsef Kadlecsik wrote:
> The stored cidr values are tried one after anoter. The boolean
> condition evaluated to '1' instead of the first stored cidr or
> the default host cidr.

applied, thanks
