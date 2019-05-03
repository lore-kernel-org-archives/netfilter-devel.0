Return-Path: <SRS0=n11Q=TD=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,USER_AGENT_NEOMUTT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 09442C43219
	for <netfilter-devel@archiver.kernel.org>; Fri,  3 May 2019 17:20:54 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id CD9152075C
	for <netfilter-devel@archiver.kernel.org>; Fri,  3 May 2019 17:20:53 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727818AbfECRUx (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Fri, 3 May 2019 13:20:53 -0400
Received: from mx1.redhat.com ([209.132.183.28]:50948 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726724AbfECRUx (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 3 May 2019 13:20:53 -0400
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id ED126C05681F;
        Fri,  3 May 2019 17:20:52 +0000 (UTC)
Received: from egarver.localdomain (ovpn-122-125.rdu2.redhat.com [10.10.122.125])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 2825016582;
        Fri,  3 May 2019 17:20:49 +0000 (UTC)
Date:   Fri, 3 May 2019 13:20:47 -0400
From:   Eric Garver <eric@garver.life>
To:     Phil Sutter <phil@nwl.cc>, netfilter-devel@vger.kernel.org
Subject: Re: [PATCH nft] py: fix missing decode/encode of strings
Message-ID: <20190503172047.n33zwid642x63pdn@egarver.localdomain>
Mail-Followup-To: Eric Garver <eric@garver.life>, Phil Sutter <phil@nwl.cc>,
        netfilter-devel@vger.kernel.org
References: <20190501163500.29662-1-eric@garver.life>
 <20190503155154.GM31599@orbyte.nwl.cc>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20190503155154.GM31599@orbyte.nwl.cc>
User-Agent: NeoMutt/20180716
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.32]); Fri, 03 May 2019 17:20:53 +0000 (UTC)
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Fri, May 03, 2019 at 05:51:54PM +0200, Phil Sutter wrote:
> Hi,
> 
> On Wed, May 01, 2019 at 12:35:00PM -0400, Eric Garver wrote:
> > When calling ffi functions we need to convert from python strings to
> > utf-8. Then convert back for any output we receive.
> 
> So the problem is passing utf-8 encoded strings as command?

In python3 strings are unicode. But we need "bytes" when calling the
ctypes function since it's imported with "c_char_p". This is what
encode() is doing for us.

    https://docs.python.org/3/library/ctypes.html#fundamental-data-types

In python2 strings are a sequence of bytes already. I'll have to v2 to
if we care about python2 support.

> 
> [...]
> > -        rc = self.nft_run_cmd_from_buffer(self.__ctx, cmdline)
> > -        output = self.nft_ctx_get_output_buffer(self.__ctx)
> > -        error = self.nft_ctx_get_error_buffer(self.__ctx)
> > +        rc = self.nft_run_cmd_from_buffer(self.__ctx, cmdline.encode("utf-8"))
> > +        output = self.nft_ctx_get_output_buffer(self.__ctx).decode("utf-8")
> > +        error = self.nft_ctx_get_error_buffer(self.__ctx).decode("utf-8")
> 
> Should the encoding be made configurable? I see encode() and decode()
> parameters are optional, but as soon as I call them with a string
> containing umlauts I get errors. So not sure if that would be an
> alternative.

I don't think so. Since we're calling system level stuff (nftables,
kernel) I think utf-8 is what we want.

Encoding with utf-8 does the right thing:

python3:

    >>> "ö".encode("utf-8")
    >>> b'\xc3\xb6'

python2:

    >>> u"ö".encode("utf-8")
    >>> '\xc3\xb6'
