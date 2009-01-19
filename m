From: Simon Labrecque <simon@clubbeadplus.com>
Subject: Re: Permit *any* destination port from source ip
Date: Mon, 19 Jan 2009 15:27:00 -0500
Message-ID: <C59A4C44.D285%simon@clubbeadplus.com>
References: <alpine.LSU.2.00.0901192112530.11601@fbirervta.pbzchgretzou.qr>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="US-ASCII"
Content-Transfer-Encoding: 7bit
Cc: <netfilter-devel@vger.kernel.org>
To: Jan Engelhardt <jengelh@medozas.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from simmts5-srv.bellnexxia.net ([206.47.199.163]:57826 "EHLO
	simmts5-srv.bellnexxia.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752247AbZASU2M (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 19 Jan 2009 15:28:12 -0500
Received: from simip11-ac.srvr.bell.ca ([206.47.199.91])
          by simmts5-srv.bellnexxia.net
          (InterMail vM.5.01.06.13 201-253-122-130-113-20050324) with ESMTP
          id <20090119202810.LWJK1658.simmts5-srv.bellnexxia.net@simip11-ac.srvr.bell.ca>
          for <netfilter-devel@vger.kernel.org>;
          Mon, 19 Jan 2009 15:28:10 -0500
In-Reply-To: <alpine.LSU.2.00.0901192112530.11601@fbirervta.pbzchgretzou.qr>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On 19/01/09 3:14 PM, "Jan Engelhardt" <jengelh@medozas.de> wrote:

> 
> On Monday 2009-01-19 21:11, Simon Labrecque wrote:
>> 
>>   I would like to have a specific connection act like an "authentication"
>> service; that is, when a connection to a specific port is made and once the
>> required data has passed between the 2 hosts, the client is now
>> authenticated, permitting access to other network services which are flagged
>> with the RELATED state (and not the NEW one).
> 
> "RELATED" is for protocol-related connections and, I think, it should
> not be abused to denote "AUTHENTICATED".
> 

Agreed; however, currently the network services are open (ie, they accept
NEW). I need to find a way to restrict access to those services *without*
modifying the applications/services, because they are closed, and ideally
without deploying new applications/daemons.

>>   Is this possible? It seems it was possible a while ago (while
>> exp->mask.dst was still present), but this was removed and I don't see how I
>> can achieve the same functionality with the current structures. Am I missing
>> something?
> 
> A userspace daemon can augment the ruleset after authentication,
> either by calling iptables(8), or iptables-restore/save.
> 

I agree too that a userspace daemon would better fit the philosophy of
netfilter/iptables, but it's not practical as a real solution in this
particular case. 

Currently, my conntrack module takes a list of "child" ports for which it
sets expectactions, but those same ports are duplicated in the iptable
rules. It seems to me it would be a lot cleaner to just maintain the
ports/rules in a single place, ie, in iptables (as, of course, I'm using a
DROP policy on INPUT on everything not explicitely ACCEPT'ed).

If there's no way to flag a connection as RELATED for any destination port
(given a known source and destination IP), then I guess I'll have no choice,
but I'm still not sure if it's possible or not (beside the fact that this
wouldn't be a *best practice*).

Thanks!

Simon Labrecque

