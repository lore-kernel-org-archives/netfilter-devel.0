From: Kristen Carlson <kristenc@cs.pdx.edu>
Subject: Re: connection destruction question
Date: Thu, 11 Mar 2004 13:55:08 -0800 (PST)
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <200403112155.i2BLt8Er012209@sirius.cs.pdx.edu>
References: <no.id>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Cc: kristenc@cs.pdx.edu (Kristen Carlson), netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: emmanuel@netlab.hut.fi
In-Reply-To: <no.id> from "Emmanuel Guiton" at Mar 11, 2004 10:13:15 AM
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

> Hi!
> 
> Did you take a look at the events used in nf_conntrack?
> I had a similar problem and I solved it that way. You may have to define 
> a new event (in ip_conntrack.h), or may not, I don't remember if it's 
> already included. if you have to use a new event, you can send it with 
> the ip_conntrack_cache_event() function.


	Hum, I don't see any such thing in my kernel version.  I'm using
a kernel for an embedded system, so it isn't straight forward for me to 
upgrade.  I should have specified: on 2.4.18.  Unless I am insane and 
this is really somewhere I didn't grep properly.  I didn't see it in
net/ipv4/netfilter or include/linux/netfilter_ipv4.

> 
> -Emmanuel
> 
> 
> Kristen Carlson wrote:
> 
> >Hello,
> >Is there a way to be notified in a kernel module 
> >when a connection is destroyed?  I have a nice helper
> >module that would like to know when connections are destroyed
> >so it can do some internal cleanup work. 
> >Thanks,
> >Kristen
> >
> >  
> >
> 
> 
> 
> 
