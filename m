From: Piotr Chytla <pch@fouk.org>
Subject: Re: Backported conntrack-acct/connbytes to 2.4 tree
Date: Mon, 4 Apr 2005 00:47:03 +0200
Message-ID: <20050403224703.GA15036@fouk.org>
References: <20041116220502.GA2677@fouk.org> <20041121163442.GA99261@fouk.org>
	<1112349726.20323.23.camel@develbox.linuxbox.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-2
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Nikola Ciprich <extmaillist@linuxbox.cz>
Content-Disposition: inline
In-Reply-To: <1112349726.20323.23.camel@develbox.linuxbox.cz>
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

On Fri, Apr 01, 2005 at 12:02:06PM +0200, Nikola Ciprich wrote:
> Hi all, I'd like to ask, what is state of this patch? Is it going to
> main tree? 
conntrack-acct is in 2.6 main tree but Herald wrote this patch not me , my patch is 
only dirty backport :>

>I'm not able to build iptables-1.3.1 without it, but it
> breaks (at least) conntrack_{gre,mppe}
What kernel version? maybe you have old kernel headers.

/pch
