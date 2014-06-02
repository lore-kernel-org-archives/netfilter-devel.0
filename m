From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH] driver/netfilter/nfnetlink: removed unused variable
Date: Mon, 2 Jun 2014 10:06:56 +0200
Message-ID: <20140602080656.GB4923@localhost>
References: <20140531110628.GA30443@shodan.fritz.box>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: netfilter-devel@vger.kernel.org
To: Robin Schroer <sulamiification@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:54638 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751567AbaFBIHE (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 2 Jun 2014 04:07:04 -0400
Content-Disposition: inline
In-Reply-To: <20140531110628.GA30443@shodan.fritz.box>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Sat, May 31, 2014 at 01:06:28PM +0200, Robin Schroer wrote:
> Removes the unused struct net *net =3D sock_net(skb->sk);

David already applied a patch for this in master.

commit a64d90fd962c2956da7505f98a302408450365e2
Author: David S. Miller <davem@davemloft.net>
Date:   Thu Apr 24 13:51:29 2014 -0400

    netfilter: Fix warning in nfnetlink_receive().
   =20
    net/netfilter/nfnetlink.c: In function =E2=80=98nfnetlink_rcv=E2=80=
=99:
    net/netfilter/nfnetlink.c:371:14: warning: unused variable =E2=80=98=
net=E2=80=99 [-Wunused-variable]

Thanks anyway.
--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
