From: Friedrich Lobenstock <fl@fl.priv.at>
Subject: Re: extra/pptp-conntrack-nat.patch
Date: Fri, 11 Apr 2003 23:26:21 +0200
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <3E9732FD.1010804@fl.priv.at>
References: <Pine.LNX.4.44.0304111409550.15504-100000@localhost.localdomain>
Reply-To: Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>
In-Reply-To: <Pine.LNX.4.44.0304111409550.15504-100000@localhost.localdomain>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

Hello!

Ilguiz Latypov wrote:
> 
> The following chart represents my understanding of the PPTP tracking
> modules capabilities in their current state.  I assumed that uncommenting
> the "return NF_ACCEPT" statement in question is equivalent to not tracking
> a connection with bad TCP checksum. [....]
> 
>                                  connection from       connection from
>                                behind the NAT box    the NAT box itself
> 
>                                good TCP   bad TCP     good TCP   bad TCP
>                                checksum   checksum    checksum   checksum
> 
> 
>       no PPTP modules             1          1           +          +

For connections from behind the NAT box I can not confirm this.

> 
> 
>    unmodified PPTP modules        +          +           -          -
>  without the local NAT option
> 
>    unmodified PPTP modules        +          +           +          +
>   with the local NAT option
> 
>  uncommented "return NF_ACCEPT"
>     for bad TCP checksums         +          1           -          +
>  without the local NAT option
> 
>  uncommented "return NF_ACCEPT"
>     for bad TCP checksums         +          1           +          +
>   with the local NAT option
> 
> 
> ------------------
> +: Any number of connections of given class is treated correctly.
> -: No connection possible.
> 1: Only one connection at a time will work in these cases.  If this refers
>    to the "behind the NAT box" connections, no connections from the NAT
>    box itself should be allowed for this to work.
> 

As the local nat patch is not in patch-o-matic-20030107 did not
get applied to my kernel, but for me that's irrelevant, as I don't
currently use pptp from the linux maschine itself.

-- 
MfG / Regards
Friedrich Lobenstock
