From: Olivier Blin <dev@blino.org>
Subject: Re: [PATCH] ipset tool: Fix link with libtool >= 2.4.4
Date: Thu, 07 Jan 2016 13:36:45 +0100
Message-ID: <m3bn8xsh0i.fsf@euphor.blino.org>
References: <1452122469-22209-1-git-send-email-dev@blino.org>
	<alpine.DEB.2.10.1601070847180.15530@blackhole.kfki.hu>
Mime-Version: 1.0
Content-Type: text/plain
Cc: netfilter-devel@vger.kernel.org
To: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from nan92-5-82-235-5-110.fbx.proxad.net ([82.235.5.110]:54928 "EHLO
	euphor.blino.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752810AbcAGMgu (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 7 Jan 2016 07:36:50 -0500
In-Reply-To: <alpine.DEB.2.10.1601070847180.15530@blackhole.kfki.hu> (Jozsef
	Kadlecsik's message of "Thu, 7 Jan 2016 08:48:27 +0100 (CET)")
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Jozsef Kadlecsik <kadlec@blackhole.kfki.hu> writes:

> On Thu, 7 Jan 2016, Olivier Blin wrote:
>
>> This is a simple patch to fix link of ipset with latest libtool
>> versions.
>
> Is the patch compatible with non-latest libtool versions?

Hi Jozsef,

I have tested this with libtool 2.4.2 and 2.4.6 versions, ipset builds
fine with both.

The only downside is that -ldl is now passed twice with older libtool
versions, but this should not be a problem.

Thanks

-- 
Olivier Blin - blino
