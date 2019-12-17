Return-Path: <SRS0=i/iJ=2H=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.3 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B693EC43603
	for <netfilter-devel@archiver.kernel.org>; Tue, 17 Dec 2019 16:41:44 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 8B50021D7D
	for <netfilter-devel@archiver.kernel.org>; Tue, 17 Dec 2019 16:41:44 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727543AbfLQQlo (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 17 Dec 2019 11:41:44 -0500
Received: from orbyte.nwl.cc ([151.80.46.58]:32934 "EHLO orbyte.nwl.cc"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727039AbfLQQlo (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 17 Dec 2019 11:41:44 -0500
Received: from n0-1 by orbyte.nwl.cc with local (Exim 4.91)
        (envelope-from <n0-1@orbyte.nwl.cc>)
        id 1ihFum-00052T-Vg; Tue, 17 Dec 2019 17:41:41 +0100
Date:   Tue, 17 Dec 2019 17:41:40 +0100
From:   Phil Sutter <phil@nwl.cc>
To:     "Serguei Bezverkhi (sbezverk)" <sbezverk@cisco.com>
Cc:     Arturo Borrero Gonzalez <arturo@netfilter.org>,
        "netfilter-devel@vger.kernel.org" <netfilter-devel@vger.kernel.org>
Subject: Re: Numen with reference to vmap
Message-ID: <20191217164140.GE8553@orbyte.nwl.cc>
Mail-Followup-To: Phil Sutter <phil@nwl.cc>,
        "Serguei Bezverkhi (sbezverk)" <sbezverk@cisco.com>,
        Arturo Borrero Gonzalez <arturo@netfilter.org>,
        "netfilter-devel@vger.kernel.org" <netfilter-devel@vger.kernel.org>
References: <20191204101819.GN8016@orbyte.nwl.cc>
 <AFC93A41-C4DD-4336-9A62-6B9C6817D198@cisco.com>
 <20191204151738.GR14469@orbyte.nwl.cc>
 <5337E60B-E81D-46ED-912F-196E23C76701@cisco.com>
 <20191204155619.GU14469@orbyte.nwl.cc>
 <624cc1ac-126e-8ad3-3faa-f7869f7d2d5b@netfilter.org>
 <20191204223215.GX14469@orbyte.nwl.cc>
 <98A8233C-1A83-44A1-A122-6F80212D618F@cisco.com>
 <20191217122925.GD8553@orbyte.nwl.cc>
 <C5103001-881F-46A8-8738-EC8F8117FAE6@cisco.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <C5103001-881F-46A8-8738-EC8F8117FAE6@cisco.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Hi Serguei,

On Tue, Dec 17, 2019 at 02:05:58PM +0000, Serguei Bezverkhi (sbezverk) wrote:
> Thank you very much for your reply. Can I paste your reply into the doc with reference to your name? If you do not wish. I will rephrase it and post it there.

Noo, don't tell anyone what I write in mails to public lists! ;)
Seriously, I don't care if you paste it there or just link to my reply
in a public archive.

> I have one question, 
> 
> chain KUBE-SVC-57XVOCFNTLTR3Q27 {
> 	numgen random mod 2 vmap { 0 : jump KUBE-SEP-FS3FUULGZPVD4VYB, 
>                                                                        1 : jump KUBE-SEP-MMFZROQSLQ3DKOQA }
> }
> 
> In this rule, as far as I understood you last time, there is no way dynamically change elements of anonymous vmap. So if the service has large number of dynamic (short lived) endpoints, this rule will have to be reprogrammed for every change and it would be extremely inefficient. Is there any way to make it more dynamic or plans to change the static behavior?  That would extremely important.

Consensus was that you should either copy the iptables solution for now
(accepting the drawbacks I explained in my last mail) or go with
replacing that rule for each added/removed node. You'll have to adjust
both mapping contents and modulus value!

While it would be nice to have a better way of managing this
load-balancing, I have no idea how one would ideally implement it. Feel
free to file a ticket in netfilter bugzilla, but don't hold your breath
for a quick solution.

Cheers, Phil
