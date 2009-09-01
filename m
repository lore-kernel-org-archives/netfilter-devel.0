From: Kuzin Andrey <kuzinandrey@yandex.ru>
Subject: Re: Mac addresses
Date: Tue, 1 Sep 2009 08:13:42 +0400
Message-ID: <1634030396.20090901081342@yandex.ru>
References: <c97a47b90908310323p3178b638k51dc18944e7b7534@mail.gmail.com>
Reply-To: Kuzin Andrey <kuzinandrey@yandex.ru>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@vger.kernel.org
To: "Michael Lawson (mshindo)" <michael@sphinix.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from forward3.yandex.ru ([77.88.46.8]:35715 "EHLO forward3.yandex.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751485AbZIAETV (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 1 Sep 2009 00:19:21 -0400
In-Reply-To: <c97a47b90908310323p3178b638k51dc18944e7b7534@mail.gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

MLm> This may be a really stupid question, but can someone tell me how I
MLm> can get a mac address into char or string format from struct
MLm> nfqnl_msg_packet_hw?

MLm> Regards

struct nfq_data *nfa;
struct nfqnl_msg_packet_hw *hwh = NULL;
u_int8_t *mac;

hwh = nfq_get_packet_hw(nfa);
if (hwh) {
   mac = (u_int8_t *)hwh;
   snprintf(buffer,buffer_length,"%02X:%02X:%02X:%02X:%02X:%02X",mac[0],mac[1],mac[2],mac[3],mac[4],mac[5]);
}


