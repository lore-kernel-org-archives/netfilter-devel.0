From: Emmanuel Guiton <emmanuel@netlab.hut.fi>
Subject: Re: connection destruction question
Date: Thu, 11 Mar 2004 10:13:15 +0200
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <40501F9B.3000803@netlab.hut.fi>
References: <200403110051.i2B0pYU0025941@sirius.cs.pdx.edu>
Reply-To: emmanuel@netlab.hut.fi
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Kristen Carlson <kristenc@cs.pdx.edu>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

Hi!

Did you take a look at the events used in nf_conntrack?
I had a similar problem and I solved it that way. You may have to define 
a new event (in ip_conntrack.h), or may not, I don't remember if it's 
already included. if you have to use a new event, you can send it with 
the ip_conntrack_cache_event() function.

-Emmanuel


Kristen Carlson wrote:

>Hello,
>Is there a way to be notified in a kernel module 
>when a connection is destroyed?  I have a nice helper
>module that would like to know when connections are destroyed
>so it can do some internal cleanup work. 
>Thanks,
>Kristen
>
>  
>
