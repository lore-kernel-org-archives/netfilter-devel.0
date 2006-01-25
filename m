From: Patrick McHardy <kaber@trash.net>
Subject: Re: [NETFILTER] nf_conntrack: fix memset() size.
Date: Wed, 25 Jan 2006 09:43:23 +0100
Message-ID: <43D73A2B.6030402@trash.net>
References: <m2hd7tass3.fsf@cerbere.dyndns.info>	<200601250405.k0P45IjD000878@toshiba.co.jp>	<m2acdkc3xl.fsf@cerbere.dyndns.info>
	<200601250541.k0P5fnG7019802@toshiba.co.jp>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: laforge@netfilter.org, netfilter-devel@lists.netfilter.org,
	sbellabes@mandriva.com, davem@davemloft.net
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Yasuyuki KOZAKAI <yasuyuki.kozakai@toshiba.co.jp>
In-Reply-To: <200601250541.k0P5fnG7019802@toshiba.co.jp>
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

Yasuyuki KOZAKAI wrote:
> From: Samir Bellabes <sbellabes@mandriva.com>
> Date: Wed, 25 Jan 2006 05:44:06 +0100
> 
> 
>>[PATCH] [NETFILTER] nf_conntrack_ftp : delete bogus memset()
>>
>>This memset() is executing with a bad size.
>>According to Yasuyuki Kozakai, this memset() can be deleted, as 'ftp'
>>is declared in global area.
>>
>>Signed-off-by: Samir Bellabes <sbellabes@mandriva.com>
> 
> 
> Well, your mailer or something seems to replace tab with white spaces.
> OK, I've fixed up this to save more mails. Anyway, thanks a lot !
> 
> Harald, or Patrick, please apply this.

Done, thanks.
