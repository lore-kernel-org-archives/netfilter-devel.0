Return-Path: <SRS0=ffOv=3X=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8078CC35247
	for <netfilter-devel@archiver.kernel.org>; Mon,  3 Feb 2020 17:30:05 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 5289C2087E
	for <netfilter-devel@archiver.kernel.org>; Mon,  3 Feb 2020 17:30:05 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727230AbgBCRaF (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 3 Feb 2020 12:30:05 -0500
Received: from orbyte.nwl.cc ([151.80.46.58]:41904 "EHLO orbyte.nwl.cc"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727150AbgBCRaE (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 3 Feb 2020 12:30:04 -0500
Received: from n0-1 by orbyte.nwl.cc with local (Exim 4.91)
        (envelope-from <n0-1@orbyte.nwl.cc>)
        id 1iyfXv-0001FV-JI; Mon, 03 Feb 2020 18:30:03 +0100
Date:   Mon, 3 Feb 2020 18:30:03 +0100
From:   Phil Sutter <phil@nwl.cc>
To:     dyslexicatheist <dyslexicatheist@protonmail.com>
Cc:     "netfilter-devel@vger.kernel.org" <netfilter-devel@vger.kernel.org>
Subject: Re: invalid read in
Message-ID: <20200203173003.GF20229@orbyte.nwl.cc>
Mail-Followup-To: Phil Sutter <phil@nwl.cc>,
        dyslexicatheist <dyslexicatheist@protonmail.com>,
        "netfilter-devel@vger.kernel.org" <netfilter-devel@vger.kernel.org>
References: <gwRjoIGUgI5MEgxSob7CBSUwPbYkxILRc4_ZrYWYNI7d1-T5Ej95p3XkEY_f9hLqHK5nVun7dk6RqObi0c_4482IJ6s6U33PyS6Hrm4z46E=@protonmail.com>
 <20200203163152.GY19873@orbyte.nwl.cc>
 <7BnNOPQw33ulxkwoWPovsrpwB_JPbS5nJhaTevbPCUkPRxObOpyrmqo3pFe_h82tov85DMfE1cYdX1xX3xhHNLbTef3XXmkqU26_ulUKpfY=@protonmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <7BnNOPQw33ulxkwoWPovsrpwB_JPbS5nJhaTevbPCUkPRxObOpyrmqo3pFe_h82tov85DMfE1cYdX1xX3xhHNLbTef3XXmkqU26_ulUKpfY=@protonmail.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Hi,

On Mon, Feb 03, 2020 at 05:14:45PM +0000, dyslexicatheist wrote:
> On Monday, February 3, 2020 4:31 PM, Phil Sutter <phil@nwl.cc> wrote:
> > On Mon, Feb 03, 2020 at 01:54:31PM +0000, dyslexicatheist wrote:
> >
> > I guess this is the typical "problem" situation in which userspace uses
> > a non-zeroed buffer to feed into sendto() and due to padding not
> > every byte was written to. So basically userspace "leaks" garbage to
> > kernel, which is something I'd consider harmless and merely a minor
> > inconvenience when analyzing with valgrind. I usually suffer from this
> > as well since libmnl()'s allocation routines don't zero the buffer
> > either.
> >
> > In your case, I'd say the error message disappears if you add
> > 'memset(&u, 0, sizeof(u))' to the beginning of nfq_set_mode().
> 
> thanks for your help Phil. I have just tried this but unfortunately it didn't change the outcome. Also tried other variations such as memset'ing both &u and the &params struct, but nada.

Maybe you need to apply the same to __build_send_cfg_msg() as well?

Cheers, Phil
