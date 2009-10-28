From: Patrick McHardy <kaber@trash.net>
Subject: Re: resend your pending patches, please
Date: Wed, 28 Oct 2009 16:44:57 +0100
Message-ID: <4AE866F9.5040503@trash.net>
References: <4AE6FD76.40705@netfilter.org> <4AE6FDB5.4060500@netfilter.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Cc: Netfilter Development Mailinglist
	<netfilter-devel@vger.kernel.org>,
	Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>, jkosina@suse.cz,
	"David S. Miller" <davem@davemloft.net>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:60351 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754037AbZJ1PzI (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 28 Oct 2009 11:55:08 -0400
In-Reply-To: <4AE6FDB5.4060500@netfilter.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Pablo Neira Ayuso wrote:
> Pablo Neira Ayuso wrote:
>> Hi all,
>>
>> While Patrick is recovering, I'll temporarily do the netfilter/iptables
>> kernel-space maintainance. While spinning on the mailing list, I have
>> found two pending patches that can be qualified as bugfixes:
>>
>> [PATCH] netfilter: remove CONFIG_NF_CT_ACCT from Jiri Kosina
>> [PATCH] netfilter: nf_nat: fix NAT issue in 2.6.30.4+
>>
>> If I'm missing any other patch, please let me know.
>>
>> Once this bugfix round is done, I'll look at net-next-2.6 patches. I
>> have seen one patchset from Jan Engelhardt so far.
> 
> I forgot to say that I have set a couple of git trees at:
> 
> http://1984.lsi.us.es/git/

Thanks for taking care of this.

I'm working through my backlog, I'll simply start pickup all patches
that are not in your tree yet, unless you want me to submit those as
well.
