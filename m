From: David Miller <davem@davemloft.net>
Subject: Re: [NETFILTER 00/02]: Netfilter fixes
Date: Fri, 22 Jun 2007 14:11:15 -0700 (PDT)
Message-ID: <20070622.141115.110134584.davem@davemloft.net>
References: <20070622114656.14839.1945.sendpatchset@localhost.localdomain>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@lists.netfilter.org
To: kaber@trash.net
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
In-Reply-To: <20070622114656.14839.1945.sendpatchset@localhost.localdomain>
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

From: Patrick McHardy <kaber@trash.net>
Date: Fri, 22 Jun 2007 13:47:30 +0200 (MEST)

> Hi Dave,
> 
> following are two netfilter fixes for 2.6.22, adding a few new SIP message
> types that are necessary to get Jerome's setup working, and a patch to
> forbid changing helpers of an existing connection to avoid races while
> changing the helper private area.
> 
> Please apply, thanks.

Both patches applied, thanks Patrick!
