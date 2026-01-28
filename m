Received: from orbyte.nwl.cc (orbyte.nwl.cc [151.80.46.58])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7A5DC309EFB
	for <netfilter-devel@vger.kernel.org>; Wed, 28 Jan 2026 16:37:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=151.80.46.58
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769618272; cv=none; b=s9Pyhej5cnCCRn1ACJL2lp3+hEdMgqCC7zp2NmXoof4lHJ8DtwmN4gCe+w8P1HC4sqSq1XTq+lhjoe/CeSR3OLJ/ArpQ8pYo8Dmgxv7MKNl2faWOrZFfMSFccPjFqz5zL0bPGOJ08TzQrPLjGKOLrGoUWI3EiZuN+3/JJp79zdc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769618272; c=relaxed/simple;
	bh=FduemdCUqxkGCJv1cMxFWDffYJGRKXxrhnztd4oRxkM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=gS3R5PEkNk/B0I1fU9NXZUihhgMbLvL4TtioUMKxykWbeiCye8IWVA7bgDP1Q3/uDF4cuZocz5mKXxrftIMSJWXN8Myg2xkj6PS4MESxbaqYG8gvXuhltJYz/UZvJU5pEJzE25s9NL4F6AvCpimczz4yLiGxf8uCzuGzBwma9cM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc; spf=pass smtp.mailfrom=nwl.cc; dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b=fNaEj0xN; arc=none smtp.client-ip=151.80.46.58
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nwl.cc
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b="fNaEj0xN"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nwl.cc;
	s=mail2022; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
	Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=+ueWk23/sTxWAebwE1Y+bBEtGhfUoQjiHJJSLpEnbhY=; b=fNaEj0xNLMtVH/uaIqQgmrGdpf
	IOHcXmZvMEKY3zYzr/GEr0SJkh9E1kATdA8zsfzwyRmdUF5aELoAK8pP77NmK1uE3SoaCYdhgdMRQ
	VVMnp+AFNNTn3ivwMuTlaf9TZ3twvBHpAr8YQyDfWZ6Oe6K8zgrgmtFQUS0I01K25XU/DMefA3wlC
	S3S/6nfIbO0o4fUW1MOOJsBUq7ar978Eu8Y+qlGhV1AdBSrFjgVt2/T7H1iJ6mzV8GptnfTMi1+Mt
	3mbjbiMdI0LOvOKyQvJXI5Zrm296FDocRG2yjJ0xhFH9dzDh8M459uylvrFtcEr9ECyLf88esiVe3
	B7KSOEAA==;
Received: from n0-1 by orbyte.nwl.cc with local (Exim 4.98.2)
	(envelope-from <phil@nwl.cc>)
	id 1vl8Y6-0000000008s-3sNg;
	Wed, 28 Jan 2026 17:37:46 +0100
Date: Wed, 28 Jan 2026 17:37:46 +0100
From: Phil Sutter <phil@nwl.cc>
To: Jeremy Sowden <jeremy@azazel.net>
Cc: Pablo Neira Ayuso <pablo@netfilter.org>,
	netfilter-devel@vger.kernel.org, Florian Westphal <fw@strlen.de>,
	Arnout Engelen <arnout@bzzt.net>, Philipp Bartsch <phil@grmr.de>
Subject: Re: [nft PATCH] configure: Generate BUILD_STAMP at configure time
Message-ID: <aXo7Wvl0-TtCkVMH@orbyte.nwl.cc>
Mail-Followup-To: Phil Sutter <phil@nwl.cc>,
	Jeremy Sowden <jeremy@azazel.net>,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	netfilter-devel@vger.kernel.org, Florian Westphal <fw@strlen.de>,
	Arnout Engelen <arnout@bzzt.net>, Philipp Bartsch <phil@grmr.de>
References: <20260128145251.26767-1-phil@nwl.cc>
 <20260128151152.GB2884714@celephais.dreamlands>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260128151152.GB2884714@celephais.dreamlands>

