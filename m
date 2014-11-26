From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [nft PATCH v2] evaluate: reject: fix crash on NULL location with
 bridge and tcp reset
Date: Wed, 26 Nov 2014 12:13:28 +0100
Message-ID: <20141126111328.GA4685@salvia>
References: <1417000071-22579-1-git-send-email-alvaroneay@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org, kaber@trash.net
To: Alvaro Neira Ayuso <alvaroneay@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:40521 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751036AbaKZLLS (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 26 Nov 2014 06:11:18 -0500
Content-Disposition: inline
In-Reply-To: <1417000071-22579-1-git-send-email-alvaroneay@gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Wed, Nov 26, 2014 at 12:07:51PM +0100, Alvaro Neira Ayuso wrote:
> If we use tcp reset with a network protocol that tcp is not supported,
> we display an error. This error use the reject.expr location which is NULL,
> therefore we have a crash. This patch replaces it using the reject statement
> to display the error like:
> 
> Rule:
>  nft add bridge filter input ether type vlan reject with tcp reset
> Output:
>  <cmdline>:1:46-51: Error: cannot reject this ether type
>  add rule bridge filter input ether type vlan reject with tcp reset

Applied, thanks.
