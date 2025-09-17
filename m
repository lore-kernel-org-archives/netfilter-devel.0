Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3A2E4307486;
	Wed, 17 Sep 2025 08:18:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.190.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758097102; cv=none; b=af5D0jKd0pm4nCRFGIyT4eZdiug+ciFIFL63VHGfNo2XgjP7wEZpqzrG0/Wpk77g1RxSZeLSHWDxoPrJWAeLLBltIM3tfrrBddWfzkpf/OmX6WFD7shG7aPdq78DP17zJgtZMRl7jm3a7yL4njrtPGLkL2ImVuI362JgvZkSQ4k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758097102; c=relaxed/simple;
	bh=PxX2wWK2AzUL3Kv8PxHLOuoo7uCUWpaXq79PBXnYeaY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=UQtcNB3xSFSdNL8DhKiUZsGh+27E9qugykdNN1Bw1lrYgjOE00fTlxBAzR+0Zqtc7RSO1TS/3bxBgoJbZoSKV1Zg56A4wDIqjnFnlHlhiC7PdHgGCWT4ikkTyUo8e3gHvSmKYK7g+zAdK/1f7ySCaaTtTldA8cBMaf+5SbK8DaU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=AdwB6HDA; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=Wbvh7kr6; arc=none smtp.client-ip=217.70.190.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="AdwB6HDA";
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="Wbvh7kr6"
Received: by mail.netfilter.org (Postfix, from userid 109)
	id C69B960272; Wed, 17 Sep 2025 10:18:15 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1758097095;
	bh=RbG84KRk+ZARIr3NTuMvsr3teq8bq7o+LQmBa3ocmxw=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=AdwB6HDAf15JmLsk1MytzPVu37WB9THdQt+wQGTu4uriwDLt2SZV4ibE/a0kf6g6B
	 0IqIiezkQUxn+5YciilsPRIqmxrETQdCMuoHlbLmUF5GNKtkuHqYLBXdMdYKfgQ6oW
	 kvTH4AUpgXUyAvRWhKRMh4E2DU7ctBlVNSw6ixqrAFdAJzeq3Qu3mOtf/U5uahet5P
	 AaPI4Q9HYpQojZHy1nq+7GUEBxkmWVGzvdLBHQKp6qyyLyClNXXFeiMPoIhQgGVwc9
	 ShGnIhkZm+NFXNnYm8L1iw/19MeOLFwrAhV+nqJU7INg5iiM/IMk0TXiXn6LOkaTSE
	 hmOzf+DNlP8zw==
X-Spam-Level: 
Received: from netfilter.org (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with ESMTPSA id E89D460254;
	Wed, 17 Sep 2025 10:18:11 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1758097092;
	bh=RbG84KRk+ZARIr3NTuMvsr3teq8bq7o+LQmBa3ocmxw=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=Wbvh7kr6OODQtOuwXTSScZOukMPX5FkGpmCRibj4SxfgahGIqk1pslNgLcIhmkf1g
	 HHVZSYV4PoLgBF09PHCEeixzgb6catrzG/W0CLojfK/t3KQ/Wq5GQrbqXc0KrDFIhx
	 X15fPPe1IfFX6tWaFzpGZgpA3tE45oVUcaxcuHRW17jkYCsQNkA5jQcJNQNXH+8dE7
	 zVqP95kPx2k5UhFWshF+wK4S2tx/9BvXunmDVFXUH6gvFwPUyUeQbCUz/++HzKxIZX
	 CYrkUjiVVEQAo5GF8cBUYwuhAty4ZuT590sx6GDQUELBnNGzxMIEy9kJZ1R3ywNOXc
	 DhIKNyZer+0wg==
Date: Wed, 17 Sep 2025 10:18:09 +0200
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: Elad Yifee <eladwf@gmail.com>
Cc: Jozsef Kadlecsik <kadlec@netfilter.org>,
	Florian Westphal <fw@strlen.de>, Phil Sutter <phil@nwl.cc>,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>,
	Simon Horman <horms@kernel.org>, netfilter-devel@vger.kernel.org,
	coreteam@netfilter.org, netdev@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH net-next RFC] netfilter: flowtable: add CT metadata
 action for nft flowtables
Message-ID: <aMpuwRiqBtG7ps30@calendula>
References: <20250912163043.329233-1-eladwf@gmail.com>
 <CA+SN3sp6ZidPXhZnP0E4KQyt95pp_-M9h2MMwLozObp9JH-8LQ@mail.gmail.com>
 <aMnnKsqCGw5JFVrD@calendula>
 <CA+SN3srpbVBK10-PtOcikSphYDRf1WwWjS0d+R76-qCouAV2rQ@mail.gmail.com>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CA+SN3srpbVBK10-PtOcikSphYDRf1WwWjS0d+R76-qCouAV2rQ@mail.gmail.com>

On Wed, Sep 17, 2025 at 06:10:10AM +0300, Elad Yifee wrote:
> On Wed, Sep 17, 2025 at 1:39 AM Pablo Neira Ayuso <pablo@netfilter.org> wrote:
> >
> > May I ask, where is the software plane extension for this feature?
> > Will you add it for net/sched/act_ct.c?
> >
> >
> > Adding the hardware offload feature only is a deal breaker IMO.
> Software plane: This doesn’t add a new user feature, it just surfaces
> existing CT state to offload so the software plane already exists
> today via nft/TC. In software you can already set/match ct mark/labels
> (e.g., tag flows), and once offloaded the exporter snapshots that so a
> driver can map the tag to a HW queue/class if it wants per-flow QoS in
> hardware. Drivers that don’t need it can simply accept and ignore the
> metadata.

Hm, flowtable software datapath cannot do ct marks/label at this time.

> act_ct.c: Yes - I’ll include a small common helper so TC and nft
> flowtable offloads produce identical CT metadata.
> 
> If there’s no objection to the direction, I’ll respin with:
> - the common helper
> - act_ct switched to it
> - nft flowtable exporter appending CT metadata

Just to make sure we are on the same page: Software plane has to match
the capabilities of the hardware offload plan, new features must work
first in the software plane, then extend the hardware offload plane to
support it.
