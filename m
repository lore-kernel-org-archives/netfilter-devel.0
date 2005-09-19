From: "John A. Sullivan III" <jsullivan@opensourcedevel.com>
Subject: Re: NetBIOS datagram nat helper proposal
Date: Mon, 19 Sep 2005 17:39:43 -0400
Message-ID: <1127165983.25000.51.camel@localhost>
References: <1127164215.25000.44.camel@localhost>
	<20050919212756.GA26816@linuxace.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Phil Oester <kernel@linuxace.com>
In-Reply-To: <20050919212756.GA26816@linuxace.com>
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

On Mon, 2005-09-19 at 14:27 -0700, Phil Oester wrote:
> On Mon, Sep 19, 2005 at 05:10:15PM -0400, John A. Sullivan III wrote:
> > It appears that we may need a netbios datagram NAT helper.  Unless we
> > can find a workaround, it we have encountered a couple of environments
> > where we need to NAT netbios datagram packets.  Since they have embedded
> > IP address information in the netbios header, this protocol breaks with
> > NAT.  We see the packets enter the server with the NAT address but the
> > replies are addressed to the original address as per the netbios header.
> 
> Like this one:
> 
> http://www.kernel.org/git/gitweb.cgi?p=linux/kernel/git/torvalds/linux-2.6.git;a=commit;h=a2978aea393b5e00b55b219786a5b8a47f838a7f
> 
> which was merged 12 days ago?
> 
> Phil
> 
Thanks but it looks like that's name service - John
-- 
John A. Sullivan III
Open Source Development Corporation
+1 207-985-7880
jsullivan@opensourcedevel.com

Financially sustainable open source development
http://www.opensourcedevel.com
