From: kuznet@ms2.inr.ac.ru
Subject: Re: 2.6 IPSEC + SNAT
Date: Tue, 7 Oct 2003 16:51:22 +0400 (MSD)
Sender: linux-net-owner@vger.kernel.org
Message-ID: <200310071251.QAA32679@yakov.inr.ac.ru>
References: <20031001121648.GA8755@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Cc: davem@redhat.com, jmorris@redhat.com, linux-net@vger.kernel.org,
	netfilter-devel@lists.netfilter.org
Return-path: <linux-net-owner@vger.kernel.org>
To: herbert@gondor.apana.org.au (Herbert Xu)
In-Reply-To: <20031001121648.GA8755@gondor.apana.org.au> from "Herbert Xu" at  =?ISO-8859-1?Q?=20=EF?=
	=?ISO-8859-1?Q?=CB=D4?= 01, 2003 10:16:48
List-Id: netfilter-devel.vger.kernel.org

Hello!

> Has anyone else thought about this problem?

I thought about this (ages ago, so this can be stale)
The verdict was that self-consistent picture is possible only
when NAT rules are integral part of SPD. It does not look like
a stimulating idea. :-)


> I have considered introducing a new NAT chain between filtering
> and routing where you can place SNAT rules into.

I do not understand this. In this case IPsec is to be applied to _translated_
packet, is not it? Am I wrong? If I am not wrong, there is no place to add
an additional hook.

Alexey
