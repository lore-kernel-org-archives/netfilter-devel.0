From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: queuing to userspace for the bridge family, using nftables
Date: Thu, 16 Oct 2014 10:54:49 +0200
Message-ID: <20141016085449.GA8884@salvia>
References: <5432D0D2.5050905@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: netfilter-devel@vger.kernel.org
To: =?iso-8859-1?Q?st=E9phane?= bryant <stephane.ml.bryant@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:55014 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751194AbaJPIxW convert rfc822-to-8bit (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 16 Oct 2014 04:53:22 -0400
Content-Disposition: inline
In-Reply-To: <5432D0D2.5050905@gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Mon, Oct 06, 2014 at 07:26:42PM +0200, st=E9phane bryant wrote:
> Hello,
>=20
> We are currently working on a project which may need the use of nftab=
les
> to queue AF_BRIDGE packets to the userspace and back. Apparently this
> is already supported in the nftables code itself, but not in the
> bridge netfilter code (the corresponding nf_afinfo is missing, at lea=
st).
>=20
> I would like to know if there are plans to support this? If yes, in w=
hat
> timeframe? If no, would you be interested if we were to submit a patc=
h
> to that effect?

Please, submit patches.

> Also, what should be included in the payload send to userspace?
> (starting from the 802.3 LLC/protocol header, or also including up to
> the MAC addresses ?)

I think you have to include everything relevant from layer 2 upward. I
think it would be good if we indicate userspace that NFQA_PAYLOAD
starts from the mac header some way. So the same process can handle
packets coming from bridge and the ip layer.

Thanks.
--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
