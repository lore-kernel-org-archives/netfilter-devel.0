Received: from ganesha.gnumonks.org (ganesha.gnumonks.org [213.95.27.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2C4DB1C28E
	for <netfilter-devel@vger.kernel.org>; Mon, 11 Nov 2024 10:30:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.27.120
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731321016; cv=none; b=D/u6VF8DCUkPiXN8P+eCWPZWaYfJywn1L+q57QaXO/fVCtreSX+FWP5tugw9pqWVmhIN83p3igfatYu+A9gDM4HKfqodQJ+mI/V6mKCKQ5lIqotoZXMCdZ3BkRAirP6/zm9NzkCN9OkvnI6e6CYxa+kJqMpoiOEJhT5OK+MP98Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731321016; c=relaxed/simple;
	bh=ssmBkvUVicg0o0VTaRtFYAmrjLb6TeJ5pu1zvjifZWc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=bAiwbls7k53RIXOBliXi7Zmv01vTWekDlGlIvt7+updyrtoBrTYefV5ZIKcboDjGjDflkajWRvmF79AxNjfBzR3/nE4klxmilWpTrG+nEh/CE6CpDoD/RwT553MEivdXa+aDj10a9Fd8JOhILB4hsnOQGqZRg5uCAICPw42LI8A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=gnumonks.org; arc=none smtp.client-ip=213.95.27.120
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gnumonks.org
Received: from [78.30.37.63] (port=48114 helo=gnumonks.org)
	by ganesha.gnumonks.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.94.2)
	(envelope-from <pablo@gnumonks.org>)
	id 1tARgP-001Xui-Ak; Mon, 11 Nov 2024 11:30:11 +0100
Date: Mon, 11 Nov 2024 11:30:08 +0100
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: Duncan Roe <duncan_roe@optusnet.com.au>
Cc: netfilter-devel@vger.kernel.org
Subject: Re: [PATCH libmnl] whitespace: remove spacing irregularities
Message-ID: <ZzHcsEYWLdt_j0Iy@calendula>
References: <20241111025608.8683-1-duncan_roe@optusnet.com.au>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20241111025608.8683-1-duncan_roe@optusnet.com.au>
X-Spam-Score: -1.9 (-)

On Mon, Nov 11, 2024 at 01:56:08PM +1100, Duncan Roe wrote:
> Two distinct actions:
>  1. Remove trailing spaces and tabs.
>  2. Remove spaces that are followed by a tab, inserting extra tabs
>     as required.
> Action 2 is only performed in the indent region of a line.
> 
> Signed-off-by: Duncan Roe <duncan_roe@optusnet.com.au>
> ---
>  include/linux/netlink.h | 6 +++---
>  src/callback.c          | 4 ++--
>  src/socket.c            | 6 +++---
>  3 files changed, 8 insertions(+), 8 deletions(-)
> 
> diff --git a/include/linux/netlink.h b/include/linux/netlink.h
> index ced0e1a..7c26175 100644
> --- a/include/linux/netlink.h
> +++ b/include/linux/netlink.h
> @@ -14,7 +14,7 @@
>  #define NETLINK_SELINUX		7	/* SELinux event notifications */
>  #define NETLINK_ISCSI		8	/* Open-iSCSI */
>  #define NETLINK_AUDIT		9	/* auditing */
> -#define NETLINK_FIB_LOOKUP	10	
> +#define NETLINK_FIB_LOOKUP	10
>  #define NETLINK_CONNECTOR	11
>  #define NETLINK_NETFILTER	12	/* netfilter subsystem */
>  #define NETLINK_IP6_FW		13
> @@ -29,13 +29,13 @@
>  
>  #define NETLINK_INET_DIAG	NETLINK_SOCK_DIAG
>  
> -#define MAX_LINKS 32		
> +#define MAX_LINKS 32

Submit uapi/netlink.h update upstream via netdev@

This is a cached copy of uapi/netlink.h

If I take this, the extra line spaces and indentation will come back
sooner or later.

Thanks.
