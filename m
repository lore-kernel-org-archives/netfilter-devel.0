From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH nft 0/9] tests: Move tests from files to shell.
Date: Wed, 11 Oct 2017 11:57:08 +0200
Message-ID: <20171011095708.GB1678@salvia>
References: <cover.1507696149.git.rvarsha016@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Varsha Rao <rvarsha016@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from ganesha.gnumonks.org ([213.95.27.120]:60737 "EHLO
        ganesha.gnumonks.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752686AbdJKJ5M (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 11 Oct 2017 05:57:12 -0400
Content-Disposition: inline
In-Reply-To: <cover.1507696149.git.rvarsha016@gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hi Varsha,

On Wed, Oct 11, 2017 at 10:03:56AM +0530, Varsha Rao wrote:
> Test files of tests/files/ are moved to tests/shell.

We have more than 100 tests these days, could you have a look at the
repository to see if this is adding redundant tests for what we have?
If we already have a test covering the same configuration, we should
just remove them from tests/files/.

Thanks.
