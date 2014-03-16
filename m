From: "M.G." <mg887@yahoo.com>
Subject: Re: xt_CHAOS - PDE_DATA compilation error
Date: Sun, 16 Mar 2014 11:01:36 -0700 (PDT)
Message-ID: <1394992896.60188.YahooMailNeo@web121206.mail.ne1.yahoo.com>
References: <1394985214.54868.YahooMailNeo@web121203.mail.ne1.yahoo.com> <5325CFFB.7030206@chello.at>
Reply-To: "M.G." <mg887@yahoo.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
To: "netfilter-devel@vger.kernel.org" <netfilter-devel@vger.kernel.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from nm44.bullet.mail.ne1.yahoo.com ([98.138.120.51]:32271 "HELO
	nm44.bullet.mail.ne1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1753281AbaCPSB4 convert rfc822-to-8bit
	(ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Sun, 16 Mar 2014 14:01:56 -0400
In-Reply-To: <5325CFFB.7030206@chello.at>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>






On Sunday, March 16, 2014 5:22 PM, Mart Frauenlob <mart.frauenlob@chell=
o.at> wrote:
On 16.03.2014 16:53, M.G. wrote:
>
> Today at 1:49 PM
> Hello Everyone,
>
>
> in Centos 6 x64 with kernel 2.6.32-431.3.1.el6.centos.plus.x86_64=A0 =
I have compilation error with=A0 conflicting types for PDE_DATA.
> How to fix it ?
> Is it possible to exclude this xt_CHAOS module from compilation ?

I think you can modify 'mconfig' to:

build_CHAOS=3D

so it won't be built.



Yes you are right, but I have the same compilation errror in xt_geoip.c=
=A0
Any idea how to fix it ?


Best regards
--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
