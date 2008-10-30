From: =?ISO-8859-1?Q?D=E2niel?= Fraga <fragabr@gmail.com>
Subject: Re: Every other char with LOG netfilter output (bug?)
Date: Thu, 30 Oct 2008 21:23:43 -0200
Message-ID: <490a4204.2786460a.5242.ffffbe1f@mx.google.com>
References: <rlujt5-k63.ln1@tux.abusar.org.br>
	<49074E81.6010207@trash.net>
	<49075276.2686460a.0b00.ffff9f09@mx.google.com>
	<4907564D.5090103@trash.net>
	<49094b22.0f87460a.09d2.55b6@mx.google.com>
	<49095F02.7040104@trash.net>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="MP_/5fFCJDn./_4v7ATiEMt1lVS"
Cc: netfilter-devel@vger.kernel.org,
	Pablo Neira Ayuso <pablo@netfilter.org>
To: Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from el-out-1112.google.com ([209.85.162.176]:19043 "EHLO
	el-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751673AbYJ3XXw (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 30 Oct 2008 19:23:52 -0400
Received: by el-out-1112.google.com with SMTP id z25so495963ele.1
        for <netfilter-devel@vger.kernel.org>; Thu, 30 Oct 2008 16:23:50 -0700 (PDT)
In-Reply-To: <49095F02.7040104@trash.net>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

--MP_/5fFCJDn./_4v7ATiEMt1lVS
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8bit
Content-Disposition: inline

On Thu, 30 Oct 2008 08:15:14 +0100
Patrick McHardy <kaber@trash.net> wrote:

> One thing you need is to specify the amount of bytes you want transfered
> to userspace:
> 
> iptables ... -j NFLOG --nflog-range 65535

	Ok, I forgot to use --nflog-range, but I have an issue. I'm
sending anyway... maybe there's some hint of what is happening:

	1) for comparison, on old LOG target I get:

Oct 30 20:55:16 tux vmunix: 6 P=7LN38

	2) on NFLOG, using syslog emul, I get:

Oct 30 20:55:16 tux DROP INPUT:  IN=eth0 OUT= MAC=ff:ff:ff:ff:ff:ff:00:21:00:31:6c:f0:08:00 SRC=192.168.1.100 DST=255.255.255.255 LEN=328 TOS=00 PREC=0x00 TTL=128 ID=21248 PROTO=UDP SPT=68 DPT=67 LEN=308 MARK=0 

Oct 30 20:55:19 tux DROP INPUT:  IN=eth0 OUT= MAC=ff:ff:ff:ff:ff:ff:00:21:00:31:6c:f0:08:00 SRC=192.168.1.100 DST=255.255.255.255 LEN=328 TOS=00 PREC=0x00 TTL=128 ID=21250 PROTO=UDP SPT=68 DPT=67 LEN=308 MARK=0

	You can compare both and see what's missing on the first one (LOG).

	And I attached the pcap log binary file (bzipped). If it's
uselles, wait that I'll send a new one with -nflog-range 65535, which I
forgot to use.

	Thank you very much!

-- 

--MP_/5fFCJDn./_4v7ATiEMt1lVS
Content-Type: application/octet-stream; name=ulogd.pcap.bz2
Content-Transfer-Encoding: base64
Content-Disposition: attachment; filename=ulogd.pcap.bz2

QlpoOTFBWSZTWU8ekeAAAgB////3pKT2f//OT2JuhT+G7GhQmYikKUgWBm1iRQqCQHk8wAIQEkIS
UhNNT1TDU8UGTTCbSPUPQRiaeg0mEZqaPRAaPUYZCMyHqmmYmp7UgkSk00Ao9R6IzU8ptI9NQAND
1ADT1NHqABkGIBoAAGjRoOAAAAAAAAAAAAAAAAAAAAAHAAAAAAAAAAAAAAAAAAAAAPbZ83l7h/rn
h6RrGoQpVPGU2TkRA0IpbuCIxJFmNHUaV5oCwcqBssFJKCwiQYaFedI18z8d/V1aM+/hrSJFZDTH
KxBmFREXXPY9+CrkhlDDAhowF2EK7SgJ9SSUnMYUhl2rCU4NqoRAxZoYWD3CPhR9huahl61uVGlg
vkgRgHFBQ7AxQnZWKbNEmxRMIi1IQGyC965NQli0ODEellTi2X0QbctdOhjDlxYwlEeElOrKQytH
3BgTIt4yLsx10fqrQVNF4sxVQ1EzTaoMcVeCvEJ05XFNxPDaI6HzotTzRy3jePmipVYnD0H4REzi
gaqdRNROmM3Yxvur1UokiFEpHhJovujQRoolphCPHALbHggyDJDTShFLnVce99Ngj+TTaeRVPT0U
a7QT4+aXJgrjSgTSuCYiyhgTGPDCDRQPocM9zbpCcglRrcni4UcyX6RH8kaVHbGvOElKzAxjFJER
10BUy6gJ8ifVhFb/dFDiSmJarUh+Zg8z7edMe4yjeVnA9m2WfW0INeyy454p3f5iogKuRnul0nSt
Xl4vb+LIqLGjWJpDDCST/MOfA7Bwa7GWLRLhtAmvMPQou2lCHWpxTMAy0G0c9oOG0sklKPbT/4u5
IpwoSCePSPAA

--MP_/5fFCJDn./_4v7ATiEMt1lVS--
