From: Yasuyuki KOZAKAI <yasuyuki.kozakai@toshiba.co.jp>
Subject: Re: [PATCH 07/**] Move connlimit to xt
Date: Wed, 01 Aug 2007 23:32:58 +0900 (JST)
Message-ID: <200708011432.l71EWxqk008393@toshiba.co.jp>
References: <Pine.LNX.4.64.0707241246160.18990@fbirervta.pbzchgretzou.qr>
	<200707310044.l6V0iw0T027806@toshiba.co.jp>
	<Pine.LNX.4.64.0707310939390.22515@fbirervta.pbzchgretzou.qr>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@lists.netfilter.org, kaber@trash.net,
	yasuyuki.kozakai@toshiba.co.jp
To: jengelh@computergmbh.de
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
In-Reply-To: <Pine.LNX.4.64.0707310939390.22515@fbirervta.pbzchgretzou.qr>
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

From: Jan Engelhardt <jengelh@computergmbh.de>
Date: Tue, 31 Jul 2007 09:58:33 +0200 (CEST)

> 
> On Jul 31 2007 09:44, Yasuyuki KOZAKAI wrote:
> >
> >The manuals cannot be unified in the current.
> 
> Updated patch below.

(snip)

> >Looks fine, But this patch also includes a change to allow to use
> >--connlimit-mask and --connlimit-above. Why previous connlimit prohibited
> >that ?
> 
> Previously, there was
> 
> 	if (*flags & c)
> 		exit_error();
> 
> But connlimit_parse() does not only get c=1 or c=2. It also gets 
> c=<something else>, for example by specifying a non-connlimit option.
> 
> Then, *flags & c does the wrong thing.

Thanks for explanation. I applied it. BTW, please split patch into 2
piecies in such case and please don't mix fix and others from next time.

Thanks,

-- Yasuyuki Kozakai
