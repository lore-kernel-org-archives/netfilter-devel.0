From: "John A. Sullivan III" <jsullivan@opensourcedevel.com>
Subject: Re: NetBIOS datagram nat helper proposal
Date: Mon, 19 Sep 2005 21:52:04 -0400
Message-ID: <1127181124.29021.34.camel@localhost>
References: <1127164215.25000.44.camel@localhost> <432F58A7.4030907@trash.net>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Patrick McHardy <kaber@trash.net>
In-Reply-To: <432F58A7.4030907@trash.net>
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

On Tue, 2005-09-20 at 02:32 +0200, Patrick McHardy wrote:
> John A. Sullivan III wrote:
> > It appears that we may need a netbios datagram NAT helper.  Unless we
> > can find a workaround, it we have encountered a couple of environments
> > where we need to NAT netbios datagram packets.  Since they have embedded
> > IP address information in the netbios header, this protocol breaks with
> > NAT.  We see the packets enter the server with the NAT address but the
> > replies are addressed to the original address as per the netbios header.
> > 
> > We have not seen such a helper within netfilter.  There appears to be a
> > simple helper for this at
> > http://suif.stanford.edu/~csapuntz/ip_nat_netbios.c
> 
> The helper does stateless NAT without issuing any expectations
> or even adjusting the conntrack entry. I'm not sure this is
> enough, but I'm not familiar with the netbios stuff. What is
> running on port 138? Do you have any pointers to a description
> of the protocol?
Yes, this is what I mean by finishing and polishing.
> 
> > We are seeing if we have the resources to finish and polish this patch
> > and submit it.  It seems that we then simply post it to this list to
> > submit it.  Is that the correct procedure?
> 
> Yes, if the patch is OK conceptually. If you send me some pointers,
> I'll have a look.
> 
I believe it is defined by RFC1002.  You can find it here:
http://ubiqx.org/cifs/rfc-draft/rfc1002.html#s4.4
I would think it is pretty straightforward but it is so easy to
dreadfully underestimate these things.  Thanks - John

-- 
John A. Sullivan III
Open Source Development Corporation
+1 207-985-7880
jsullivan@opensourcedevel.com

Financially sustainable open source development
http://www.opensourcedevel.com
