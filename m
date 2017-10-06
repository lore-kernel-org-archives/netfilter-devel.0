From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH nft] tests: files: Remove old tests for chain rename.
Date: Fri, 6 Oct 2017 14:42:58 +0200
Message-ID: <20171006124258.GF4713@salvia>
References: <20171005080647.15713-1-rvarsha016@gmail.com>
 <20171005080647.15713-2-rvarsha016@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Varsha Rao <rvarsha016@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from ganesha.gnumonks.org ([213.95.27.120]:41696 "EHLO
        ganesha.gnumonks.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751807AbdJFMnF (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 6 Oct 2017 08:43:05 -0400
Content-Disposition: inline
In-Reply-To: <20171005080647.15713-2-rvarsha016@gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Thu, Oct 05, 2017 at 01:36:47PM +0530, Varsha Rao wrote:
> These tests are not required as new test cases are added in tests/shell
> file.

Also applied, thanks.

It would be great if you can go over those tests/files/ to get rid of
them. Just make a replacement that we can fit into tests/shell/

However, before doing so, you should have a look first that there is
no overlap with any existing test, we should avoid duplicates. I mean,
go over files under tests/shell/ and make sure what you add does not
exists already in the tree.

Thanks!
