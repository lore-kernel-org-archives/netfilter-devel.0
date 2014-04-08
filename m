From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [nftables PATCH] src: rule: Fix list of set: Add a forgotten
 'return'
Date: Tue, 8 Apr 2014 09:35:02 +0200
Message-ID: <20140408073502.GA3700@localhost>
References: <bf9127aa386c8ca027215124fc1540f4f8ab9797.1396941336.git.anarey@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Ana Rey <anarey@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:42467 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756220AbaDHHfH (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 8 Apr 2014 03:35:07 -0400
Content-Disposition: inline
In-Reply-To: <bf9127aa386c8ca027215124fc1540f4f8ab9797.1396941336.git.anarey@gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Tue, Apr 08, 2014 at 09:19:27AM +0200, Ana Rey wrote:
> Add a return forgotten.

I prefer if you include in the patch description the important facts:

* This patch fixes a crash since this iterates over the temporary
  context list a bit below on that code to handle table and chains
  (that we don't have in this case).

* Something descriptive on how this happens, eg.

  % nft list sets
  Segmentation fault

Or even better:

  % valgrind nft list sets
  ...
  valgrind report goes here.
  ...

Please, also rework the title:

src: rule: Fix list of set: Add a forgotten 'return'

something much more simple like:

rule: fix crash in set listing

should be fine.
