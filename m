From: Yasuyuki KOZAKAI <yasuyuki.kozakai@toshiba.co.jp>
Subject: Re: iptables-xml broken with IPTABLES_MULTI
Date: Mon, 11 Dec 2006 13:00:49 +0900 (JST)
Message-ID: <200612110400.kBB40pI7019407@toshiba.co.jp>
References: <20061207123847.GA30414@innominate.com>
	<200612071249.kB7Cn4N1022459@toshiba.co.jp>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@lists.netfilter.org, ljaenicke@innominate.com
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: yasuyuki.kozakai@toshiba.co.jp
In-Reply-To: <200612071249.kB7Cn4N1022459@toshiba.co.jp>
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

From: Yasuyuki KOZAKAI <yasuyuki.kozakai@toshiba.co.jp>
Date: Thu, 07 Dec 2006 21:49:02 +0900 (JST)

> From: Lutz Jaenicke <ljaenicke@innominate.com>
> Date: Thu, 7 Dec 2006 13:38:47 +0100
> 
> > Hi!
> > 
> > as of iptables-1.3.7 a new "iptables-xml" command is added automatically
> > to the IPTABLES_MULTI executable. It however breaks during build.
> > The attached patch seems to fix it.
> 
> Wow same timing. Your patch is better than mine, then I'll apply it.
> 
> Thanks a lot.

Applied. I've also added the deleted 'void' for exit_error and fixed
Makefile to create link iptables-xml to iptables.

-- Yasuyuki Kozakai
