From: Robert de Bath <list-netfilter@debath.co.uk>
Subject: Re: The big Picture of all the tables ...
Date: Sat, 4 Jun 2005 22:49:04 +0100 (BST)
Message-ID: <5559d90e8cb32fad@mayday.cix.co.uk>
References: <3abe8064b60ddf1a@mayday.cix.co.uk>
	<42A218B8.8060504@outerspace.dyndns.org>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Jonas Berlin <xkr47@outerspace.dyndns.org>
In-Reply-To: <42A218B8.8060504@outerspace.dyndns.org>
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

On Sat, 4 Jun 2005, Jonas Berlin wrote:

> Quoting Robert de Bath on 2005-06-04 18:10 UTC:
>
>> I _think_ the attached picture shows all the predefined chains in all
>> the tables that the kernel uses in the order that it uses them (except
>> for the raw table).
>
> You might be interested in a picture I drew, with some help of Steven
> Van Acker:
>
> http://xkr47.outerspace.dyndns.org/netfilter/packet_flow/packet_flow9.png
Yes, that's exactly it.

>> Even the netfilter website doesn't seem to have a BIG picture ... does it?
>
> No.. but I usually paste my picture to people on #netfilter on freenode
> ircnet. :)
>
> I agree some picture should be on the netfilter page for reference..

On Sat, 4 Jun 2005, Jonas Berlin wrote:

>> 3) What happens if you use NOTRACK.
>
> If you look at my pic, NOTRACK makes the packet skip all the green boxes.
But what about the pink boxes (NAT), they can't do anything without
connection tracking but do they try?

>> 4) Is there anything else that can make a packet deviate (cf: DROP)
>
> Well there is QUEUE but I guess it continues from where it left off..
> I'm not really sure.

Hmmm, QUEUE ... :-/

-- 
Rob.                          (Robert de Bath <robert$ @ debath.co.uk>)
                                              <http://www.debath.co.uk/>
