From: "Nishit Shah" <nishit@elitecore.com>
Subject: Re: problem with connection tracking with fragmentation needed icmp
	error
Date: Fri, 3 Nov 2006 16:13:51 +0530
Message-ID: <022501c6ff34$f842d6b0$4c01a8c0@elitecore26>
References: <013a01c6fe4b$c5032dc0$4c01a8c0@elitecore26>
	<454B17C8.1010904@trash.net>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="ISO-8859-15"
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: "Patrick McHardy" <kaber@trash.net>
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

Well,
            router and firewall both running with kernel 2.6.16.13 and one
more thing, i got invalid state on firewall not on router, i am not running
conntrack on router machine.(i guess firewall machine is not able to relate
this error msg with existing conntrack entry)

Regards,
Nishit Shah.

----- Original Message ----- 
From: "Patrick McHardy" <kaber@trash.net>
To: "Nishit Shah" <nishit@elitecore.com>
Cc: <netfilter-devel@lists.netfilter.org>
Sent: Friday, November 03, 2006 3:49 PM
Subject: Re: problem with connection tracking with fragmentation needed icmp
error


> Nishit Shah wrote:
> > Hi,
> >
> > I have a following setup
> >
> > machineA ------------------------------router -------------------------- 
> > firewall ------------------------------------ machineB
> > 172.16.16.2              172.16.16.1    9.9.9.1          9.9.9.2
> > 192.168.1.1                       192.168.1.2
> >
> >
> > router has two interfaces, eth0 is connected to machineA with mtu of
1000,
> > all other interfaces with mtu of 1500.
> > if i ping from machineA to machineB with data size 1200 and DF bit set,
> > packet will reach machineB, machineB will reply with DF bit set and data
> > size 1200,
> > upon receving this packet router sends icmp fragmentation needed and DF
bit
> > set message to machineB, when this packet comes to firewall conntrack
marks
> > that packet's state as INVALID. is it the valid case ??
>
> I don't see how this can happen on current kernels that manually
> associate locally generated ICMP errors with the original conntrack.
> What kernel version are you running on the router?
>
>
>
