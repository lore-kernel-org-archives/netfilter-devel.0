From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [libnetfilter_conntrack PATCH 1/3] conntrack: add mark event
 filter
Date: Mon, 14 Apr 2014 14:53:24 +0200
Message-ID: <20140414125324.GA22192@localhost>
References: <20140408102614.GA29462@gmail.com>
 <20140408103002.GB29462@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Ken-ichirou MATSUZAWA <chamaken@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:47238 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753030AbaDNMxa (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 14 Apr 2014 08:53:30 -0400
Content-Disposition: inline
In-Reply-To: <20140408103002.GB29462@gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Tue, Apr 08, 2014 at 07:30:04PM +0900, Ken-ichirou MATSUZAWA wrote:
> This patch adds mark filter for event listener, using same struct
> nfct_filter_dump_mark.

OK, let's put this in the tree.
