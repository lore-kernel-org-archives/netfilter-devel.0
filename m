From: Samir Bellabes <sbellabes@mandriva.com>
Subject: Re: [NETFILTER] nf_conntrack: fix memset() size.
Date: Wed, 25 Jan 2006 05:44:06 +0100
Message-ID: <m2acdkc3xl.fsf@cerbere.dyndns.info>
References: <m2hd7tass3.fsf@cerbere.dyndns.info>
	<200601250405.k0P45IjD000878@toshiba.co.jp>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@lists.netfilter.org, sbellabes@mandriva.com,
	davem@davemloft.net
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Yasuyuki KOZAKAI <yasuyuki.kozakai@toshiba.co.jp>
In-Reply-To: <200601250405.k0P45IjD000878@toshiba.co.jp> (Yasuyuki KOZAKAI's
	message of "Wed, 25 Jan 2006 13:05:18 +0900 (JST)")
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

Yasuyuki KOZAKAI <yasuyuki.kozakai@toshiba.co.jp> writes:

> From: Samir Bellabes <sbellabes@mandriva.com>
>> This patch fix a bad size in memset().
>> The memory handle by 'struct nf_conntrack_helper ftp[MAX_PORTS][2]' is
>> only set for ftp[*][0], but not for ftp[*][1].
>
> Thanks. But I think better change is just removing this memset()
> because 'ftp' is declared in global area. Can I ask you to re-send a patch
> which just removes this memset() ?

[PATCH] [NETFILTER] nf_conntrack_ftp : delete bogus memset()

This memset() is executing with a bad size.
According to Yasuyuki Kozakai, this memset() can be deleted, as 'ftp'
is declared in global area.

Signed-off-by: Samir Bellabes <sbellabes@mandriva.com>

---

 net/netfilter/nf_conntrack_ftp.c |    2 --
 1 files changed, 0 insertions(+), 2 deletions(-)

applies-to: 84cf4e20ce5038cb701373c6d9f97195dfd23dfc
2b9fb3186e686e0f1029c33d7a2aaa2dcf20b36f
diff --git a/net/netfilter/nf_conntrack_ftp.c b/net/netfilter/nf_conntrack_ftp.c
index ab0c920..6f210f3 100644
--- a/net/netfilter/nf_conntrack_ftp.c
+++ b/net/netfilter/nf_conntrack_ftp.c
@@ -657,8 +657,6 @@ static int __init init(void)
        /* FIXME should be configurable whether IPv4 and IPv6 FTP connections
                 are tracked or not - YK */
        for (i = 0; i < ports_c; i++) {
-               memset(&ftp[i], 0, sizeof(struct nf_conntrack_helper));
-
                ftp[i][0].tuple.src.l3num = PF_INET;
                ftp[i][1].tuple.src.l3num = PF_INET6;
                for (j = 0; j < 2; j++) {
