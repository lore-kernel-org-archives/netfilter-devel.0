Return-Path: <SRS0=RvX8=7K=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 36476C433DF
	for <netfilter-devel@archiver.kernel.org>; Thu, 28 May 2020 21:04:18 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 184212088E
	for <netfilter-devel@archiver.kernel.org>; Thu, 28 May 2020 21:04:18 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2407505AbgE1VEP (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 28 May 2020 17:04:15 -0400
Received: from smtprelay0156.hostedemail.com ([216.40.44.156]:49172 "EHLO
        smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S2407503AbgE1VEO (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 28 May 2020 17:04:14 -0400
Received: from filter.hostedemail.com (clb03-v110.bra.tucows.net [216.40.38.60])
        by smtprelay06.hostedemail.com (Postfix) with ESMTP id 02A0218224D60;
        Thu, 28 May 2020 21:03:59 +0000 (UTC)
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-HE-Tag: whip61_331100626d5d
X-Filterd-Recvd-Size: 3056
Received: from XPS-9350.home (unknown [47.151.136.130])
        (Authenticated sender: joe@perches.com)
        by omf06.hostedemail.com (Postfix) with ESMTPA;
        Thu, 28 May 2020 21:03:58 +0000 (UTC)
Message-ID: <7934ff03b72eac71a8cff3e8bd0f4d8cac0e136e.camel@perches.com>
Subject: Re: clean up kernel_{read,write} & friends v2
From:   Joe Perches <joe@perches.com>
To:     Linus Torvalds <torvalds@linux-foundation.org>,
        Christoph Hellwig <hch@lst.de>
Cc:     Al Viro <viro@zeniv.linux.org.uk>, Ian Kent <raven@themaw.net>,
        David Howells <dhowells@redhat.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        LSM List <linux-security-module@vger.kernel.org>,
        NetFilter <netfilter-devel@vger.kernel.org>
Date:   Thu, 28 May 2020 14:03:57 -0700
In-Reply-To: <f68b7797aa73452d99508bdaf2801b3d141e7a69.camel@perches.com>
References: <20200528054043.621510-1-hch@lst.de>
         <CAHk-=wj3iGQqjpvc+gf6+C29Jo4COj6OQQFzdY0h5qvYKTdCow@mail.gmail.com>
         <f68b7797aa73452d99508bdaf2801b3d141e7a69.camel@perches.com>
Content-Type: text/plain; charset="ISO-8859-1"
User-Agent: Evolution 3.36.2-0ubuntu1 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Thu, 2020-05-28 at 12:22 -0700, Joe Perches wrote:
> On Thu, 2020-05-28 at 11:51 -0700, Linus Torvalds wrote:
> > On Wed, May 27, 2020 at 10:40 PM Christoph Hellwig <hch@lst.de> wrote:
> > > this series fixes a few issues and cleans up the helpers that read from
> > > or write to kernel space buffers, and ensures that we don't change the
> > > address limit if we are using the ->read_iter and ->write_iter methods
> > > that don't need the changed address limit.
> > 
> > Apart from the "please don't mix irrelevant whitespace changes with
> > other changes" comment, this looks fine to me.
> > 
> > And a rant related to that change: I'm really inclined to remove the
> > checkpatch check for 80 columns entirely, but it shouldn't have been
> > triggering for old lines even now.
> > 
> > Or maybe make it check for something more reasonable, like 100 characters.
> > 
> > I find it ironic and annoying how "checkpatch" warns about that silly
> > legacy limit, when checkpatch itself then on the very next few lines
> > has a line that is 124 columns wide

Another option is to only warn by default when a line in a
patch but not a file exceeds the line length maximum.
---
 scripts/checkpatch.pl | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/scripts/checkpatch.pl b/scripts/checkpatch.pl
index dd750241958b..78f5b7f97e42 100755
--- a/scripts/checkpatch.pl
+++ b/scripts/checkpatch.pl
@@ -3282,8 +3282,10 @@ sub process {
 
 			if ($msg_type ne "" &&
 			    (show_type("LONG_LINE") || show_type($msg_type))) {
-				WARN($msg_type,
-				     "line over $max_line_length characters\n" . $herecurr);
+				my $msg_level = \&WARN;
+				$msg_level = \&CHK if ($file);
+				&{$msg_level}($msg_type,
+					      "line over $max_line_length characters\n" . $herecurr);
 			}
 		}
 

