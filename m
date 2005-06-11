From: Patrick McHardy <kaber@trash.net>
Subject: Re: Missed any patches? [PATCH] expectation timeouts
Date: Sat, 11 Jun 2005 19:10:29 +0200
Message-ID: <42AB1B05.2060509@trash.net>
References: <42AB1577.5040006@trash.net> <20050611170739.GA5018@linuxace.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Cc: Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Phil Oester <kernel@linuxace.com>
In-Reply-To: <20050611170739.GA5018@linuxace.com>
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

Phil Oester wrote:
> Since expectation timeouts were made compulsory [1], there is no need to
> check for them in ip_conntrack_expect_insert.

Thanks, I just found it and am about to apply it to my 2.6.13 tree.

Regards
Patrick
