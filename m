From: Wolfgang Bumiller <w.bumiller@proxmox.com>
Subject: Re: [PATCH nf] netfilter: nft_set_rbtree: handle re-addition element
 after deletion
Date: Mon, 22 May 2017 08:52:32 +0200
Message-ID: <20170522065232.msjhklsynbdjyrjn@olga.proxmox.com>
References: <1495405050-2332-1-git-send-email-pablo@netfilter.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from proxmox.maurer-it.com ([212.186.127.180]:36941 "EHLO
        proxmox.maurer-it.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751212AbdEVHAR (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 22 May 2017 03:00:17 -0400
Content-Disposition: inline
In-Reply-To: <1495405050-2332-1-git-send-email-pablo@netfilter.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Mon, May 22, 2017 at 12:17:30AM +0200, Pablo Neira Ayuso wrote:
> The existing code selects no next branch to be inspected when
> re-inserting an inactive element into the rb-tree, looping endlessly.
> This patch restricts the check for active elements to the EEXIST case
> only.
> 
> Fixes: e701001e7cbe ("netfilter: nft_rbtree: allow adjacent intervals with dynamic updates")
> Reported-by: Wolfgang Bumiller <w.bumiller@proxmox.com>
> Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>

I can confirm that this fixes the issue for me.

Thanks.

