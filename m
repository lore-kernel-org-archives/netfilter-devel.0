From: Shiyao Ma <i@introo.me>
Subject: how to get consistent value of "nf_conntrack_htable_size" and
 "nf_conntrack_hash" in a kernel module ?
Date: Fri, 7 Jul 2017 23:55:25 +0800
Message-ID: <1DAD1BCA-3138-4A7E-B64E-405EA12E6111@introo.me>
Mime-Version: 1.0 (Mac OS X Mail 10.3 \(3273\))
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: quoted-printable
To: netfilter-devel@vger.kernel.org,
        kernelnewbies <kernelnewbies@kernelnewbies.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-pg0-f41.google.com ([74.125.83.41]:33499 "EHLO
        mail-pg0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752000AbdGGPza (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 7 Jul 2017 11:55:30 -0400
Received: by mail-pg0-f41.google.com with SMTP id k14so19236970pgr.0
        for <netfilter-devel@vger.kernel.org>; Fri, 07 Jul 2017 08:55:29 -0700 (PDT)
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hi,

I want to foreach all the `struct nf_conn's in my out-of-tree kernel =
module.

My plan is to get the `nf_conntrack_htable_size' and =
`nf_conntrack_hash', then do some read on the hash table.

However, the symbol `nf_conntrack_generation' is not exported, so I =
cannot do things like this:

struct hlist_nulls_head *hptr;
unsigned int sequence, hsz;

do {
    sequence =3D read_seqcount_begin(&nf_conntrack_generation);
    hsz =3D nf_conntrack_htable_size;
    hptr =3D nf_conntrack_hash;
} while (read_seqcount_retry(&nf_conntrack_generation, sequence));


How to get a consistent value of `nf_conntrack_htable_size' and =
`nf_conntrack_hash' ?


Thanks.=
