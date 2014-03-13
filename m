From: Jiri Popelka <jpopelka@redhat.com>
Subject: Re: [PATCH] iptables: make 'iptables-save -M' actually work
Date: Thu, 13 Mar 2014 17:05:19 +0100
Message-ID: <5321D73F.9020705@redhat.com>
References: <1394630169-21124-1-git-send-email-jpopelka@redhat.com> <20140312135038.GA31353@localhost>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Pablo Neira Ayuso <pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:53634 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752289AbaCMQF0 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 13 Mar 2014 12:05:26 -0400
In-Reply-To: <20140312135038.GA31353@localhost>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On 03/12/2014 02:50 PM, Pablo Neira Ayuso wrote:
> Could you also fix this in the nftables compat layer, please? See
> iptables/xtables-save.c.

done, I've sent a patch

> Most likely you'll need to define a struct xtables_afinfo for IPv4 and
> IPv6 to set the .kmod field that points to nf_tables_ipv4 and
> nf_tables_ipv6 respectively. Similar to what we use in
> xtables-arp-standalone.c, and skip xtables_set_nfproto of course. This
> is currently broken there.

I'm sorry I have no idea where to start. Could you do that ?

--
Jiri
