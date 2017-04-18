From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: Doubt about CTA_EXPECT_* values passed to ctnetlink_parse_tuple()
Date: Tue, 18 Apr 2017 10:39:47 +0200
Message-ID: <20170418083947.GA1720@salvia>
References: <20170417223730.GR28657@google.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="3V7upXqbjpZ4EhLz"
Cc: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>,
        netfilter-devel@vger.kernel.org, coreteam@netfilter.org
To: Matthias Kaehlcke <mka@chromium.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:32994 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1755818AbdDRIj6 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 18 Apr 2017 04:39:58 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 906E611E5A3
        for <netfilter-devel@vger.kernel.org>; Tue, 18 Apr 2017 10:39:52 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 84EF1DA86E
        for <netfilter-devel@vger.kernel.org>; Tue, 18 Apr 2017 10:39:52 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id B34EADA86E
        for <netfilter-devel@vger.kernel.org>; Tue, 18 Apr 2017 10:39:48 +0200 (CEST)
Content-Disposition: inline
In-Reply-To: <20170417223730.GR28657@google.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


--3V7upXqbjpZ4EhLz
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hi Mattias,

On Mon, Apr 17, 2017 at 03:37:30PM -0700, Matthias Kaehlcke wrote:
> Hi,
> 
> While working on clang support for kernel builds I came across at what
> at first sight looks like an enum mismatch in the netfilter conntrack
> code:
> 
> In multiple occasions CTA_EXPECT_* values (of type enum ctattr_expect)
> are passed to ctnetlink_parse_tuple(), which expects an 'enum
> ctattr_type' as type argument.

Are you refering to this? See patch.

--3V7upXqbjpZ4EhLz
Content-Type: text/x-diff; charset=us-ascii
Content-Disposition: attachment; filename="x.patch"

diff --git a/net/netfilter/nf_conntrack_netlink.c b/net/netfilter/nf_conntrack_netlink.c
index dc7dfd68fafe..88d7cd9b6b0a 100644
--- a/net/netfilter/nf_conntrack_netlink.c
+++ b/net/netfilter/nf_conntrack_netlink.c
@@ -1006,9 +1006,8 @@ static const struct nla_policy tuple_nla_policy[CTA_TUPLE_MAX+1] = {
 
 static int
 ctnetlink_parse_tuple(const struct nlattr * const cda[],
-		      struct nf_conntrack_tuple *tuple,
-		      enum ctattr_type type, u_int8_t l3num,
-		      struct nf_conntrack_zone *zone)
+		      struct nf_conntrack_tuple *tuple, u32 type,
+		      u_int8_t l3num, struct nf_conntrack_zone *zone)
 {
 	struct nlattr *tb[CTA_TUPLE_MAX+1];
 	int err;

--3V7upXqbjpZ4EhLz--
