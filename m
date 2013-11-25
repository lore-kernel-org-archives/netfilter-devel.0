From: David Binderman <dcb314@hotmail.com>
Subject: RE: ip_set_hash_netnet.c:62: possible typo ?
Date: Mon, 25 Nov 2013 22:13:11 +0000
Message-ID: <DUB118-W48FC0FEE04F347D23F33C9CED0@phx.gbl>
References: <DUB118-W3449F030E13F8088A847CC9CED0@phx.gbl>,<alpine.DEB.2.10.1311252149230.5977@blackhole.kfki.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Cc: "netfilter-devel@vger.kernel.org" <netfilter-devel@vger.kernel.org>
To: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from dub0-omc1-s20.dub0.hotmail.com ([157.55.0.219]:38023 "EHLO
	dub0-omc1-s20.dub0.hotmail.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753134Ab3KYWNM convert rfc822-to-8bit
	(ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 25 Nov 2013 17:13:12 -0500
In-Reply-To: <alpine.DEB.2.10.1311252149230.5977@blackhole.kfki.hu>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

hello there Jozsef,
----------------------------------------

>> static inline bool
>> hash_netnet4_data_equal(const struct hash_netnet4_elem *ip1,
>>              const struct hash_netnet4_elem *ip2,
>>              u32 *multi)
>> {
>>     return ip1->ipcmp == ip2->ipcmp &&
>>            ip1->ccmp == ip2->ccmp;
>> }
>>
>> would be better code ?
>
> Yes, you are completely right. I'm going to check why the testsuite did
> not catch it.

Maybe because the function is dead code ?

I couldn't find any callers of it. Maybe that's another bug and
it should be called from somewhere else in the same file.

Regards

David Binderman 		 	   		  