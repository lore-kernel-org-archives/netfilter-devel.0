From: Yasuyuki KOZAKAI <yasuyuki.kozakai@toshiba.co.jp>
Subject: Re: [NETFILTER] nf_conntrack: fix memset() size.
Date: Wed, 25 Jan 2006 14:41:48 +0900 (JST)
Message-ID: <200601250541.k0P5fnMQ019797@toshiba.co.jp>
References: <m2hd7tass3.fsf@cerbere.dyndns.info>
	<200601250405.k0P45IjD000878@toshiba.co.jp>
	<m2acdkc3xl.fsf@cerbere.dyndns.info>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@lists.netfilter.org, davem@davemloft.net,
	yasuyuki.kozakai@toshiba.co.jp
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: sbellabes@mandriva.com, laforge@netfilter.org, kaber@trash.net
In-Reply-To: <m2acdkc3xl.fsf@cerbere.dyndns.info>
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


From: Samir Bellabes <sbellabes@mandriva.com>
Date: Wed, 25 Jan 2006 05:44:06 +0100

> [PATCH] [NETFILTER] nf_conntrack_ftp : delete bogus memset()
> 
> This memset() is executing with a bad size.
> According to Yasuyuki Kozakai, this memset() can be deleted, as 'ftp'
> is declared in global area.
> 
> Signed-off-by: Samir Bellabes <sbellabes@mandriva.com>

Well, your mailer or something seems to replace tab with white spaces.
OK, I've fixed up this to save more mails. Anyway, thanks a lot !

Harald, or Patrick, please apply this.


[PATCH] [NETFILTER] nf_conntrack_ftp : delete bogus memset()

This memset() is executing with a bad size.
According to Yasuyuki Kozakai, this memset() can be deleted, as 'ftp'
is declared in global area.

Signed-off-by: Samir Bellabes <sbellabes@mandriva.com>
Signed-off-by: Yasuyuki Kozakai <yasuyuki.kozakai@toshiba.co.jp>

---

diff --git a/net/netfilter/nf_conntrack_ftp.c b/net/netfilter/nf_conntrack_ftp.c
index ab0c920..6f210f3 100644
--- a/net/netfilter/nf_conntrack_ftp.c
+++ b/net/netfilter/nf_conntrack_ftp.c
@@ -657,8 +657,6 @@ static int __init init(void)
 	/* FIXME should be configurable whether IPv4 and IPv6 FTP connections
 		 are tracked or not - YK */
 	for (i = 0; i < ports_c; i++) {
-		memset(&ftp[i], 0, sizeof(struct nf_conntrack_helper));
-
 		ftp[i][0].tuple.src.l3num = PF_INET;
 		ftp[i][1].tuple.src.l3num = PF_INET6;
 		for (j = 0; j < 2; j++) {
