Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 045E83CC7EC;
	Fri, 10 Jul 2026 09:27:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.190.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783675625; cv=none; b=QBkOwiSwlY99TX9aBKxpJ599U238O7i5l5kFTNPpXITl1G5IEG3qnh4BSqgcLG5Hl/RG0KhEM0fMWgRPsBsDJNIamZUGEPgF+tor+WD5GtZXJOeBr8CJ1WaI8Zqtn8bs3bkXe4oZRZ3hGynXQ5gGN1d9X6qiWyOGb+I4LC0BirI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783675625; c=relaxed/simple;
	bh=DXlxi6FvkGmt8WkwHNfC3lOzCxOOIwiRRE2SS37ftP8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=CCewdRbLZVq0Xt/0sSJB9Zxe2uI0fFcg7D8GVp82QYPVJqKvTp6O/Bl9ALszqbp1AFdXM93mNurXoyBHw8qmIHF0sPsgX7u3AFnOypISzkCqeL52ZtoqhlDFJgmy1TnXzEhpGjlyWnQkTsN+V6pZBxYtaXT/Yd2oQAFsHWgwQPc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=i7T+bfRo; arc=none smtp.client-ip=217.70.190.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="i7T+bfRo"
Received: from netfilter.org (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with UTF8SMTPSA id 976DB6057A;
	Fri, 10 Jul 2026 11:27:01 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1783675621;
	bh=YLWyZ3h1hshbu033MQgy1J8KKJjRd55U+F2x53SL5JA=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=i7T+bfRoG88EefZUHsKOmOdtF3eVsKYKfJECyEfDOpRo30HsnBHoFsVg5O4jMTL7V
	 gkXKEfYl0sOc8UYg0I7LJ0wCj8FtddNSstm31828+Qc1DaaH3fPIjTAlY9ccf3hT6W
	 m2oRaYmRL2zQc03YdsrzztyXYs/fv4LkPkbgFDBStXgoe0ssI67oz5TBlIlRy8FEhw
	 3WS+4g4w8nT1E9N+YZPwWt5biNw94eUChwAJ34zFzJz7DagMs1G8KWXei9GJcwo8sx
	 OAkUBdQjJXGIAu5V9szb/jlO5iT5g5Qar6vrTh25h1ksaavFW/P3Q1hKrcxQxviUaR
	 GVUHa5d9OUfLA==
Date: Fri, 10 Jul 2026 11:26:57 +0200
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: Eric Woudstra <ericwouds@gmail.com>
Cc: Andrew Lunn <andrew+netdev@lunn.ch>,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>,
	Simon Horman <horms@kernel.org>, Florian Westphal <fw@strlen.de>,
	Phil Sutter <phil@nwl.cc>,
	Nikolay Aleksandrov <razor@blackwall.org>,
	Ido Schimmel <idosch@nvidia.com>,
	Kuniyuki Iwashima <kuniyu@google.com>,
	Stanislav Fomichev <sdf.kernel@gmail.com>,
	Samiullah Khawaja <skhawaja@google.com>,
	Hangbin Liu <liuhangbin@gmail.com>,
	Krishna Kumar <krikku@gmail.com>,
	Martin Karsten <mkarsten@uwaterloo.ca>, netdev@vger.kernel.org,
	netfilter-devel@vger.kernel.org, bridge@lists.linux.dev
Subject: Re: [PATCH v12 nf-next 3/7] netfilter: nf_flow_table_offload: Add
 nf_flow_rule_bridge()
Message-ID: <alC64Vg_xihR-huW@chamomile>
References: <20260707091045.967678-1-ericwouds@gmail.com>
 <20260707091045.967678-4-ericwouds@gmail.com>
 <ak4dAXHDmTDRr7-b@chamomile>
 <81c3bf65-b19b-4f80-aa8e-c0c4b3f5d6a7@gmail.com>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <81c3bf65-b19b-4f80-aa8e-c0c4b3f5d6a7@gmail.com>

Hi Eric,

On Wed, Jul 08, 2026 at 08:36:11PM +0200, Eric Woudstra wrote:
> On 7/8/26 11:48 AM, Pablo Neira Ayuso wrote:
> > On Tue, Jul 07, 2026 at 11:10:41AM +0200, Eric Woudstra wrote:
> >> Add nf_flow_rule_bridge().
> >>
> >> It only calls the common rule and adds the redirect.
> > 
> > I decided to use the new _unsupp() function, so we don't pretend
> > bridge hw offload is already supported. We will need a driver before
> > we can add this, this stub does not provide much. I guess your goal
> > was just to avoid a crash here.
> 
> No, I am already using hw_offload between bridged interfaces
> on the mt7986 succesfully for almost 2 years.
> It works dsa-port to direct interface (lan1 to eth1 on Bananapi R3) and
> between direct interfaces (eth0 to eth1 on Bananapi-R3-mini)

Do you utilize the existing mt7986 driver in-tree without changes to
achive this hardware offload? Or you have still have out-of-tree
patches that need to be merged to achive this?

> It can also be tested with my bridge_fastpath.sh selftest script.
> This script uses veth-device pairs to test the software fastpath.
> It can also use 2 real interfaces interconnected in a loop of copper,
> when chosen with commandline arguments. Then it tests software- and
> hardware-fastpath. It also tests many different scenarios.
> 
> So this is why I've added it, as it is already functional. If a software
> fastpath is setup correctly, the hardware fastpath is also functional.

Thanks for explaining.

I am targetting at a minimal subset of the flowtable bridge support at
this stage. There is a need to make progress with the
nf_conntrack_bridge counterpart before the flowtable bridge can get
more features (namely, bridge vlan filtering support).
