From: "David S. Miller" <davem@redhat.com>
Subject: Re: [PATCH] Fix ip_queue for bridged packets
Date: Wed, 29 Oct 2003 14:41:36 -0800
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <20031029144136.56c74aba.davem@redhat.com>
References: <200310251709.13913.bdschuym@pandora.be>
	<200310280002.12023.bdschuym@pandora.be>
	<20031028065610.499a5b01.davem@redhat.com>
	<200310292325.44927.bdschuym@pandora.be>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Bart De Schuymer <bdschuym@pandora.be>
In-Reply-To: <200310292325.44927.bdschuym@pandora.be>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

On Wed, 29 Oct 2003 23:25:44 +0100
Bart De Schuymer <bdschuym@pandora.be> wrote:

> On Tuesday 28 October 2003 15:56, David S. Miller wrote:
> > skb_copy_expand() is not exactly a fast path, so let's just make
> > it copy the header area too.
> >
> > Bart, does this fix your bug too?  Please test it, thanks.
> 
> It fixes the bug.

Thanks a lot for getting it tested.
