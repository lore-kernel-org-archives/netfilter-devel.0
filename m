From: Jan Engelhardt <jengelh@medozas.de>
Subject: Re: [PATCH 1/2] Add new input plugin UNIXSOCK
Date: Sun, 1 Nov 2009 14:41:21 +0100 (CET)
Message-ID: <alpine.LSU.2.00.0911011432160.26262@obet.zrqbmnf.qr>
References: <1257072828-11028-1-git-send-email-chifflier@inl.fr> <1257072828-11028-2-git-send-email-chifflier@inl.fr> <alpine.LSU.2.00.0911011336330.22807@obet.zrqbmnf.qr> <20091101130739.GC11601@piche.inl.fr>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: netfilter-devel@vger.kernel.org, eleblond@inl.fr
To: Pierre Chifflier <pchifflier@edenwall.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from borg.medozas.de ([188.40.89.202]:54857 "EHLO borg.medozas.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752234AbZKANlR (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Sun, 1 Nov 2009 08:41:17 -0500
In-Reply-To: <20091101130739.GC11601@piche.inl.fr>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


On Sunday 2009-11-01 14:07, Pierre Chifflier wrote:

>> >+	ip = (struct iphdr *) data;
>> 
>> If data is not aligned, later dereferencing can fail :(
>
>I remember some arches (sparc, arm ?) will send a signal (SIGBUS I
>think) in this case.
>How can I prevent data from being unaligned ?
>Adding some __attribute__((aligned(4)) will be enough ?

__attribute__(aligned) only specifies the minimum requirement.

What one would need is __attribute__((packed)), and it needs
to be on struct iphdr - in /usr/include/... - and that is the
problem because you cannot change it.
And gcc does not allow saying (ignored the attribute)

  struct iphdr __attribute__((packed)) *iph = data;

So.. tough luck.

>> >+
>> >+		while ( (data - packet_buf) < total_len) {
>> >+
>> >+			option_number = ntohs(*(u_int16_t*)(data));
>> 
>> This can fail even if packet_buf _is_ aligned, all it takes
>> is that payload_len is an odd number.
>> Unfortunately, I see no way to easily address this without
>> lame bitshifting :(
>
>Yes, since this is a Key-Length-Value protocol it's hard to ensure there
>is no weird value. I tried to add checks (marker on start, etc.), but I
>see no easy way to address this;

+static inline uint32_t deref_get_32(const void *ptr)
+{
+       uint32_t ret;
+       memcpy(&ret, ptr, sizeof(ret));
+       return ret;
+}

Is what I use in one project; however, trying to minimize the
unalignedness - iptables is a "perfect" example, and netlink
may do the same tho I am not sure - seems to be the best
approach in serialized streams.