On Wed, Jan 28, 2026 at 03:11:52PM +0000, Jeremy Sowden wrote:
> On 2026-01-28, at 15:52:51 +0100, Phil Sutter wrote:
> >Several flaws were identified with the previous approach at generating
> >the build timestamp during compilation:
> >
> >- Recursive expansion of the BUILD_STAMP make variable caused changing
> >  values upon each gcc call
> >- Partial recompiling could also lead to changing BUILD_STAMP values in
> >  objects
> >
> >While it is possible to work around the above issues using simple
> >expansion and a mandatorily recompiled source file holding the values,
> >generating the stamp at configure time is a much simpler solution and
> >deemed sufficient enough for the purpose.
> >
> >While at it:
> >
> >- Respect SOURCE_DATE_EPOCH environment variable to support reproducible
> >  builds, suggested by Philipp Bartsch
> >- Guard the header against multiple inclusion, just in case
> >
> >Fixes: 64c07e38f049 ("table: Embed creating nft version into userdata")
> >Reported-by: Arnout Engelen <arnout@bzzt.net>
> >Closes: https://github.com/NixOS/nixpkgs/issues/478048
> >Sugested-by: Philipp Bartsch <phil@grmr.de>
> >Cc: Jeremy Sowden <jeremy@azazel.net>
> >Signed-off-by: Phil Sutter <phil@nwl.cc>
> >---
> > Makefile.am  |  2 --
> > configure.ac | 16 ++++++++--------
> > 2 files changed, 8 insertions(+), 10 deletions(-)
> >
> >diff --git a/Makefile.am b/Makefile.am
> >index 5c7c197f43ca7..c60c2e63d5aff 100644
> >--- a/Makefile.am
> >+++ b/Makefile.am
> >@@ -159,8 +159,6 @@ AM_CFLAGS = \
> > 	\
> > 	$(GCC_FVISIBILITY_HIDDEN) \
> > 	\
> >-	-DMAKE_STAMP=$(MAKE_STAMP) \
> >-	\
> > 	$(NULL)
> >
> > AM_YFLAGS = -d -Wno-yacc
> >diff --git a/configure.ac b/configure.ac
> >index dd172e88ca581..ff1d86213eb80 100644
> >--- a/configure.ac
> >+++ b/configure.ac
> >@@ -152,20 +152,20 @@ AC_CONFIG_COMMANDS([stable_release],
> >                    [stable_release=$with_stable_release])
> > AC_CONFIG_COMMANDS([nftversion.h], [
> > (
> >+	echo "#ifndef NFTABLES_NFTVERSION_H"
> >+	echo "#define NFTABLES_NFTVERSION_H"
> >+	echo ""
> > 	echo "static char nftversion[[]] = {"
> > 	echo "	${VERSION}," | tr '.' ','
> > 	echo "	${STABLE_RELEASE}"
> > 	echo "};"
> >-	echo "static char nftbuildstamp[[]] = {"
> >-	for i in `seq 56 -8 0`; do
> >-		echo "	((uint64_t)MAKE_STAMP >> $i) & 0xff,"
> >-	done
> >-	echo "};"
> >+	printf "static char nftbuildstamp[[]] = { "
> >+	printf "%.16x" "$(printenv SOURCE_DATE_EPOCH || date '+%s')" | \
> >+		sed -e 's/\(..\)/0x\1, /g' -e 's/, $/ };\n/'
> >+	echo ""
> >+	echo "#endif /* NFTABLES_NFTVERSION_H */"
> > ) >nftversion.h
> > ])
> >-# Current date should be fetched exactly once per build,
> >-# so have 'make' call date and pass the value to every 'gcc' call
> >-AC_SUBST([MAKE_STAMP], ["\$(shell date +%s)"])
> >
> > AC_ARG_ENABLE([distcheck],
> > 	      AS_HELP_STRING([--enable-distcheck], [Build for distcheck]),
> 
> One other thing that I wondered about is why we are generating
> nftversion.h like this.   How about the attached?

Oh, much simpler. You wonder why I apparently reimplemented parts of
autotools? The obvious answer is incompetence! ;)

Will you formally submit a patch?

Thanks, Phil
