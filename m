From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH nf-next] netfilter: nf_tables: get rid of possible_net_t
 from set and basechain
Date: Fri, 8 Jul 2016 15:28:39 +0200
Message-ID: <20160708132839.GA31102@salvia>
References: <1467981709-23173-1-git-send-email-pablo@netfilter.org>
 <201607082158.JUJZEPlL%fengguang.wu@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: kbuild-all@01.org, netfilter-devel@vger.kernel.org
To: kbuild test robot <lkp@intel.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:48431 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754947AbcGHN2o (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 8 Jul 2016 09:28:44 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
	by mail.us.es (Postfix) with ESMTP id 423D91B6942
	for <netfilter-devel@vger.kernel.org>; Fri,  8 Jul 2016 15:28:43 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id 33F6F9EBB7
	for <netfilter-devel@vger.kernel.org>; Fri,  8 Jul 2016 15:28:43 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id E277FA827A
	for <netfilter-devel@vger.kernel.org>; Fri,  8 Jul 2016 15:28:40 +0200 (CEST)
Content-Disposition: inline
In-Reply-To: <201607082158.JUJZEPlL%fengguang.wu@intel.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Fri, Jul 08, 2016 at 09:19:24PM +0800, kbuild test robot wrote:
> Hi,
> 
> [auto build test ERROR on nf-next/master]
> 
> url:    https://github.com/0day-ci/linux/commits/Pablo-Neira-Ayuso/netfilter-nf_tables-get-rid-of-possible_net_t-from-set-and-basechain/20160708-204354
> base:   https://git.kernel.org/pub/scm/linux/kernel/git/pablo/nf-next.git master

This is a false positive, that is actually my fault because I forgot
to push a fresh tree that I was using as base to nf-next.git.

So this was compiling against the older tree that contained no nf.git
chunks.

Thanks.
