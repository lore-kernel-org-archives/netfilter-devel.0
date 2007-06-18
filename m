From: fabien.marotte@mindspeed.com
Subject: Re: libnetfilter_conntrack, nfct_catch returns ENOBUFS
Date: Mon, 18 Jun 2007 18:56:35 +0200
Message-ID: <OF7C77170F.72E89A61-ONC12572FE.005AF6F6-C12572FE.005D1649@mindspeed.com>
References: <4676AE6A.7060605@netfilter.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
To: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
In-Reply-To: <4676AE6A.7060605@netfilter.org>
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

> So am I. Could you post the code?

I reduced my callback to the following :
CtCatch( ...)
{
   return NFCT_CB_CONTINUE;
}
and I still see the bug with 20 simultaneous connections.


> Default buffer size in your system? cat /proc/sys/net/core/rmem_default

/proc/sys/net/core/rmem_default is set to 108544 by default.
I tried to increase the value up to 262144 and I still get the same issue.
Is it possible conntrack module to send more than one event in the same 
netlink messages ?








Pablo Neira Ayuso <pablo@netfilter.org> 
Sent by: netfilter-devel-bounces@lists.netfilter.org
06/18/2007 06:10 PM

To
fabien.marotte@mindspeed.com
cc
netfilter-devel@lists.netfilter.org
Subject
Re: libnetfilter_conntrack, nfct_catch returns ENOBUFS






fabien.marotte@mindspeed.com wrote:
> I develop an application using libnetfilter_conntrack to catch events 
> happening in the conntrack system.
> I am currently testing the robustness of my application using ab tool 
> (connection stress).
> 
> libnetfilter_conntrack version is 0.50. I use the new API.
> My callback catching the events always returns NFCT_CB_CONTINUE meaning 
> that ncft_catch should never returns.
> 
> But with 20 (and more) TCP  connections opening simultaneously, 
nfct_catch 
> returns. The error code in errno is 105. Seems to be ENOBUFS.
> 
> Looking at the code, I see the comment "ENOBUFS is returned in case that 

> nfnetlink is exhausted".
> 
> I am very surprised to have memory issues with so few connections.

So am I. Could you post the code?

> Could you explain me why this error occurs ? Is this a kernel error 
> propagated in user space or is this a user space error ?

Default buffer size in your system? cat /proc/sys/net/core/rmem_default

-- 
The dawn of the fourth age of Linux firewalling is coming; a time of 
great struggle and heroic deeds -- J.Kadlecsik got inspired by J.Morris
