Return-Path: <SRS0=RvX8=7K=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BBE05C433E0
	for <netfilter-devel@archiver.kernel.org>; Thu, 28 May 2020 20:18:40 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9DE3D207D3
	for <netfilter-devel@archiver.kernel.org>; Thu, 28 May 2020 20:18:40 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2407092AbgE1USg (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 28 May 2020 16:18:36 -0400
Received: from smtprelay0203.hostedemail.com ([216.40.44.203]:35514 "EHLO
        smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S2406935AbgE1USf (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 28 May 2020 16:18:35 -0400
Received: from filter.hostedemail.com (clb03-v110.bra.tucows.net [216.40.38.60])
        by smtprelay05.hostedemail.com (Postfix) with ESMTP id DC94B18000C0E;
        Thu, 28 May 2020 20:18:32 +0000 (UTC)
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-HE-Tag: burn98_22177ce26d5d
X-Filterd-Recvd-Size: 2530
Received: from XPS-9350.home (unknown [47.151.136.130])
        (Authenticated sender: joe@perches.com)
        by omf03.hostedemail.com (Postfix) with ESMTPA;
        Thu, 28 May 2020 20:18:30 +0000 (UTC)
Message-ID: <499cba4e00172867850b13df26670ed80d41d7a6.camel@perches.com>
Subject: Re: clean up kernel_{read,write} & friends v2
From:   Joe Perches <joe@perches.com>
To:     Matthew Wilcox <willy@infradead.org>,
        Al Viro <viro@zeniv.linux.org.uk>
Cc:     Linus Torvalds <torvalds@linux-foundation.org>,
        Christoph Hellwig <hch@lst.de>, Ian Kent <raven@themaw.net>,
        David Howells <dhowells@redhat.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        LSM List <linux-security-module@vger.kernel.org>,
        NetFilter <netfilter-devel@vger.kernel.org>,
        Alex Deucher <alexander.deucher@amd.com>,
        David Airlie <airlied@linux.ie>
Date:   Thu, 28 May 2020 13:18:29 -0700
In-Reply-To: <20200528194441.GQ17206@bombadil.infradead.org>
References: <20200528054043.621510-1-hch@lst.de>
         <CAHk-=wj3iGQqjpvc+gf6+C29Jo4COj6OQQFzdY0h5qvYKTdCow@mail.gmail.com>
         <f68b7797aa73452d99508bdaf2801b3d141e7a69.camel@perches.com>
         <20200528193340.GR23230@ZenIV.linux.org.uk>
         <20200528194441.GQ17206@bombadil.infradead.org>
Content-Type: text/plain; charset="ISO-8859-1"
User-Agent: Evolution 3.36.2-0ubuntu1 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Thu, 2020-05-28 at 12:44 -0700, Matthew Wilcox wrote:
> On Thu, May 28, 2020 at 08:33:40PM +0100, Al Viro wrote:
> > On Thu, May 28, 2020 at 12:22:08PM -0700, Joe Perches wrote:
> > 
> > > Hard limits at 80 really don't work well, especially with
> > > some of the 25+ character length identifiers used today.
> > 
> > IMO any such identifier is a good reason for a warning.
> > 
> > The litmus test is actually very simple: how unpleasant would it be
> > to mention the identifiers while discussing the code over the phone?
> 
> Here's a good example of a function which should be taken out and shot:
> 
> int amdgpu_atombios_get_leakage_vddc_based_on_leakage_params(struct amdgpu_devic
> e *adev,

Ick.

Seems simple enough as it doesn't appear to be used...

$ git grep amdgpu_atombios_get_leakage_vddc_based_on_leakage_params
drivers/gpu/drm/amd/amdgpu/amdgpu_atombios.c:int amdgpu_atombios_get_leakage_vddc_based_on_leakage_params(struct amdgpu_device *adev,
drivers/gpu/drm/amd/amdgpu/amdgpu_atombios.h:int amdgpu_atombios_get_leakage_vddc_based_on_leakage_params(struct amdgpu_device *adev,


