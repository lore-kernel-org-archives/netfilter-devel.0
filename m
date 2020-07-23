Return-Path: <SRS0=/ZNS=BC=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.5 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5E58CC433E4
	for <netfilter-devel@archiver.kernel.org>; Thu, 23 Jul 2020 15:41:02 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3BE77206D8
	for <netfilter-devel@archiver.kernel.org>; Thu, 23 Jul 2020 15:41:02 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729616AbgGWPlA (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 23 Jul 2020 11:41:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60362 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726761AbgGWPk6 (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 23 Jul 2020 11:40:58 -0400
Received: from a3.inai.de (a3.inai.de [IPv6:2a01:4f8:10b:45d8::f5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E8452C0619DC;
        Thu, 23 Jul 2020 08:40:52 -0700 (PDT)
Received: by a3.inai.de (Postfix, from userid 25121)
        id 049975872C746; Thu, 23 Jul 2020 17:40:49 +0200 (CEST)
Received: from localhost (localhost [127.0.0.1])
        by a3.inai.de (Postfix) with ESMTP id 038D360C4009F;
        Thu, 23 Jul 2020 17:40:49 +0200 (CEST)
Date:   Thu, 23 Jul 2020 17:40:49 +0200 (CEST)
From:   Jan Engelhardt <jengelh@inai.de>
To:     Christoph Hellwig <hch@lst.de>
cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        Eric Dumazet <edumazet@google.com>,
        linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, bpf@vger.kernel.org,
        Netfilter Developer Mailing List 
        <netfilter-devel@vger.kernel.org>, coreteam@netfilter.org,
        linux-sctp@vger.kernel.org, linux-hams@vger.kernel.org,
        linux-bluetooth@vger.kernel.org, bridge@lists.linux-foundation.org,
        linux-can@vger.kernel.org, dccp@vger.kernel.org,
        linux-decnet-user@lists.sourceforge.net,
        linux-wpan@vger.kernel.org, linux-s390@vger.kernel.org,
        mptcp@lists.01.org, lvs-devel@vger.kernel.org,
        rds-devel@oss.oracle.com, linux-afs@lists.infradead.org,
        tipc-discussion@lists.sourceforge.net, linux-x25@vger.kernel.org
Subject: Re: [PATCH 04/26] net: add a new sockptr_t type
In-Reply-To: <20200723060908.50081-5-hch@lst.de>
Message-ID: <nycvar.YFH.7.77.849.2007231725090.11202@n3.vanv.qr>
References: <20200723060908.50081-1-hch@lst.de> <20200723060908.50081-5-hch@lst.de>
User-Agent: Alpine 2.22 (LSU 394 2020-01-19)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org


On Thursday 2020-07-23 08:08, Christoph Hellwig wrote:
>+typedef struct {
>+	union {
>+		void		*kernel;
>+		void __user	*user;
>+	};
>+	bool		is_kernel : 1;
>+} sockptr_t;
>+
>+static inline bool sockptr_is_null(sockptr_t sockptr)
>+{
>+	return !sockptr.user && !sockptr.kernel;
>+}

"""If the member used to access the contents of a union is not the same as the
member last used to store a value, the object representation of the value that
was stored is reinterpreted as an object representation of the new type (this
is known as type punning). If the size of the new type is larger than the size
of the last-written type, the contents of the excess bytes are unspecified (and
may be a trap representation)"""

As I am not too versed with the consequences of trap representations, I will
just point out that a future revision of the C standard may introduce (proposal
N2362) stronger C++-like requirements; as for union, that would imply a simple:

"""It's undefined behavior to read from the member of the union that wasn't
most recently written.""" [cppreference.com]


So, in the spirit of copy_from/to_sockptr, the is_null function should read

{
	return sockptr.is_kernel ? !sockptr.user : !sockptr.kernel;
}

