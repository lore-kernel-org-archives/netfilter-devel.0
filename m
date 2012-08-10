From: =?UTF-8?Q?=C4=B0brahim_Ercan?= <ibrahim.ercan@engineer.com>
Subject: ipset : ip range insertion to hash:net list does not work
Date: Fri, 10 Aug 2012 19:08:45 +0300
Message-ID: <CAK6Qs9nVL6hzcjdaF98RkPhvH-sf+KUYnoeNxMyDvf92O9bK3A@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mailout-us.mail.com ([74.208.122.35]:38354 "HELO
	mailout-us.mail.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751810Ab2HJQP0 convert rfc822-to-8bit (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 10 Aug 2012 12:15:26 -0400
Received: by qcro28 with SMTP id o28so1039648qcr.19
        for <netfilter-devel@vger.kernel.org>; Fri, 10 Aug 2012 09:08:45 -0700 (PDT)
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hi. This is my first post. Sorry if there is impropriety. Here is the s=
tory.

 I made rpm packet 6.13 for centos 5. While compilation, I got these er=
rors:

ipset v6.13: Syntax error: IP address or IP/cidr must be specified:
1.2.3.4-1.2.3.10
print.c:675: error: =E2=80=98IPPROTO_UDPLITE=E2=80=99 undeclared (first=
 use in this function)

Then I added below lines to needed files(print.c , parse.c) and
problem solved and I installed rpm.

#ifndef IPPROTO_UDPLITE
#define IPPROTO_UDPLITE 136 /* from IANA */
#endif


Now I need to use hash:net and insert ip range. When I call following
commands, I get error.

# ipset create foo hash:net family inet
# ipset add foo 192.168.0.1-192.168.0.20
ipset v6.13: Syntax error: IP address or IP/cidr must be specified:
192.168.0.1-192.168.0.20

Here is some information
kernel 3.0.4
ipset 6.13
iptables 1.4.14

In addition to that, I tried it with ubuntu with version 6.11 and it wo=
rks!.

Thanks for any help...

--=20
=C4=B0brahim Ercan
--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
