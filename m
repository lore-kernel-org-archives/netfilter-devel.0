From: Henrik Nordstrom <hno@marasystems.com>
Subject: Re: RE : RE : RE : Apply rules to 1 UDP port but port used as a
 socket: possible?
Date: Thu, 12 Feb 2004 12:35:01 +0100 (CET)
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <Pine.LNX.4.44.0402121231580.20259-100000@filer.marasystems.com>
References: <D4EF10CCEB2CE742BEEA9838C590B0E8011CB76E@ftrdmel2.rd.francetelecom.fr>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: zze-Proxy GRALL O ext FTRD/SVA/LAN <ograll.ext@rd.francetelecom.com>
In-Reply-To: <D4EF10CCEB2CE742BEEA9838C590B0E8011CB76E@ftrdmel2.rd.francetelecom.fr>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

On Thu, 12 Feb 2004, zze-Proxy GRALL O ext FTRD/SVA/LAN wrote:

> Then packets which arrive on the socket stop

Yes.

> That's what I want!

There is unfortunately not much to choose from here. Either you allow the 
packet to be delivered locally and accept that all further packets of the 
same session will be dealt with in the same manner, or you intercept the 
packet early in the processing via QUEUE and have control over what 
happens with the session.


> I will just approve the packet in my queue handler and I must receive
> packets from the other side so I think it will be OK hoping it won't
> load CPU too much more because I must treat thousands connection at the
> end...

You can not approve the packet until you have set up the required NAT 
rules for how this session is to be forwarded.

If you let a single packet be forwarded to the local socket then all 
further packets of this session will be forwarded the same way.


If you perhaps described what the actual problem you are trying to solve 
is then we could help you finding a reasonable approach.

Regards
Henrik
