From: Yasuyuki KOZAKAI <yasuyuki.kozakai@toshiba.co.jp>
Subject: Re: Tracking additional information
Date: Mon, 16 Apr 2007 21:34:19 +0900 (JST)
Message-ID: <200704161234.l3GCYKqV007207@toshiba.co.jp>
References: <82b0add70704140904n4b86fc3dhaab274aee36914d@mail.gmail.com>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@lists.netfilter.org
To: joubertb@gmail.com
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
In-Reply-To: <82b0add70704140904n4b86fc3dhaab274aee36914d@mail.gmail.com>
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

From: "Joubert Berger" <joubertb@gmail.com>
Date: Sat, 14 Apr 2007 12:04:20 -0400

> Hi,
> 
> I am looking for some advise.
> 
> I need to track additional information about a connection.  I had
> hoped that I can extend the connection tracking code using a helper or
> something similar.  But, it looks like using a helper will not help.
> 
> What I was going to do is look if it is a new connection, if so,
> squirrel away the information I want from the SYN packet and then use
> it later.  From my initial observations, the helper is able to add a
> secondary connection into the connection tracking table, but can it
> also be used to store information about the connection somewhere?
>
> I would prefer not to have to patch the kernel because that would make
> me not have to rebuild the base code.  I like the idea of just
> installing a distributions RPM and then I just compile my code and I
> am done :-)
>
> But, maybe what I need to do is extend the connection tracking code
> and add a place for me to keep my information per connection and then
> store the data there on each connection?  Maybe where the tuple is
> being saved.

You can declare a structure so that your helper can store informations.
What you need is that 'union nf_conntrack_help' includes the structure.
So you need to change include/net/netfilter/nf_conntrack.h

> 
> Does my ramblings above make sense :-)  Any ideas would be great.
> Thanks in advance.
> 
> --joubert
> 


-- Yasuyuki Kozakai
