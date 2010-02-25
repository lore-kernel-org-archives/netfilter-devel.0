From: supercodeing35271 supercodeing35271 <supercodeing35271@gmail.com>
Subject: About the variable of "network_header" in the struct sk_buff
Date: Fri, 26 Feb 2010 02:17:44 +0800
Message-ID: <28efc0211002251017r76cd02ew122739990f30b3e9@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
To: "netfilter-devel@vger.kernel.org" <netfilter-devel@vger.kernel.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-iw0-f177.google.com ([209.85.223.177]:39512 "EHLO
	mail-iw0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932681Ab0BYSRp convert rfc822-to-8bit (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 25 Feb 2010 13:17:45 -0500
Received: by iwn7 with SMTP id 7so5400819iwn.4
        for <netfilter-devel@vger.kernel.org>; Thu, 25 Feb 2010 10:17:45 -0800 (PST)
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hi,I really do not know that is it correctly of =A0asking such a foolis=
h
question in this high-level mailing list,but i could not find the
answer by google it.
As a recruit,i'm now studying netfilter,i want to write a simply test
kernel module by the function of dropping the packet which the
protocol is TCP.For that i have read the "Using Netfilter
hooks"(http://www.topsight.net/article.php/2003050621055083/print),in
the page there is a piece of code below:
      static int check_tcp_packet(struct sk_buff *skb)
          {
              /*........................*/
              if (skb->nh.iph->protocol !=3D IPPROTO_TCP) {
                  return NF_ACCEPT;
              }

              /*................*/
          }

But when i look up the source code of the kernel of 2.6.32,the sk_buff
has changed.It is not a nh,the name is "network_header",as the others
are "transport_header" and "mac_header".Then i found that the
"network_header" is just a sk_buff_data_t(the true is a "unsigned int"
or "unsigned char *") type variable.
So, my question is how to get a IP packet with it protocol or tcp
flags or someother things by the "network_header" variable in the
struct sk_buff.
--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
