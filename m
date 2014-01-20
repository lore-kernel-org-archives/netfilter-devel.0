From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [HEADS UP] libnftables renamed to libnftnl
Date: Mon, 20 Jan 2014 13:19:35 +0100
Message-ID: <20140120121935.GA2794@localhost>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: netfilter-devel@vger.kernel.org, netfilter@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:53603 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750721AbaATMTr (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 20 Jan 2014 07:19:47 -0500
Content-Disposition: inline
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hi,

We have renamed libnftables to libnfnl to reserve this name for the
higher layer library API.

Please, update your git/.config files to point to the new repository.
Thanks.
