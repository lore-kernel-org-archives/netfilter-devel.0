From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH 0/2] ipset patches against net-2.6/nf-2.6
Date: Thu, 26 May 2011 18:41:30 +0200
Message-ID: <4DDE82BA.8080507@netfilter.org>
References: <1305917503-14427-1-git-send-email-kadlec@blackhole.kfki.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@vger.kernel.org, Patrick McHardy <kaber@trash.net>,
	David Miller <davem@davemloft.net>
To: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:43413 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757785Ab1EZQlf (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 26 May 2011 12:41:35 -0400
In-Reply-To: <1305917503-14427-1-git-send-email-kadlec@blackhole.kfki.hu>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On 20/05/11 20:51, Jozsef Kadlecsik wrote:
> Hi Dave and Patrick,
> 
> Here follows two patches against net-2.6/nf-2.6, please apply them.
> 
> Best regards,
> Jozsef
> 
> Jozsef Kadlecsik (2):
>   netfilter: ipset: Use proper timeout value to jiffies conversion
>   netfilter: ipset: remove unused variable from type_pf_tdel()

Thanks, I have applied these patches to my tree.

http://1984.lsi.us.es/git/?p=net-2.6/.git;a=shortlog;h=refs/heads/pablo/nf-2.6-updates
