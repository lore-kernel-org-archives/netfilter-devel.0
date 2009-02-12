From: David Miller <davem@davemloft.net>
Subject: Re: [PATCH] Update jhash.h with the new version of Jenkins' hash
Date: Wed, 11 Feb 2009 16:29:28 -0800 (PST)
Message-ID: <20090211.162928.193706021.davem@davemloft.net>
References: <alpine.DEB.2.00.0902111107480.15665@blackhole.kfki.hu>
	<20090212001223.GA5757@movementarian.org>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Cc: kadlec@blackhole.kfki.hu, linux-kernel@vger.kernel.org,
	netdev@vger.kernel.org, netfilter-devel@vger.kernel.org,
	rusty@rustcorp.com.au
To: wli@movementarian.org
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <20090212001223.GA5757@movementarian.org>
Sender: netdev-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

From: wli@movementarian.org
Date: Wed, 11 Feb 2009 19:12:23 -0500

> (double)0xdeadbeef/((unsigned long long)1 << 32) is a rather poor
> approximation of (sqrt(5)-1)/2. If this value which is not the
> golden ratio is arbitrary, calling it something different from
> JHASH_GOLDEN_RATIO would surprise the code's readers much less.

Then we can change the name, whatever...

But really, anyone truly interested will read the friggin' web site
where all the design documents and hash test results live.
