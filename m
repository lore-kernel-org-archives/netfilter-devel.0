From: Patrick McHardy <kaber@trash.net>
Subject: Re: [RFC] limit - token bucket filter analysis
Date: Mon, 06 Aug 2007 14:28:52 +0200
Message-ID: <46B71404.7010403@trash.net>
References: <dd45289d0708041701l38f224e0l7347c0e1bf8e0327@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Cc: Rusty Russell <rusty@rustcorp.com.au>,
	Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>
To: NICOLAS BOULIANE <nicboul@gmail.com>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
In-Reply-To: <dd45289d0708041701l38f224e0l7347c0e1bf8e0327@mail.gmail.com>
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

NICOLAS BOULIANE wrote:
> Hi everybody,
> 
> I've write a paper that analysis the token bucket filter algorithm and
> would like your comments. If you find it right, my patchs should
> follow soon.


Great, this has been a longstanding problem. I'm not sure how to
fix it without breaking compatibility though.
