From: Andy Whitcroft <apw@shadowen.org>
Subject: Re: src/dest wilcard matching
Date: Thu, 16 Sep 2004 12:56:23 +0100
Sender: netfilter-devel-bounces@lists.netfilter.org
Message-ID: <200409161256.23156.apw@shadowen.org>
References: <54512.139.76.128.1.1095257166.squirrel@www.the-links.net>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: netfilter-devel@lists.netfilter.org, zack@the-links.net
In-Reply-To: <54512.139.76.128.1.1095257166.squirrel@www.the-links.net>
Content-Disposition: inline
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: </pipermail/netfilter-devel>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
Errors-To: netfilter-devel-bounces@lists.netfilter.org
List-Id: netfilter-devel.vger.kernel.org

On Wednesday 15 September 2004 15:06, Zachary Link wrote:
> I am looking for the ability to use wilcards or regexp type matching for
> source and destination fields.  Maybe this could be an extension or
> something...
>
> For example
> --source 172.*.*.1
> or
> --destination 10.[1-10].[10|20].1
>
> Picture, if you will, a situation where you had 1,000 offices all on
> 10.x.y.0/24 networks.  All routers might be 10.x.y.1.  You might want to
> give your network guys access to just those devices, and sysadmins access
> to all servers at 10.x.y.10-19 or any other types of devices sitting on
> these networks.
>
> So, the biggest hurdle I need to overcome is to allow arbitrary middle
> octets while matching 1st and last octet.  I was looking through the docs
> and I found that something like this could be done with the u32 extensions
> (I think), but it would be very cumbersome, and not easy to use.  I also
> took a look at the code and realized there is no way to do it myself as I
> have no real knowledge of C (I'll look like an idiot here if that's not C
> ;-).
>
> So, am I missing some existing functionality that would allow for that?
> Or, does anyone have any desire to develop that sort of feature?

Well some of this is pretty easy.  The -s and -d matches are actually in the 
form of an address and mask, the normal form is 1.2.3.4/N to match the left N 
bits, but there is also a 1.2.3.4/255.0.0.255 form of the mask.  You could 
use this for some of your stuff definatly.

iptables -A FORWARD -d 10.0.0.1/255.0.0.255 -j ACCEPT

If the ranges you have picked in each subnet are not simply maskable, ie say 
16-32 not 10-20 then you could use a user chain for that.  Something like the 
following, untested but modelled on something which works. 

iptables -N adminguy
iptables -A adminguy -d 10.0.0.10/255.0.0.255 -j ACCEPT
[...]
iptables -A adminguy -d 10.0.0.19/255.0.0.255 -j ACCEPT

iptables -N networkguy
iptables -A networkguy -d 10.0.0.1/255.0.0.255 -j ACCEPT

Obviously you could then use source checks to pick in the original 
selector ...

iptables -A FORWARD -s 1.2.3.0/24 -j networkguys
iptables -A FORWARD -s 1.2.4.0/24 -j adminguy

-apw
