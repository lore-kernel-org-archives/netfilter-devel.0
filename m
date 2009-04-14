From: Jan Engelhardt <jengelh@medozas.de>
Subject: Re: connection tracking problem ?
Date: Tue, 14 Apr 2009 20:27:49 +0200 (CEST)
Message-ID: <alpine.LSU.2.00.0904142024580.21682@fbirervta.pbzchgretzou.qr>
References: <5c0c5c050904141033w1f66c6d6waa068b937861a20@mail.gmail.com> <5c0c5c050904141054q3700518fu1584bfd97a902239@mail.gmail.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: netfilter-devel@vger.kernel.org
To: Mekabe Ramein <mrmrmrmr@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from sovereign.computergmbh.de ([85.214.69.204]:55638 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758599AbZDNS1v (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 14 Apr 2009 14:27:51 -0400
In-Reply-To: <5c0c5c050904141054q3700518fu1584bfd97a902239@mail.gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


On Tuesday 2009-04-14 19:54, Mekabe Ramein wrote:
>
>I am using Shorewall on CentOS with kernel 2.6.18-92.1.13.el5.
[...]
>After some time, I notice that one or two of the clients are not
>registered.[...]
>I found out that when in this condition, if I reset the connection
>tracking table with "conntrack -F" the clients can get registered
>because their packets reach Asterisk application.

Your kernel is over 937 days old, something that is not supported on
this end normally. If you can reproduce it with the latest 2.6.29.1,
the better.

By way, if conntrack -F solves the problem, it would be worthwhile
to see the conntrack -L entries for the still-active UDP connections.
