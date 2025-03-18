Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AAC1A1C3BE2;
	Tue, 18 Mar 2025 22:19:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.190.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742336346; cv=none; b=FmS9I+DWL/cI6LE0LICWsuQqB54Ux8uFSKOCzA8ldEqRJiPe2UfCV8raSjN42YY1wa8HFIyEqkMjlmJxj0gm+JgBan85gpms5hmL8c4aU+WhbbfTQF5frUhebrr5sbuDxqUKZFkJTIwhCryyzpQSPrwuJ3M5pdjl/Xh8BGldutQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742336346; c=relaxed/simple;
	bh=ch+52xgnbhBHa2hybNEoD+zC1WGPsxH0LfNtU6RGhRc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=dKcp/iyQjggXRqGxjVifftCga7WARNfUWI0W6A5ts/uLUrHijnYIo2kssXERFIXrE50vhE+f3K+H+7YyGThkT6/f6IdzXJLVdSCxkyvpwXNqHB8G7c4LKMCwxH/75he00F33h6S5PuTOB82af8ziZqHUKxJxNOYJFcy5tUKQMFE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=WbezOLmI; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=Ki6XdZwi; arc=none smtp.client-ip=217.70.190.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="WbezOLmI";
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="Ki6XdZwi"
Received: by mail.netfilter.org (Postfix, from userid 109)
	id 08CEA605C4; Tue, 18 Mar 2025 23:19:03 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1742336343;
	bh=StJSqHruUAvAlDLN30dMWLBYHKM0bC+uK1yMEGF2UnA=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=WbezOLmIzT3mRchfWZ6FU4O+wXDB6jKR2DjtjDj6F8xKSwS3ODNz2Dgls21qjKSR4
	 qL7JAZeFfFGAWZwtuwZPkWVSB8B+DaA336koVay/cMg3yDGojn61QpZPCyShXTt2GS
	 nlGrjrGXVZejtJbOPyoG/yJYy8dDsEOH/UEUUu4jNyyKmXFiKzZAuaHx1Fow3NkVqd
	 uRc9Bm0WKbRZpp/UCWHXU/gZJrGU1cB7zEnQmtlllbjNkhQLTb3sUX1hJekhBajwys
	 m2aJflD2kT/8aK/DfGzKwqzpYAlY/hzvWM/eU+n62cFk41eVHhaJWjtROD9ejeLjs3
	 fa1q0MR5Meu2A==
X-Spam-Level: 
Received: from netfilter.org (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with ESMTPSA id A5A8A6059E;
	Tue, 18 Mar 2025 23:18:59 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1742336339;
	bh=StJSqHruUAvAlDLN30dMWLBYHKM0bC+uK1yMEGF2UnA=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=Ki6XdZwi+piR3LjabJGxx3Obx0FkH1SUg4fJDaGCmsT9JxUnTeCP3pMSvHEiZWX77
	 NMn4Km3z/3vXkN9u/qlFsEUR55f8TM6Tp4XmPG9rzzoTvtc/+BExUARvWehWaTHlgz
	 u8PefjONqrpp1DAQ6j2zUoVWDFt/kxCjswTvE1LD5Y62vMB0QP+v20gbIlHPb48z+t
	 qvwuscdlw0ZGh6zNyaDpculC5vwyAoBiL9vz+SXjSa1/qMXf8S3QQ6ilCXta8/A4GQ
	 hX3QXgqHT+9c7v0TwGtFLryyo7TuAcbJ+lQ5S7gejHs8zK7GpfPivgI7Xidp0T7qXU
	 pB/aNcbMW97mA==
Date: Tue, 18 Mar 2025 23:18:57 +0100
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: gregkh@linuxfoundation.org, sashal@kernel.org
Cc: jianqi.ren.cn@windriver.com, stable@vger.kernel.org,
	patches@lists.linux.dev, linux-kernel@vger.kernel.org,
	kadlec@netfilter.org, fw@strlen.de, davem@davemloft.net,
	edumazet@google.com, kuba@kernel.org, pabeni@redhat.com,
	kaber@trash.net, netfilter-devel@vger.kernel.org,
	coreteam@netfilter.org, netdev@vger.kernel.org
Subject: Re: [PATCH 6.6.y] netfilter: nf_tables: use timestamp to check for
 set element timeout
Message-ID: <Z9nxUdl9OcOlEl8L@calendula>
References: <20250317081632.2997440-1-jianqi.ren.cn@windriver.com>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20250317081632.2997440-1-jianqi.ren.cn@windriver.com>

Hi Greg, Sasha,

This backport is correct, please apply to -stable 6.6

On Mon, Mar 17, 2025 at 04:16:32PM +0800, jianqi.ren.cn@windriver.com wrote:
> From: Pablo Neira Ayuso <pablo@netfilter.org>
> 
> [ Upstream commit 7395dfacfff65e9938ac0889dafa1ab01e987d15 ]
> 
> Add a timestamp field at the beginning of the transaction, store it
> in the nftables per-netns area.
> 
> Update set backend .insert, .deactivate and sync gc path to use the
> timestamp, this avoids that an element expires while control plane
> transaction is still unfinished.
> 
> .lookup and .update, which are used from packet path, still use the
> current time to check if the element has expired. And .get path and dump
> also since this runs lockless under rcu read size lock. Then, there is
> async gc which also needs to check the current time since it runs
> asynchronously from a workqueue.
> 
> Fixes: c3e1b005ed1c ("netfilter: nf_tables: add set element timeout support")
> Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
> Signed-off-by: Jianqi Ren <jianqi.ren.cn@windriver.com>
> Signed-off-by: He Zhe <zhe.he@windriver.com>

Reviewed-by: Pablo Neira Ayuso <pablo@netfilter.org>
Tested-by: Pablo Neira Ayuso <pablo@netfilter.org>
