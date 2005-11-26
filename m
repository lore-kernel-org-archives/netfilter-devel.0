From: Patrick McHardy <kaber@trash.net>
Subject: Re: [1/1] OSF: fix 2.4 compilation.
Date: Sun, 27 Nov 2005 00:42:08 +0100
Message-ID: <4388F2D0.9040102@trash.net>
References: <20051126123334.GA31037@2ka.mipt.ru>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Harald Welte <laforge@netfilter.org>, netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Evgeniy Polyakov <johnpol@2ka.mipt.ru>
In-Reply-To: <20051126123334.GA31037@2ka.mipt.ru>
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

Evgeniy Polyakov wrote:
> Bug found by Aleksey Barabanov <alekseybb mail.ru>.
> Thank you.
> 
> Signed-off-by: Evgeniy Polyakov <johnpol@2ka.mipt.ru>
> 
> --- net/ipv4/netfilter/ipt_osf.c.orig	2005-11-26 15:29:33.000000000 +0300
> +++ net/ipv4/netfilter/tmp/ipt_osf.c	2005-11-26 15:29:05.000000000 +0300

This doesn't apply, I had to fix it up by hand. Please
make sure future patches are based in the patch-o-matic
root and patch the right file.
