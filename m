From: =?iso-8859-2?Q?Ond=F8ej_Slanina?= <oslanina@kerio.com>
Subject: Re: netfilter 03/03: nf_queue: fix NF_STOLEN skb leak
Date: Tue, 17 May 2011 13:25:16 +0200
Message-ID: <AD57A470C4C54FD5BC30CAD5BCE0D0D8@kerio.local>
References: <20100219170206.18096.12788.sendpatchset@x2.localnet> <20100219170210.18096.32795.sendpatchset@x2.localnet>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-2;
	format=flowed	reply-type=original
Content-Transfer-Encoding: QUOTED-PRINTABLE
To: <netfilter-devel@vger.kernel.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mx1.kerio.com ([195.113.184.2]:53184 "EHLO mx1.kerio.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753987Ab1EQL5J (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 17 May 2011 07:57:09 -0400
Received: from localhost ([127.0.0.1])
	by mx1.kerio.com
	(using TLSv1/SSLv3 with cipher AES256-SHA (256 bits))
	for netfilter-devel@vger.kernel.org;
	Tue, 17 May 2011 13:25:47 +0200
Received: from localhost ([127.0.0.1])
	by bes-test.kerio.local
	(using TLSv1/SSLv3 with cipher AES128-SHA (128 bits))
	for netfilter-devel@vger.kernel.org;
	Tue, 17 May 2011 13:25:41 +0200
In-Reply-To: <20100219170210.18096.32795.sendpatchset@x2.localnet>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hi,
I know that this patch were applied a long time ago but unfortunately I=
=20
worked all the time on old 2.6.32 kernel. I am confused, because=20
documentation said that returning NF_STOLEN means that netfilter releas=
e=20
ownership of this skb and my hook/queue function is responsible for=20
deallocating of this skb. But from now, It's true only for function=20
registered by nf_register_hooks (for example defrag function still uses=
=20
NF_STOLEN verdict when performing packed defragmentation). For function=
=20
registered by nf_register_queue_handler() it's not true, because NF_STO=
LEN=20
wil free skb! It's the same as NF_DROP. I have no chance to get ownersh=
ip of=20
skb after call to nf_reinject. Or I am missed something ?
Best Regards,
Ondrej Slanina


-----P=F9vodn=ED zpr=E1va-----=20
=46rom: Patrick McHardy
Sent: Friday, February 19, 2010 6:02 PM
To: davem@davemloft.net
Cc: netdev@vger.kernel.org ; Patrick McHardy ;=20
netfilter-devel@vger.kernel.org
Subject: netfilter 03/03: nf_queue: fix NF_STOLEN skb leak

commit 64507fdbc29c3a622180378210ecea8659b14e40
Author: Eric Dumazet <eric.dumazet@gmail.com>
Date:   Fri Feb 19 15:28:38 2010 +0100

    netfilter: nf_queue: fix NF_STOLEN skb leak

    commit 3bc38712e3a6e059 (handle NF_STOP and unknown verdicts in
    nf_reinject) was a partial fix to packet leaks.

    If user asks NF_STOLEN status, we must free the skb as well.

    Reported-by: Afi Gjermund <afigjermund@gmail.com>
    Signed-off-by: Eric DUmazet <eric.dumazet@gmail.com>
    Signed-off-by: Patrick McHardy <kaber@trash.net>

diff --git a/net/netfilter/nf_queue.c b/net/netfilter/nf_queue.c
index 3a6fd77..ba095fd 100644
--- a/net/netfilter/nf_queue.c
+++ b/net/netfilter/nf_queue.c
@@ -265,7 +265,6 @@ void nf_reinject(struct nf_queue_entry *entry, unsi=
gned=20
int verdict)
  local_bh_disable();
  entry->okfn(skb);
  local_bh_enable();
- case NF_STOLEN:
  break;
  case NF_QUEUE:
  if (!__nf_queue(skb, elem, entry->pf, entry->hook,
@@ -273,6 +272,7 @@ void nf_reinject(struct nf_queue_entry *entry, unsi=
gned=20
int verdict)
  verdict >> NF_VERDICT_BITS))
  goto next_hook;
  break;
+ case NF_STOLEN:
  default:
  kfree_skb(skb);
  }
--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el"=20
in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html



--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
