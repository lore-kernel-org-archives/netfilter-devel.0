From: Yasuyuki KOZAKAI <yasuyuki.kozakai@toshiba.co.jp>
Subject: Re: [PATCH 04/**] Properly terminate option struct
Date: Tue, 31 Jul 2007 09:28:53 +0900 (JST)
Message-ID: <200707310028.l6V0SscL015483@toshiba.co.jp>
References: <Pine.LNX.4.64.0707241218590.18990@fbirervta.pbzchgretzou.qr>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@lists.netfilter.org, kaber@trash.net,
	yasuyuki.kozakai@toshiba.co.jp
To: jengelh@computergmbh.de
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
In-Reply-To: <Pine.LNX.4.64.0707241218590.18990@fbirervta.pbzchgretzou.qr>
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

> The option struct needs to be terminated, otherwise ip{,6}tables
> will access illegal memory in merge_options().
> 
> Signed-off-by: Jan Engelhardt <jengelh@gmx.de>

nice catch. Applied.

-- Yasuyuki Kozakai
