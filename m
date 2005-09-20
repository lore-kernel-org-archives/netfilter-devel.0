From: Patrick McHardy <kaber@trash.net>
Subject: Re: NetBIOS datagram nat helper proposal
Date: Tue, 20 Sep 2005 02:32:39 +0200
Message-ID: <432F58A7.4030907@trash.net>
References: <1127164215.25000.44.camel@localhost>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: "John A. Sullivan III" <jsullivan@opensourcedevel.com>
In-Reply-To: <1127164215.25000.44.camel@localhost>
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

John A. Sullivan III wrote:
> It appears that we may need a netbios datagram NAT helper.  Unless we
> can find a workaround, it we have encountered a couple of environments
> where we need to NAT netbios datagram packets.  Since they have embedded
> IP address information in the netbios header, this protocol breaks with
> NAT.  We see the packets enter the server with the NAT address but the
> replies are addressed to the original address as per the netbios header.
> 
> We have not seen such a helper within netfilter.  There appears to be a
> simple helper for this at
> http://suif.stanford.edu/~csapuntz/ip_nat_netbios.c

The helper does stateless NAT without issuing any expectations
or even adjusting the conntrack entry. I'm not sure this is
enough, but I'm not familiar with the netbios stuff. What is
running on port 138? Do you have any pointers to a description
of the protocol?

> We are seeing if we have the resources to finish and polish this patch
> and submit it.  It seems that we then simply post it to this list to
> submit it.  Is that the correct procedure?

Yes, if the patch is OK conceptually. If you send me some pointers,
I'll have a look.
