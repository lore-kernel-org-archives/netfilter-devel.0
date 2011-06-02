From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: Iptables
Date: Thu, 02 Jun 2011 13:47:56 +0200
Message-ID: <4DE7786C.8070308@netfilter.org>
References: <BANLkTi=G1ecs9wx+QgAcUphK2-jg60nbAw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
To: jordann thefaut <thefaut.jordann@gmail.com>,
	Netfilter Development Mailinglist
	<netfilter-devel@vger.kernel.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:45941 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752558Ab1FBLsA (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 2 Jun 2011 07:48:00 -0400
In-Reply-To: <BANLkTi=G1ecs9wx+QgAcUphK2-jg60nbAw@mail.gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On 31/05/11 16:10, jordann thefaut wrote:
> Hello. I contact you because I use Iptables on my Android, and I have
> has some problems to compile it. The solution is one line!
> I think is also the same thing on linux, because I wanted to use MARK,
> but in file "libxt_MARK.c" in dir "extensions" we find:
> 
> void _init(void)
> 
> and I replace it by :
> 
> void libxt_MARK_init(void)
> 
> And my cross compile for Android is ok. I am French and I don't know
> if I am comprehensible, but I think that it's a little modification
> onyour different version with Xtable.

thanks, that's nice, but I need more details on why we need to apply
that change and a patch for iptables.
