From: Ravi Kumar <ravivsn@rocsys.com>
Subject: Re: How can I get these packets in the user space application?
Date: Thu, 09 Dec 2004 11:52:32 +0530
Message-ID: <41B7EF28.9070904@rocsys.com>
References: <4EE0CBA31942E547B99B3D4BFAB348112588BA@mail.esn.co.in>
	<Pine.LNX.4.61.0412081632530.19244@filer.marasystems.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@lists.netfilter.org,
	"Mukund JB." <mukundjb@esntechnologies.co.in>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Henrik Nordstrom <hno@marasystems.com>
In-Reply-To: <Pine.LNX.4.61.0412081632530.19244@filer.marasystems.com>
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

Lets say we wish to modify the packets in user space, then I think QUEUE 
is not the way, is my understanding right?

If so, what approach is followed to get packets to user space to modify 
them. Note that I understand performance issues in moving packets from 
kernel space to user space and back.

-Ravi

Henrik Nordstrom wrote:
> yOn Wed, 8 Dec 2004, Srinivas G. wrote:
> 
>> My question is: How can I get these packets in the user space
>> application?
> 
> 
> Depends on what you want to do with the packet. If you intend to have 
> them returned back to the kernel then QUEUE is the best action.
> 
> If you only want to have them sent to userspace then a more lean design 
> may be desireable.
> 
> Regards
> Henrik
> 
