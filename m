From: "David S. Miller" <davem@redhat.com>
Subject: Re: [PATCH] Fix ip_queue for bridged packets
Date: Tue, 28 Oct 2003 06:02:02 -0800
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <20031028060202.7ab26fae.davem@redhat.com>
References: <200310251709.13913.bdschuym@pandora.be>
	<20031027000447.417915d0.davem@redhat.com>
	<200310280002.12023.bdschuym@pandora.be>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Bart De Schuymer <bdschuym@pandora.be>
In-Reply-To: <200310280002.12023.bdschuym@pandora.be>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

On Tue, 28 Oct 2003 00:02:11 +0100
Bart De Schuymer <bdschuym@pandora.be> wrote:

> On Monday 27 October 2003 09:04, David S. Miller wrote:
> > I thought we were taking care of this stuff via other means?
> >
> > This problem feels like an old one to me, and it's why we added all
> > the bridge netfilter objects to struct sk_buff, right?  Why doesn't
> > that take care of this instance of the problem?
> 
> The thing is, we currently only copy the Ethernet header to 
> skb->nf_bridge->data at PF_BRIDGE/POST_ROUTING. So, if the queue happens 
> earlier, the Ethernet header is lost.

Ok, let me think about this a little more.  I may just apply
your original patch.
