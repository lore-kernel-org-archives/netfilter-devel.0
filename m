From: Patrick McHardy <kaber@trash.net>
Subject: Re: [PATCH] compilation error + kernel panic sip-conntrack-nat
Date: Wed, 29 Mar 2006 10:41:10 +0200
Message-ID: <442A4826.3060908@trash.net>
References: <20060327135637.GA19422@runtux.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Ralf Schlatterbeck <rsc@runtux.com>
In-Reply-To: <20060327135637.GA19422@runtux.com>
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

Ralf Schlatterbeck wrote:
> The following patch fixes a compilation problem for 2.6.16 (two missing
> includes) and a kernel panic on the first sip packets (reproduced with
> 2.6.15.4 and 2.6.16, tested only with 2.6.16). The kernel-panic fix is
> from the mailinglist-archive but obviously didn't yet make it into
> the official tree yet.

I actually have a version with some more fixes I wanted to submit (since
quite some time), but I haven't gotten around to fixing the last
remaining issue, so I've applied your patch for now. Thanks.

> Note: The FAQ-Entry about SIP 
> http://www.netfilter.org/documentation/FAQ/netfilter-faq-1.html#ss1.8
> should be updated to point to sip-conntrack-nat, see
> http://www.iptel.org/sipalg/
> The conntrack module would surely get more testing if it is mentioned in
> the FAQ :-)

Feel free to send a patch :)
