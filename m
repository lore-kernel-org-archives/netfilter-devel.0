Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E2E6163CB;
	Sun, 19 Jan 2025 00:58:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737248322; cv=none; b=N5v2dEAb/1bYISfw/jwsGnCCrnL6B2kFZltClMdvE0r48O+MJr7WgDGAq+PMmeWAXk3c7VDdpFTU+d20R+zOyDKa580UGV6FBMKkLPoa7nPL3aGEOmdpwS7kH0d1w7j+ABl/w0U+vHWWiFnTuQuNg2RNdwHSUU+ES4OnNjnhfmc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737248322; c=relaxed/simple;
	bh=6p2f7n+MTTUwMkcl17RaSp0LJV7WINDRBrzrdT+L+eM=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=X3v/EzZiCdoc29qJZkx7qj8CGbVKCv4PhNWi0ujxgmGNf5qVA480T7CQI0GlI4SBHOmaejmfAQ0+WCxod4lSEB3qrVMECjRAljm2Tnbt3S04TYDb626C4B10DV0Gn95Q/ewrtG8gS/x4gqaLirmo3qIH2eQQWDwcVhqm58LXtwk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=H8Zf+BgV; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="H8Zf+BgV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0A9E2C4CED1;
	Sun, 19 Jan 2025 00:58:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1737248321;
	bh=6p2f7n+MTTUwMkcl17RaSp0LJV7WINDRBrzrdT+L+eM=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=H8Zf+BgVz4ctqiQ3kuoJx0SlLKbTT/JK31YoV4X6lgFJFEtG0mLJmoW8WF3oPJpyk
	 p7zH2CfwJgYQgSHfH6fVWFGVORWyRdbKYzodkFnx+3xKANx+BfWErBPO5qgFTxLFTP
	 1+b5vNBa3aIhmg4qF373OfNTa4ly6AsGUqCylWnP7kKvy+nBJ/1Qrvf+qNS+Dp/ubU
	 S1lfbGVFetrW6s9D9nKOCwjv79INWBYEHecIWut2+0Tyob/CaqEA2c4NKBkVIOvxkl
	 0jWr5EumHdkmomygD/kJSSdeCOFNQHcRFGNSuxXwBW3E58x/XEWbFzRfZL9VSawE5A
	 Tiz/iBD9fMl2Q==
Date: Sat, 18 Jan 2025 16:58:40 -0800
From: Jakub Kicinski <kuba@kernel.org>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Cc: netfilter-devel@vger.kernel.org, davem@davemloft.net,
 netdev@vger.kernel.org, pabeni@redhat.com, edumazet@google.com,
 fw@strlen.de
Subject: Re: [PATCH net-next 02/14] netfilter: br_netfilter: remove unused
 conditional and dead code
Message-ID: <20250118165840.7a4fb1d0@kernel.org>
In-Reply-To: <20250116171902.1783620-3-pablo@netfilter.org>
References: <20250116171902.1783620-1-pablo@netfilter.org>
	<20250116171902.1783620-3-pablo@netfilter.org>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Thu, 16 Jan 2025 18:18:50 +0100 Pablo Neira Ayuso wrote:
> Subject: [PATCH net-next 02/14] netfilter: br_netfilter: remove unused conditional and dead code

This one is missing Pablo's SoB. Maybe you could respin with this and
the kdoc fixed?
