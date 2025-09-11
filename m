Received: from proxmox-new.maurer-it.com (proxmox-new.maurer-it.com [94.136.29.106])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 443152EA726
	for <netfilter-devel@vger.kernel.org>; Thu, 11 Sep 2025 09:41:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=94.136.29.106
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757583676; cv=none; b=fIlARisQsUT5fFQp8ceAQgI6SKE2wHNNMyLleyTKM5LNmFmqSgYmDbTfX2qqRQfoq3ezIlECWzugcx/S+Av4VuHSN/bOVHXqtK8vFJfIl1tlSxpt/iMKt5kd99w5qDtfwNwlshEVNc1arThJ8D46xrpddRtBH0isJME7nahG6+Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757583676; c=relaxed/simple;
	bh=GbFdGx66AFQrk6lWc03kgeXoXOKKviWKXfdx3VtcMjU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=rINsXi86VNfGRu66yz/tL0lhycyodFmJGF3M68ziuenXERyU0QlPm1UE9JBeJaHOfHnh3wQKDtMbfCQ8hvtTRwyzU/tT+7oiz0afBq9eDH9v3UQCeSy1B+K8zmODfW23vBivKighPBPdMfEWt1db5HENt0c2FzjOM2Unfk1OhC0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=proxmox.com; spf=pass smtp.mailfrom=proxmox.com; arc=none smtp.client-ip=94.136.29.106
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=proxmox.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=proxmox.com
Received: from proxmox-new.maurer-it.com (localhost.localdomain [127.0.0.1])
	by proxmox-new.maurer-it.com (Proxmox) with ESMTP id 955AF42115;
	Thu, 11 Sep 2025 11:31:31 +0200 (CEST)
Date: Thu, 11 Sep 2025 11:31:31 +0200
From: Gabriel Goller <g.goller@proxmox.com>
To: Florian Westphal <fw@strlen.de>
Cc: netfilter-devel@vger.kernel.org, s.hanreich@proxmox.com
Subject: Re: [PATCH nf 0/5] netfilter: nf_tables: fix false negative lookups
 with ongoing transaction
Message-ID: <v3tlcx4h44yh2a4lac5lx643o6a7cvneyokojx5y7znll4nfmj@xmw57s4u3hnt>
Mail-Followup-To: Florian Westphal <fw@strlen.de>, 
	netfilter-devel@vger.kernel.org, s.hanreich@proxmox.com
References: <20250910080227.11174-1-fw@strlen.de>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20250910080227.11174-1-fw@strlen.de>
User-Agent: NeoMutt/20241002-35-39f9a6
X-Bm-Milter-Handled: 55990f41-d878-4baa-be0a-ee34c49e34d2
X-Bm-Transport-Timestamp: 1757583088687

I tested this fix using Stefan Hanreich’s reproducer on the latest
master branch. The bug was resolved, and I didn't see anything out
of the ordinary.

Consider:

Tested-by: Gabriel Goller <g.goller@proxmox.com>

