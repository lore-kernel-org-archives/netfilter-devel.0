From: "billbonaparte" <programme110@gmail.com>
Subject: Re: netfilter: nf_conntrack: there maybe a bug in __nf_conntrack_confirm, when it race against get_next_corpse
Date: Tue, 4 Nov 2014 09:52:58 +0800
Message-ID: <01b101cff7d2$1715ef20$4541cd60$@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
Cc: "Netfilter Developer Mailing List" <netfilter-devel@vger.kernel.org>,
	"Pablo Neira Ayuso" <pablo@netfilter.org>,
	"Patrick McHardy" <kaber@trash.net>, <kadlec@blackhole.kfki.hu>,
	<davem@davemloft.net>, "Changli Gao" <xiaosuo@gmail.com>,
	"Andrey Vagin" <avagin@openvz.org>
To: "Jesper Dangaard Brouer" <brouer@redhat.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-pd0-f170.google.com ([209.85.192.170]:61831 "EHLO
	mail-pd0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751081AbaKDBxi (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 3 Nov 2014 20:53:38 -0500
Received: by mail-pd0-f170.google.com with SMTP id z10so12707767pdj.29
        for <netfilter-devel@vger.kernel.org>; Mon, 03 Nov 2014 17:53:38 -0800 (PST)
Content-Language: zh-cn
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

(sorry to send this e-mail again, last mail is rejected by server due to
non-acceptable content)

Jesper Dangaard Brouer <brouer@redhat.com> wrote:
>> In function __nf_conntrack_confirm, we check the conntrack if it was 
>> already dead, before insert it into hash-table.
>> We do this because if we insert an already 'dead' hash,  it will 
>> block further use of that particular connection.

>Have you run into this problem in practice, or is this based on a theory?

If we insert a dead conntrack into hash-table, let's see what will happen to
the packet which has the same tuple with that dead conntrack:
1) if it is a valid packet, it will enter in nf_conntrack_in hook, then
2) we will find a corresponding conntrack for that packet in
__nf_conntrack_find_get, and there is no doubt that we will find that dead
conntrack,
  according to the current implement, we don't use dead conntrack, so we
create a new conntrack which is unconfirmed.
3) because there is already a conntrack with the same tuples in hash-table,
the new conntrack can not be inserted into hash-table, it will return
NF_DROP,
4) the packet will be dropped due to the failure of nf_conntrack_confirm.
That's why inserting an already 'dead' hash will block further use of that
particular connection.

