From: Kuzin Andrey <kuzinandrey@yandex.ru>
Subject: Re[2]: how to update payload using QUEUE
Date: Tue, 11 Nov 2008 09:56:00 +0300
Message-ID: <69704515.20081111095600@yandex.ru>
References: <c813aacf0811091503u26425f2fw368689d7d0ea6d6b@mail.gmail.com>
 <1189733016.20081110095859@yandex.ru>
 <c813aacf0811101648l169bdffne799c41d014733d9@mail.gmail.com>
Reply-To: Kuzin Andrey <kuzinandrey@yandex.ru>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.mjkmail.ru ([212.45.5.115]:35286 "HELO mail.mjkmail.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1754131AbYKKHC0 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 11 Nov 2008 02:02:26 -0500
In-Reply-To: <c813aacf0811101648l169bdffne799c41d014733d9@mail.gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

>> Cut from libnetfilter_queue.c
>> ================================
>> int nfq_set_verdict(struct nfq_q_handle *qh, u_int32_t id,
>>                u_int32_t verdict, u_int32_t data_len,
>>                unsigned char *buf)
>> ================================
>>
>> You call this function in this way:
>> return nfq_set_verdict(qh, id, NF_ACCEPT, 0, NULL);
>>
>> I think right function call:
>> ===================
>> ret = nfq_set_verdict(qh, id, NF_ACCEPT, new_len, newPayload);
>> free(newPayload);
>> return ret;
>> ===================
>> and my be without any memcpy()
>>
>> Try this...

OD> Thank you all. It worked for me.
OD> Now I think I am in right direction :)

OD> However, now I am having problem with checksum. After processing
OD> payload, I set the iphdr checksum value to 0 hoping system would
OD> automatically compute the check sum but it is not. Tcpdump shows "bad
OD> checksum" value (0).

OD> Or do I need to compute and set checksum manually. Ideally I would
OD> like to offload-checksum when possible.
OD> Looking for your suggestions.
OD> thanks again :)
OD> Bikrant

I found some useful links for you !

Here use checksum compute for tcp and ip packets (some code from TCPDUMP):
http://code.google.com/p/quefuzz/source/browse/trunk/quefuzz.c?r=5

Here use another cksum() function:
https://trac.luffy.cx/udpproxy/browser/src
https://trac.luffy.cx/udpproxy/browser/src/cksum.c
https://trac.luffy.cx/udpproxy/browser/src/proxy.c

Question is what function calculate checksum faster and rigth for
nf_queue ?!

May be this help to you !
Write something about that. I also need this experience, but
i don't have any time for experiments now.

Any comments from nfq developers also appreciated.
Why your nfq_set_verdict with payload don't compute checksum
automatically ???!!!
Google say what whole the world have difficults with that.

