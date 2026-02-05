Received: from orbyte.nwl.cc (orbyte.nwl.cc [151.80.46.58])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0548035502A
	for <netfilter-devel@vger.kernel.org>; Thu,  5 Feb 2026 14:27:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=151.80.46.58
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770301678; cv=none; b=gKDgs+l7xxXrd8I2QY/kxAk+E8cr6JzcdOTaGAbi64iwcllbtpI/G56cu/opJ6QP2+SwaTFLFIsFKZdy6KwG45ksyx2DAFVotrdPA4sfuGjehC27kuYNKNQqXaM9dBtk0s/Qm5ePdFkA8TaMX1HXa7RKneysc4Aj0UWPufAjb6s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770301678; c=relaxed/simple;
	bh=wMPpQ6l48WALPrmuGS7KcmaaKFA4O0LG/9/WqQM60fw=;
	h=Date:From:To:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=s0+IgZaTQIO8w+ISeb7uLOmf4BLQEENfxaEJEM521/PKbPEQXSEH6sFhr2gfcL8+QuUmDmb3MMTamQYszUjmyIiq0CGGCaa0DMKZLQ0k3ey/hq3F9Km/KfDW2H6CpOgzt66CFfpKrGL/idU3tGBho5JG1KAFOeoEDcGUIPv5whg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc; spf=pass smtp.mailfrom=nwl.cc; dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b=Gx9yq8FK; arc=none smtp.client-ip=151.80.46.58
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nwl.cc
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b="Gx9yq8FK"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nwl.cc;
	s=mail2022; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
	Subject:To:From:Date:Sender:Reply-To:Cc:Content-Transfer-Encoding:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=540U3a7jnFoCnrKIXj3/FQYBNLV1Fw2Y5ICRd/Hg4fo=; b=Gx9yq8FKLJZBhIQtk404zErETy
	22LpCG4mLGcsmwjEaJp6TCTBpI1k1/Frn9Mv71wSXIUFkD3b02cqmb/25oUSRqVPPUC0+hZ2imMDA
	YCirutuQlLD/3bb7rZyO1eRDLHcCc/tt9tUzVCSeXNhR6uRUxPTV+Z0QcrTMrPW7jVPygDQHg1iTd
	m3nnXiAoI3sEm0JNy30lsPnMy+8/D4nSP61QXOfjiRK0BwfV0M4BXJqgmYGBsTCnhHRBku80pQtT5
	XCwAXlNReickaotzCw/DU8Ip5CL8WYlmvJjHrHWr4Rsx2It+FXaQ6Nv4kjDq8cRyHKC7v3ub2mdMH
	MKV+tS6w==;
Received: from n0-1 by orbyte.nwl.cc with local (Exim 4.98.2)
	(envelope-from <phil@nwl.cc>)
	id 1vo0Kq-000000002TL-1rXK;
	Thu, 05 Feb 2026 15:27:56 +0100
Date: Thu, 5 Feb 2026 15:27:56 +0100
From: Phil Sutter <phil@nwl.cc>
To: Pablo Neira Ayuso <pablo@netfilter.org>,
	netfilter-devel@vger.kernel.org
Subject: Re: [nft PATCH] Makefile: Set PKG_CONFIG_PATH env for 'make check'
Message-ID: <aYSo7O8bOB1uAStR@orbyte.nwl.cc>
Mail-Followup-To: Phil Sutter <phil@nwl.cc>,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	netfilter-devel@vger.kernel.org
References: <20260127221657.28148-1-phil@nwl.cc>
 <aYPzQOgGxpacVYMV@chamomile>
 <aYSoDgjTbH9t5Na6@orbyte.nwl.cc>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="jU06t90bjaNrwqif"
Content-Disposition: inline
In-Reply-To: <aYSoDgjTbH9t5Na6@orbyte.nwl.cc>


