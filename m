From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [nft PATCH] tests: shell: allow to execute a single testcase
Date: Thu, 24 Nov 2016 13:01:56 +0100
Message-ID: <20161124120156.GA16178@salvia>
References: <147930071248.11586.102674356702325099.stgit@nfdev2.cica.es>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:54448 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S936501AbcKXMCB (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 24 Nov 2016 07:02:01 -0500
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 172B41B7F80
        for <netfilter-devel@vger.kernel.org>; Thu, 24 Nov 2016 13:02:00 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 06ADCA0FCC
        for <netfilter-devel@vger.kernel.org>; Thu, 24 Nov 2016 13:02:00 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id E7237A7BD8
        for <netfilter-devel@vger.kernel.org>; Thu, 24 Nov 2016 13:01:57 +0100 (CET)
Content-Disposition: inline
In-Reply-To: <147930071248.11586.102674356702325099.stgit@nfdev2.cica.es>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Wed, Nov 16, 2016 at 01:51:52PM +0100, Arturo Borrero Gonzalez wrote:
> From: Arturo Borrero Gonzalez <arturo@debian.org>
> 
> Using, for example:
>  % sudo ./run-tests.sh testcase/mytest_0
> 
> Will result in an execution of this single testcase rather than
> the complete suite.
> 
> This is useful while working with a concrete testcase.

Applied, thanks Arturo.
