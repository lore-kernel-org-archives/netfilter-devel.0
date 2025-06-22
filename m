Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 299B147F4A
	for <netfilter-devel@vger.kernel.org>; Sun, 22 Jun 2025 14:18:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750601929; cv=none; b=Lsvu9CI9UkZ+gmV9mXJ5ttRiRIo6EPp8tHzZ4OTmf8mvOShs/OK3oWxD9LrSsZwy5V/9eEVwRX3oBqNEArxkPpjFAbB3SDkV5cJRzVifbk1Ipi4RSS6UBSneO57VYAo48qBPKYH4M4Qx4I48ekkKDlYun9cOVuW1VDiWItLQIrI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750601929; c=relaxed/simple;
	bh=oHmqw0hLvMWWWswpDJ7bMltvbfCMsdcNhmWIMhB8e4w=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=DquYvm7qqLf2J6Ze53JS5jzONBKnuTfwcKy7spEH62mWStlR9liYfwnuzDQgaWkvVBSLUX6rIJUs0/d25LfoXCyyOOG/dWzq97Te0nFS/L6sMiCk08qapHMvfKYPPBRA8s6kq8N7Guv13JW/TB+ksSFonJQGR0G4UeRhwgHLFnE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=strlen.de; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=strlen.de
Received: by Chamillionaire.breakpoint.cc (Postfix, from userid 1003)
	id 2C9836123A; Sun, 22 Jun 2025 16:18:38 +0200 (CEST)
Date: Sun, 22 Jun 2025 16:18:37 +0200
From: Florian Westphal <fw@strlen.de>
To: Yi Chen <yiche@redhat.com>
Cc: netfilter-devel@vger.kernel.org
Subject: Re: [PATCH v2 3/4] test: shell: Add wait_local_port_listen() helper
 to lib.sh
Message-ID: <aFgQreFzWJJlLVhU@strlen.de>
References: <20250622125554.4960-1-yiche@redhat.com>
 <20250622125554.4960-2-yiche@redhat.com>
 <20250622125554.4960-3-yiche@redhat.com>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250622125554.4960-3-yiche@redhat.com>

Yi Chen <yiche@redhat.com> wrote:
>  ip netns exec $S tcpdump -q --immediate-mode -Ui s_r -w ${PCAP} 2> /dev/null &
>  pid=$!
> +sleep 0.5

You might want to add a wait_for_tcpdump_listen helper, that checks
/proc/net/packet for tcpdump appearance, or /porc/$pid/fd/ for
appearance of the packet socket.

No need to resend and no need to work on this, just something to keep
in mind of the future.

I've applied all 4 patches and pushed them out, thanks for addressing
all review comments.
