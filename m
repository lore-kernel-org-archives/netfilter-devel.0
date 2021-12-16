Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8A350C433EF
	for <netfilter-devel@archiver.kernel.org>; Thu, 16 Dec 2021 12:26:21 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236830AbhLPM0U (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 16 Dec 2021 07:26:20 -0500
Received: from mail.netfilter.org ([217.70.188.207]:58048 "EHLO
        mail.netfilter.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236816AbhLPM0Q (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 16 Dec 2021 07:26:16 -0500
Received: from netfilter.org (unknown [78.30.32.163])
        by mail.netfilter.org (Postfix) with ESMTPSA id 113A4625D0
        for <netfilter-devel@vger.kernel.org>; Thu, 16 Dec 2021 13:23:46 +0100 (CET)
Date:   Thu, 16 Dec 2021 13:26:10 +0100
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Netfilter Development <netfilter-devel@vger.kernel.org>
Subject: Re: [PATCH libnetfilter_queue] build: doc: Update build_man.sh for
 doxygen 1.9.2
Message-ID: <YbswYqgQ2EYfBWGO@salvia>
References: <20211207224502.16008-1-duncan_roe@optusnet.com.au>
 <Ybp6IlQAlAFVSdjQ@salvia>
 <Ybsv3Hkk93EEYqSr@slk1.local.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <Ybsv3Hkk93EEYqSr@slk1.local.net>
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Thu, Dec 16, 2021 at 11:23:56PM +1100, Duncan Roe wrote:
> Hi Pablo,
> 
> On Thu, Dec 16, 2021 at 12:28:34AM +0100, Pablo Neira Ayuso wrote:
> > A bit more details on this one? It's just a cosmetic issue?
> >
> > On Wed, Dec 08, 2021 at 09:45:02AM +1100, Duncan Roe wrote:
> > > Cater for bold line number in del_def_at_lines()
> > >
> > > Signed-off-by: Duncan Roe <duncan_roe@optusnet.com.au>
> > > ---
> > >  doxygen/build_man.sh | 2 +-
> > >  1 file changed, 1 insertion(+), 1 deletion(-)
> > >
> > > diff --git a/doxygen/build_man.sh b/doxygen/build_man.sh
> > > index 852c7b8..c68876c 100755
> > > --- a/doxygen/build_man.sh
> > > +++ b/doxygen/build_man.sh
> > > @@ -96,7 +96,7 @@ fix_double_blanks(){
> > >  del_def_at_lines(){
> > >    linnum=1
> > >    while [ $linnum -ne 0 ]
> > > -  do mygrep "^Definition at line [[:digit:]]* of file" $target
> > > +  do mygrep '^Definition at line (\\fB)?[[:digit:]]*(\\fP)? of file' $target
> > >      [ $linnum -eq 0 ] || delete_lines $(($linnum - 1)) $linnum
> > >    done
> > >  }
> > > --
> > > 2.17.5
> > >
> No, not cosmetic. The regexp has to be updated to recognise a line with bold
> line numbering. Without the patch, the unwanted line appears in the man page.

I see.

> I thought that was obvious. Will submit a v2 explaining a bit more, unless you
> apply the patch in the meantime.

Thanks for sending v2.
