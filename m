From: Patrick McHardy <kaber@trash.net>
Subject: Re: More nf_conntrack_sip questions
Date: Fri, 05 Dec 2008 17:21:01 +0100
Message-ID: <493954ED.9070002@trash.net>
References: <4935B885.8030107@redfish-solutions.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@vger.kernel.org
To: Philip Prindeville <philipp_subx@redfish-solutions.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:59462 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751869AbYLEQVE (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 5 Dec 2008 11:21:04 -0500
In-Reply-To: <4935B885.8030107@redfish-solutions.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Philip Prindeville wrote:
> I did a little investigation into my one-way voice issue, and noticed 
> that if I don't do voice-menus (i.e. where the Asterisk box itself 
> generates the first outbound INVITE, then passes-through the 2nd INVITE 
> once a handset picks up) then I get two-way voice (i.e. with sending the 
> call directly to the phone).  (In this topology, my Asterisk box is also 
> my firewall/NATting router...)
> 
> If I enable the voice menus in the inbound dialplan, however, it can 
> hear the voice menus, but not the called-party when they pick up their 
> phone (extension).
> 
> So someone (either the SIP conntrack module on the Asterisk border 
> firewall or else the SBC at the ILEC) is failing to look into the 2nd 
> INVITE (i.e. we're not rewriting it properly as it goes by, or the SBC 
> is failing to see it).


What module options are you using for the SIP helper and how is call
setup in asterisk configured (directrtpsetup, canreinvite, ...)?

