From: Zeeshan Ali <zeelists@yahoo.com>
Subject: Re: ip_route_me_harder question...
Date: Wed, 26 Nov 2003 13:18:21 -0800 (PST)
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <20031126211821.63036.qmail@web60704.mail.yahoo.com>
References: <3FC50AD6.7080105@binary-one.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: netfilter-devel@lists.netfilter.org
In-Reply-To: <3FC50AD6.7080105@binary-one.com>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

Hello,
  I thought your reply implicitly suggested to try
route_me_hard () instead of ip_route_me_hard (), so i
gave it a try. The compiler is happy but not the
kernel. Most probably because the route_me_hard () is
not accessible to all? Bye.

--- Jon <jon_webb@binary-one.com> wrote:
> This is a good question. I've noticed that sometimes
> it's needed and 
> sometimes it isn't. We implemented a routing
> protocol where all the 
> packets were bumped up to userspace and after
> fiddling with the routing 
> system for a long time, we ended up using some code
> from iproute2 to 
> change the table before reinjecting the packet
> (unmodified). This 
> alleviated our route_me_harder() issues. But another
> protocol we were 
> looking at during our implementation used
> route_me_harder() and it 
> seemed to work fine. Very confusing.
> 
> Regards,
> Jon Webb
> Computer Communications Research Group
> University of California at Santa Cruz



__________________________________
Do you Yahoo!?
Protect your identity with Yahoo! Mail AddressGuard
http://antispam.yahoo.com/whatsnewfree
