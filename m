From: Werner Pawlitschko <werner.pawlitschko@arcor.de>
Subject: iptables-1.4.5 REPLACE rule problem
Date: Sat, 14 Nov 2009 10:25:16 +0100
Message-ID: <4AFE777C.8090106@net.wpww>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-in-16.arcor-online.net ([151.189.21.56]:55146 "EHLO
	mail-in-16.arcor-online.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755017AbZKNJZP (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Sat, 14 Nov 2009 04:25:15 -0500
Received: from mail-in-19-z2.arcor-online.net (mail-in-19-z2.arcor-online.net [151.189.8.36])
	by mx.arcor.de (Postfix) with ESMTP id 03F0125717F
	for <netfilter-devel@vger.kernel.org>; Sat, 14 Nov 2009 10:25:20 +0100 (CET)
Received: from mail-in-02.arcor-online.net (mail-in-02.arcor-online.net [151.189.21.42])
	by mail-in-19-z2.arcor-online.net (Postfix) with ESMTP id DA18B6C014
	for <netfilter-devel@vger.kernel.org>; Sat, 14 Nov 2009 10:25:19 +0100 (CET)
Received: from snoopy.net.wpww (u26-245.dsl.vianetworks.de [212.168.165.245])
	(Authenticated sender: werner.pawlitschko@arcor.de)
	by mail-in-02.arcor-online.net (Postfix) with ESMTPSA id C72513FE4A5
	for <netfilter-devel@vger.kernel.org>; Sat, 14 Nov 2009 10:25:19 +0100 (CET)
Received: from [172.16.3.196] (dell-nb3.net.wpww [172.16.3.196])
	by snoopy.net.wpww (8.14.3/8.14.3) with ESMTP id nAE9PIsH003818
	for <netfilter-devel@vger.kernel.org>; Sat, 14 Nov 2009 10:25:18 +0100
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hi dear netfilter team,
I just upgraded from iptables-1.4.3 to 1.4.5 and found the following 
problem. Probably it has already been reported.

 I think it should be just as simple as doing this at the prompt:
iptables -A OUPUT -j LOG -d 10.11.12.13
then iptables-save shows
-A OUPUT -d 10.11.12.13/32 -j LOG
that's ok.
Then doing:
iptables -R OUTPUT 1 -j LOG -d 10.11.12.13
then iptables-save shows
-A OUTPUT -d 10.11.12.13/0 -j LOG
Looks bad. As you see the mask is set to zero for all bits.
But redirecting the output of iptables-save into a file, editing the 
mask manually and restoring the rules by iptables-restore works perfectly.

Your sincerely,
  Werner
