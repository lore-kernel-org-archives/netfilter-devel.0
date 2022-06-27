Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B5203C433EF
	for <netfilter-devel@archiver.kernel.org>; Mon, 27 Jun 2022 17:31:33 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235192AbiF0Rbc (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 27 Jun 2022 13:31:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44346 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231809AbiF0Rba (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 27 Jun 2022 13:31:30 -0400
Received: from mail.netfilter.org (mail.netfilter.org [217.70.188.207])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 4E01C6153
        for <netfilter-devel@vger.kernel.org>; Mon, 27 Jun 2022 10:31:30 -0700 (PDT)
Date:   Mon, 27 Jun 2022 19:31:27 +0200
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Oleksandr Natalenko <oleksandr@natalenko.name>
Cc:     netfilter-devel@vger.kernel.org, Florian Westphal <fw@strlen.de>,
        Loganaden Velvindron <logan@cyberstorm.mu>
Subject: Re: [PATCH] src: proto: support DF, LE, VA for DSCP
Message-ID: <Yrnpb7DcTz7qW1hh@salvia>
References: <20220620185807.968658-1-oleksandr@natalenko.name>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20220620185807.968658-1-oleksandr@natalenko.name>
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Hi,

On Mon, Jun 20, 2022 at 08:58:07PM +0200, Oleksandr Natalenko wrote:
> Add a couple of aliases for well-known DSCP values.
> 
> As per RFC 4594, add "df" as an alias of "cs0" with 0x00 value.
> 
> As per RFC 5865, add "va" for VOICE-ADMIT with 0x2c value.

Quickly browsing, I don't find "va" nor 0x2c in this RFC above? Could
you refer to page?

> As per RFC 8622, add "le" for Lower-Effort with 0x01 value.

This RFC refers to replacing CS1 by LE

   o  This update to RFC 4594 removes the following entry from its
      Figure 4:

   |---------------+------+-------------------+---------+--------+----|
   | Low-Priority  | CS1  | Not applicable    | RFC3662 |  Rate  | Yes|
   |     Data      |      |                   |         |        |    |
    ------------------------------------------------------------------

      and replaces it with the following entry:

   |---------------+------+-------------------+----------+--------+----|
   | Low-Priority  | LE   | Not applicable    | RFC 8622 |  Rate  | Yes|
   |     Data      |      |                   |          |        |    |
    -------------------------------------------------------------------


static const struct symbol_table dscp_type_tbl = {
        .base           = BASE_HEXADECIMAL,
        .symbols        = {
                [...]
                SYMBOL("cs1",   0x08),
                [...]
                SYMBOL("le",    0x01),

> tc-cake(8) in diffserv8 mode would benefit from having "le" alias since
> it corresponds to "Tin 0".

Aliasing is fine, let's just clarify this first.

Thanks.
