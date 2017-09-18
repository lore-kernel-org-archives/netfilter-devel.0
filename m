From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH 0/4] ipset patches for nf-next
Date: Mon, 18 Sep 2017 14:30:52 +0200
Message-ID: <20170918123052.GA28702@salvia>
References: <1505159560-13161-1-git-send-email-kadlec@blackhole.kfki.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from ganesha.gnumonks.org ([213.95.27.120]:34559 "EHLO
        ganesha.gnumonks.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932114AbdIRMa7 (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 18 Sep 2017 08:30:59 -0400
Content-Disposition: inline
In-Reply-To: <1505159560-13161-1-git-send-email-kadlec@blackhole.kfki.hu>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hi Jozsef,

On Mon, Sep 11, 2017 at 09:52:36PM +0200, Jozsef Kadlecsik wrote:
> Hi Pablo,
> 
> Here follows a few ipset patches for the nf-next tree:
> 
> * Merge assignment and simplify return in a fuction by Simran Singhal
> * Fix a sparse warning from me
> * Deduplicate prefixlen maps by Aaron Conole
> * Fix the outdated element counter for sets with timeout by Vishwanath Pai

Let me take 4/4 to nf.git as a fix, so we don't wait for one month for
this to show up.

I will take from 1/4 to 3/4 to nf-next. You can either send me a new
pull request for this or I can just include your Signed-off-by: tag in
those patches when applying them.

Thanks!
