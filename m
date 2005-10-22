From: Thomas Andrews <tandrews@grok.co.za>
Subject: Re: netlink socket problem
Date: Sat, 22 Oct 2005 22:16:09 +0200
Message-ID: <20051022201609.GA20885@grok.co.za>
References: <20051022192241.GZ20885@grok.co.za>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: netfilter-devel@lists.netfilter.org
Content-Disposition: inline
In-Reply-To: <20051022192241.GZ20885@grok.co.za>
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

On Sat, Oct 22, 2005 at 09:22:41PM +0200, Thomas Andrews wrote:

> I hope this isn't considered off-topic. I'm trying to get some code to
> talk to a netlink socket, but I keep getting this error:
> 
>     RTNETLINK answers: Invalid argument

To answer my own question - the destination IP *must* match
req.r.rtm_dst_len (which must also be set up, or it will be 0). By that
I mean the IP must have already been ANDed with the netmask in
rtm_dst_len.

Hopefully nobody else will waste a whole day figuring that out :p

Thomas
