Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C7046C352A1
	for <netfilter-devel@archiver.kernel.org>; Wed,  7 Dec 2022 18:56:12 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229736AbiLGS4J (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 7 Dec 2022 13:56:09 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57382 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229529AbiLGS4I (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 7 Dec 2022 13:56:08 -0500
Received: from orbyte.nwl.cc (orbyte.nwl.cc [IPv6:2001:41d0:e:133a::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 05E58532FE
        for <netfilter-devel@vger.kernel.org>; Wed,  7 Dec 2022 10:56:08 -0800 (PST)
Received: from n0-1 by orbyte.nwl.cc with local (Exim 4.94.2)
        (envelope-from <n0-1@orbyte.nwl.cc>)
        id 1p2zaP-0001Ju-KM; Wed, 07 Dec 2022 19:56:05 +0100
Date:   Wed, 7 Dec 2022 19:56:05 +0100
From:   Phil Sutter <phil@nwl.cc>
To:     Jan Engelhardt <jengelh@inai.de>
Cc:     netfilter-devel@vger.kernel.org
Subject: Re: [iptables PATCH 08/11] Makefile: Generate .tar.bz2 archive with
 'make dist'
Message-ID: <Y5DhxWh+2qpixI5O@orbyte.nwl.cc>
Mail-Followup-To: Phil Sutter <phil@nwl.cc>,
        Jan Engelhardt <jengelh@inai.de>, netfilter-devel@vger.kernel.org
References: <20221207174430.4335-1-phil@nwl.cc>
 <20221207174430.4335-9-phil@nwl.cc>
 <p1286pq3-rprq-p2pq-3172-22p6s42pq3r1@vanv.qr>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <p1286pq3-rprq-p2pq-3172-22p6s42pq3r1@vanv.qr>
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Wed, Dec 07, 2022 at 07:45:30PM +0100, Jan Engelhardt wrote:
> On Wednesday 2022-12-07 18:44, Phil Sutter wrote:
> 
> >Instead of the default .tar.gz one.
> 
> I get the feeling that at this point (in time), bzip2 as compression 
> does not make much sense anymore. If targeting size, the win goes to 
> LZMA-class compressors (e.g. xz), if targeting speed, the win goes to 
> LZ/deflate-ish compressors (e.g. gzip, zstd).

Yes, the discussion is moot with only 4.6MB to be compressed. FWIW:

| 4.6M	iptables-1.8.8.tar
| 984K	iptables-1.8.8.tar.gz
| 772K	iptables-1.8.8.tar.bz2
| 636K	iptables-1.8.8.tar.xz

Moving to LZMA is trivial from a Makefile's point of view, but most
packagers will have extra work adjusting for the new file name if we
move away from bzip2.

Cheers, Phil
