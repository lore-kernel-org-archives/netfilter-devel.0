From: n.susarla@ugrad.unimelb.edu.au
Subject: socket buffer
Date: Wed, 24 Sep 2003 15:34:14 +1000
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <200309240534.h8O5YEuE030452@cassius.its.unimelb.edu.au>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <netfilter-devel-admin@lists.netfilter.org>
Content-Disposition: inline
To: netfilter-devel@lists.netfilter.org
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

Hi,

When an IP packet is placed into a socket buffer skb it is right that
the network header is stored in a network header struct and the transport
header is stored in a separate transport header struct? Or is it just that
the whole IP packet is stored in a network header struct.
Therefore to access the transport header do you need to access the pointer
in the transport structure or do you access the ip header and increment the
pointer till you get to the TCP header? The main question is: is a packet
stored as it is in an skbuff or separate segments of the packet are stored in
separate structs of the skb?

Thanks
Nandita


In message <20030923013902.21762.29246.Mailman@netfilter-sponsored-by.noris.net> netfilter-devel-request@lists.netfilter.org
 writes:
> Welcome to the netfilter-devel@lists.netfilter.org mailing list!
> 
> To post to this list, send your email to:
> 
>   netfilter-devel@lists.netfilter.org
> 
> General information about the mailing list is at:
> 
>   https://lists.netfilter.org/mailman/listinfo/netfilter-devel
> 
> If you ever want to unsubscribe or change your options (eg, switch to
> or from digest mode, change your password, etc.), visit your
> subscription page at:
> 
>   https://lists.netfilter.org/mailman/options/netfilter-devel/n.susarla%40ugrad.unimelb.edu.au
> 
> 
> You can also make such adjustments via email by sending a message to:
> 
>   netfilter-devel-request@lists.netfilter.org
> 
> with the word `help' in the subject or body (don't include the
> quotes), and you will get back a message with instructions.
> 
> You must know your password to change your options (including changing
> the password, itself) or to unsubscribe.  It is:
> 
>   @Mmgn(*)
> 
> If you forget your password, don't worry, you will receive a monthly
> reminder telling you what all your lists.netfilter.org mailing list
> passwords are, and how to unsubscribe or change your options.  There
> is also a button on your options page that will email your current
> password to you.
> 
> You may also have your password mailed to you automatically from the
> Web page noted above.

-- 
n.susarla@ugrad.unimelb.edu.au
