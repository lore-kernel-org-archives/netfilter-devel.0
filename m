From: Patrick McHardy <kaber@trash.net>
Subject: Re: [PATCH] ct-event API port to 2.6.11
Date: Sun, 03 Apr 2005 19:42:51 +0200
Message-ID: <42502B1B.7090309@trash.net>
References: <424747D5.8060500@eurodev.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Pablo Neira <pablo@eurodev.net>
In-Reply-To: <424747D5.8060500@eurodev.net>
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

Pablo Neira wrote:
> I sent this patch to Krisztian Kovacs some time ago in private but 
> forgot to post it in mailing list. It is currently used by ct_sync.
> 
> BTW, I also ported this to nf_conntrack some time ago:
> 
> https://lists.netfilter.org/pipermail/netfilter-devel/2005-January/018219.html 
> 
> 
> I guess that such patch doesn't apply anymore since Rusty's changes. If 
> I ported it again, could it be merge to the nf_conntrack tree or better 
> wait until it's pushed forward?

I think it would be better to wait to avoid delaying both.
Is there already a user of this API for nf_conntrack?

Regards
Patrick
