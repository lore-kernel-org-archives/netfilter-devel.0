From: Patrick McHardy <kaber@trash.net>
Subject: Re: [PATCH 09/15] netfilter: ipset: Take into account cidr value
 for the from address when creating the set
Date: Thu, 16 Jun 2011 18:55:16 +0200
Message-ID: <4DFA3574.6080105@trash.net>
References: <1307465780-28980-1-git-send-email-kadlec@blackhole.kfki.hu> <1307465780-28980-2-git-send-email-kadlec@blackhole.kfki.hu> <1307465780-28980-3-git-send-email-kadlec@blackhole.kfki.hu> <1307465780-28980-4-git-send-email-kadlec@blackhole.kfki.hu> <1307465780-28980-5-git-send-email-kadlec@blackhole.kfki.hu> <1307465780-28980-6-git-send-email-kadlec@blackhole.kfki.hu> <1307465780-28980-7-git-send-email-kadlec@blackhole.kfki.hu> <1307465780-28980-8-git-send-email-kadlec@blackhole.kfki.hu> <1307465780-28980-9-git-send-email-kadlec@blackhole.kfki.hu> <1307465780-28980-10-git-send-email-kadlec@blackhole.kfki.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@vger.kernel.org,
	Pablo Neira Ayuso <pablo@netfilter.org>
To: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:61681 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932090Ab1FPQzR (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 16 Jun 2011 12:55:17 -0400
In-Reply-To: <1307465780-28980-10-git-send-email-kadlec@blackhole.kfki.hu>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On 07.06.2011 18:56, Jozsef Kadlecsik wrote:
> When creating a set from a range expressed as a network like
> 10.1.1.172/29, the from address was taken as the IP address part and
> not masked with the netmask from the cidr.

Applied.
