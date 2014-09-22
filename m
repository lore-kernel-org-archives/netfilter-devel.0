From: Patrick McHardy <kaber@trash.net>
Subject: Re: [nft PATCH 3/4] datatype: add symbolic_constant_parse_table()
Date: Mon, 22 Sep 2014 09:59:02 +0200
Message-ID: <20140922075902.GJ4971@acer.localdomain>
References: <1411327957-19379-1-git-send-email-alvaroneay@gmail.com>
 <1411327957-19379-3-git-send-email-alvaroneay@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Alvaro Neira Ayuso <alvaroneay@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:35521 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751068AbaIVH7G (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 22 Sep 2014 03:59:06 -0400
Content-Disposition: inline
In-Reply-To: <1411327957-19379-3-git-send-email-alvaroneay@gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Sun, Sep 21, 2014 at 09:32:36PM +0200, Alvaro Neira Ayuso wrote:
> This function finds the symbol inside the table that you pass as parameter.
> If the symbol doesn't exist we use the basetype to parse it and
> symbolic_constant_parse().

I'm thinking that we should probably do this in all cases and not
specific to mark and ICMP types. At least I can't see a reason not
to.
