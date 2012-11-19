From: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Subject: Re: [ANNOUNCE] ipset 6.15 released
Date: Mon, 19 Nov 2012 18:50:25 +0100 (CET)
Message-ID: <alpine.DEB.2.00.1211191847190.23128@blackhole.kfki.hu>
References: <alpine.DEB.2.00.1211191356240.21756@blackhole.kfki.hu> <CADuigkX_Mr_7ur=mta0DKhB7vmdXeAytBaDvP_zKHug5sO8zbg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: netfilter@vger.kernel.org, netfilter-devel@vger.kernel.org
To: Ricardo Klein <klein.rfk@gmail.com>
Return-path: <netfilter-owner@vger.kernel.org>
In-Reply-To: <CADuigkX_Mr_7ur=mta0DKhB7vmdXeAytBaDvP_zKHug5sO8zbg@mail.gmail.com>
Sender: netfilter-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

On Mon, 19 Nov 2012, Ricardo Klein wrote:

> It fails on ./configure on CentOS 6.3 x84_64 with the message:./configure: line
> 14702: syntax error near unexpected token `libmnl,'
> ./configure: line 14702: `PKG_CHECK_MODULES(libmnl, libmnl >= 1)'

It's funny, because that part was not touched at all. Can you successfully 
run "./configure" in ipset 6.14??

Best regards,
Jozsef
-
E-mail  : kadlec@blackhole.kfki.hu, kadlecsik.jozsef@wigner.mta.hu
PGP key : http://www.kfki.hu/~kadlec/pgp_public_key.txt
Address : Wigner Research Centre for Physics, Hungarian Academy of Sciences
          H-1525 Budapest 114, POB. 49, Hungary
