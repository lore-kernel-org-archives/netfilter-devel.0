From: Christoph Paasch <christoph.paasch@gmail.com>
Subject: Re: -m state is not working.
Date: Tue, 10 Feb 2009 10:06:02 +0100
Message-ID: <200902101006.02550.christoph.paasch@gmail.com>
References: <498AFBBC.20608@metu.edu.tr> <4990638A.1090208@trash.net> <499127AB.2050702@metu.edu.tr>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@vger.kernel.org, Patrick McHardy <kaber@trash.net>
To: hdemir@metu.edu.tr
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-bw0-f161.google.com ([209.85.218.161]:34587 "EHLO
	mail-bw0-f161.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755004AbZBJJGI (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 10 Feb 2009 04:06:08 -0500
Received: by bwz5 with SMTP id 5so2361948bwz.13
        for <netfilter-devel@vger.kernel.org>; Tue, 10 Feb 2009 01:06:05 -0800 (PST)
In-Reply-To: <499127AB.2050702@metu.edu.tr>
Content-Disposition: inline
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hi,

On Tue February 10 2009, Husnu Demir wrote:
> Yes,
>
> I forgat to add that support :) But xt_state should not be seen if
> nf_conntrack_ipv4 is not selected on the kernel config. It is useless
> without nf_conntrack_ipv4 support.

Well, xt_state doesn't depends on nf_conntrack_ipv4, it can also be use 
nf_conntrack_ipv6 or any other module you write yourself. The thing is that 
without nf_conntrack_ipv4 (or *_ipv6), it uses nf_conntrack_l3proto_generic, 
which won't be tracked, because get_l4proto(...) returns -NF_ACCEPT.

Maybe it would be nice to return NF_ACCEPT,  and then handle it with the 
generic layer 4 protocol handler. (set *protonum = 255 and let *dataoff 
unchanged)

Just a little suggestion.

Have a nice day.

--
Christoph Paasch

www.rollerbulls.be
--
