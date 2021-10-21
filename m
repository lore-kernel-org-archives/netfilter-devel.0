Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 277C8C433F5
	for <netfilter-devel@archiver.kernel.org>; Thu, 21 Oct 2021 08:29:49 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 10B2361056
	for <netfilter-devel@archiver.kernel.org>; Thu, 21 Oct 2021 08:29:49 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231441AbhJUIcD (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 21 Oct 2021 04:32:03 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:55949 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231354AbhJUIcD (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 21 Oct 2021 04:32:03 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1634804987;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=qGTqBnaftPOf6RGLPy6Bce/HE6K78KPUFS2N4WcnNNs=;
        b=dl041NKlMTiWw1l1pTIvlB2PIJ+i0iph6Z1vqTFemh6kMM466VbwPP1zicO4DFniokvsoS
        vlRsCptG4csPNEh2oFsIlqKs9Rj4vgOdb5XWNcusr1O21cxCmh6PY1SWL40GHyWKaKJXKA
        UwLxtWLtS1w6LtWbBokKMEQdfAcVJQU=
Received: from mail-ed1-f71.google.com (mail-ed1-f71.google.com
 [209.85.208.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-403-_pke2ZaTOOWGsRvGPGluCw-1; Thu, 21 Oct 2021 04:29:45 -0400
X-MC-Unique: _pke2ZaTOOWGsRvGPGluCw-1
Received: by mail-ed1-f71.google.com with SMTP id d3-20020a056402516300b003db863a248eso23545843ede.16
        for <netfilter-devel@vger.kernel.org>; Thu, 21 Oct 2021 01:29:45 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references
         :user-agent:date:message-id:mime-version;
        bh=qGTqBnaftPOf6RGLPy6Bce/HE6K78KPUFS2N4WcnNNs=;
        b=QI3aC1/tz3xuuahE3smq7e07wkwBO+uvMTA/OVJU50aN5DJWsFXJUmIFBiASab8ScD
         n2SeLAxaGFsGyMJkwER5fr/MOfjAAuqtxo96uDG96RhXrJCTdwqi9J94aNBldvciwOGJ
         pSkpNMrQEKw8dqJQYL6mQlk0eOvFvUWFks64S2KT28BFQ1ZrVRiK2yEUa7yKsWAhEPRr
         B53pMGsTrHCtU7vQVKSUrYX02f2gELBmB63WAxex8ZSpLKT8inW2/V/vTHKoFLJ3dukV
         fHmzWe9hgLzcS5zwB1KYVFPeXji6AUcV+bd/TY2b23IYlmjTy5JGhzt3B2MMGgvXWzqv
         N1Pg==
X-Gm-Message-State: AOAM533mMNqrLwTs919bT+zK/L2ePl+crquCA8JerEpgE059c0bS909N
        MRGOPNEK4pik17piDOp9BDOUJzpzyIWuvymHB+bOHFwSQWwTF32S/ijw0i3juQNhvpyhA3ua14I
        +bV95uNDH1sDyuzsz40nJcLuLJQT0
X-Received: by 2002:a17:907:2d14:: with SMTP id gs20mr5426574ejc.415.1634804984125;
        Thu, 21 Oct 2021 01:29:44 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJzFUmV//6fbtA5VDBneFnsEFzesUcZRSAxWikbmGDmOShxFmDa4MbJXI20AmJ0tjGWEetV7nQ==
X-Received: by 2002:a17:907:2d14:: with SMTP id gs20mr5426554ejc.415.1634804983979;
        Thu, 21 Oct 2021 01:29:43 -0700 (PDT)
Received: from localhost ([185.112.167.53])
        by smtp.gmail.com with ESMTPSA id ay7sm2138614ejb.116.2021.10.21.01.29.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 21 Oct 2021 01:29:43 -0700 (PDT)
From:   =?utf-8?B?xaB0xJtww6FuIE7Em21lYw==?= <snemec@redhat.com>
To:     Phil Sutter <phil@nwl.cc>
Cc:     netfilter-devel@vger.kernel.org,
        Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH nft 1/3] tests: shell: README: copy edit
In-Reply-To: <20211020150402.GJ1668@orbyte.nwl.cc>
References: <20211020124512.490288-1-snemec@redhat.com>
 <20211020150402.GJ1668@orbyte.nwl.cc>
User-Agent: Notmuch/0.33.2 (https://notmuchmail.org) Emacs/29.0.50
 (x86_64-pc-linux-gnu)
Date:   Thu, 21 Oct 2021 10:30:25 +0200
Message-ID: <20211021103025+0200.945334-snemec@redhat.com>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="=-=-="
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

--=-=-=
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable

On Wed, 20 Oct 2021 17:04:02 +0200
Phil Sutter wrote:

> What you you mean with 'copy edit'?

https://en.wikipedia.org/wiki/Copy_editing

> Please make subject line a bit more comprehensible.

Would "fix language issues" work for you? Or, could we perhaps keep the
original subject, and add "fix language issues" in the body, to address
your other concern?

> Also, adding at least a single line of description is mandatory, even
> if the subject speaks for itself.

Commit messages consisting of only the subject and trailers (SOB et al.)
are quite common, both in this project and elsewhere. [1]

I suppose that as someone responsible for reviewing and applying
patches, you're free to install any hoops you see fit for contributors
to jump through, but if it is the project's and contributors' best
interest you have in mind, I think it would be better if you mentioned
the "description is always mandatory" rule explicitly in patch
submission guidelines [2] (providing a rationale and being consistent
about it in reality would be better still).

Thanks,
=20
  =C5=A0t=C4=9Bp=C3=A1n

[1] To get some picture, you can pipe output of the attached script to
'git log --stdin --no-walk', or further pipe that to 'git shortlog -ns'
for a summary.

[2] https://wiki.nftables.org/wiki-nftables/index.php/Portal:DeveloperDocs/=
Patch_submission_guidelines


--=-=-=
Content-Type: text/plain
Content-Disposition: inline; filename=git_log_filter.perl

#!/usr/bin/env perl

use strict;
use warnings;

my $log_cmd = "git log -z --pretty=format:'%H\n%b'";

local $/ = "\0";

open(my $log_fh, '-|', $log_cmd) or die "Can't start git log: $!";

while (<$log_fh>) {
  chomp;
  my ($hash, $body) = split(/\n/, $_, 2);
  print($hash, "\n") if ($body =~ /\A\s*(?:[^:\n]+: +[^\n]+\n?)*\s*\Z/);
}

--=-=-=--

