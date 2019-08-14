Return-Path: <SRS0=qEnH=WK=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.0 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 51979C0650F
	for <netfilter-devel@archiver.kernel.org>; Wed, 14 Aug 2019 07:53:05 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 2647B2054F
	for <netfilter-devel@archiver.kernel.org>; Wed, 14 Aug 2019 07:53:05 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=azazel.net header.i=@azazel.net header.b="sv6t142v"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726986AbfHNHxE (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 14 Aug 2019 03:53:04 -0400
Received: from kadath.azazel.net ([81.187.231.250]:48214 "EHLO
        kadath.azazel.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726527AbfHNHxE (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 14 Aug 2019 03:53:04 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=azazel.net;
         s=20190108; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=Z1ZeiPXHySZ5F4wBRu7h0kUAhRu1wtbKLF8v1Xq92fM=; b=sv6t142vddKN1Wb4PeX3Tcvr2W
        YkwiYzm9mC8WuG0uiVNMJ6sDqKsiYNYYT0Gt139x93usmtVwxfvV3IJJC5iXjkWA2fEOJ32gREVMw
        yGl28iOIjJeD3HsP+gv7xHKI8d9BXjerk2x55Ae0TaUbthY4AdtdfuLXb0UQDcYrbU4wKu4Ld3ysP
        ixe30OfnUHzeiJvgG7oPS/bP1V+mUWK5g9HGYbH/HmSpVVY3IVPVAJjYpOoUbzosodj5mp20aGT4B
        DKAEj8X1L88nJsG/j4ay+FDTzzr00k4qWZEbvJS2uZ8YIlAfeJ7f/GcV+gQhAx6Xc81MDvUX4301z
        +j7gop3A==;
Received: from pnakotus.dreamlands.azazel.net ([2001:8b0:fb7d:d6d7:208:9bff:febe:32] helo=azazel.net)
        by kadath.azazel.net with esmtpsa (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <jeremy@azazel.net>)
        id 1hxo5b-0006bg-EX; Wed, 14 Aug 2019 08:52:59 +0100
Date:   Wed, 14 Aug 2019 08:52:59 +0100
From:   Jeremy Sowden <jeremy@azazel.net>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     kbuild-all@01.org, kbuild test robot <lkp@intel.com>,
        netfilter-devel@vger.kernel.org, coreteam@netfilter.org
Subject: Re: [nf-next:master 14/17]
 include/uapi/linux/netfilter_ipv6/ip6t_LOG.h:5:2: warning: #warning "Please
 update iptables, this file will be removed soon!"
Message-ID: <20190814075259.GA9536@azazel.net>
References: <201908140638.At0bDWvT%lkp@intel.com>
 <20190814074539.ort2lumte4gw3oix@salvia>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="VS++wcV0S1rZb1Fb"
Content-Disposition: inline
In-Reply-To: <20190814074539.ort2lumte4gw3oix@salvia>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-SA-Exim-Connect-IP: 2001:8b0:fb7d:d6d7:208:9bff:febe:32
X-SA-Exim-Mail-From: jeremy@azazel.net
X-SA-Exim-Scanned: No (on kadath.azazel.net); SAEximRunCond expanded to false
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org


--VS++wcV0S1rZb1Fb
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On 2019-08-14, at 09:45:39 +0200, Pablo Neira Ayuso wrote:
> On Wed, Aug 14, 2019 at 06:05:49AM +0800, kbuild test robot wrote:
> > tree:   https://kernel.googlesource.com/pub/scm/linux/kernel/git/pablo/nf-next.git master
> > head:   105333435b4f3b21ffc325f32fae17719310db64
> > commit: 2a475c409fe81a76fb26a6b023509d648237bbe6 [14/17] kbuild: remove all netfilter headers from header-test blacklist.
> > config: sparc64-allmodconfig (attached as .config)
> > compiler: sparc64-linux-gcc (GCC) 7.4.0
> > reproduce:
> >         wget https://raw.githubusercontent.com/intel/lkp-tests/master/sbin/make.cross -O ~/bin/make.cross
> >         chmod +x ~/bin/make.cross
> >         git checkout 2a475c409fe81a76fb26a6b023509d648237bbe6
> >         # save the attached .config to linux build tree
> >         GCC_VERSION=7.4.0 make.cross ARCH=sparc64
> >
> > If you fix the issue, kindly add following tag
> > Reported-by: kbuild test robot <lkp@intel.com>
> >
> > All warnings (new ones prefixed by >>):
> >
> >    In file included from <command-line>:0:0:
> > >> include/uapi/linux/netfilter_ipv6/ip6t_LOG.h:5:2: warning: #warning "Please update iptables, this file will be removed soon!" [-Wcpp]
> >     #warning "Please update iptables, this file will be removed soon!"
> >      ^~~~~~~
>
> I'd suggest you send me a patch to remove this #warning.
>
> userspace iptables still refer to this header. The intention was to
> use xt_LOG.h instead and remove these, but userspace was never
> updated.

Was just preparing one to add "#ifndef __KERNEL__" guards to the
warnings.  I'll remove them instead.

J.

--VS++wcV0S1rZb1Fb
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAABCgAdFiEEZ8d+2N/NBLDbUxIF0Z7UzfnX9sMFAl1Tvc8ACgkQ0Z7UzfnX
9sMchxAAr1Jzv9XvvKQ1G6KHrs2zGVm9yyg0JdgKdUh8IhPdeSJVo6LCVY2R5cR8
XRj20Q72BVpX+hSQcIixVCfRbTk/m1J+TXVzWhlMAw2Iao7OQ1FTb14yYa/7uhY9
QYC4R8oxhivlA4R1j5lse2aqZNu3VHWY+BCRngVdQgU883h5Mm4W8Ucuovc7DjsK
mO/UQTVhXRV06AwSVqsroNB3jjN2Y+CbizmwG9ZvhMa0BrA+feawdrjQLMuRAznY
KvoIHJskeZ+5nn/R8Y3SU8OmdLPe/WxtaKMw/5STL8Kv/D97yqNTcPZp0euEuSOk
loMKWVUIIXNo4UQ95OwWjMi9dFXPHWOrUi+JV8EaMWbFqTtf1DqYAlQRJnYJZFDp
Mq4azT9OhhEGfOQdCKpHBDY7XNGNvvmiya23tULR6WpFOzmUK+R2Nmemo6e3Nd/9
7brPIxmk7biYeBb1wCKJu+dUkXbtiwxq5h71gN0hIRc8WV7kAp8GXB3IvOY70NV7
qf744QIYcY51F6qUsbINzQE30089xbdCLTc/ybLAJtIeBK0GurfJFUQWmLzC8Kfn
kYj0zn7zFhUtS68hmH8jRGJjg8VD81PNZI24a4fvpgPElGmKOfB4vc6c/l9i0+qJ
poqhhp5zNu76Tb9dBfkJ/+EW37MsQC/ZUmF+DJM4wWrnKZhqCEg=
=dEhD
-----END PGP SIGNATURE-----

--VS++wcV0S1rZb1Fb--
