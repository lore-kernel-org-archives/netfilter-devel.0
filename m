From: David Miller <davem@davemloft.net>
Subject: Re: [TEXTSEARCH]: Fix Boyer Moore initialization bug
Date: Tue, 22 Aug 2006 00:45:34 -0700 (PDT)
Message-ID: <20060822.004534.88338145.davem@davemloft.net>
References: <44EA66FD.8050502@trash.net>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@lists.netfilter.org, stable@kernel.org, bunk@stusta.de
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: kaber@trash.net
In-Reply-To: <44EA66FD.8050502@trash.net>
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
Date: Tue, 22 Aug 2006 04:07:57 +0200

> this fixes an initialization bug in the bm textsearch
> algorithm affecting the netfilter string match (the
> only user AFAIK). Please apply to 2.6.18, thanks.
> 
> @stable maintainers: the bm_ts author asked me to also
> submit this to -stable, please apply.

Applied and Ack'd for -stable.
