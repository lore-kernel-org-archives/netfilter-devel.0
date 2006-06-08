From: Patrick McHardy <kaber@trash.net>
Subject: Re: POSTROUTING hooks
Date: Thu, 08 Jun 2006 09:43:50 +0200
Message-ID: <4487D536.1050702@trash.net>
References: <0633E0EDB4F25F43A2D7179CA11FAFAB25544B@xavier.staff.greatlakes.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Cc: Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: "Eliot, Wireless and Server Administrator,
	Great Lakes Internet" <support8@greatlakes.net>
In-Reply-To: <0633E0EDB4F25F43A2D7179CA11FAFAB25544B@xavier.staff.greatlakes.net>
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

Eliot, Wireless and Server Administrator, Great Lakes Internet wrote:
> Where in the kernel's packet delivery process does the POSTROUTING chain
> hook in? 
> 
> I'm trying to figure out how to write a module to allow matching on the
> destination MAC address. From what I have been able to figure out so
> far, it looks like the destination MAC is not actually set until right
> before the packet goes out of the interface. Now, I have not been able
> to find the code that would confirm this, so if anyone can point me to
> the exact position where the destination MAC address is set, that would
> be helpful. However, from what I have been able to observe with logging
> and some quick and dirty modifications to a couple of modules to print
> out some extra debugging info, this appears to be the case. 
> 
> What would it take to modify the Netfilter code to make the POSTROUTING
> chain hook in AFTER the destination MAC is set, but BEFORE it gets sent
> out the interface? 

Still doesn't help, ARP resolution happens after that.
