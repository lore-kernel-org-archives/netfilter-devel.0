From: Henrik Nordstrom <hno@marasystems.com>
Subject: Re: bidirectional CONNMARK?
Date: Wed, 9 Mar 2005 10:24:50 +0100 (CET)
Message-ID: <Pine.LNX.4.61.0503091019020.6780@filer.marasystems.com>
References: <20050309124806.A55C.LARK@linux.net.cn>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Cc: netfilter-devel@lists.netfilter.org
To: Wang Jian <lark@linux.net.cn>
In-Reply-To: <20050309124806.A55C.LARK@linux.net.cn>
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

On Wed, 9 Mar 2005, Wang Jian wrote:

> What is the CONNMARK's purpose?

To act as a decision memory on the connection. What you use this memory 
for is up to you.

> I think it is to reduce rule traversal,

This is one of many applications.

The --save-mark/--restore-mark options to CONNMARK should be seen as a 
bonus. It is not the main purpose of CONNMARK. The main purpose of 
CONNMARK is to act as a connection oriented state memory, allowing you to 
remember an earlier decision about something on later packets in the same 
session.

> But an issue occurs, when we want to set 2 different marks for a single
> session in two directions.

Then you need to structure the use of CONNMARK differently, and depending 
on the direction set different marks.

> When doing QoS control as an router between two or more interfaces,
> bi-directional control is neccessary. Since nfmark is the most
> convenient way to classify packet, should we extend CONNMARK to support
> two marks?

If it helps you in reducing your ruleset, why not? Adjusting the tools to 
your needs is one of the cornerstones of using Open Source software.

But I don't think it is generally suitable for CONNMARK.

Regards
Henrik
