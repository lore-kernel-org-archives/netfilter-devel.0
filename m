From: =?ISO-8859-1?Q?D=E2niel?= Fraga <fragabr@gmail.com>
Subject: Re: Every other char with LOG netfilter output (bug?)
Date: Fri, 31 Oct 2008 00:01:57 -0200
Message-ID: <490a671a.0687460a.3af5.40a2@mx.google.com>
References: <rlujt5-k63.ln1@tux.abusar.org.br>
	<49074E81.6010207@trash.net>
	<49075276.2686460a.0b00.ffff9f09@mx.google.com>
	<4907564D.5090103@trash.net>
	<49094b22.0f87460a.09d2.55b6@mx.google.com>
	<49095F02.7040104@trash.net>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="MP_/y3XsJ3pgnnqCqYnmT5y919F"
Cc: netfilter-devel@vger.kernel.org,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	"Ilpo =?ISO-8859-1?Q?J=E4rvinen?=" <ilpo.jarvinen@helsinki.fi>
To: Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from el-out-1112.google.com ([209.85.162.176]:31560 "EHLO
	el-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751387AbYJaCCF (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 30 Oct 2008 22:02:05 -0400
Received: by el-out-1112.google.com with SMTP id z25so526388ele.1
        for <netfilter-devel@vger.kernel.org>; Thu, 30 Oct 2008 19:02:04 -0700 (PDT)
In-Reply-To: <49095F02.7040104@trash.net>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

--MP_/y3XsJ3pgnnqCqYnmT5y919F
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8bit
Content-Disposition: inline

On Thu, 30 Oct 2008 08:15:14 +0100
Patrick McHardy <kaber@trash.net> wrote:

> One thing you need is to specify the amount of bytes you want transfered
> to userspace:
> 
> iptables ... -j NFLOG --nflog-range 65535

	Another one (now with --nflog-range 65535 as requested):

	1) using LOG:

Oct 30 23:14:34 tux vmunix: :d0:87:60:0SC6.3.310DT121812LN4 O=x0PE=x0TL4 D0POOTPST8 P=94 IDW0RS00 C S RP0
Oct 30 23:14:34 tux vmunix: 6DO NU:I=t0OT A=01:3e:79:01:fe:b2:80 R=3267.9 S=9.6.. E=0TS00 RC00 T=4I= RT=C P=0DT585WNO= E=x0AKRTUG= 

	2) using NFLOG (syslog emul):

Oct 30 23:14:34 tux DROP INPUT:  IN=eth0 OUT= MAC=00:18:f3:e4:47:9f:00:1d:0f:e8:7b:26:08:00 SRC=63.236.73.190 DST=192.168.1.2 LEN=40 TOS=00 PREC=0x00 TTL=44 ID=0 PROTO=TCP SPT=80 DPT=59845 SEQ=0 ACK=2739255566 WINDOW=0 ACK RST URGP=0 MARK=0 

Oct 30 23:14:34 tux DROP INPUT:  IN=eth0 OUT= MAC=00:18:f3:e4:47:9f:00:1d:0f:e8:7b:26:08:00 SRC=63.236.73.190 DST=192.168.1.2 LEN=40 TOS=00 PREC=0x00 TTL=44 ID=0 PROTO=TCP SPT=80 DPT=59845 SEQ=0 ACK=2739255566 WINDOW=0 ACK RST URGP=0 MARK=0 

Oct 30 23:14:34 tux DROP INPUT:  IN=eth0 OUT= MAC=00:18:f3:e4:47:9f:00:1d:0f:e8:7b:26:08:00 SRC=63.236.73.190 DST=192.168.1.2 LEN=40 TOS=00 PREC=0x00 TTL=44 ID=0 PROTO=TCP SPT=80 DPT=59845 SEQ=0 ACK=2739255566 WINDOW=0 ACK RST URGP=0 MARK=0 

