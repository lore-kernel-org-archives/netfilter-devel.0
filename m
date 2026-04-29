Received: from a3.inai.de (a3.inai.de [144.76.212.145])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 89D283F23AA
	for <netfilter-devel@vger.kernel.org>; Wed, 29 Apr 2026 12:41:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.76.212.145
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777466520; cv=none; b=LUQUhN5wcN7G8AcSNRR4JN8o9NPifdPBeiJ5pGihY1gEhZyzH/SIecXePVAWTOE3sfgTR/gAH3ghL0UcKEKD/miHN5rCQQYZOCMPxXZuVrkEftWAkqmOzuDMQ0Lo2wl8VFszPpGm0GmTrn16xDQdOti4r6Z3xql8LMLu+0RSlC8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777466520; c=relaxed/simple;
	bh=JQJFRLFeX3aIm4bSI7SbBlzTzXsY8sbWqb2cMuwhMAM=;
	h=Date:From:To:cc:Subject:In-Reply-To:Message-ID:References:
	 MIME-Version:Content-Type; b=hp8MYV/nFdj8r0FnLtpK6uUlfjXfypnXOjOBwAnju2q1iGUh6S3T3W7/ZS/OE8mV3XIs+9EzyRg9B19VYLn981bsG1vtkwqMPg4x/r5B1fZxX2N/P4+zk4MyEPl/VwBxsI7jOLVhtWEEMMABrKE9HGEg3tcyU1eV11KqHqOi33s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=inai.de; spf=pass smtp.mailfrom=inai.de; arc=none smtp.client-ip=144.76.212.145
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=inai.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=inai.de
Received: by a3.inai.de (Postfix, from userid 25121)
	id 879C11003C5108; Wed, 29 Apr 2026 14:33:02 +0200 (CEST)
Received: from localhost (localhost [127.0.0.1])
	by a3.inai.de (Postfix) with ESMTP id 8726A1100AFC08;
	Wed, 29 Apr 2026 14:33:02 +0200 (CEST)
Date: Wed, 29 Apr 2026 14:33:02 +0200 (CEST)
From: Jan Engelhardt <ej@inai.de>
To: Florian Westphal <fw@strlen.de>
cc: netfilter-devel@vger.kernel.org
Subject: Re: [PATCH nf-next] netfilter: x_tables: disable 32bit compat
 interface in user namespaces
In-Reply-To: <20260429095949.20910-1-fw@strlen.de>
Message-ID: <950150qr-9p6p-q772-9796-p5o9o06r32q0@vanv.qr>
References: <20260429095949.20910-1-fw@strlen.de>
User-Agent: Alpine 2.26 (LSU 649 2022-06-02)
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII


On Wednesday 2026-04-29 11:59, Florian Westphal wrote:

>This feature is required to use 32bit arp/ip/ip6/ebtables binaries on
>64bit kernels.  I don't think there are many users left.

This breaks the setup in a Debian x32 systemd-nspawn container with 
xtables-legacy-multi.
