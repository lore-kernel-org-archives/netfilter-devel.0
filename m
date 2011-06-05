From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH 00/20] netfilter updates for 3.0.0-rc1
Date: Mon, 06 Jun 2011 01:23:46 +0200
Message-ID: <4DEC1002.7070708@netfilter.org>
References: <1307315350-17782-1-git-send-email-pablo@netfilter.org> <20110605.161505.1477780372925642508.davem@davemloft.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@vger.kernel.org
To: David Miller <davem@davemloft.net>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:39280 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756514Ab1FEXX7 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Sun, 5 Jun 2011 19:23:59 -0400
In-Reply-To: <20110605.161505.1477780372925642508.davem@davemloft.net>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On 06/06/11 01:15, David Miller wrote:
> From: pablo@netfilter.org
> Date: Mon,  6 Jun 2011 01:08:51 +0200
> 
>> the following patches contain Netfilter updates for 3.0.0-rc1
>> The highlights are:
> 
> Are these bug fixes only or do we have new features in here?
> 
> If new features, then this stuff should be targeted for 3.1
> (ie. net-next-2.6) not 3.0.0-rc1

There are a couple of new features in this batch, sorry.

I'll remake this batch to only include fixes for 3.0.0-rc1 only.

BTW, when does 3.1 (net-next-2.6) becomes closed for new features?
