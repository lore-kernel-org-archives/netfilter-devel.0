From: Darryl Miles <darryl-mailinglists@netbauds.net>
Subject: Can NFQUEUE accept/continue when there is no userspace listener registered
 ?
Date: Thu, 04 Nov 2010 03:52:40 +0000
Message-ID: <4CD22E08.2060300@netbauds.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-2.netbauds.net ([78.33.0.163]:50704 "EHLO
	mail-2.netbauds.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751243Ab0KDE14 (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 4 Nov 2010 00:27:56 -0400
Received: from 93-97-168-38.zone5.bethere.co.uk ([93.97.168.38]:40072 "EHLO
	odin.home.darrylmiles.org" smtp-auth: "darryl" TLS-CIPHER:
	"DHE-RSA-AES256-SHA keybits 256/256 version TLSv1/SSLv3" TLS-PEER-CN1:
	<none> rhost-flags-OK-OK-OK-FAIL) by mail-1.netbauds.net with ESMTPSA
	id S8323183Ab0KDDwm (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 4 Nov 2010 03:52:42 +0000
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


Hi,

Is there any mechanism which would allow additional options to NFQUEUE 
target to instruct the kernel what to do:

  --action-no-listener NF_ACCEPT|NF_DROP|CONTINUE  (with NF_DROP being 
the default)
  --action-backlog-overflow NF_ACCEPT|NF_DROP|CONTINUE   (with NF_DROP 
being the default)

Where CONTINUE would in effect ignore the existence of the "-j NFQUEUE" 
rule in the chain and continue to the next rule.  I guess this is 
possible if the packet never made it to user-space.


Would there be any objections to providing a patch to kernel and 
userspace tooling to provide this configurable behavior ?   Is it 
obviously useful to others ?


I am writing a non-critical userspace tool to fire Wake-on-LAN magic 
packets, if incoming TCP SYN "-p tcp --syn" is matched (and presumably 
forwarded).  The SYN packet is always allowed to pass but the userspace 
tools then goes into monitoring mode in the period after each SYN 
packet, it looks for either a valid IPv4 or IPv6 neighbour entry 
(/sbin/ip neigh) and/or Echo Reply.  As well as periodically monitoring 
the last known MAC address for each destination IP/IP6 to auto-learn.

This is not a critical application, I am looking for a minimal CPU 
overhead on the router and a best-effort service.  It should never be 
the cause of a failure (to connect i.e. pass SYN packets) should it 
crash / not be running.


Your comments appreciated,

Darryl

