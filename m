From: AIJAZ BAIG <aijazbaig1@gmail.com>
Subject: newbie seeking clarification between nf_conntrack_l3proto and
	ip_conntrack*
Date: Mon, 14 Jun 2010 19:17:49 +0530
Message-ID: <AANLkTimdexfzRGpmBPLUCAmfE68rhkBE22mY_W68Rn_0@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-vw0-f46.google.com ([209.85.212.46]:40851 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750813Ab0FNNru (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 14 Jun 2010 09:47:50 -0400
Received: by vws14 with SMTP id 14so686076vws.19
        for <netfilter-devel@vger.kernel.org>; Mon, 14 Jun 2010 06:47:49 -0700 (PDT)
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hello people.

I have been trying to understand how the entire kernel side of
conntracking actually works and I have been able to find this document
which attempts to track the flow on the kernel
side:http://blog.chinaunix.net/u/23353/showart_2188246.html

I am also been studying rusty's netfilter hacking how to. So here is
what I have humbly understood till now. (Gurus i'd be indebted to you
fellows if u'd correct me.)

Now following rusty's doc, I have a question. It looks like there is a
framework which was present before the actual nf_conntrack gained
ground and it seemed to be exclusively for ipv4. I feel this way
because rusty has repeatedly referred to ip_conntrack_*. Like for
instance, he talks about populating the ip_conntrack_protocol
structure as against the nf_ct_l3proto array which is the global array
which contain pointers to structures of type nf_conntrack_l3proto. On
checking out nf_conntrack_l3proto.h it looks like this very struct
viz. nf_conntrack_l3proto, is the present day default for how
connection tracking code looks at a given L3 proto. It however seems
to be 'derived' from include/netfilter_ipv4/ip_conntrack_protocol.h.

Now this is seriously confusing me. If netfilter connection tracking
is supposed to super-cede connection tracking related code exclusively
for ipv4, why is it still being circulated? Or may be my amateurish
brain fails to understand and links the dots together.

I am keen to hear from you people

Regards,
Aijaz Baig.
