From: "pankaj jain" <jainp1979@gmail.com>
Subject: Re: ebtables v/s arptables
Date: Thu, 14 Jun 2007 13:55:30 +0530
Message-ID: <d41814cf0706140125i52cef5a6u6e73ab3395290e35@mail.gmail.com>
References: <d41814cf0706130120x5609dfc2o285a07ceda1ba21b@mail.gmail.com>
	<1181755998.2976.1.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@lists.netfilter.org
To: "Bart De Schuymer" <bdschuym@pandora.be>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
In-Reply-To: <1181755998.2976.1.camel@localhost.localdomain>
Content-Disposition: inline
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

Hi Bart,
I am quite new to these concepts and tools,
It would be great if you could please elaborate the statement and
throw some light on arptables also.
I believe for ebtables to work , we have to create a bridge interface also.
without creating a bridge I was not able to respond to arp requests
for IPs which are with me but are not plumbed on any interface.
Does ip_forwarding have any impact on arptables and ebtables.

Regards
Pankaj jain

On 6/13/07, Bart De Schuymer <bdschuym@pandora.be> wrote:
> Op wo, 13-06-2007 te 13:50 +0530, schreef pankaj jain:
> > Hi,
> > I am trying to reply the arp requests in which the destination IP is
> > of my machine but I have not plumbed the IP on any physical interface
> > I am able to achieve this with both ebtables and arptables.
> > I want to know the pros and cons of using any of the two (arptables ,
> > ebtables) tools.
>
> Using ebtables should be faster because the packet doesn't need to
> traverse through the network stack.
>
> cheers,
> Bart
>
>
>


-- 
Thanks
Pankaj Jain
