From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH] iptables: make 'iptables-save -M' actually work
Date: Wed, 12 Mar 2014 14:50:38 +0100
Message-ID: <20140312135038.GA31353@localhost>
References: <1394630169-21124-1-git-send-email-jpopelka@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Jiri Popelka <jpopelka@redhat.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:53795 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753475AbaCLNun (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 12 Mar 2014 09:50:43 -0400
Content-Disposition: inline
In-Reply-To: <1394630169-21124-1-git-send-email-jpopelka@redhat.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Wed, Mar 12, 2014 at 02:16:09PM +0100, Jiri Popelka wrote:
> also add missing bracket in iptables-save(8)

Please, put this in a separated patch.

Could you also fix this in the nftables compat layer, please? See
iptables/xtables-save.c.

Most likely you'll need to define a struct xtables_afinfo for IPv4 and
IPv6 to set the .kmod field that points to nf_tables_ipv4 and
nf_tables_ipv6 respectively. Similar to what we use in
xtables-arp-standalone.c, and skip xtables_set_nfproto of course. This
is currently broken there.

Thanks.
