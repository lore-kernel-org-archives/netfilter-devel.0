From: Jan Engelhardt <jengelh@medozas.de>
Subject: Re: [PATCH 4/6] build: tag function headers rather than decls as
 exported
Date: Fri, 19 Nov 2010 12:26:35 +0100 (CET)
Message-ID: <alpine.LNX.2.01.1011191225260.31107@obet.zrqbmnf.qr>
References: <1289907814-32706-1-git-send-email-jengelh@medozas.de> <1289907814-32706-5-git-send-email-jengelh@medozas.de> <4CE65AF9.9090904@netfilter.org>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: netfilter-devel@vger.kernel.org
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from borg.medozas.de ([188.40.89.202]:43138 "EHLO borg.medozas.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753242Ab0KSL0h (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 19 Nov 2010 06:26:37 -0500
In-Reply-To: <4CE65AF9.9090904@netfilter.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


On Friday 2010-11-19 12:09, Pablo Neira Ayuso wrote:
>
>I like this patchset. Some minor glitch:
>
>On 16/11/10 12:43, Jan Engelhardt wrote:
>> @@ -49,31 +43,31 @@ MNL_API int mnl_socket_getsockopt(const struct mnl_socket *nl, int type, void *b
>> -MNL_API size_t mnl_nlmsg_size(size_t len);
>> -MNL_API size_t mnl_nlmsg_total_size(size_t len);
>> -MNL_API size_t mnl_nlmsg_get_payload_len(const struct nlmsghdr *nlh);
>> +extern size_t mnl_nlmsg_size(size_t len);
>> +extern size_t mnl_nlmsg_total_size(size_t len);
>> +extern size_t mnl_nlmsg_get_payload_len(const struct nlmsghdr *nlh);
>
>In patch 1/6 mnl_nlmsg_next looks like:
>
>-struct nlattr *mnl_attr_next(const struct nlattr *attr, int *len)
>+struct nlattr *mnl_attr_next(const struct nlattr *attr)
>
>but here the old API seems to come back:
>
>extern struct nlmsghdr *mnl_nlmsg_next(const struct nlmsghdr *nlh, int
>*len);

I only changed the attr iteration interface so far, but not yet
that of nlmsg iteration.
