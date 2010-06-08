From: Anand Raj Manickam <anandrm@gmail.com>
Subject: Redundant calls to nf_ct_tuplehash_to_ctrack
Date: Tue, 8 Jun 2010 19:48:42 +0530
Message-ID: <AANLkTikuYXpQrc3MECpkj_h8E19D5ZM07Li_CpqRYc7k@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-pw0-f46.google.com ([209.85.160.46]:43645 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755170Ab0FHOSp (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 8 Jun 2010 10:18:45 -0400
Received: by pwj5 with SMTP id 5so1307218pwj.19
        for <netfilter-devel@vger.kernel.org>; Tue, 08 Jun 2010 07:18:44 -0700 (PDT)
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

This my observation ..

There is a redundant call to nf_ct_tuplehash_to_ctrack() after every
nf_conntrack_find_get() call .

Why is ct not returned from nf_conntrack_find_get() , since in all the
occurances of nf_conntrack_find_get() there is immediate call to
nf_ct_tuplehash_to_ctrack() . Although  nf_ct_tuplehash_to_ctrack() is
invoked to check the ct after we get a valid hash .

Following the code snippet of nf_conntrack_find_get


struct nf_conntrack_tuple_hash *
nf_conntrack_find_get(struct net *net, u16 zone,
                      const struct nf_conntrack_tuple *tuple)
{
        struct nf_conntrack_tuple_hash *h;
        struct nf_conn *ct;

        rcu_read_lock();
begin:
        h = __nf_conntrack_find(net, zone, tuple);
        if (h) {
                ct = nf_ct_tuplehash_to_ctrack(h);
                if (unlikely(nf_ct_is_dying(ct) ||
                             !atomic_inc_not_zero(&ct->ct_general.use)))
                        h = NULL;
                else {
                        if (unlikely(!nf_ct_tuple_equal(tuple, &h->tuple) ||
                                     nf_ct_zone(ct) != zone)) {
                                nf_ct_put(ct);
                                goto begin;
                        }
                }
        }
        rcu_read_unlock();

        return h;
}
