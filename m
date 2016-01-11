From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH net-next v6 0/7] openvswitch: NAT support.
Date: Mon, 11 Jan 2016 19:50:33 +0100
Message-ID: <20160111185033.GA15660@salvia>
References: <1452277800-46541-1-git-send-email-jarno@ovn.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netdev@vger.kernel.org, netfilter-devel@vger.kernel.org,
	dev@openvswitch.org, David Miller <davem@davemloft.net>
To: Jarno Rajahalme <jarno@ovn.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:50822 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759660AbcAKSuj (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 11 Jan 2016 13:50:39 -0500
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
	by mail.us.es (Postfix) with ESMTP id F0C88E3A05
	for <netfilter-devel@vger.kernel.org>; Mon, 11 Jan 2016 19:50:36 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id D802ADA86B
	for <netfilter-devel@vger.kernel.org>; Mon, 11 Jan 2016 19:50:36 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id 92140DA808
	for <netfilter-devel@vger.kernel.org>; Mon, 11 Jan 2016 19:50:34 +0100 (CET)
Content-Disposition: inline
In-Reply-To: <1452277800-46541-1-git-send-email-jarno@ovn.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hi Jarno,

On Fri, Jan 08, 2016 at 10:29:53AM -0800, Jarno Rajahalme wrote:
> This series adds NAT support to openvswitch kernel module.  A few
> changes are needed to the netfilter code to facilitate this (patches
> 1-2/8).  Patches 3-6 make the openvswitch kernel module ready for the
> patch 7 that adds the NAT support by calling into netfilter NAT code
> from the openvswitch conntrack action.

I received this batch just a bit later by when I already submitted my
last netfilter batch to David.

I can integrate this into the nf-next tree once the David re-opens his
merge window.

@David, let me know if you prefer an alternate path.

Thanks.
