Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b="S3jLZn5d"
Received: from orbyte.nwl.cc (orbyte.nwl.cc [IPv6:2001:41d0:e:133a::1])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C3221F9
	for <netfilter-devel@vger.kernel.org>; Tue, 28 Nov 2023 17:21:02 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nwl.cc;
	s=mail2022; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
	Subject:To:From:Date:Sender:Reply-To:Cc:Content-Transfer-Encoding:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=Ee11+Ns2TBU1OIoyYMvypZc09TJkwpTv2SjX9s/Diuo=; b=S3jLZn5dyqpUtjPASOxO7yT1ro
	GCuEA69tRu9u5/TtbrZYnd9/i9FHaFCcEWBlagQdfFwXYGdVKzg8IJMWNMgba0Zwg2zRcrwoi8Ue1
	OfiVT7hqv9I9KFDqYveYTDFFXEYTRdvy2wPloOxvFoJWiZmBPn1XcJjdV7170Aozeuma2vw2aV7nE
	0fXWRk/k2Leu+61EhUWeq6JrHiXFRS/lo2eNaSiIgqedHZxojs6jU1ch8urh1BtQtudIJjD5xT02C
	JP/681CqJnL+J4BpSQPVQhvA7LjuxQXbkzj/wiigWB6N2Fclbh15EGL1WO9gWaA8oN3wbRjRFjCMK
	X0kYW/tg==;
Received: from n0-1 by orbyte.nwl.cc with local (Exim 4.94.2)
	(envelope-from <phil@nwl.cc>)
	id 1r89G8-0007nd-Rx
	for netfilter-devel@vger.kernel.org; Wed, 29 Nov 2023 02:21:00 +0100
Date: Wed, 29 Nov 2023 02:21:00 +0100
From: Phil Sutter <phil@nwl.cc>
To: netfilter-devel@vger.kernel.org
Subject: Re: [iptables PATCH 0/3] xshared: Review option parsing
Message-ID: <ZWaR/LhhbCZwStEl@orbyte.nwl.cc>
Mail-Followup-To: Phil Sutter <phil@nwl.cc>,
	netfilter-devel@vger.kernel.org
References: <20231124111325.5221-1-phil@nwl.cc>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20231124111325.5221-1-phil@nwl.cc>

On Fri, Nov 24, 2023 at 12:13:22PM +0100, Phil Sutter wrote:
> Faced with the need to extend optflags, inverse_for_options and
> commands_v_options arrays in order to integrate ebtables-specific
> options, I chose to get rid of them all instead.
> 
> Patch 1 replaces opt2char() function which didn't work well since not
> every option has printable short-option character. The callback-based
> replacement returns the long-option and should make error messages more
> readable this way.
> 
> Patch 2 elminates the inverse_for_options array along with the loop
> turning a given option into its bit's position for use in the array. The
> switch statement in the replacing callback is much easier to maintain
> and extend.
> 
> Patch 3 makes use of the fact that no command has a mandatory option
> anymore. So every combination is either allowed or not, and a single bit
> may indicate that.
> 
> Phil Sutter (3):
>   xshared: Introduce xt_cmd_parse_ops::option_name
>   xshared: Introduce xt_cmd_parse_ops::option_invert
>   xshared: Simplify generic_opt_check()

Series applied.
