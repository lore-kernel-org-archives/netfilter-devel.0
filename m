From: dwhite@speakeasy.net
Subject: Re: Usage of CONNMARK
Date: Fri, 4 Feb 2005 13:35:42 -0800 (PST)
Message-ID: <Pine.LNX.4.61.0502041331160.7246@willie>
References: <42032EC5.4090303@multitech.co.in>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Cc: netfilter-devel <netfilter-devel@lists.netfilter.org>,
	netfilter@lists.netfilter.org
To: Vinod Chandran <vinod_chandran@multitech.co.in>
In-Reply-To: <42032EC5.4090303@multitech.co.in>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter>,
	<mailto:netfilter-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: </pipermail/netfilter>
List-Post: <mailto:netfilter@lists.netfilter.org>
List-Help: <mailto:netfilter-request@lists.netfilter.org?subject=help>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter>,
	<mailto:netfilter-request@lists.netfilter.org?subject=subscribe>
Sender: netfilter-bounces@lists.netfilter.org
Errors-To: netfilter-bounces@lists.netfilter.org
List-Id: netfilter-devel.vger.kernel.org


Hi vinod,

I could be wrong, but if you want to mark a connection, use CONNMARK, if 
you want to mark a packet, use MARK.

perhaps there is a better way, but I don't know of one at this point.

-dave

On Fri, 4 Feb 2005, Vinod Chandran wrote:

> Hi,
>
> I am using the CONNMARK patch.
> Inside conntrack_core, in case of special conditions, I have modified the 
> mark value in the conntrack.
>
> I then added the following rules in FORWARD chain.
>
> iptables -t mangle -A FORWARD -m connmark --m mark 1 -j DROP
>
> where the CONNMARK is set in case of the illegal packet.
>
> However this CONNMARK value is getting effective only for the next packet and 
> not for the same packet.
>
> Is there some way by which, I can make the settings applicable to the same 
> packet itself?
>
> Thanks and Regards,
> Vinod C
>
>
