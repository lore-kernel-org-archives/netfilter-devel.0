Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5A1D01CD15
	for <netfilter-devel@vger.kernel.org>; Sun, 15 Jun 2025 09:47:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.190.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749980851; cv=none; b=Id7uHmMN7MWR0Cw+zjq3QxyrskRDAgDL13aji46zU2tdll+fDrTO+0vfQciT+6st/3MboEuREAcnJm5dKfX4gCVZ7VaIw1twVS8m06ISHjyKW9cQoXuvrejVIZHZr3x7JnY2lweB7rM5pznS5FD/f9mti2+GYojDMejeR0mQo5E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749980851; c=relaxed/simple;
	bh=VmnkZQI0rGFrceSgoh6gjYTFwwj2qYJTXGSTmjnu/T4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=sttr3cEhe0Q+CIOl6TQpXUQmYuwvTNd+zP1ArOQzrninMai1zMKLS/Vcx+L3+6WIcCUg2TPh5EM4cCBw4WMr7E9sZ9iiVLGbbdnn9owL1r7ymq5MMWuZESw7GThi21noT2lY0sfY6YpII2Qgh0uHVJDWHAB/jgibFGDcg1ko5c8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=rOImxKsI; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=rOImxKsI; arc=none smtp.client-ip=217.70.190.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="rOImxKsI";
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="rOImxKsI"
Received: by mail.netfilter.org (Postfix, from userid 109)
	id D1FAB602B4; Sun, 15 Jun 2025 11:47:23 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1749980843;
	bh=LQ94VPLi1XBsUpb6kLee3DFfpNB7VUGyzN4nkb2X80c=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=rOImxKsIm03vVVlNTxk5DZ/yd+9slYm62+jg2zIMBSBcDqZ5g7rkCvnQ4wJrlSShB
	 6ZpgCN2sO0FYfoadow/uykNV1ikNjo6wGpNfV8P6vdTP76J0TnyIDUAWXN5yaKDq2T
	 JoXblJdtdf23B4R3I25bCTBcUW52sW0FuUKz9kMEUuAx0wamRVN3oDq4JUrAy26Ok9
	 wBNdIgv+TeBxC3glrTmsS1mlxGim8jO9lwwWcQBVNphoSklXrClsZYQh6Vmny8nV0H
	 q2MnzMjUQ6+9SuUidWWSdreW1CZ0hzHmk/1xnEefRnkYJAQgiXDIuSAu1wdK0h6/Qw
	 5ot/vjlaSd3Xg==
X-Spam-Level: 
Received: from netfilter.org (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with ESMTPSA id 20FEB602B4;
	Sun, 15 Jun 2025 11:47:23 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1749980843;
	bh=LQ94VPLi1XBsUpb6kLee3DFfpNB7VUGyzN4nkb2X80c=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=rOImxKsIm03vVVlNTxk5DZ/yd+9slYm62+jg2zIMBSBcDqZ5g7rkCvnQ4wJrlSShB
	 6ZpgCN2sO0FYfoadow/uykNV1ikNjo6wGpNfV8P6vdTP76J0TnyIDUAWXN5yaKDq2T
	 JoXblJdtdf23B4R3I25bCTBcUW52sW0FuUKz9kMEUuAx0wamRVN3oDq4JUrAy26Ok9
	 wBNdIgv+TeBxC3glrTmsS1mlxGim8jO9lwwWcQBVNphoSklXrClsZYQh6Vmny8nV0H
	 q2MnzMjUQ6+9SuUidWWSdreW1CZ0hzHmk/1xnEefRnkYJAQgiXDIuSAu1wdK0h6/Qw
	 5ot/vjlaSd3Xg==
Date: Sun, 15 Jun 2025 11:47:20 +0200
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: Phil Sutter <phil@nwl.cc>
Cc: netfilter-devel@vger.kernel.org
Subject: Re: [nft PATCH 3/7] monitor: Correctly print flowtable updates
Message-ID: <aE6Wf82Lf09Qo2WK@calendula>
References: <20250612115218.4066-1-phil@nwl.cc>
 <20250612115218.4066-4-phil@nwl.cc>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20250612115218.4066-4-phil@nwl.cc>

On Thu, Jun 12, 2025 at 01:52:14PM +0200, Phil Sutter wrote:
> An update deleting a hook from a flowtable was indistinguishable from a
> flowtable deletion.

tests/monitor fails:

--- /tmp/tmp.CxT9laP7kj/tmp.qTOOOcfTUY  2025-06-15 11:44:55.690784518 +0200
+++ /tmp/tmp.CxT9laP7kj/tmp.JdiYcpuAKK  2025-06-15 11:44:56.337658195 +0200
@@ -1 +1,2 @@
-delete flowtable ip t ft
+delete flowtable ip t ft { hook ingress priority 0; devices = { lo }; }
+# new generation 3 by process 2954068 (nft)

> Fixes: 73a8adfc2432e ("monitor: Recognize flowtable add/del events")
> Signed-off-by: Phil Sutter <phil@nwl.cc>
> ---
>  src/monitor.c | 14 +++++++++-----
>  1 file changed, 9 insertions(+), 5 deletions(-)
> 
> diff --git a/src/monitor.c b/src/monitor.c
> index 4ceff94824432..e3e38c2a12b78 100644
> --- a/src/monitor.c
> +++ b/src/monitor.c
> @@ -577,14 +577,18 @@ static int netlink_events_flowtable_cb(const struct nlmsghdr *nlh, int type,
>  		nft_mon_print(monh, "%s ", cmd);
>  
>  		switch (type) {
> +		case NFT_MSG_DELFLOWTABLE:
> +			if (!ft->dev_array_len) {
> +				nft_mon_print(monh, "flowtable %s %s %s",
> +					      family,
> +					      ft->handle.table.name,
> +					      ft->handle.flowtable.name);
> +				break;
> +			}
> +			/* fall through */
>  		case NFT_MSG_NEWFLOWTABLE:
>  			flowtable_print_plain(ft, &monh->ctx->nft->output);
>  			break;
> -		case NFT_MSG_DELFLOWTABLE:
> -			nft_mon_print(monh, "flowtable %s %s %s", family,
> -				      ft->handle.table.name,
> -				      ft->handle.flowtable.name);
> -			break;
>  		}
>  		nft_mon_print(monh, "\n");
>  		break;
> -- 
> 2.49.0
> 
