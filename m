Return-Path: <SRS0=WbMd=5D=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 74224C10DCE
	for <netfilter-devel@archiver.kernel.org>; Wed, 18 Mar 2020 11:06:56 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 547542076D
	for <netfilter-devel@archiver.kernel.org>; Wed, 18 Mar 2020 11:06:56 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727441AbgCRLG4 (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 18 Mar 2020 07:06:56 -0400
Received: from orbyte.nwl.cc ([151.80.46.58]:35290 "EHLO orbyte.nwl.cc"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726586AbgCRLGz (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 18 Mar 2020 07:06:55 -0400
Received: from n0-1 by orbyte.nwl.cc with local (Exim 4.91)
        (envelope-from <n0-1@orbyte.nwl.cc>)
        id 1jEWXF-0006md-TS; Wed, 18 Mar 2020 12:06:53 +0100
Date:   Wed, 18 Mar 2020 12:06:53 +0100
From:   Phil Sutter <phil@nwl.cc>
To:     "MELCHOR PENA, Bernardo Santiago" <B.S.Melchor-Pena@iaea.org>
Cc:     "netfilter-devel@vger.kernel.org" <netfilter-devel@vger.kernel.org>
Subject: Re: compilation of netfilter missing libnftnl functions - undefined
 reference - (RASPBERRY pi 3B)
Message-ID: <20200318110653.GA7493@orbyte.nwl.cc>
Mail-Followup-To: Phil Sutter <phil@nwl.cc>,
        "MELCHOR PENA, Bernardo Santiago" <B.S.Melchor-Pena@iaea.org>,
        "netfilter-devel@vger.kernel.org" <netfilter-devel@vger.kernel.org>
References: <AM0PR01MB62900376D6F0DCAA682DB966F6F90@AM0PR01MB6290.eurprd01.prod.exchangelabs.com>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="KsGdsel6WgEHnImy"
Content-Disposition: inline
In-Reply-To: <AM0PR01MB62900376D6F0DCAA682DB966F6F90@AM0PR01MB6290.eurprd01.prod.exchangelabs.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org


--KsGdsel6WgEHnImy
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hi,

On Mon, Mar 16, 2020 at 08:16:28AM +0000, MELCHOR PENA, Bernardo Santiago wrote:
> After downloading snapshots for NFTABLES and LIBNFTNL for 20200314 I proceeded to compile both library and NFTABLES
> 
> Library compiled with no errors.
> libnftnl installed in /usr/local/lib
> 
> pi@raspberrypi:~/nftables-20200314 $ ls -lia /usr/local/lib/libnftnl.*
> 130735 -rwxr-xr-x 1 root root 974 Mar 15 10:55 /usr/local/lib/libnftnl.la
> 150748 lrwxrwxrwx 1 root root 18 Mar 15 10:55 /usr/local/lib/libnftnl.so -> libnftnl.so.11.2.0
> 150737 lrwxrwxrwx 1 root root 18 Mar 15 10:55 /usr/local/lib/libnftnl.so.11 -> libnftnl.so.11.2.0
> 130734 -rwxr-xr-x 1 root root 969712 Mar 15 10:55 /usr/local/lib/libnftnl.so.11.2.0
> 
> 
> nftables gives this error when compiling with Make
> 
> /usr/bin/ld: ./.libs/libnftables.so: undefined reference to `nftnl_flowtable_set_data@LIBNFTNL_13'
> /usr/bin/ld: ./.libs/libnftables.so: undefined reference to `nftnl_udata_nest_end@LIBNFTNL_14'
> /usr/bin/ld: ./.libs/libnftables.so: undefined reference to `nftnl_obj_set_data@LIBNFTNL_13'
> /usr/bin/ld: ./.libs/libnftables.so: undefined reference to `nftnl_flowtable_get_u64@LIBNFTNL_11'
> /usr/bin/ld: ./.libs/libnftables.so: undefined reference to `nftnl_flowtable_set_u64@LIBNFTNL_11'
> /usr/bin/ld: ./.libs/libnftables.so: undefined reference to `nftnl_udata_nest_start@LIBNFTNL_14'
> 
> I have tried to  point link under nftables-20200314/src/.libs
> to point to /usr/local/lib with ln -sf /usr/local/lib/libnftnl.so ./libnftables.so

Looks like you're compiling against host's libnftnl by accident. Have a
look at the build script I attached to this email. Put it into nftables
TOPDIR and adjust LIBNFTNL_PATH, then call as regular user.

Cheers, Phil

--KsGdsel6WgEHnImy
Content-Type: application/x-sh
Content-Disposition: attachment; filename="full_rebuild.sh"
Content-Transfer-Encoding: quoted-printable

#!/bin/bash=0A#=0A# Recompile both libnftnl and nftables so that nft does n=
ot use the host=0A# libnftnl anymore.=0A=0ALIBNFTNL_PATH=3D/home/$USER/git/=
libnftnl=0A=0Acd "$(dirname $0)"=0A=0A# first libnftnl build=0Acd $LIBNFTNL=
_PATH=0Arm -rf install=0A./autogen.sh=0A./configure --enable-static --prefi=
x=3D"$PWD/install" || {=0A	echo "libnftnl: configure failed"=0A	exit 1=0A}=
=0Amake clean=0Amake || { echo "libnftnl: make failed"; exit 2; }=0Amake in=
stall || { echo "libnftnl: make install failed"; exit 3; }=0Acd -=0A=0A# no=
w build nftables and link against static libnftnl=0A./autogen.sh=0A./config=
ure --enable-static --enable-shared --with-json --with-xtables \=0A	--prefi=
x=3D"$PWD/install" \=0A	PKG_CONFIG_PATH=3D"${LIBNFTNL_PATH}/install/lib/pkg=
config"=0A#	CFLAGS=3D"-fprofile-arcs -ftest-coverage"=0A[[ $? -eq 0 ]] || {=
 echo "nftables: configure failed"; exit 4; }=0Amake clean=0Amake V=3D1 || =
{ echo "nftables: make failed"; exit 5; }=0Amake install || { echo "nftable=
s: make install failed"; exit 6; }=0A
--KsGdsel6WgEHnImy--
