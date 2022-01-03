Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BE123C433F5
	for <netfilter-devel@archiver.kernel.org>; Mon,  3 Jan 2022 18:10:19 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234580AbiACSKS (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 3 Jan 2022 13:10:18 -0500
Received: from mail.netfilter.org ([217.70.188.207]:57456 "EHLO
        mail.netfilter.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235234AbiACSKS (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 3 Jan 2022 13:10:18 -0500
Received: from netfilter.org (unknown [78.30.32.163])
        by mail.netfilter.org (Postfix) with ESMTPSA id 71E8162BDB;
        Mon,  3 Jan 2022 19:07:33 +0100 (CET)
Date:   Mon, 3 Jan 2022 19:10:13 +0100
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Jeremy Sowden <jeremy@azazel.net>
Cc:     Netfilter Devel <netfilter-devel@vger.kernel.org>
Subject: Re: [ulogd2 PATCH v4 00/32] Fixes for compiler warnings
Message-ID: <YdM8BYK5U+CMU+ow@salvia>
References: <20211130105600.3103609-1-jeremy@azazel.net>
 <Ya6MyhseW80+w0FY@salvia>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <Ya6MyhseW80+w0FY@salvia>
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Mon, Dec 06, 2021 at 11:21:01PM +0100, Pablo Neira Ayuso wrote:
> On Tue, Nov 30, 2021 at 10:55:28AM +0000, Jeremy Sowden wrote:
> > This patch-set fixes all the warnings reported by gcc 11.
> > 
> > Most of the warnings concern fall-throughs in switches, possibly
> > problematic uses of functions like `strncpy` and `strncat` and possible
> > truncation of output by `sprintf` and its siblings.
> > 
> > Some of the patches fix bugs revealed by warnings, some tweak code to
> > avoid warnings, others fix or improve things I noticed while looking at
> > the warnings.
> > 
> > Changes since v3:
> > 
> >   * When publishing v3 I accidentally sent out two different versions of the
> >     patch-set under one cover-letter.  There are no code-changes in v4: it just
> >     omits the earlier superseded patches.
> 
> Applied from 1 to 19 (all inclusive)

Applied remaining patches with comments.

- Patch #20, #24 maybe consider conversion to snprintf at some point, not
  your fault, this code is using sprintf in many spots. I think the
  only problematic scenario which might trigger problems is the
  configuration path using too long object names.

- Patch #21, #22 and #25, maybe consolidate this database field from
  _ to . in a common function.

- Patch #27, tm_gmtoff mod 86400 is really required? tm_gmtoff can be
  either -12/+12 * 60 * 60, simple assignment to integer should calm
  down the compiler?

- Patch #80, I guess you picked 80 just to provide a sufficiently
  large buffer to calm down compiler.

- Patch #31: I have replaced this patch with a check from .start and
  .signal paths to validate the unix socket path. The signal path of
  ulogd2 is problematic since configuration file errors should
  likely stop the daemon. I'll post it after this email.

- Patch #32: this IPFIX plugin was tested with wireshark according to
  4f639231c83b ("IPFIX: Add IPFIX output plugin"), I wonder if this
  attribute((packed)) is breaking anything, or maybe this was all
  tested on 32-bit?

Anyway, after this update it's probably better to look at using
pkg-config in the build system.

Thanks for fixing up these compiler warnings.
