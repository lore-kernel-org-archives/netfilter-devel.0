From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: ctnetlink kernel dump while running multiple libnfct clients
Date: Wed, 30 Mar 2011 01:11:54 +0200
Message-ID: <4D92673A.5070108@netfilter.org>
References: <AANLkTi=17VZ6Sjgj57LTa-xcJj00BSjv_-4DveiutNo1@mail.gmail.com>	<4D908351.5010407@netfilter.org>	<AANLkTi=LNMqTMf34OnjP3rgp5hrw=bLgrdZneZ4cyffi@mail.gmail.com>	<4D91B083.2000001@netfilter.org>	<AANLkTi=XfknKE9RkiohtW4+xzpAe2CGY1JDg7_JtfSUG@mail.gmail.com>	<4D925614.2000909@netfilter.org> <AANLkTi=9y=E3dfq3QZEUHcQ506uHb+VhsivB+Ot-QQgR@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: Netfilter Developer Mailing List <netfilter-devel@vger.kernel.org>
To: Sam Roberts <vieuxtech@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:53596 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751989Ab1C2XMA (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 29 Mar 2011 19:12:00 -0400
In-Reply-To: <AANLkTi=9y=E3dfq3QZEUHcQ506uHb+VhsivB+Ot-QQgR@mail.gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On 30/03/11 00:44, Sam Roberts wrote:
> When this happened, I was running the prototype conntracker, and
> several instances of conntrack -E (for each table). I typed a
> conntrack -L command, and the kernel died after I hit ENTER. Could be
> unrelated to that, but seems suspiciously coincidental that the
> backtrace shown reflects something I did (it looks related to printing
> conntracks). Still, you would know better than me what the kernel does
> when things go wrong.

I think I've got the problematic scenario: the master ct is released
while there are still user-space expectations. In that case, the
expectations still point to the master, once they've been released. Once
the expectations expire, we dereference to the master ct which is not
valid anymore.

I'll send a patch to fix this.
