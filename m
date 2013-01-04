From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH v2] iptables: allow IPv6 port NAT without address NAT
Date: Fri, 4 Jan 2013 01:10:10 +0100
Message-ID: <20130104001010.GA4053@1984>
References: <20130102155244.GB5133@uweber-WS>
 <20130103001306.GB27394@1984>
 <20130103103958.GA9315@uweber-WS>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Ulrich Weber <ulrich.weber@sophos.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:58741 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753559Ab3ADAKP (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 3 Jan 2013 19:10:15 -0500
Content-Disposition: inline
In-Reply-To: <20130103103958.GA9315@uweber-WS>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Thu, Jan 03, 2013 at 11:39:58AM +0100, Ulrich Weber wrote:
> correct parsing of IPv6 port NAT without address NAT,
> assume one colon as port information.
> 
> Allows:
> * address only:
>  -j DNAT --to affe::1
>  -j DNAT --to [affe::1]
> 
> * port only
>  -j DNAT --to :80
>  -j DNAT --to :80-110
>  -j DNAT --to []:80
>  -j DNAT --to []:80-110
> 
> * address and port
>  -j DNAT --to [affe::1]:80
>  -j DNAT --to [affe::1]:80-110

Applied, thanks Ulrich.
