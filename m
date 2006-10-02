From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH] libnfnetlink register callback
Date: Mon, 02 Oct 2006 15:10:04 +0200
Message-ID: <45210FAC.9030107@netfilter.org>
References: <1159258392.4518e118dd50f@www.domainfactory-webmail.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Maik Hentsche <maik@mm-double.de>
In-Reply-To: <1159258392.4518e118dd50f@www.domainfactory-webmail.de>
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

Hi Maik,

Sorry for the late reply, I've been overloaded with work.

Maik Hentsche wrote:
> Hi pablo, hello readers of the list!
> I found, that nfnl_callback_register() and nfnl_callback_unregister() in
> libnfnetlink do not behave as documented. Instead of returning -1 and
> setting errno, they return -EINVAL without setting errno at all. Find a
> patch attached, that changes this behaviour. The patch has been build
> and
> tested with the unofficial libnfnetlink-0.0.16-pablo-r1 only, but the
> previous version 0.0.16 also has this bug and therefore, it should also
> apply there.

I'll add this to my tree including the appropiate credits, I'm
periodically posting the patch to the list in the hope that it will be
applied to mainline.

-- 
The dawn of the fourth age of Linux firewalling is coming; a time of
great struggle and heroic deeds -- J.Kadlecsik got inspired by J.Morris
