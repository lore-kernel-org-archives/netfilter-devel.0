Authentication-Results: smtp.subspace.kernel.org; dkim=none
Received: from ganesha.gnumonks.org (ganesha.gnumonks.org [IPv6:2001:780:45:1d:225:90ff:fe52:c662])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0AFEE99
	for <netfilter-devel@vger.kernel.org>; Wed, 29 Nov 2023 10:55:43 -0800 (PST)
Received: from [78.30.43.141] (port=40754 helo=gnumonks.org)
	by ganesha.gnumonks.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.94.2)
	(envelope-from <pablo@gnumonks.org>)
	id 1r8Pij-00CF7o-Gm; Wed, 29 Nov 2023 19:55:39 +0100
Date: Wed, 29 Nov 2023 19:55:36 +0100
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: Thomas Haller <thaller@redhat.com>
Cc: NetFilter <netfilter-devel@vger.kernel.org>
Subject: Re: [PATCH nft 0/2] tests/shell: workaround for bash
Message-ID: <ZWeJKDOvIMXQhcrJ@calendula>
References: <20231127191713.3528973-1-thaller@redhat.com>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20231127191713.3528973-1-thaller@redhat.com>
X-Spam-Score: -1.9 (-)

On Mon, Nov 27, 2023 at 08:15:34PM +0100, Thomas Haller wrote:
> RHEL8 has bash 4.4. Make some adjustments so that the test script works
> there.

Applied, thanks.
