From: "Grace Li" <zheyinli@hotmail.com>
Subject: Re: How does iptables redirect a packet that is not addressed to its local machi
Date: Thu, 08 Apr 2004 10:58:10 -0400
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <BAY7-F89pJbxZN8WHqQ000321c9@hotmail.com>
Mime-Version: 1.0
Content-Type: text/plain; format=flowed
Return-path: <netfilter-devel-admin@lists.netfilter.org>
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




>From: Phil Oester <kernel@linuxace.com>
>To: Grace Li <zheyinli@hotmail.com>
>CC: netfilter-devel@lists.netfilter.org
>Subject: Re: How does iptables redirect a packet that is not addressed to 
>its local machine
>Date: Wed, 7 Apr 2004 16:40:58 -0700
>
>Perhaps you haven't added a corresponding rule to the INPUT table
>to actually allow port 2000 to the gateway?
>
>Phil
>
>On Wed, Apr 07, 2004 at 06:16:07PM -0700, Grace Li wrote:
> > Hi,
> >
> > I am just wondering if anybody could explain what happened in the 
>following experiments:
> >
> > Client (192.168.1.134) tries to connect to port 1888 of Server
> > (192.168.1.115) through Gateway (192.168.1.1).  In the Gateway, the 
>iptables
> > has been instructed to redirect traffic on port 1888 to 2000 (iptables 
>-t
> > nat -A PREROUTING -i eth0 -p tcp --dport 1888 -j REDIRECT -to-port 2000 
>).
> >
> > The results of my experiments is that the application on Gateway who 
>listens
> > to port 2000 could not get anything, while Server receives everything
> > expected on its port 1888. So my question is that did iptables do 
>anything
> > here?
> >
> > Many thanks,
> >
> > Grace
> >

_________________________________________________________________
http://join.msn.com/?pgmarket=en-ca&page=byoa/prem&xAPID=1994&DI=1034&SU=http://hotmail.com/enca&HL=Market_MSNIS_Taglines
