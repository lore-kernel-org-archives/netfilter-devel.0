From: Patrick McHardy <kaber@trash.net>
Subject: Re: [PATCH]: ROUTE: convert hh_lock to seqlock
Date: Thu, 24 May 2007 19:45:02 +0200
Message-ID: <4655CF1E.3050500@trash.net>
References: <20070524015758.GA6544@mycre.ws>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@lists.netfilter.org
To: Robert Edmonds <edmonds@debian.org>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
In-Reply-To: <20070524015758.GA6544@mycre.ws>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: </pipermail/netfilter-devel>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
Sender: netfilter-devel-bounces@lists.netfilter.org
Errors-To: netfilter-devel-bounces@lists.netfilter.org
List-Id: netfilter-devel.vger.kernel.org

Robert Edmonds wrote:
> hh_cache's lock has been converted to a seqlock in recent kernels.


Applied, thanks. I wish someone else could take care of ROUTE
maintenance.
