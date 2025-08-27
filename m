Received: from orbyte.nwl.cc (orbyte.nwl.cc [151.80.46.58])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C3939350847
	for <netfilter-devel@vger.kernel.org>; Wed, 27 Aug 2025 14:13:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=151.80.46.58
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756304020; cv=none; b=JZKmNzJsD9g3/DanRRTbBs56B1H36CgHPd+3N+fPP/PJG0yqx5UTnzwKTHbUyR6mZNEGRDEmNgVClTBzPwUs6zPbG5mv/HWBtLvKljqPNQG864s5mljNz/RFJCJgDB/deIeNHTL20DTjZLroqTN+f71DxTIPrnru9RizZCPchbg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756304020; c=relaxed/simple;
	bh=7D93hK8LCEqjpIofgoVw1/7k4fMijIdSLFZeJ0V1ojM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=f6AB0EvV22nwprNwUq8HphH2PRnrFvTxKMpRA6aTEUyrr8bQ5ILYBOytqwJ8oPEnplVJ/OW6wBHc4+srMhVzDMS8dC9aLSJOo52HnOP2/CoafB5MrMO31MgEnck+JBeVJUNpOsXn0LQueNRKP4+eKU5RlRwjkPA4hlEJ1z3xYTE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc; spf=pass smtp.mailfrom=nwl.cc; dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b=RyjW/c5I; arc=none smtp.client-ip=151.80.46.58
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nwl.cc
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b="RyjW/c5I"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nwl.cc;
	s=mail2022; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
	Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=qJiFwWNEOvHcUcPFfOrS3AES1hg+aesQ+GFEM8PQ+ec=; b=RyjW/c5IfL2pChxWPF4kbIMPRq
	jCejDGp5zVp4ySwnMfIeD6R0XhirYy21645tv+i1seBLAziZFKMnpE6J23Ueira13PvIcvbjHi1wc
	OBV+R+lMdx/YymE1CV5weSqVxMf7pcku8AsGMUPpvOBELyAn3yzph854Z6mqiy8UpYcjxxWIUf/FC
	a2rNGlxlGB5RkvSoye7sLEJxaCk9UyJ7Y6ZOCHZm2wUsYMw9XCBf/GTkB87YZte8sjkQxphsRGoHW
	BaThOjP0f4rTBOTJNZlDlqmT0QhIkkSV4I/m5+F8liUXC7zpqrNflxaBvQIwrgf1GV/lP0UghFU29
	fdONhb7g==;
Received: from n0-1 by orbyte.nwl.cc with local (Exim 4.97.1)
	(envelope-from <phil@nwl.cc>)
	id 1urGu1-000000008R8-2mJH;
	Wed, 27 Aug 2025 16:13:29 +0200
Date: Wed, 27 Aug 2025 16:13:29 +0200
From: Phil Sutter <phil@nwl.cc>
To: Jan Engelhardt <jengelh@inai.de>
Cc: pablo@netfilter.org, netfilter-devel@vger.kernel.org
Subject: Re: [PATCH] build: make `make distcheck` succeed in the face of
 absolute paths
Message-ID: <aK8SiX2hNhdgzmD5@orbyte.nwl.cc>
Mail-Followup-To: Phil Sutter <phil@nwl.cc>,
	Jan Engelhardt <jengelh@inai.de>, pablo@netfilter.org,
	netfilter-devel@vger.kernel.org
References: <90rp264n-po69-op18-1s8r-615r43sq38r0@vanv.qr>
 <20250827124307.894879-1-jengelh@inai.de>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250827124307.894879-1-jengelh@inai.de>

On Wed, Aug 27, 2025 at 02:43:07PM +0200, Jan Engelhardt wrote:
> `make distcheck` has an expectation that, if only --prefix is
> specified, all other potentially-configurable paths are somehow
> relative to '${prefix}', e.g. bindir defaults to '${prefix}/bin'.
> 
> We get an absolute path from $(pkg-config systemd ...) at all times
> in case systemd.pc is present, and an empty path in case it is not,
> which collides with the aforementioned expectation two ways. Add an
> internal --with-dcprefix configure option for the sake of distcheck.
> ---
>  Makefile.am  | 1 +
>  configure.ac | 5 +++++
>  2 files changed, 6 insertions(+)
> 
> diff --git a/Makefile.am b/Makefile.am
> index e292d3b9..52a3e6c4 100644
> --- a/Makefile.am
> +++ b/Makefile.am
> @@ -23,6 +23,7 @@ libnftables_LIBVERSION = 2:0:1
>  ###############################################################################
>  
>  ACLOCAL_AMFLAGS = -I m4
> +AM_DISTCHECK_CONFIGURE_FLAGS = --with-dcprefix='$${prefix}'
>  
>  EXTRA_DIST =
>  BUILT_SOURCES =
> diff --git a/configure.ac b/configure.ac
> index 626c641b..198b3be8 100644
> --- a/configure.ac
> +++ b/configure.ac
> @@ -122,6 +122,11 @@ AC_ARG_WITH([unitdir],
>  		AS_IF([test -z "$unitdir"], [unitdir='${prefix}/lib/systemd/system'])
>  	])
>  AC_SUBST([unitdir])
> +AC_ARG_WITH([dcprefix],
> +        [AS_HELP_STRING([Extra path inserted for distcheck])],
> +        [dcprefix="$withval"])
> +AC_SUBST([dcprefix])
> +AS_IF([test -z "$unitdir"], [unitdir='${prefix}/lib/systemd/system'], [unitdir='${dcprefix}'"$unitdir"])

Shouldn't this test for '-z "$dcprefix"'?

Cheers, Phil
