From: "David S. Miller" <davem@davemloft.net>
Subject: Re: skb_ip_make_writable and skbs not owned by a socket
Date: Wed, 26 Jan 2005 21:50:39 -0800
Message-ID: <20050126215039.65ebd158.davem@davemloft.net>
References: <41D86571.6070501@trash.net>
	<20050113213122.7e70c3c2.davem@davemloft.net>
	<41E75FA4.907@trash.net>
	<20050117135029.04e6580f.davem@davemloft.net>
	<41EC469F.6010605@trash.net> <41F869C2.5030800@trash.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: hadi@cyberus.ca, rusty@rustcorp.com.au, netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Patrick McHardy <kaber@trash.net>
In-Reply-To: <41F869C2.5030800@trash.net>
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

On Thu, 27 Jan 2005 05:10:42 +0100
Patrick McHardy <kaber@trash.net> wrote:

> Dave, could you please have another look at this ? I think the patch is
> correct, and even necessary to make the ipt action work with targets
> that mangle the data area. Jamal asked me to put back the pskb_expand_head
> call in the ipt action, so iptables won't see cloned skbs and copy them
> (actions must not replace the skb), but the protocol-dependant cases
> in skb_ip_make_writable can cause copying anyway. I think you missed
> my reply to your last mail, please see below.

It's in my backlog, don't worry.  I'll try to get to it tomorrow.

Is it the end of the world if I defer it to 2.6.12?
