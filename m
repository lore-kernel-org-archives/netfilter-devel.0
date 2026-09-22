Received: from sipsolutions.net (s3.sipsolutions.net [168.119.38.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7544C3ED5DA;
	Tue, 22 Sep 2026 05:56:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=168.119.38.16
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790056599; cv=none; b=KcRVoiwc3++qWp0gq0CUQ+Vryok2XOpm8Vj1/VZ2JYQ0ARTTdVYvRzmg+iGSKXQ87jWukXbj1JUS7LhiwVeaArFjVpWOD0B7WAaaeQ+UQufLeAj1Lr0L8yeB1sIYEJySnhETs766vM5YFnpBxpQbgd0wbTK9a2KYAg1yjED/oHE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790056599; c=relaxed/simple;
	bh=og44il2qA3A9kiF+37B7/rasittptoeYqRvvfkslOoQ=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=EMCXt6Dlf/887J1DFY3XEWDAjDDwZU8Z1whFQmgMXyhHF2f27jFy4Xno4I2QLcE1EcWrdq/rkIfjWrfqrPzlGi4x+n8KJt9aEwNjvFm3GE0jJLwlzuggi0uLcXomLYDIChAlKfzWi6M9lM5JxgaLn9z2NiVE3Bl2/nyYSBqLPb8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=permerror header.from=sipsolutions.net; spf=pass smtp.mailfrom=sipsolutions.net; dkim=pass (2048-bit key) header.d=sipsolutions.net header.i=@sipsolutions.net header.b=dnN3/4gV; arc=none smtp.client-ip=168.119.38.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=permerror header.from=sipsolutions.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=sipsolutions.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=sipsolutions.net header.i=@sipsolutions.net header.b="dnN3/4gV"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=sipsolutions.net; s=mail; h=MIME-Version:Content-Transfer-Encoding:
	Content-Type:References:In-Reply-To:Date:Cc:To:From:Subject:Message-ID:Sender
	:Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:Resent-To:
	Resent-Cc:Resent-Message-ID; bh=YV8xmrLfuB0pp6kkajjjm++EqC/+8Rwh/pdBHgNrjZk=;
	t=1790056598; x=1791266198; b=dnN3/4gV/YdlJNscHEK0ojLW/176P5+zWEaSMnzvlUUH74V
	iskellyNkM8x5/Ps8LyNjfju8Duq32ydCaVN9RfMV+NE7mtt8hcLNkNo0P0xXE6m4VpVGFOGblh7L
	BXdc1T3gVbemW6a7hGxiN7a7a34qajtyG6Mf3g37gHbZ67xeFqoQmurXeB1t7BFyyaVdSmoewS5T8
	rptXK2iCMtgaumh1GagugqfDg3agV86flkcU3PwT+TTpPhOchNWk8VAa6oLFzxdjZ3Le+hSWeFpQ+
	iv2qajtg6kTbRkWv42ZcoSnKGrMLgu2YcJLMGbBczVM7K6o0sewqoiQCuhLTNlPA==;
Received: by sipsolutions.net with esmtpsa (TLS1.3:ECDHE_X25519__ECDSA_SECP256R1_SHA256__AES_256_GCM:256)
	(Exim 4.98.2)
	(envelope-from <johannes@sipsolutions.net>)
	id 1x8tUO-00000006i1J-38TH;
	Tue, 22 Sep 2026 07:56:24 +0200
Message-ID: <aa560d2d2cbf94e50397740159c12e24e0ecf820.camel@sipsolutions.net>
Subject: Re: [PATCH net v6 1/2] net: validate virtio checksum start after
 network header
From: Johannes Berg <johannes@sipsolutions.net>
To: "Michael S. Tsirkin" <mst@redhat.com>, Paulos Yibelo
	 <habte.yibelo@gmail.com>
Cc: netdev@vger.kernel.org, richard@nod.at, anton.ivanov@cambridgegreys.com,
 	willemdebruijn.kernel@gmail.com, jasowangio@gmail.com,
 eperezma@redhat.com, 	xuanzhuo@linux.alibaba.com, andrew+netdev@lunn.ch,
 pablo@netfilter.org, 	fw@strlen.de, phil@nwl.cc, razor@blackwall.org,
 idosch@nvidia.com, 	dsahern@kernel.org, davem@davemloft.net,
 edumazet@google.com, kuba@kernel.org, 	pabeni@redhat.com, horms@kernel.org,
 linux-um@lists.infradead.org, 	virtualization@lists.linux.dev,
 netfilter-devel@vger.kernel.org, 	coreteam@netfilter.org,
 bridge@lists.linux.dev, linux-kernel@vger.kernel.org
Date: Tue, 22 Sep 2026 07:56:23 +0200
In-Reply-To: <20260922005353-mutt-send-email-mst@kernel.org>
References: <20260922030310.8684-1-habte.yibelo@gmail.com>
	 <20260922030310.8684-2-habte.yibelo@gmail.com>
	 <20260922005353-mutt-send-email-mst@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.60.2 (3.60.2-2.fc44) 
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-malware-bazaar: not-scanned

On Tue, 2026-09-22 at 01:14 -0400, Michael S. Tsirkin wrote:
>=20
> > =20
> > +/*
> > + * Return the L3 offset and protocol of an Ethernet frame starting at =
skb->data.
> > + * The offset is unused without NEEDS_CSUM, so avoid parsing and retur=
n zero.
> > + */
>=20
> for networking code multiline comments:
>=20
> /* always
>  * look like this
>  */
>=20
> /*
>  * never
>  * like this
>  */

This, for the record, is't really true any more - we dropped the special
rule a few years ago.

johannes
