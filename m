From: Patrick McHardy <kaber@trash.net>
Subject: Re: [BUG] Conntrack SIP Problem
Date: Thu, 14 Jun 2007 14:54:10 +0200
Message-ID: <46713A72.7010604@trash.net>
References: <E1HyFtX-0001fw-00@gondolin.me.apana.org.au> <Pine.LNX.4.64.0706140902250.1844@knorkaan.xs4all.nl> <20070614104919.GA24945@gondor.apana.org.au> <Pine.LNX.4.64.0706141253460.1919@knorkaan.xs4all.nl> <20070614124857.GA25863@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Cc: Jerome Borsboom <j.borsboom@erasmusmc.nl>,
	michael.rack@rsm-freilassing.de, linux-net@vger.kernel.org,
	Netfilter Development Mailinglist
	<netfilter-devel@lists.netfilter.org>
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-net-owner@vger.kernel.org>
In-Reply-To: <20070614124857.GA25863@gondor.apana.org.au>
Sender: linux-net-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

[CCed netfilter-devel]

Herbert Xu wrote:
> We should correlate the RTP addresses in the SIP packets and setup
> a correct expectation once both are received.


This is a bit of a problem because if we want to NAT the port,
we can't guarantee that its still unused when we finally set
up the expectation. We'd need a way to reserve ports to make
this work reliable.

