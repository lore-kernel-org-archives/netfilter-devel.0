From: Henrik Nordstrom <hno@marasystems.com>
Subject: RE: Userspace queuing
Date: Sat, 26 Jun 2004 15:41:04 +0200 (CEST)
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <Pine.LNX.4.44.0406261535140.16464-100000@filer.marasystems.com>
References: <200406260818.i5Q8ILMX023595@madinah.ccse.kfupm.edu.sa>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: "'Netfilter List'" <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: "Muhammad R. Sami" <sami@ccse.kfupm.edu.sa>
In-Reply-To: <200406260818.i5Q8ILMX023595@madinah.ccse.kfupm.edu.sa>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

On Sat, 26 Jun 2004, Muhammad R. Sami wrote:

> But as far as I have worked on it, I an only accept or drop packets using
> libipq and Queue. What if I want to set priority to accepted packets, like
> high priority and low priority, can this be also done using the same or
> there is some other mechanism in iptables. 

While it is true that you can only accept/deny/modify packets via the
ip_queue it is not hard to extend ip_queue with additional result fields
to allow specifying for example the nfmark or other relevan skbuff packet
parameters.

See the mailing-list archives for both discussions and patches for doing 
this.

You also can implement whatever queue policy you like in your userspace
application which I thought it was you asked for. How you manage the
priority queue while the packet is owned by your userspace application is 
well up to your application. The kernel only requires that you at some 
point tell a fate for the packet (accept/drop, accept -> packet continues 
within the Linux kernel)

Regards
Henrik
