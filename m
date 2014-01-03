From: Eric Leblond <eric@regit.org>
Subject: Re: How to get pid of packet sender from NFQUEUE?
Date: Fri, 03 Jan 2014 09:12:54 +0100
Message-ID: <1388736774.19005.3.camel@tiger2>
References: <CAKiFbu9h1an38XXeNDy1ivcEz1vZHaqK+ekmQVXZLUChpJ3pBQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@vger.kernel.org
To: Mehran Kholdi <semekh.dev@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from ks28632.kimsufi.com ([91.121.96.152]:34694 "EHLO
	ks28632.kimsufi.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750812AbaACINH (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 3 Jan 2014 03:13:07 -0500
In-Reply-To: <CAKiFbu9h1an38XXeNDy1ivcEz1vZHaqK+ekmQVXZLUChpJ3pBQ@mail.gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hello,

On Fri, 2014-01-03 at 03:52 +0330, Mehran Kholdi wrote:
> So, I've got my code in userland (using netfilter_queue) that tries to
> handle packets according to different attributes (sort of a firewall).
> Is it possible to get the pid of sender program?
> I'm aware that it is possible to apply pid-based rules with iptables
> directly, but how could I access that property in the NFQUEUE?

You can't for now. Patches to access to UID GID have been made available
recently:
http://www.spinics.net/lists/netfilter-devel/msg29355.html

I don't think it should be too complex to propose the same for PID.

BR,
-- 
Eric Leblond <eric@regit.org>
Blog: https://home.regit.org/

