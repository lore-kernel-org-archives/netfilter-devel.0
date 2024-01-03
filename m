Received: from ganesha.gnumonks.org (ganesha.gnumonks.org [213.95.27.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1FE1918C10;
	Wed,  3 Jan 2024 10:26:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gnumonks.org
Received: from [78.30.41.52] (port=54536 helo=gnumonks.org)
	by ganesha.gnumonks.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.94.2)
	(envelope-from <pablo@gnumonks.org>)
	id 1rKyRx-009QtZ-F1; Wed, 03 Jan 2024 11:26:15 +0100
Date: Wed, 3 Jan 2024 11:26:12 +0100
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: Aaron Conole <aconole@redhat.com>
Cc: Simon Horman <horms@kernel.org>, Brad Cowie <brad@faucet.nz>,
	netdev@vger.kernel.org, dev@openvswitch.org, fw@strlen.de,
	linux-kernel@vger.kernel.org, kadlec@netfilter.org,
	edumazet@google.com, netfilter-devel@vger.kernel.org,
	kuba@kernel.org, pabeni@redhat.com, davem@davemloft.net,
	Xin Long <lucien.xin@gmail.com>, coreteam@netfilter.org
Subject: Re: [PATCH net] netfilter: nf_nat: fix action not being set for all
 ct states
Message-ID: <ZZU2RPcYX/iueeRe@calendula>
References: <20231221224311.130319-1-brad@faucet.nz>
 <20231223211306.GA215659@kernel.org>
 <f7tle97eppk.fsf@redhat.com>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <f7tle97eppk.fsf@redhat.com>
X-Spam-Score: -1.9 (-)

Applied to nf.git, thanks everyone for reviewing.
