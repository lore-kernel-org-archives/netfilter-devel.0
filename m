From: Daniel Collins <solemnwarning@solemnwarning.net>
Subject: Read-only fields in libnetfilter_conntrack ct_conntrack structure
Date: Sat, 14 Nov 2015 18:34:12 +0000
Message-ID: <56477EA4.8010402@solemnwarning.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-wm0-f44.google.com ([74.125.82.44]:34948 "EHLO
	mail-wm0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751448AbbKNSeP (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Sat, 14 Nov 2015 13:34:15 -0500
Received: by wmdw130 with SMTP id w130so65704324wmd.0
        for <netfilter-devel@vger.kernel.org>; Sat, 14 Nov 2015 10:34:13 -0800 (PST)
Received: from [10.52.13.21] (host81-159-50-109.range81-159.btcentralplus.com. [81.159.50.109])
        by smtp.gmail.com with ESMTPSA id pc2sm25908736wjb.11.2015.11.14.10.34.13
        for <netfilter-devel@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Sat, 14 Nov 2015 10:34:13 -0800 (PST)
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hi

I've found a bug in libnetfilter_conntrack - the nfct_set_attr() function silently doesn't populate certain fields (this behavior is documented), but it still calls set_bit(), so it actually "sets" the field without initialising it. nfct_attr_unset() also works on these fields.

But before thinking about fixing that bug: Why not make all the fields writable? If the intent is to be a general-purpose structure representing a conntrack table entry, I should be able to set all the fields, as little use as that may appear to have, if the intent is just to allow changing useful/meaningful ones in the kernel... should the list of writable ones not be shorter?

Background as to why I want to set the fields: I'm writing Perl bindings for libnetfilter_conntrack and some other stuff using them, I want to be able to serialise an entire nf_conntrack structure in one (privileged) process and then pass it to other unprivileged ones where it will be deserialized and stuff done with it.

Happy to write a patch to make them all writable if noone objects to it.

Thanks
