Return-Path: <SRS0=cPjr=73=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C0A4AC433DF
	for <netfilter-devel@archiver.kernel.org>; Sun, 14 Jun 2020 22:46:44 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 96EE1206D7
	for <netfilter-devel@archiver.kernel.org>; Sun, 14 Jun 2020 22:46:44 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="VI8xu1lr"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727951AbgFNWqo (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Sun, 14 Jun 2020 18:46:44 -0400
Received: from us-smtp-1.mimecast.com ([205.139.110.61]:57463 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1727928AbgFNWqo (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Sun, 14 Jun 2020 18:46:44 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1592174802;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=VZ+xxFwO/qBmW1EfLSMuYMLQkglP30JZAbnMQ8/Ua1Y=;
        b=VI8xu1lrqwhJD2a9gfAwXhHZ4ELnM6NAaFMPq+kAYLn/Q2jP8bZF22n3Y9GGd9HunCLI31
        AyvrYcWEk7qfGWmb9ZIkpXRGaT4K6BFnrBkdhpM8X+IN5MrpEo04ycMrzTY7PgPiNlxgjM
        bZPBLKRmJZRc951U067/FOgnbiz8Xww=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-424-aLMFDozpMgOZuaVuZth6cA-1; Sun, 14 Jun 2020 18:46:38 -0400
X-MC-Unique: aLMFDozpMgOZuaVuZth6cA-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 9FDE21883609;
        Sun, 14 Jun 2020 22:46:37 +0000 (UTC)
Received: from localhost (unknown [10.36.110.3])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 62DFB7CAA4;
        Sun, 14 Jun 2020 22:46:36 +0000 (UTC)
Date:   Mon, 15 Jun 2020 00:46:30 +0200
From:   Stefano Brivio <sbrivio@redhat.com>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     Phil Sutter <phil@nwl.cc>, netfilter-devel@vger.kernel.org
Subject: Re: [PATCH nft] tests: Run in separate network namespace, don't
 break connectivity
Message-ID: <20200615004630.597c9752@redhat.com>
In-Reply-To: <20200614220309.GA9310@salvia>
References: <8efb5334f8b4df21b8833e576abd5721486c0182.1592170411.git.sbrivio@redhat.com>
        <20200614220309.GA9310@salvia>
Organization: Red Hat
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Mon, 15 Jun 2020 00:03:09 +0200
Pablo Neira Ayuso <pablo@netfilter.org> wrote:

> On Sun, Jun 14, 2020 at 11:41:57PM +0200, Stefano Brivio wrote:
> > It might be convenient to run tests from a development branch that
> > resides on another host, and if we break connectivity on the test
> > host as tests are executed, we can't run them this way.
> > 
> > If kernel implementation (CONFIG_NET_NS), unshare(1), or Python
> > bindings for unshare() are not available, warn and continue.
> > 
> > Suggested-by: Phil Sutter <phil@nwl.cc>
> > Signed-off-by: Stefano Brivio <sbrivio@redhat.com>
> > ---
> >  tests/py/nft-test.py     | 6 ++++++
> >  tests/shell/run-tests.sh | 9 +++++++++
> >  2 files changed, 15 insertions(+)
> > 
> > diff --git a/tests/py/nft-test.py b/tests/py/nft-test.py
> > index 01ee6c980ad4..df97ed8eefb7 100755
> > --- a/tests/py/nft-test.py
> > +++ b/tests/py/nft-test.py
> > @@ -1394,6 +1394,12 @@ def main():
> >      # Change working directory to repository root
> >      os.chdir(TESTS_PATH + "/../..")
> >  
> > +    try:
> > +        import unshare
> > +        unshare.unshare(unshare.CLONE_NEWNET)
> > +    except:
> > +        print_warning("cannot run in own namespace, connectivity might break")
> > +  
> 
> In iptables-tests.py, there is an option for this:
> 
>         parser.add_argument('-N', '--netns', action='store_true',
>                             help='Test netnamespace path')
> 
> Is it worth keeping this in sync with it?

I'm not sure: keeping it in sync would mean that's not the default,
which might result in significant frustration. By the way,
iptables/tests/shell/run-tests.sh just calls unshare -n, instead.

In the past, I guess the --netns flag led to noise and a number of new
errors being found, but nowadays that part should be quite robust and I
don't see the noise.

I think that today the added benefit of an explicit option would come
from the fact that one can check what happened, on failure, on a
single test run, by checking rulesets in the init namespace afterwards.

However, the clean-up strategy is a bit inconsistent right now,
especially with the Python tests: after running some of them as single
runs you might still have a number of chains while rules are deleted --
so I think we should fix that before a flag becomes useful in this
sense.

That could also be achieved by running in a namespace with a known
name, which would need either a patch in the Python bindings here:
	https://github.com/shubham1172/unshare/blob/3e3cc4cd5128976a56601eb5764741fec9c242f8/unshare.c#L26

or wrapping commands with 'ip netns exec' as iptables-tests.py does.

If we do that, I guess we should also introduce a pause-on-fail
mechanism, cf.:
	https://lore.kernel.org/netfilter-devel/20191206101549.4b05f74a@elisabeth/

All in all, from a functionality perspective, I don't think we're
losing anything with this patch -- if you ask me, I'd rather keep this
to avoid the current annoyance, make an explicit option usable in the
future, and then implement the option.

-- 
Stefano

