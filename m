From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH 4/4] netfilter: ipset: ipset list may return wrong member
 count for set with timeout
Date: Mon, 18 Sep 2017 17:35:09 +0200
Message-ID: <20170918153509.GA2177@salvia>
References: <1505159560-13161-1-git-send-email-kadlec@blackhole.kfki.hu>
 <1505159560-13161-5-git-send-email-kadlec@blackhole.kfki.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from ganesha.gnumonks.org ([213.95.27.120]:35932 "EHLO
        ganesha.gnumonks.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752921AbdIRPfN (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 18 Sep 2017 11:35:13 -0400
Content-Disposition: inline
In-Reply-To: <1505159560-13161-5-git-send-email-kadlec@blackhole.kfki.hu>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Mon, Sep 11, 2017 at 09:52:40PM +0200, Jozsef Kadlecsik wrote:
> From: Vishwanath Pai <vpai@akamai.com>
> 
> Simple testcase:
> 
> $ ipset create test hash:ip timeout 5
> $ ipset add test 1.2.3.4
> $ ipset add test 1.2.2.2
> $ sleep 5
> 
> $ ipset l
> Name: test
> Type: hash:ip
> Revision: 5
> Header: family inet hashsize 1024 maxelem 65536 timeout 5
> Size in memory: 296
> References: 0
> Number of entries: 2
> Members:
> 
> We return "Number of entries: 2" but no members are listed. That is
> because mtype_list runs "ip_set_timeout_expired" and does not list the
> expired entries, but set->elements is never upated (until mtype_gc
> cleans it up later).

Applied to nf.git. Thanks Jozsef.
