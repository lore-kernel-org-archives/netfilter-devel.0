From: Henrik Nordstrom <hno@marasystems.com>
Subject: Re: How can I get these packets in the user space application?
Date: Wed, 8 Dec 2004 16:34:55 +0100 (CET)
Message-ID: <Pine.LNX.4.61.0412081632530.19244@filer.marasystems.com>
References: <4EE0CBA31942E547B99B3D4BFAB348112588BA@mail.esn.co.in>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Cc: netfilter-devel@lists.netfilter.org,
	"Mukund JB." <mukundjb@esntechnologies.co.in>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: "Srinivas G." <srinivasg@esntechnologies.co.in>
In-Reply-To: <4EE0CBA31942E547B99B3D4BFAB348112588BA@mail.esn.co.in>
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

yOn Wed, 8 Dec 2004, Srinivas G. wrote:

> My question is: How can I get these packets in the user space
> application?

Depends on what you want to do with the packet. If you intend to have them 
returned back to the kernel then QUEUE is the best action.

If you only want to have them sent to userspace then a more lean design 
may be desireable.

Regards
Henrik
