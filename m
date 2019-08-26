Return-Path: <SRS0=4EdP=WW=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.3 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 548E3C3A59F
	for <netfilter-devel@archiver.kernel.org>; Mon, 26 Aug 2019 14:37:43 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 3293C217F5
	for <netfilter-devel@archiver.kernel.org>; Mon, 26 Aug 2019 14:37:43 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732529AbfHZOhm (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 26 Aug 2019 10:37:42 -0400
Received: from ganesha.gnumonks.org ([213.95.27.120]:41533 "EHLO
        ganesha.gnumonks.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726484AbfHZOhm (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 26 Aug 2019 10:37:42 -0400
Received: from sys.soleta.eu ([212.170.55.40] helo=gnumonks.org)
        by ganesha.gnumonks.org with esmtpsa (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.89)
        (envelope-from <pablo@gnumonks.org>)
        id 1i2G7h-00033z-TF; Mon, 26 Aug 2019 16:37:39 +0200
Date:   Mon, 26 Aug 2019 16:37:33 +0200
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     wenxu <wenxu@ucloud.cn>
Cc:     netfilter-devel@vger.kernel.org
Subject: Re: [PATCH nft v5] meta: add ibrpvid and ibrvproto support
Message-ID: <20190826143733.fmbwf3gfm2r5ctf7@salvia>
References: <1566567928-18121-1-git-send-email-wenxu@ucloud.cn>
 <20190826102615.cqfidve47clkhzdr@salvia>
 <989de2f9-c66b-aae1-ce39-50baffd98a2b@ucloud.cn>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <989de2f9-c66b-aae1-ce39-50baffd98a2b@ucloud.cn>
User-Agent: NeoMutt/20170113 (1.7.2)
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Mon, Aug 26, 2019 at 09:51:57PM +0800, wenxu wrote:
> 
> 在 2019/8/26 18:26, Pablo Neira Ayuso 写道:
> > On Fri, Aug 23, 2019 at 09:45:28PM +0800, wenxu@ucloud.cn wrote:
> >> From: wenxu <wenxu@ucloud.cn>
> >>
> >> This allows you to match the bridge pvid and vlan protocol, for
> >> instance:
> >>
> >> nft add rule bridge firewall zones meta ibrvproto 0x8100
> >> nft add rule bridge firewall zones meta ibrpvid 100
> > When running python nft-tests.py with -j, I get this here:
> >
> > bridge/meta.t: WARNING: line 7: '{"nftables": [{"add": {"rule":
> > {"table": "test-bridge", "chain": "input", "family": "bridge", "expr":
> > [{"match": {"op": "==", "right": "0x8100", "left": {"meta": {"key":
> > "ibrvproto"}}}}]}}}]}': '[{"match": {"left": {"meta": {"key":
> > "ibrvproto"}}, "op": "==", "right": "0x8100"}}]' mismatches
> > '[{"match": {"left": {"meta": {"key": "ibrvproto"}}, "op": "==",
> > "right": 33024}}]'
> > /tmp/nftables/tests/py/bridge/meta.t.json.output.got:
> > WARNING: line 2: Wrote JSON output for rule meta ibrvproto 0x8100
> >
> > Then, if I type:
> >
> >         nft rule x y meta protocol vlan
> >
> > Then, printing shows:
> >
> > table ip x {
> >         chain y {
> >                 meta protocol vlan
> >         }
> > }
> >
> > However, with:
> >
> >         nft rule x y meta ibrvproto vlan
> >
> > I get this:
> >
> > table bridge x {
> >         chain y {
> >                 meta ibrvproto 0x8100
> >         }
> > }
> >
> > I think the problem the endianess in the new key definitions are not
> > correct.
> >
> > The br_vlan_get_proto() in the kernel returns a value in network byte
> > order.
> >
> > I think this does not match either then? Because bytecode is
> > incorrect?
> 
> The br_vlan_get_proto returns vlan_proto in host byte order.

Then, that's why ethertype datatype does not work, because it expects
this network byteorder.
