Return-Path: <SRS0=CgNT=DN=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.6 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 89CD7C4363A
	for <netfilter-devel@archiver.kernel.org>; Tue,  6 Oct 2020 00:40:55 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 514EA2074A
	for <netfilter-devel@archiver.kernel.org>; Tue,  6 Oct 2020 00:40:55 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=arista.com header.i=@arista.com header.b="BaOKJLY3"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725925AbgJFAkz (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 5 Oct 2020 20:40:55 -0400
Received: from mx.aristanetworks.com ([162.210.129.12]:44758 "EHLO
        smtp.aristanetworks.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725865AbgJFAky (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 5 Oct 2020 20:40:54 -0400
X-Greylist: delayed 383 seconds by postgrey-1.27 at vger.kernel.org; Mon, 05 Oct 2020 20:40:54 EDT
Received: from us180.sjc.aristanetworks.com (us180.sjc.aristanetworks.com [10.243.128.7])
        by smtp.aristanetworks.com (Postfix) with ESMTP id 06BB940186E;
        Mon,  5 Oct 2020 17:34:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arista.com;
        s=Arista-A; t=1601944471;
        bh=LpZcLetgb6Yau+n4eJ1mqDJGnO3Rm9CeKFzY3fDiNBA=;
        h=Date:To:Subject:From:From;
        b=BaOKJLY3y0+cmHigCOFvT1aWajaHlz2pSbQfzN/k+l9Tmbd8UMoyKGpC1BBfXGI9T
         zmXuEDYl0Wqc6Zu+Mc+IIEF+ZyYtqmEVP97+PuDOuHYtm9QAzrSnuzFuVkhkZuufgo
         3/7g/mOpZQVNQ7lrc+VLO/hv+/0YVomid5/FUUIa8bT81PJyf/7M1A9Mes0yyEm30N
         Kf2NHZbO2itXPtyQGx41RzE32B6UXvNY3ZfDuyhx8kUAW5EqIoSLCo95C2IM7EuPX4
         7+PiSHDA+itNv73LUORAcdp3luHva8yi6wfGbNP7XvoAi5VWKXyV20cbLqUiN0x+4u
         dYE7NKYmrjKbg==
Received: by us180.sjc.aristanetworks.com (Postfix, from userid 10189)
        id DFDEE95C02DC; Mon,  5 Oct 2020 17:34:30 -0700 (PDT)
Date:   Mon, 05 Oct 2020 17:34:30 -0700
To:     linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        coreteam@netfilter.org, netfilter-devel@vger.kernel.org,
        kuba@kernel.org, davem@davemloft.net, fw@strlen.de,
        kadlec@netfilter.org, pablo@netfilter.org, fruggeri@arista.com
Subject: [PATCH nf] netfilter: conntrack: connection timeout after
 re-register
User-Agent: Heirloom mailx 12.5 7/5/10
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-Id: <20201006003430.DFDEE95C02DC@us180.sjc.aristanetworks.com>
From:   fruggeri@arista.com (Francesco Ruggeri)
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

I am sending out this patch mainly to clarify the source of a problem
I am seeing.
An idle tcp connection is timing out on a 4.19 kernel after
conntrack unregister/re-register. By playing with SO_KEEPALIVE
setsockopts on the client I can make it timeout in a few seconds.
I could not find any relevant commits in code after 4.19.
The problem seems to come from commit f94e63801ab2 ("netfilter:
conntrack: reset tcp maxwin on re-register").
Clearing maxwin of existing tcp connections on register, causes
tcp_in_window to set td_end to 1 less than it should if the first
packet it sees after the re-register is an outgoing keepalive packet,
causing it to later return false when getting packets from the peer
ack-ing the correct octet.
My iptables configuration on the client is:

*filter
:INPUT DROP [0:0]
:FORWARD ACCEPT [0:0]
:OUTPUT ACCEPT [0:0]
-A INPUT -p icmp -j ACCEPT
-A INPUT -m conntrack --ctstate RELATED,ESTABLISHED -j ACCEPT
-A INPUT -p tcp -m tcp --dport 4445 -j ACCEPT
COMMIT

I unregister conntrack by using:

*filter
:INPUT ACCEPT [0:0]
:FORWARD ACCEPT [0:0]
:OUTPUT ACCEPT [0:0]
COMMIT

and then I restore the original one.
I do not see the issue with this patch, but I am not sure it is the
correct

Thanks,
Francesco Ruggeri

Fixes: f94e63801ab2 ("netfilter: conntrack: reset tcp maxwin on re-register")
Signed-off-by: Francesco Ruggeri <fruggeri@arista.com>
---
 net/netfilter/nf_conntrack_proto_tcp.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/net/netfilter/nf_conntrack_proto_tcp.c b/net/netfilter/nf_conntrack_proto_tcp.c
index e8c86ee4c1c4..1ae1b7c78393 100644
--- a/net/netfilter/nf_conntrack_proto_tcp.c
+++ b/net/netfilter/nf_conntrack_proto_tcp.c
@@ -538,6 +538,12 @@ static bool tcp_in_window(const struct nf_conn *ct,
 			 * Let's try to use the data from the packet.
 			 */
 			sender->td_end = end;
+			if (seq == end) {
+				/* This could be a keepalive packet with
+				 * SEG.SEQ = SND.NXT-1.
+				 */
+				sender->td_end++;
+			}
 			swin = win << sender->td_scale;
 			sender->td_maxwin = (swin == 0 ? 1 : swin);
 			sender->td_maxend = end + sender->td_maxwin;
-- 
2.28.0

