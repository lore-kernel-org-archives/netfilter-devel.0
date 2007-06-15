From: "pankaj jain" <jainp1979@gmail.com>
Subject: Re: ebtables v/s arptables
Date: Fri, 15 Jun 2007 10:51:14 +0530
Message-ID: <d41814cf0706142221u735ff9a8v1b1debf802c3f400@mail.gmail.com>
References: <d41814cf0706130120x5609dfc2o285a07ceda1ba21b@mail.gmail.com>
	<1181755998.2976.1.camel@localhost.localdomain>
	<d41814cf0706140125i52cef5a6u6e73ab3395290e35@mail.gmail.com>
	<1181837804.2972.16.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@lists.netfilter.org
To: "Bart De Schuymer" <bdschuym@pandora.be>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
In-Reply-To: <1181837804.2972.16.camel@localhost.localdomain>
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
Do I have to create a bridge to use "arpreply --arpreply-mac <MAC
address>" as a target.
I am asking this because I was not getting arp responses from the
machine where I inserted the ebtable rule but did not create a bridge.

Regards
Pankaj

On 6/14/07, Bart De Schuymer <bdschuym@pandora.be> wrote:
> Op do, 14-06-2007 te 13:55 +0530, schreef pankaj jain:
> > Hi Bart,
> > I am quite new to these concepts and tools,
> > It would be great if you could please elaborate the statement and
> > throw some light on arptables also.
> > I believe for ebtables to work , we have to create a bridge interface also.
> > without creating a bridge I was not able to respond to arp requests
> > for IPs which are with me but are not plumbed on any interface.
>
> That's correct. If you don't need a bridge (you're not forwarding based
> on MAC addresses) you should probably not use one. It's possible to get
> packets sent to ebtables on a device with only one network interface,
> though. See http://ebtables.sourceforge.net/examples.html#ex_nobridge
>
> > Does ip_forwarding have any impact on arptables and ebtables.
>
> No.
>
> cheers,
> Bart
>
>
>


-- 
Thanks
Pankaj Jain
