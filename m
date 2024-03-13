Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 68EF920309
	for <netfilter-devel@vger.kernel.org>; Wed, 13 Mar 2024 09:13:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710321217; cv=none; b=JwOhcHp7+hf0pduQe2zxdCP96g1vdiZ9oh24p/7NqpX/TAefeqgHRWgRSdAZPU+pOiViQfi0aiZLrNnXjQN5nAYkyTk2vm88wSwvPjugttEEq8MZ1fH3D5qd1iM8ux+v7AyKCsji2clIp2doEeKGWUTYDUAOfMCKiQkFCWXss84=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710321217; c=relaxed/simple;
	bh=jSJpKbHJWbC6oF1VcylyQZwq254lUHbjw7M/gBNWfM0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ajlZKAtAbpZFiVOtBbEaqV1fy/ahQz8UQH3KBnZOX9OPhmAf4CGTR+95LjKYRFKt2UcSz6iZnd1789gp8TRuUrWY0Z74SboSXAdIPQnqbkmmyOYly9YQkKeJpwoCLkB5XH4L6O6F9iFJq+yyOGHgN0dsszD/iYrX5GZ4qo1Q99A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=strlen.de; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=strlen.de
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
	(envelope-from <fw@strlen.de>)
	id 1rkKg1-0006eV-3g; Wed, 13 Mar 2024 10:13:33 +0100
Date: Wed, 13 Mar 2024 10:13:33 +0100
From: Florian Westphal <fw@strlen.de>
To: Sriram Rajagopalan <bglsriram@gmail.com>
Cc: netfilter-devel@vger.kernel.org
Subject: Re: [PATCH] nftables: Fixed the issue with merging the payload in
 case of invert filter for tcp src and dst ports
Message-ID: <20240313091333.GH1529@breakpoint.cc>
References: <CAPtndGAHG-xKJrU3+9hYtcmbBizK4p_4w1kn_eTN0F8B6KB8kw@mail.gmail.com>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAPtndGAHG-xKJrU3+9hYtcmbBizK4p_4w1kn_eTN0F8B6KB8kw@mail.gmail.com>
User-Agent: Mutt/1.10.1 (2018-07-13)

Sriram Rajagopalan <bglsriram@gmail.com> wrote:
> From: Sriram Rajagopalan <bglsriram@gmail.com>
> Date: Wed, 13 Mar 2024 01:32:42 -0700
> Subject: [PATCH] nftables: Fixed the issue with merging the payload in case of
>  invert filter for tcp src and dst ports

Applied with test cases.
