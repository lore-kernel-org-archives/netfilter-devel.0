From: "billbonaparte" <programme110@gmail.com>
Subject: netfilter: nf_conntrack: there maybe a bug in __nf_conntrack_confirm, when it race against get_next_corpse
Date: Tue, 28 Oct 2014 11:27:43 +0800
Message-ID: <02ee01cff25f$28808540$79818fc0$@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
Cc: "'Changli Gao'" <xiaosuo@gmail.com>,
	"'Jozsef Kadlecsik'" <kadlec@blackhole.kfki.hu>,
	"'Jesper Dangaard Brouer'" <brouer@redhat.com>,
	"'Andrey Vagin'" <avagin@openvz.org>
To: <linux-kernel@vger.kernel.org>,
	"Netfilter Developer Mailing List" <netfilter-devel@vger.kernel.org>,
	"'Pablo Neira Ayuso'" <pablo@netfilter.org>,
	"'Patrick McHardy'" <kaber@trash.net>, <kadlec@blackhole.kfki.hu>,
	<davem@davemloft.net>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-pa0-f45.google.com ([209.85.220.45]:50183 "EHLO
	mail-pa0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753461AbaJ1D2P (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 27 Oct 2014 23:28:15 -0400
Content-Language: zh-cn
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hi, all:
	In function __nf_conntrack_confirm, we check the conntrack if it was
alreay dead, before insert it into hash-table. 
	we do this because if we insert an already 'dead' hash,  it will
block further use of that particular connection.
	but we don't do that right.
    let's consider the following case:
	
	cpu1
cpu2
	__nf_conntrack_confirm
get_next_corpse
   		lock corresponding hash-list
....
		check nf_ct_is_dying(ct)
for_each_possible_cpu(cpu) {
		......
spin_lock_bh(&pcpu->lock);
		......
set_bit(IPS_DYING_BIT, &ct->status);
		nf_ct_del_from_dying_or_unconfirmed_list(ct);
spin_unlock_bh(&pcpu_lock);
		add_timer(&ct->timeout);
}	
		ct->status |= IPS_CONFIRMD;
		__nf_conntrack_hash_insert(ct);


	
	The above case reveal two problems:
	1. we may insert a dead conntrack to hash-table, it will block
further use of that particular connection.
	2. operation on ct->status should be atomic, because it race aginst
get_next_corpse.
	  due to this reason, the operation on ct->status in
nf_nat_setup_info should be atomic as well.

	if we want to resolve the first problem, we must delete the
unconfirmed conntrack from unconfirmed-list first, then check if it is
already dead.
	Am I right to do this ?
	Appreciate any comments and reply.

