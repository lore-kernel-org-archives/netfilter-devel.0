From: Thierry Du Tre <thierry@dtsystems.be>
Subject: Re: [PATCH v2] netfilter : add NAT support for shifted portmap ranges
Date: Fri, 12 Jan 2018 11:21:31 +0100
Message-ID: <6e2a6f91-e2ff-2d1f-862f-1d5a9086d364@dtsystems.be>
References: <728b1f75-3f1b-c137-b2ca-8e0d50c07bce@dtsystems.be>
 <20180112002119.ta4eodm6uuad27wu@salvia>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@vger.kernel.org
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-wm0-f44.google.com ([74.125.82.44]:46170 "EHLO
        mail-wm0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754660AbeALKVe (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 12 Jan 2018 05:21:34 -0500
Received: by mail-wm0-f44.google.com with SMTP id 143so10934755wma.5
        for <netfilter-devel@vger.kernel.org>; Fri, 12 Jan 2018 02:21:33 -0800 (PST)
In-Reply-To: <20180112002119.ta4eodm6uuad27wu@salvia>
Content-Language: nl
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hi Pablo, thanks for you quick response.

Op 12/01/2018 om 1:21 schreef Pablo Neira Ayuso:
> Hi Thierry,
> 
> On Thu, Jan 11, 2018 at 07:42:27PM +0100, Thierry Du Tre wrote:
>> This is a patch proposal to support shifted ranges in portmaps.
> 
> I think you can get a much smaller patch if you rename the existing
> "struct nf_nat_range" to "struct nf_nat_range_old", then the idea is
> to dump the old representation into the new one, something like:
> 
>          struct nf_nat_range range = {};
> 
>          memcpy(&range, range_old, sizeof(range_old));

I did think about this but then checked other xt modules with multiple revisions :
xt_hashlimit.c - struct xt_hashlimit_mtinfo3
xt_conntrack.c - struct xt_conntrack_mtinfo3
xt_mark.c - struct xt_mark_tginfo2

But you prefer changing uapi/linux/netfilter/nf_nat.h with something like this ?

+struct nf_nat_range1 {
+       unsigned int                    flags;
+       union nf_inet_addr              min_addr;
+       union nf_inet_addr              max_addr;
+       union nf_conntrack_man_proto    min_proto;
+       union nf_conntrack_man_proto    max_proto;
+};
+
 struct nf_nat_range {
        unsigned int                    flags;
        union nf_inet_addr              min_addr;
        union nf_inet_addr              max_addr;
        union nf_conntrack_man_proto    min_proto;
        union nf_conntrack_man_proto    max_proto;
+       union nf_conntrack_man_proto    base_proto;
 };

In your reply to my first patch proposal you mentioned the backwards compatibility problem regarding userspace applications.
The new revisions for SNAT and DNAT target do keep ABI constant, but changing the current nf_nat_range definition will impact API (although it won't trigger any compile errors because new nf_nat_range is a simple superset of the current definition).
Is that ok for you then ?
