From: Patrick McHardy <kaber@trash.net>
Subject: Re: [PATCH 01/15] netfilter: ipset: Timeout can be modified for already
 added elements
Date: Thu, 16 Jun 2011 18:41:39 +0200
Message-ID: <4DFA3243.5070709@trash.net>
References: <1307465780-28980-1-git-send-email-kadlec@blackhole.kfki.hu> <1307465780-28980-2-git-send-email-kadlec@blackhole.kfki.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@vger.kernel.org,
	Pablo Neira Ayuso <pablo@netfilter.org>
To: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:61327 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751695Ab1FPQln (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 16 Jun 2011 12:41:43 -0400
In-Reply-To: <1307465780-28980-2-git-send-email-kadlec@blackhole.kfki.hu>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On 07.06.2011 18:56, Jozsef Kadlecsik wrote:
> When an element to a set with timeout added, one can change the timeout
> by "readding" the element with the "-exist" flag. That means the timeout
> value is reset to the specified one (or to the default from the set
> specification if the "timeout n" option is not used). Example
> 
> ipset add foo 1.2.3.4 timeout 10
> ipset add foo 1.2.3.4 timeout 600 -exist

Applied, thanks.
