Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EB3663C344B
	for <netfilter-devel@vger.kernel.org>; Wed, 29 Apr 2026 12:42:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777466574; cv=none; b=IH0N/ndoDVxma5vCz4IJYtoiBqnwxLFiu5hrP91p/lOxN7b82cQvWzTqTt6MI6Ka/ush9FD9IlDk6CZz0xge7WXiNRjLlI0JBBDfjXLVAVLUxAcZPv+Rt/P01bMsdBEA9ZyjzbWy8g8TJSsW4tAemReg1M0l1259lunBeXfP7jQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777466574; c=relaxed/simple;
	bh=QXWUlBAUujBwwYzY8mt/RfL11eo4QC65A+eSuN6H4V0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ipIkMZpl8qxFEC1yPBIngSXzAmjwn+Cfnog/IRuJCnzpXM+kWkXjlxDNftHLDEVvGFFbHQvUru/mAj5oc6l/zjcyJ3zIVRr85INPtEr+5IgEhEaEDpu/YCGV5CuTqYtRbIApzbBtAR2hmttJve3CC5XfMNz+gAfOZ0G3mk4p6w0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=strlen.de; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=strlen.de
Received: by Chamillionaire.breakpoint.cc (Postfix, from userid 1003)
	id F0D0B6079C; Wed, 29 Apr 2026 14:42:48 +0200 (CEST)
Date: Wed, 29 Apr 2026 14:42:43 +0200
From: Florian Westphal <fw@strlen.de>
To: Jan Engelhardt <ej@inai.de>
Cc: netfilter-devel@vger.kernel.org
Subject: Re: [PATCH nf-next] netfilter: x_tables: disable 32bit compat
 interface in user namespaces
Message-ID: <afH8w6AjlZUQK0Ja@strlen.de>
References: <20260429095949.20910-1-fw@strlen.de>
 <950150qr-9p6p-q772-9796-p5o9o06r32q0@vanv.qr>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <950150qr-9p6p-q772-9796-p5o9o06r32q0@vanv.qr>

Jan Engelhardt <ej@inai.de> wrote:
> >This feature is required to use 32bit arp/ip/ip6/ebtables binaries on
> >64bit kernels.  I don't think there are many users left.
> 
> This breaks the setup in a Debian x32 systemd-nspawn container with 
> xtables-legacy-multi.

Thats the intent.
