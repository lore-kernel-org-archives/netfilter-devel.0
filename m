Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B677CC61D96
	for <netfilter-devel@archiver.kernel.org>; Tue, 21 Nov 2023 12:39:40 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234346AbjKUMjm (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 21 Nov 2023 07:39:42 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57676 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231360AbjKUMjm (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 21 Nov 2023 07:39:42 -0500
Received: from orbyte.nwl.cc (orbyte.nwl.cc [IPv6:2001:41d0:e:133a::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D6B02138
        for <netfilter-devel@vger.kernel.org>; Tue, 21 Nov 2023 04:39:37 -0800 (PST)
Received: from n0-1 by orbyte.nwl.cc with local (Exim 4.94.2)
        (envelope-from <n0-1@orbyte.nwl.cc>)
        id 1r5Q2Q-00085c-GI; Tue, 21 Nov 2023 13:39:34 +0100
Date:   Tue, 21 Nov 2023 13:39:34 +0100
From:   Phil Sutter <phil@nwl.cc>
To:     Thomas Haller <thaller@redhat.com>
Cc:     NetFilter <netfilter-devel@vger.kernel.org>
Subject: Re: [PATCH nft 1/1] tests/shell: sanitize "handle" in JSON output
Message-ID: <ZVylBpvC+IK4RIyH@orbyte.nwl.cc>
Mail-Followup-To: Phil Sutter <phil@nwl.cc>,
        Thomas Haller <thaller@redhat.com>,
        NetFilter <netfilter-devel@vger.kernel.org>
References: <20231117171948.897229-1-thaller@redhat.com>
 <ZVgjLFGvHqoXXvjd@orbyte.nwl.cc>
 <f4b86e5318556be07a8c86c3fdd551ad5e22a831.camel@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <f4b86e5318556be07a8c86c3fdd551ad5e22a831.camel@redhat.com>
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Tue, Nov 21, 2023 at 01:10:11PM +0100, Thomas Haller wrote:
> On Sat, 2023-11-18 at 03:36 +0100, Phil Sutter wrote:
[...]
> > Also, scoping these replacements to line 1 is funny with single line
> > input. Worse is identifying the change in the resulting diff. Maybe
> > write a helper in python which lets you more comfortably sanitize
> > input,
> > sort attributes by key and output pretty-printed?
> 
> You mean, to parse and re-encode the JSON? That introduces additional
> changes, which seems undesirable. That's why the regex is limited to
> the first line (even if we only expect to ever see one line there).
> 
> Also, normalization via 2 regex seems simpler than writing some python.
> 
> Well, pretty-printing the output with `jq` would have the advantage,
> that future diffs might be smaller (changing individual lines, vs.
> replace one large line). Still, I think it's better to keep the amount
> of post-processing minimal.

The testsuite relies upon Python and respective modules already, using
jq introduces a new dependency. Hence why I suggested to write a script.

JSON object attributes are not bound to any ordering, the code may
change it.

When analyzing testsuite failures, a diff of two overlong lines is
inconvenient to the point that one may pipe both through json_pp and
then diff again. The testsuite may do just that in case of offending
output, but the problem of reordered attributes remains.

I'd really appreciate if testsuite changes prioritized usability. I
rather focus on fixing bugs instead of parsing the testsuite results.

Cheers, Phil
