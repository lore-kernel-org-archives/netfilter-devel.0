Return-Path: <SRS0=QlJu=X5=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4AB58C4CED1
	for <netfilter-devel@archiver.kernel.org>; Fri,  4 Oct 2019 11:48:06 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 27EB920867
	for <netfilter-devel@archiver.kernel.org>; Fri,  4 Oct 2019 11:48:06 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730750AbfJDLsE (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Fri, 4 Oct 2019 07:48:04 -0400
Received: from mail104.syd.optusnet.com.au ([211.29.132.246]:51196 "EHLO
        mail104.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1729926AbfJDLsE (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 4 Oct 2019 07:48:04 -0400
Received: from dimstar.local.net (n122-110-44-45.sun2.vic.optusnet.com.au [122.110.44.45])
        by mail104.syd.optusnet.com.au (Postfix) with SMTP id 1A0C843EE9C
        for <netfilter-devel@vger.kernel.org>; Fri,  4 Oct 2019 21:47:45 +1000 (AEST)
Received: (qmail 23038 invoked by uid 501); 4 Oct 2019 11:47:45 -0000
Date:   Fri, 4 Oct 2019 21:47:45 +1000
From:   Duncan Roe <duncan_roe@optusnet.com.au>
To:     Haishuang Yan <yanhaishuang@cmss.chinamobile.com>
Cc:     Julian Anastasov <ja@ssi.bg>, Shuah Khan <shuah@kernel.org>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        "David S. Miller" <davem@davemloft.net>,
        Simon Horman <horms@verge.net.au>,
        linux-kernel@vger.kernel.org, linux-kselftest@vger.kernel.org,
        lvs-devel@vger.kernel.org, netfilter-devel@vger.kernel.org
Subject: Re: [PATCH v3 0/3] selftests: netfilter: introduce test cases for
 ipvs
Message-ID: <20191004114745.GB6803@dimstar.local.net>
Mail-Followup-To: Haishuang Yan <yanhaishuang@cmss.chinamobile.com>,
        Julian Anastasov <ja@ssi.bg>, Shuah Khan <shuah@kernel.org>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        "David S. Miller" <davem@davemloft.net>,
        Simon Horman <horms@verge.net.au>, linux-kernel@vger.kernel.org,
        linux-kselftest@vger.kernel.org, lvs-devel@vger.kernel.org,
        netfilter-devel@vger.kernel.org
References: <1569939599-1872-1-git-send-email-yanhaishuang@cmss.chinamobile.com>
 <alpine.LFD.2.21.1910012133330.3887@ja.home.ssi.bg>
 <20191002012726.GB9810@dimstar.local.net>
 <8E2E81F3-8385-4397-9A22-F513E507507D@cmss.chinamobile.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <8E2E81F3-8385-4397-9A22-F513E507507D@cmss.chinamobile.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.2 cv=FNpr/6gs c=1 sm=1 tr=0
        a=4DzML1vCOQ6Odsy8BUtSXQ==:117 a=4DzML1vCOQ6Odsy8BUtSXQ==:17
        a=jpOVt7BSZ2e4Z31A5e1TngXxSK0=:19 a=kj9zAlcOel0A:10 a=XobE76Q3jBoA:10
        a=PO7r1zJSAAAA:8 a=YExiR9hJhUxYzP8DYcgA:9 a=CjuIK1q_8ugA:10
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Thu, Oct 03, 2019 at 10:41:06PM +0800, Haishuang Yan wrote:
>
>
> > On 2019??10??2??, at ????9:27, Duncan Roe <duncan_roe@optusnet.com.au> wrote:
> >
> > On Tue, Oct 01, 2019 at 09:34:13PM +0300, Julian Anastasov wrote:
> >>
> >> 	Hello,
> >>
> >> On Tue, 1 Oct 2019, Haishuang Yan wrote:
> >>
> >>> This series patch include test cases for ipvs.
> >>>
> >>> The test topology is who as below:
> >>> +--------------------------------------------------------------+
> >>> |                      |                                       |
> >>> |         ns0          |         ns1                           |
> >>> |      -----------     |     -----------    -----------        |
> >>> |      | veth01  | --------- | veth10  |    | veth12  |        |
> >>> |      -----------    peer   -----------    -----------        |
> >>> |           |          |                        |              |
> >>> |      -----------     |                        |              |
> >>> |      |  br0    |     |-----------------  peer |--------------|
> >>> |      -----------     |                        |              |
> >>> |           |          |                        |              |
> >>> |      ----------     peer   ----------      -----------       |
> >>> |      |  veth02 | --------- |  veth20 |     | veth12  |       |
> >>> |      ----------      |     ----------      -----------       |
> >>> |                      |         ns2                           |
> >>> |                      |                                       |
> >>> +--------------------------------------------------------------+
> >>>
> >>> Test results:
> >>> # selftests: netfilter: ipvs.sh
> >>> # Testing DR mode...
> >>> # Testing NAT mode...
> >>> # Testing Tunnel mode...
> >>> # ipvs.sh: PASS
> >>> ok 6 selftests: netfilter: ipvs.sh
> >>>
> >>> Haishuang Yan (3):
> >>>  selftests: netfilter: add ipvs test script
> >>>  selftests: netfilter: add ipvs nat test case
> >>>  selftests: netfilter: add ipvs tunnel test case
> >>
> >> Acked-by: Julian Anastasov <ja@ssi.bg>
> >>
> >>> tools/testing/selftests/netfilter/Makefile |   2 +-
> >>> tools/testing/selftests/netfilter/ipvs.sh  | 234 +++++++++++++++++++++++++++++
> >>> 2 files changed, 235 insertions(+), 1 deletion(-)
> >>> create mode 100755 tools/testing/selftests/netfilter/ipvs.sh
> >>
> >> Regards
> >>
> >> --
> >> Julian Anastasov <ja@ssi.bg>
> >
> > I still prefer #!/bin/sh in 1/3. You never know what's in someone's environment
> >
> > Cheers ... Duncan.
> >
>
> It??s also my preference too. "_"	
>
> I have tested both #!/bin/bash and #!/bin/sh script, they all works properly.

Enter these 2 lines:
> ip(){ return 0; }
> export -f ip

Now try the #!/bin/bash script. If that now fails, try again with #!/bin/bash
changed to #!/bin/bash -p

Any better now?

Cheers ... Duncan.