--jU06t90bjaNrwqif
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Thu, Feb 05, 2026 at 03:24:14PM +0100, Phil Sutter wrote:
> On Thu, Feb 05, 2026 at 02:32:48AM +0100, Pablo Neira Ayuso wrote:
> > On Tue, Jan 27, 2026 at 11:15:58PM +0100, Phil Sutter wrote:
> > > When building nftables git HEAD, I use a script which also builds libmnl
> > > and libnftnl in their respective repositories and populates
> > > PKG_CONFIG_PATH variable so nftables is linked against them instead of
> > > host libraries. This is mandatory as host-installed libraries are
> > > chronically outdated and linking against them would fail.
> > 
> > How do you use this?
> 
> Please kindly find aforementioned build script attached to this mail.
> Then I just call 'make check' in the built nftables source tree.

Gna. Attached now.

> This patch's logic is: "If a custom PKG_CONFIG_PATH was needed to build
> the sources, it is needed for build test suite as well."
> 
> > > Same situation exists with build test suite. Luckily the PKG_CONFIG_PATH
> > > variable value used to build the project is cached in Makefiles and
> > > Automake supports populating test runners' environment.
> > > 
> > > Signed-off-by: Phil Sutter <phil@nwl.cc>
> > > ---
> > > Pablo: Could you please confirm this does not break your workflow? I
> > > recall you relied upon build test suite while it never passed for me due
> > > to the reasons described above.
> > 
> > Just run `make distcheck' or tests/build/ to check, I think that
> > should be enough.
> 
> Well, 'make distcheck' should not be affected by this patch since it
> does not run the test suites (df19bf51d49be ("Makefile: Enable support
> for 'make check'")).
> 
> But you have a point there, the logic from above applies to the VPATH
> build performed by 'make distcheck', too. I'll respin with added chunk:
> 
> | --- a/Makefile.am
> | +++ b/Makefile.am
> | @@ -23,7 +23,8 @@ libnftables_LIBVERSION = 2:0:1
> |  ###############################################################################
> |  
> |  ACLOCAL_AMFLAGS = -I m4
> | -AM_DISTCHECK_CONFIGURE_FLAGS = --enable-distcheck
> | +AM_DISTCHECK_CONFIGURE_FLAGS = --enable-distcheck \
> | +                              PKG_CONFIG_PATH=$(PKG_CONFIG_PATH)
> |  
> |  EXTRA_DIST =
> |  BUILT_SOURCES =
> 
> Thanks, Phil

--jU06t90bjaNrwqif
Content-Type: application/x-sh
Content-Disposition: attachment; filename=full_rebuild.sh
Content-Transfer-Encoding: quoted-printable

#!/bin/bash=0A#=0A# (fetch and) compile vanilla libmnl, libnftnl and nftabl=
es=0A=0ALIBNFTNL_PATH=3D$(realpath ../libnftnl)=0ALIBMNL_PATH=3D$(realpath =
=2E./libmnl)=0AIPTABLES_PATH=3D$(realpath ../iptables)=0AFETCH_MISSING=3Dfa=
lse=0ACORES=3D$(grep -c '^processor' /proc/cpuinfo)=0AMAKE=3D"make -j${CORE=
S}"=0ACLI=3Dreadline=0A#CLI=3Deditline=0A#CLI=3Dlinenoise=0AMINI_GMP=3D1=0A=
LUSER=3Dn0-1=0ASSH_CLIENT=3D${SSH_CLIENT%% *}=0A=0A# get all the dependenci=
es if needed=0Aif [[ -e /etc/redhat-release ]]; then=0A	# for jansson-devel=
=0A	crb_repo=3D/etc/yum.repos.d/rhel-CRB-latest.repo=0A	[[ -f $crb_repo ]] =
&& sed -i -e 's/\(enabled\)=3D0/\1=3D1/g' $crb_repo=0A	for pkg in iptables-=
devel readline-devel asciidoc gmp-devel jansson-devel libtool make gcc auto=
conf git bison flex bison-devel flex-devel python3-jsonschema; do=0A		rpm -=
q $pkg || dnf install -y $pkg=0A	done=0A	CLI=3Dreadline=0A	FETCH_MISSING=3D=
true=0Afi=0A=0Acd "$(dirname $0)"=0A=0Aif [[ -f nftables/src/libnftables.c =
]]; then=0A	cd nftables=0Aelif [[ ! -f src/libnftables.c ]]; then=0A	git cl=
one git://git.netfilter.org/nftables || exit 1=0A	cd nftables=0A	[[ -n ${SS=
H_CLIENT} ]] && \=0A		git remote add ssh ${LUSER}@${SSH_CLIENT}:git/nftable=
s=0Afi=0ALIBNFTNL_PATH=3D$(realpath ../libnftnl)=0ALIBMNL_PATH=3D$(realpath=
 ../libmnl)=0AIPTABLES_PATH=3D$(realpath ../iptables)=0A=0Aif [[ ! -d $LIBM=
NL_PATH ]] && $FETCH_MISSING; then=0A	git clone git://git.netfilter.org/lib=
mnl $LIBMNL_PATH=0A	[[ -n ${SSH_CLIENT} ]] && \=0A		git -C $LIBMNL_PATH rem=
ote add \=0A			ssh ${LUSER}@${SSH_CLIENT}:git/libmnl=0Afi=0Aif [[ -d $LIBMN=
L_PATH ]]; then=0A	# first libmnl build=0A	cd $LIBMNL_PATH=0A	rm -rf instal=
l=0A	make clean=0A	./autogen.sh=0A	./configure --enable-static --enable-sha=
red --prefix=3D"$PWD/install" || {=0A		echo "libmnl: configure failed"=0A		=
exit 1=0A	}=0A	$MAKE || { echo "libmnl: make failed"; exit 2; }=0A	make ins=
tall || { echo "libmnl: make install failed"; exit 3; }=0A	cd -=0A=0A	expor=
t PKG_CONFIG_PATH=3D"${LIBMNL_PATH}/install/lib/pkgconfig:${PKG_CONFIG_PATH=
}"=0Afi=0A=0Aif [[ ! -d $LIBNFTNL_PATH ]] && $FETCH_MISSING; then=0A	git cl=
one git://git.netfilter.org/libnftnl $LIBNFTNL_PATH=0A	[[ -n ${SSH_CLIENT} =
]] && \=0A		git -C $LIBNFTNL_PATH remote add \=0A			ssh ${LUSER}@${SSH_CLIE=
NT}:git/libnftnl=0Afi=0Aif [[ -d $LIBNFTNL_PATH ]]; then=0A	cd $LIBNFTNL_PA=
TH=0A	rm -rf install=0A	make clean=0A	./autogen.sh=0A	./configure --enable-=
static --enable-shared --prefix=3D"$PWD/install" || {=0A		echo "libnftnl: c=
onfigure failed"=0A		exit 1=0A	}=0A	$MAKE || { echo "libnftnl: make failed"=
; exit 2; }=0A	make install || { echo "libnftnl: make install failed"; exit=
 3; }=0A	cd -=0A=0A	export PKG_CONFIG_PATH=3D"${LIBNFTNL_PATH}/install/lib/=
pkgconfig:${PKG_CONFIG_PATH}"=0Afi=0A=0A[[ -d $IPTABLES_PATH ]] && export P=
KG_CONFIG_PATH=3D"${IPTABLES_PATH}/install/lib/pkgconfig:${PKG_CONFIG_PATH}=
"=0A=0A#PROF_CFLAGS=3D'CFLAGS=3D"-fprofile-arcs -ftest-coverage"'=0A#LIBMNL=
_LIBS=3D'LIBMNL_LIBS=3D"'${LIBMNL_PATH}'/install/lib/libmnl.a"'=0A#LIBNFTNL=
_LIBS=3D'LIBNFTNL_LIBS=3D"'${LIBNFTNL_PATH}'/install/lib/libnftnl.a"'=0A# n=
ow build nftables=0Arm -rf install=0Amake clean=0A./autogen.sh=0A./configur=
e --enable-static --enable-shared --enable-man-doc --with-json --with-xtabl=
es \=0A	--with-cli=3D$CLI --prefix=3D"$PWD/install" --disable-silent-rules =
\=0A	$PROF_CFLAGS $LIBMNL_LIBS $LIBNFTNL_LIBS ${MINI_GMP:+--with-mini-gmp}=
=0A[[ $? -eq 0 ]] || { echo "nftables: configure failed"; exit 4; }=0A$MAKE=
 V=3D1 || { echo "nftables: make failed"; exit 5; }=0Amake install || { ech=
o "nftables: make install failed"; exit 6; }=0A
--jU06t90bjaNrwqif--
