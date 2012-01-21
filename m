From: Quentin Aebischer <Quentin.Aebischer@USherbrooke.ca>
Subject: [PATCH] conntrackd: basic TIPC implementation for NOTRACK mode
Date: Sat, 21 Jan 2012 08:52:17 -0500
Message-ID: <20120121085217.4272940o8fmk4v80@www.usherbrooke.ca>
Mime-Version: 1.0
Content-Type: text/plain;
 charset=UTF-8;
 DelSp="Yes";
 format="flowed"
Content-Transfer-Encoding: 7bit
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from smtpi4.USherbrooke.ca ([132.210.236.3]:38794 "EHLO
	smtpi4.usherbrooke.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751594Ab2AUN6B (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Sat, 21 Jan 2012 08:58:01 -0500
Received: from localhost (www09.sti.USherbrooke.ca [132.210.244.33])
	by smtpi4.usherbrooke.ca (8.13.8/8.13.8) with ESMTP id q0LDqHnK029117
	for <netfilter-devel@vger.kernel.org>; Sat, 21 Jan 2012 08:52:17 -0500
Content-Disposition: inline
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Edit : I first sent to user list, sorry about that :x.


Hi everyone,

I've implemented a very basic TIPC channel for the conntrackd daemon.

You can pull from here : git@github.com:Vauteck/Conntrack-tools.git master

It's still in debug proccess.
Any feedbacks/hints/comments is appreciated.

Regards,

Quentin

