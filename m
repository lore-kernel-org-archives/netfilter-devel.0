From: Henrik Nordstrom <hno@marasystems.com>
Subject: Re: How can I get these packets in the user space application?
Date: Thu, 9 Dec 2004 23:36:36 +0100 (CET)
Message-ID: <Pine.LNX.4.61.0412092335480.3900@filer.marasystems.com>
References: <4EE0CBA31942E547B99B3D4BFAB348112588BA@mail.esn.co.in>
	<Pine.LNX.4.61.0412081632530.19244@filer.marasystems.com>
	<41B7EF28.9070904@rocsys.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Cc: netfilter-devel@lists.netfilter.org,
	"Mukund JB." <mukundjb@esntechnologies.co.in>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Ravi Kumar <ravivsn@rocsys.com>
In-Reply-To: <41B7EF28.9070904@rocsys.com>
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

On Thu, 9 Dec 2004, Ravi Kumar wrote:

> Lets say we wish to modify the packets in user space, then I think QUEUE is 
> not the way, is my understanding right?

QUEUE is the way for this. As part of the verdict from the userspace 
application you can include a modified packet payload.

see the libipq documentation.

Regards
Henrik