Oct 30 23:14:34 tux DROP INPUT:  IN=eth0 OUT= MAC=00:18:f3:e4:47:9f:00:1d:0f:e8:7b:26:08:00 SRC=63.236.73.190 DST=192.168.1.2 LEN=40 TOS=00 PREC=0x00 TTL=44 ID=0 PROTO=TCP SPT=80 DPT=59845 SEQ=0 ACK=2739255567 WINDOW=0 ACK RST URGP=0 MARK=0 

	It's interesting to note that NFLOG always give the double of the entries of the "wrong" LOG entries.

	3) and the attached pcap log file.

	I hope that it will give you some hint. Thanks!

-- 

--MP_/y3XsJ3pgnnqCqYnmT5y919F
Content-Type: application/octet-stream; name=ulogd-final.pcap.bz2
Content-Transfer-Encoding: base64
Content-Disposition: attachment; filename=ulogd-final.pcap.bz2

QlpoOTFBWSZTWeWNHBkAAz/////3vqX+f//O32bur//H7n5Q3+q163yfZ39i94ur9318wAMdoJYz
ahsMpNE1TbVNpGyammIeU9RiA0aPakyMgBpkDTQemk0A0aaNPUekNBkB6TQNBtRoNNPKeSAHpHtT
TQJKFMUI0ZGQfqCDyj0QD0mm0gAAGIYgPUAAAYTTEAANANDRoGQGgABkIMmmI0aYgZBo0ZDQGmQY
TTQZAaGCADRoYIyBkNAyDI0BkMhhGg0NDQZMQJIoIJNG1BoAyD1Bo0NHqYmgANAAyaaaAAAAAAaA
BoAADQAAGg0UQeZSO7ZYbuBH0udtD/Um+ry1PuOolGUAOMkwwQoZxiETCGBSpZdo5DknQxEFSxBK
YlIrqg6DLZ5AXopAzSIABksu7sUZMSdCo0QDBv7pDAyW5Y8h7N1aWkuOrr5mJhSJyYJiGQMNIYSM
+W5FlAicsUzoJbyI4qdowI2FkAVzHRUDBWIZFYU7gKdPOEds8aYIYyJJhkTxUOTEmBQhSp0OMgrg
sGBqpFV4JfWKlKfMpazYkcDHVZAJO1aO6UlA7XIYTpmIWGIUOnEQCG53y423fHgngp8to4iPcPpN
SijGl7C1iHMs0qRxGMchoGTIsqXoRjyU8k25zxMDJQ+XO2gIGKBJ7MGAkom2AXtGFsWFKNaj3zJa
n0UxfJCiF2VLvpQuci2EMITxVUqm4SmtM4PriSFxAgF1hRUeCGueF6fe4GKXTBCnPwHpFAEmmqAO
uI9y4OTG4ht8/PgwYgvCPVFQVhZDuELWgtRclsRwSILtCdPnZ8UOAsSbW/XdzSFgKohkb8GuIgEX
yHnwBqJlotYwFSDrRxHMeFxbJORHmddATVDJdJnUfWWlurGgOttUTf25abU2FQGzKK6uoZFxFmgh
LdqUuKMDUsiJomBFmGAQ4FvI3YHL+AfoGU1riyoUVMkruM/LeJ5AWwA+WseOhbg3pHwJ9BFDVucH
jgP8STU00iQ8Yl9P+pYzITUvj6GZlRCLysCHhmyihBXB+a0hKt4zkuF6TBWKPVCMKlAXkqkgRa8m
6vVaV1Xsx2I+ReNnEHd3yWZRVnmFCPiPDfy7BVnMQ3c6EMy6psAMZa78o8/QUJAFXCxUTLickRFJ
VGu8JfRtNJ9gDkfh+A3A+78jGH0lAcknc2jM19kNNTw0ZcDH/28gVL6tqFCmyAUbkWeDDxxyh/5u
TRh69DSBRD82zVgWpbkIMyPCQizjTBO1xGgUwTmUt7gQd+AivegFE2Udmcv19O5SSiByfYr4P8ps
uyQTgKlYjZIkpMlTERK56b/i7kinChIcsaODIA==

--MP_/y3XsJ3pgnnqCqYnmT5y919F--
