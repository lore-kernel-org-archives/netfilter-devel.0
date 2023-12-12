Received: from ganesha.gnumonks.org (ganesha.gnumonks.org [IPv6:2001:780:45:1d:225:90ff:fe52:c662])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6B824AD
	for <netfilter-devel@vger.kernel.org>; Tue, 12 Dec 2023 05:42:36 -0800 (PST)
Received: from [78.30.43.141] (port=35462 helo=gnumonks.org)
	by ganesha.gnumonks.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.94.2)
	(envelope-from <pablo@gnumonks.org>)
	id 1rD31s-00217f-Qf; Tue, 12 Dec 2023 14:42:34 +0100
Date: Tue, 12 Dec 2023 14:42:32 +0100
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: corubba <corubba@gmx.de>
Cc: netfilter-devel@vger.kernel.org
Subject: Re: [PATCH libnftnl] object: getters take const struct
Message-ID: <ZXhjSCLJoyJWfAHi@calendula>
References: <5c64b212-6e43-424a-a6b0-ba79c0596d3e@gmx.de>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <5c64b212-6e43-424a-a6b0-ba79c0596d3e@gmx.de>
X-Spam-Score: -0.9 (/)

On Sat, Dec 09, 2023 at 11:03:01PM +0100, corubba wrote:
> As with all the other entities (like table or set), the getter functions
> for objects now take a `const struct nftnl_obj*` as first parameter.
> The getters for all specific object types (like counter or limit), which
> are called in the default switch-case, already do.

Applied, thanks
