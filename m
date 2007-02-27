From: Yasuyuki KOZAKAI <yasuyuki.kozakai@toshiba.co.jp>
Subject: Re: [RFC][PATCH][IPTABLES]: suppress the error of modprobe
Date: Tue, 27 Feb 2007 17:43:25 +0900 (JST)
Message-ID: <200702270843.l1R8hQ4p004287@toshiba.co.jp>
References: <465018.92293.qm@web53609.mail.yahoo.com>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@lists.netfilter.org
To: hlmuller@yahoo.com
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
In-Reply-To: <465018.92293.qm@web53609.mail.yahoo.com>
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

From: Harvey Muller <hlmuller@yahoo.com>
Date: Wed, 21 Feb 2007 08:45:16 -0800 (PST)

> Yasuyuki,
> 
> I was unable to patch using the text you provided in the post, as it kept complaining about malformed text.
> 
> I did however make the corrections by hand using the iptables 1.3.7 release, and created a patch.  What I
> noticed is that all of the line numbers match in your post match, except for those in ip6tables.c.  So you
> may have made changes to a version different than that noted above.

Sorry for late replying. The patch is for the current SVN tree, not 1.3.7.

Regards,

-- Yasuyuki Kozakai
