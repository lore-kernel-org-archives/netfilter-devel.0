Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EEA0913A411;
	Mon, 15 Apr 2024 18:04:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713204251; cv=none; b=jVNvrWOSWB5P6ukW+chQcOrJNwxORhR8tMCklVbPH/OmGuKlmZyMkdtFUOUMlGcWamoAXGpaPA5lwOhDMid58S+JHRLfNpKbnAKN0WoiSAzyTqQGaqU8zDUfVbl1IwoDd6AuBVM1+4pyNRcdwFgu7o7ZzOFOWZVRRvM6xmuXo9Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713204251; c=relaxed/simple;
	bh=prw3a4gxZDfNxq4KrMzr2hxWepF5GrE6RAspKqgvOLc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ozGoCG2XfX4GXQu43oYu19NGGqSSY0nXCtAy+kIXlmAxZthAYctz31axg9dtMgsAYKWqeOhol3fT8RR+bhR3uxbjnm+AVkisTTUEwHISTrMlg2m5JjfcK67XTzlalHCuKe7wzrMwos0h7NP2vwMFAzBTSPFLgEEOzJ8nDLS6RXY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=strlen.de; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=strlen.de
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
	(envelope-from <fw@strlen.de>)
	id 1rwQgS-0000gj-49; Mon, 15 Apr 2024 20:04:00 +0200
Date: Mon, 15 Apr 2024 20:04:00 +0200
From: Florian Westphal <fw@strlen.de>
To: Jakub Kicinski <kuba@kernel.org>
Cc: Florian Westphal <fw@strlen.de>, netdev@vger.kernel.org,
	Paolo Abeni <pabeni@redhat.com>,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>, netfilter-devel@vger.kernel.org,
	pablo@netfilter.org
Subject: Re: [PATCH net-next 12/12] selftests: netfilter: update makefiles
 and kernel config
Message-ID: <20240415180400.GC27869@breakpoint.cc>
References: <20240414225729.18451-1-fw@strlen.de>
 <20240414225729.18451-13-fw@strlen.de>
 <20240415070240.3d4b63c2@kernel.org>
 <20240415143054.GA27869@breakpoint.cc>
 <20240415104626.2b1ad88f@kernel.org>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240415104626.2b1ad88f@kernel.org>
User-Agent: Mutt/1.10.1 (2018-07-13)

Jakub Kicinski <kuba@kernel.org> wrote:
> On Mon, 15 Apr 2024 16:30:54 +0200 Florian Westphal wrote:
> > If you prefer you can apply the series without the last patch
> > and then wait for v2 of that last one.
> 
> Sounds good, let me do that (in a few hours)!

Sure, no rush, thanks Jakub.
