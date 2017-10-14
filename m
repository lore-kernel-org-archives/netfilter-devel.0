From: Varsha Rao <rvarsha016@gmail.com>
Subject: Re: [PATCH nft 0/9] tests: Move tests from files to shell.
Date: Sat, 14 Oct 2017 18:34:28 +0530
Message-ID: <CAAFX7JTjwwp+pCLW6MtD6nVuq7wA4-EZVssGvEO3QOkxBnXNOQ@mail.gmail.com>
References: <cover.1507696149.git.rvarsha016@gmail.com> <20171011095708.GB1678@salvia>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Cc: netfilter-devel@vger.kernel.org
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-it0-f52.google.com ([209.85.214.52]:49791 "EHLO
        mail-it0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751550AbdJNNFJ (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Sat, 14 Oct 2017 09:05:09 -0400
Received: by mail-it0-f52.google.com with SMTP id y15so14259981ita.4
        for <netfilter-devel@vger.kernel.org>; Sat, 14 Oct 2017 06:05:09 -0700 (PDT)
In-Reply-To: <20171011095708.GB1678@salvia>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hello Pablo,

On Wed, Oct 11, 2017 at 3:27 PM, Pablo Neira Ayuso <pablo@netfilter.org> wrote:
> Hi Varsha,
>
> On Wed, Oct 11, 2017 at 10:03:56AM +0530, Varsha Rao wrote:
>> Test files of tests/files/ are moved to tests/shell.
>
> We have more than 100 tests these days, could you have a look at the
> repository to see if this is adding redundant tests for what we have?
> If we already have a test covering the same configuration, we should
> just remove them from tests/files/.
>
Sorry, the cover letter title and commit message looks misleading.
But I have removed the redundant ones and added tests which were
not there.

Thanks,
Varsha
