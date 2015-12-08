From: Sargun Dhillon <sargun@sargun.me>
Subject: libnetfilter_conntrack: set_attr_dnat_ipv4
Date: Tue, 8 Dec 2015 14:35:00 -0800
Message-ID: <CAMp4zn9xj41jv+BhQg0SPaY8VEoJa6SiHTQj470A7L1_Yr=NDQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-vk0-f42.google.com ([209.85.213.42]:35989 "EHLO
	mail-vk0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750752AbbLHWfB (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 8 Dec 2015 17:35:01 -0500
Received: by vkay187 with SMTP id y187so31643829vka.3
        for <netfilter-devel@vger.kernel.org>; Tue, 08 Dec 2015 14:35:00 -0800 (PST)
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

I'm curious, I'm looking at the libnetfilter_conntrack code, and I see
the following function definition:

static void
set_attr_dnat_ipv4(struct nf_conntrack *ct, const void *value, size_t len)
{
    ct->dnat.min_ip = ct->snat.max_ip = *((u_int32_t *) value);
}

Why does setting the DNAT_IPV4 attribute touch the snat.max_ip struct member?
