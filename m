From: Eric Leblond <eric@regit.org>
Subject: Re: [nft PATCH 0/16] introduce libnftables
Date: Thu, 17 Aug 2017 10:58:38 +0200
Message-ID: <1502960318.31564.1.camel@regit.org>
References: <20170816204310.3371-1-eric@regit.org>
         <CAOkSjBg8L7QQ2WapAoX_erz4pDm3+q9460w8qnrzgPMPouFL1A@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
Cc: Pablo Neira Ayuso <pablo@netfilter.org>,
        Netfilter Development Mailing list
        <netfilter-devel@vger.kernel.org>
To: Arturo Borrero Gonzalez <arturo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from home.regit.org ([37.187.126.138]:47670 "EHLO home.regit.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752165AbdHQI6l (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 17 Aug 2017 04:58:41 -0400
In-Reply-To: <CAOkSjBg8L7QQ2WapAoX_erz4pDm3+q9460w8qnrzgPMPouFL1A@mail.gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hi,

On Thu, 2017-08-17 at 10:32 +0200, Arturo Borrero Gonzalez wrote:
> On 16 August 2017 at 22:42, Eric Leblond <eric@regit.org> wrote:
> > 
> > Hello,
> > 
> > This patchset adds a basi high level libnftables to nftables code.
> > It is currently supporting running a command from a buffer or from
> > a file as well as batch support allowing to chain commands and
> > commit
> > them at once.
> > 
> > The API is mostly using existing structures such as nft_ctx that
> > are
> > updated to contain enough information. It also adds a structure
> > dedicated to batch.
> > 
> 
> Great work Eric, thanks!
> 
> Some comments below.
> 
> > A simple program running a command is the following:
> > 
> >         nft_global_init();
> >         nft = nft_context_new();
> >         nft_context_set_print_func(nft, my_print, buf);
> 
> ^^^
> A minor thing: Did you evaluate merging these two? Setting the print
> function directly when allocating a new context.

Nope but could make sense.

> 
> 
> >         rc = nft_run_command_from_buffer(nft, CMD, sizeof(CMD));
> >         if (rc != NFT_EXIT_SUCCESS) {
> >                 nft_get_error(nft, err_buf, sizeof(err_buf));
> >                 printf("%s\n", err_buf);
> >                 return -1;
> >         }
> >         nft_context_free(nft);
> >         nft_global_deinit();
> > 
> > Transaction support is similar with:
> > 
> >         nft = nft_context_new();
> >         batch = nft_batch_start(nft);
> >         if (nft_batch_add(nft, batch, ADD1, strlen(ADD1)) !=0) {
> >                 printf("FAIL add 1\n");
> >                 goto out;
> >         }
> >         if (nft_batch_add(nft, batch, ADD2, strlen(ADD2)) !=0) {
> >                 printf("FAIL add 2\n");
> >                 goto out;
> >         }
> >         if (nft_batch_commit(nft, batch) != 0) {
> 
> ^^^
> error handling here is like in the other case? i.e. running
> nft_get_error() ?

Yes exactly. It is supposed to do so but it seems I wrote the commit
function wrong. I'm gonna send an updated patchset.

> 
> >                 goto out;
> >         }
> > 
> > out:
> >         nft_batch_free(batch);
> >         nft_context_free(nft);
> >         nft_global_deinit();
> > 
> > The library provides a way to get standard output via
> > nft_context_set_print_func
> > and error handling is done via nft_get_error that get error message
> > in a buffer.
> > 
> > This is early stage code as it does not feature things like set
> > handling but IMO
> > it can already be used as a starting point to build more things.
> > 
> 
> Any special challenge with sets?

This is in the list of things that are yet to be developed.

> On a side note, I remember in NFWS 2017 we discussed the possibility
> of libnftables being a separate source project, i.e a standalone
> repository.
> Now that I see your patches, what I see is that libnftables is mostly
> all the code, while nft itself is very little code.
> Still, with my Debian hat, I think that different repositories is
> good to have.

I don't like the cascade idea with nftables -> libnftables -> libnftnl
-> libmnl that this will induce. Also this means some potential
breakage in versionning.

> One more comment: perhaps is good idea to release nftables v0.8
> before
> introducing this code into the repository. We may end not releasing
> nftables in quite a long time.

Fully agree on that, this was a point I forgot to mention in my initial
mail.

++
-- 
Eric Leblond <eric@regit.org>
Blog: https://home.regit.org/
