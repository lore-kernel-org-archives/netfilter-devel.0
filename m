From: Henrik Nordstrom <hno@marasystems.com>
Subject: Re: --log-uid target?
Date: Thu, 4 Nov 2004 12:20:59 +0100 (CET)
Message-ID: <Pine.LNX.4.61.0411041213580.11446@filer.marasystems.com>
References: <1099109256.1798.411.camel@ws102.darkcore.net>
	<41898F60.8080004@trash.net>
	<1099535517.26577.586.camel@ws102.darkcore.net>
	<4189A271.5060702@trash.net>
	<1099545501.26579.649.camel@ws102.darkcore.net>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Cc: netfilter-develop <netfilter-devel@lists.netfilter.org>,
	Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: John Lange <john.lange@bighostbox.com>
In-Reply-To: <1099545501.26579.649.camel@ws102.darkcore.net>
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

On Wed, 3 Nov 2004, John Lange wrote:

> Thanks for the information Patrick.
>
> Unfortunately I don't know enough about the underlying TCP layer to
> translate your email into english :)

TCP RESET is the RST flag. No lines with the RST flag will have a UID as 
these are not sent by applications but the kernel in response to "invalid" 
traffic not beloning to a existing TCP connection.

The same applies to most packets with PROTO=ICMP

> RST packet being something used to "tear down" a TCP connection in a
> hurry, for example when the port you are connecting isn't listening.

Exacly. "TCP Reset"

> Here is what I don't understand, why are these hosts trying to connect
> to a non-existent port and, why would the RST be destined for port 25?

It could be a delayed reply packet to a connection already long gone on 
your side.

Your server made a connection to port 25 on the remote IP. Then aborted 
the connection (timeout or whatever), and then a while later the remote IP 
came back trying to answer your request.

TCP Reset is not only about connection establishement, but any situation 
where a packet is received not matching a valid connection.

Regards
Henrik
