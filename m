From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [RESEND PATCH 1/2] Extend accounting capabilities to support
 quotas
Date: Mon, 28 Apr 2014 12:18:51 +0200
Message-ID: <20140428101851.GB3739@localhost>
References: <1398041896-8479-1-git-send-email-mathieu.poirier@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org, netfilter@vger.kernel.org,
	john.stultz@linaro.org
To: mathieu.poirier@linaro.org
Return-path: <netfilter-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1398041896-8479-1-git-send-email-mathieu.poirier@linaro.org>
Sender: netfilter-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

On Sun, Apr 20, 2014 at 06:58:15PM -0600, mathieu.poirier@linaro.org wrote:
> From: Mathieu Poirier <mathieu.poirier@linaro.org>
> 
> The accounting framework already supports accounting at the
> quota and byte level.  As such it is a natural extention to
> add a ceiling limit to those metrics.

Applied.
