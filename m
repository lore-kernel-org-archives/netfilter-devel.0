From: "David S. Miller" <davem@redhat.com>
Subject: Re: [PATCH 2.6]: port physdev to ip6tables
Date: Thu, 16 Sep 2004 13:31:15 -0700
Sender: netfilter-devel-bounces@lists.netfilter.org
Message-ID: <20040916133115.39a30db5.davem@redhat.com>
References: <4149C0DF.9040204@trash.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: laforge@netfilter.org, netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Patrick McHardy <kaber@trash.net>
In-Reply-To: <4149C0DF.9040204@trash.net>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: </pipermail/netfilter-devel>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
Errors-To: netfilter-devel-bounces@lists.netfilter.org
List-Id: netfilter-devel.vger.kernel.org

On Thu, 16 Sep 2004 18:35:43 +0200
Patrick McHardy <kaber@trash.net> wrote:

> at the netfilter workshop Harald and I agreed that it would
> be easier if I would submit netfilter patches directly to
> you, if you don't mind. I'll try not to clash with Harald.

I'm totally fine with this.

> If you're fine with this, here is the first one:
> 
> ChangeSet@1.1902, 2004-09-16 17:45:08+02:00, bdschuym@pandora.be
>   [NETFILTER]: port physdev to ip6tables
> 
> According to Bart, the physdev module is essential for people
> wanting to filter bridged IPv6 frames.

Applied, thanks guys.
