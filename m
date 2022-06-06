Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5119FC433EF
	for <netfilter-devel@archiver.kernel.org>; Mon,  6 Jun 2022 08:02:59 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231488AbiFFIC6 (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 6 Jun 2022 04:02:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49438 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231535AbiFFICq (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 6 Jun 2022 04:02:46 -0400
Received: from mail.netfilter.org (mail.netfilter.org [217.70.188.207])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id D571F2FFDE
        for <netfilter-devel@vger.kernel.org>; Mon,  6 Jun 2022 01:02:42 -0700 (PDT)
Date:   Mon, 6 Jun 2022 10:02:33 +0200
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Scott Wisniewski <scott@scottdw2.com>
Cc:     netfilter-devel@vger.kernel.org
Subject: Re: Expired Cert
Message-ID: <Yp20mQgBFfZ/kro3@salvia>
References: <CAO=7uoa2_4+soqK+9k+BJ4AjCbL3T7xQxNtKZ_VgRYi3ZpXb8Q@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <CAO=7uoa2_4+soqK+9k+BJ4AjCbL3T7xQxNtKZ_VgRYi3ZpXb8Q@mail.gmail.com>
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Sun, Jun 05, 2022 at 12:43:37PM -0700, Scott Wisniewski wrote:
> Just a quick heads up, it looks like the cert used by
> 
> bugzilla.netfilter.org
> and
> people.netfilter.org
> 
> Expired back on 6/3. You might want to rotate the cert.

Fixed, thanks for reporting.
