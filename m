Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b="c6zi/vXk"
Received: from orbyte.nwl.cc (orbyte.nwl.cc [IPv6:2001:41d0:e:133a::1])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A4DB793
	for <netfilter-devel@vger.kernel.org>; Tue, 28 Nov 2023 17:21:25 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nwl.cc;
	s=mail2022; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
	Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=CuND1h1hBs181Iclds/CmqgYFJf4MCpsHEdOe731OQ8=; b=c6zi/vXkYmD66+teB933r0AeVY
	De+sCnxSy8V1ax32l9wKjMpF2Dy9HSjL+Oz+8ds1vQhwsQ0xNMQ2rJK8lcmP6FGmoZAEwlHYoY0rx
	r5g0NhvolSfhzD2jvUzH0bKkBMN03QY5g2x07tZjrz0eemHC1UaFslIswJBG75LlgwtgHyjfKF51I
	jlY1q8BKh60o8IyMHPsStF1zzbD9JXiYwta/RzicYxbxr/YBkd83CwDGAaDkK8c0YE4X420fBd4fe
	FJhVBroUKn6Junazsiv4Z3dyMF6F5E/PUW7o4Fk/0ywDNQaA/06E/1S0eN/GKhyeVgMx7anI+1S/8
	5mc3ARVw==;
Received: from n0-1 by orbyte.nwl.cc with local (Exim 4.94.2)
	(envelope-from <phil@nwl.cc>)
	id 1r89GV-0007oN-Sg; Wed, 29 Nov 2023 02:21:24 +0100
Date: Wed, 29 Nov 2023 02:21:23 +0100
From: Phil Sutter <phil@nwl.cc>
To: netfilter-devel@vger.kernel.org
Cc: Jan Engelhardt <jengelh@inai.de>
Subject: Re: [iptables PATCH] man: Do not escape exclamation marks
Message-ID: <ZWaSE4CxpOM6iBF3@orbyte.nwl.cc>
Mail-Followup-To: Phil Sutter <phil@nwl.cc>,
	netfilter-devel@vger.kernel.org, Jan Engelhardt <jengelh@inai.de>
References: <20231128123243.12790-1-phil@nwl.cc>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20231128123243.12790-1-phil@nwl.cc>

On Tue, Nov 28, 2023 at 01:32:43PM +0100, Phil Sutter wrote:
> This appears to be not necessary, also mandoc complains about it:
> 
> | mandoc: iptables/iptables-extensions.8:2170:52: UNSUPP: unsupported escape sequence: \!
> 
> Fixes: 71eddedcbf7ae ("libip6t_DNPT: add manpage")
> Fixes: 0a4c357cb91e1 ("libip6t_SNPT: add manpage")
> Signed-off-by: Phil Sutter <phil@nwl.cc>

Patch applied.
