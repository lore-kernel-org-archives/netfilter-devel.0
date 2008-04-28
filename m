From: "Emmanuel B" <emmanuel.b.lists@gmail.com>
Subject: Re: libnetfilter_conntrack: Unable to create an entry in the expectation table (invalid argument)
Date: Mon, 28 Apr 2008 17:31:30 +0200
Message-ID: <a82687b60804280831i6b377b69m4409994ad3551de4@mail.gmail.com>
References: <a82687b60804250225p6b0bb892j796b80e14dc0bdcd@mail.gmail.com>
	 <48142FFD.6020902@netfilter.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@vger.kernel.org, netfilter@vger.kernel.org
To: "Pablo Neira Ayuso" <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from wf-out-1314.google.com ([209.85.200.175]:8558 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1763291AbYD1Pba (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 28 Apr 2008 11:31:30 -0400
Received: by wf-out-1314.google.com with SMTP id 28so4068478wff.4
        for <netfilter-devel@vger.kernel.org>; Mon, 28 Apr 2008 08:31:30 -0700 (PDT)
In-Reply-To: <48142FFD.6020902@netfilter.org>
Content-Disposition: inline
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

2008/4/27 Pablo Neira Ayuso <pablo@netfilter.org>:
>
> Emmanuel B wrote:
>  > Hi,
>  >
>  > The example program (expect_create) given in the utils directory of
>  > libnetfilter_conntrack return the error code -1 (Invalid argument).
>  > The master entry was correctly added to the conntrack table, but
>  > nothing appears in expect table.
>  >
>  > I have tested it on a RedHat 2.6.18 and Ubuntu 2.6.22 with the same result.
>  > I use the libnetfilter_conntrack version 0.0.89 and libnfnetlink version 0.0.33
>  >
>  > Is there anything wrong in the expect_create.c code or something
>  > missing in kernel or libnetfilter_conntrack?
>
>  You probably forgot to insmod "nf_conntrack_ftp", anyway I'll
>  investigate if we can load-on-demand the module to avoid similar reports
>  to this one.

Thanks, this was the cause of the problem for the test program
(expect_create). Now it works, master and expect lines are filled.
Nevertheless, I tried to adapt it for the UDP protocol, and although
the "nf_conntrack_ftp" module is inserted, the error is again Invalid
parameters.

Here is the command line that I use (conntrack_tools):
conntrack -I --orig-src 1.1.1.1 --orig-dst 2.2.2.2 --reply-src 2.2.2.2
--reply-dst 1.1.1.1 -p udp --orig-port-src 10000 --orig-port-dst 10001
--reply-port-src 10001 --reply-port-dst 10000  -t 600 -u UNSET
=> Master rule is OK.

conntrack -I expect --orig-src 1.1.1.1 --orig-dst 2.2.2.2 --tuple-src
4.4.4.4 --tuple-dst 5.5.5.5 --mask-src 255.255.255.0 --mask-dst
255.255.255.255 -p udp --orig-port-src 10000 --orig-port-dst 10001 -t
600 --tuple-port-src 10241 --tuple-port-dst 10242 --mask-port-src 10
--mask-port-dst 300
=> Operation failed: invalid parameters

Is the expectation mechanism possible for UDP connections?
I need to accept the response with remote-src-port=* (port is randomly chosen)

Regards,

>
>  --
>  "Los honestos son inadaptados sociales" -- Les Luthiers
>
