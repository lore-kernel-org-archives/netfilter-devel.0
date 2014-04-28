From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [RESEND PATCH v2] netfilter: nfnetlink_acct: Adding quota
 support to accounting framework
Date: Mon, 28 Apr 2014 12:18:38 +0200
Message-ID: <20140428101838.GA3739@localhost>
References: <1398041856-8440-1-git-send-email-mathieu.poirier@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org, netfilter@vger.kernel.org,
	john.stultz@linaro.org
To: mathieu.poirier@linaro.org
Return-path: <netfilter-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1398041856-8440-1-git-send-email-mathieu.poirier@linaro.org>
Sender: netfilter-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

On Sun, Apr 20, 2014 at 06:57:36PM -0600, mathieu.poirier@linaro.org wrote:
> From: Mathieu Poirier <mathieu.poirier@linaro.org>
> 
> Nf_acct objects already support accounting at the byte and packet
> level.  As such it is a natural extention to add the possiblity to
> define a ceiling limit for both metrics.
> 
> All the support for quotas itself is added to nfnetlink acctounting
> framework to stay coherent with current accounting object management.
> Quota limit checks are implemented in xt nfacct filter where
> statistic collection is already done.
> 
> Pablo Niera Ayuso has also contributed to this feature.

Enqueued to 3.16.
