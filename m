From: Johan Ankarloo <johan.ankarloo@volvo.com>
Subject: Re: DNAT/SNAT and logging
Date: Wed, 21 Jan 2004 19:48:35 +0100
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <1074710915.16080.4.camel@ankarloo.got.volvo.net>
References: <Pine.LNX.4.44.0401211303450.6443-100000@filer.marasystems.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Henrik Nordstrom <hno@marasystems.com>
In-Reply-To: <Pine.LNX.4.44.0401211303450.6443-100000@filer.marasystems.com>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

So you don't think that this is a lot of work just to get the logging to
work correctly? I mean that this is something that ( in my opinion )
should be done out of the box so to say. 

How should this be done through /dev/net/ip_conntrack? Do you have any
examples?

//Johan

On Wed, 2004-01-21 at 13:05, Henrik Nordstrom wrote:
> On Wed, 21 Jan 2004, Johan Ankarloo wrote:
> 
> > I'm not shure i agree. The problem here is that the logging is done
> > seperate from the modules that mangle the packets.
> 
> Yes, and so is the NAT rules.
> 
> > The right way ( for me ) would be to have the mangle modules send the
> > logging information to the logging module. In this way the mangle
> > modules could say what has been altered in the packet.
> 
> If you log the addressing information from conntrack then this is exacly
> what is done.
> 
> Regards
> Henrik
-- 
Mvh
 
Johan Ankarloo
Volvo IT
Network & Security Engineer
Tel: +46 31 32 70949
 
====================================================================
This message may contain confidential and/or proprietary information,
and is intended only for the person/entity to whom it was originally
addressed. The content of this message may contain private views and
opinions which do not constitute a formal disclosure or commitment
unless specifically stated.
