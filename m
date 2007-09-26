From: Krzysztof Oledzki <ole@ans.pl>
Subject: PATCH: "invalid SYNIN=" - a patch and a question
Date: Wed, 26 Sep 2007 14:27:22 +0200 (CEST)
Message-ID: <Pine.LNX.4.64.0709261414200.676@bizon.gios.gov.pl>
Mime-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="-187430788-1700815374-1190809642=:676"
To: Netfilter Developer Mailing List <netfilter-devel@vger.kernel.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from bizon.gios.gov.pl ([212.244.124.8]:54276 "EHLO
	bizon.gios.gov.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751840AbXIZMym (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 26 Sep 2007 08:54:42 -0400
Received: from bizon.gios.gov.pl (ole@localhost6 [IPv6:::1])
	by bizon.gios.gov.pl (8.14.1/8.14.1) with ESMTP id l8QCRM1f001893
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <netfilter-devel@vger.kernel.org>; Wed, 26 Sep 2007 14:27:24 +0200
Received: from localhost (ole@localhost)
	by bizon.gios.gov.pl (8.14.1/8.14.1/Submit) with ESMTP id l8QCRMSX001890
	for <netfilter-devel@vger.kernel.org>; Wed, 26 Sep 2007 14:27:22 +0200
Sender: netfilter-devel-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

---187430788-1700815374-1190809642=:676
Content-Type: TEXT/PLAIN; charset=ISO-8859-2; format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE

Hello,

Attached patch should fix missing space between "SYN" and "IN=3D".

nf_ct_tcp: invalid SYNIN=3D OUT=3D SRC=3D192.168.150.16 DST=3D192.168.50.21=
 LEN=3D60 TOS=3D0x00 PREC=3D0x00 TTL=3D64 ID=3D19810 DF PROTO=3DTCP SPT=3D4=
3183 DPT=3D80 SEQ=3D3917241971 ACK=3D0 WINDOW=3D5840 RES=3D0x00 SYN URGP=3D=
0 OPT (020405B40402080A3C14363B0000000001030307) UID=3D451

192.168.150.16 <- my local ip address
192.168.50.21  <- remote server

My question is about this message. Apparently there is someting wrong with=
=20
my configuration. I'm running http proxy/load balancer so my server makes=
=20
_a lot_ of connections for/to the same address IP pair. I noticed that=20
many of them were not successful. I know about TIMEWAIT issue, but as long=
=20
there are enough free ports for current connection rate (in my=20
situation it is about 100/s) it should not be a problem.

So, with net.netfilter.nf_conntrack_log_invalid set to 255 I get:

grep "invalid SYNIN" /var/log/syslog |wc -l
1186

Could the problem be that default=20
net.netfilter.nf_conntrack_tcp_timeout_time_wait is 120s by default, and=20
TCP_TIMEWAIT_LEN is 60:

/usr/src/linux/include/net/tcp.h:#define TCP_TIMEWAIT_LEN (60*HZ) /* how lo=
ng to wait to destroy TIME-WAIT

I tried to change net.netfilter.nf_conntrack_tcp_timeout_time_wait to 60=20
but this does not help much.

Best regards,


 =09=09=09=09Krzysztof Ol=EAdzki
---187430788-1700815374-1190809642=:676
Content-Type: TEXT/PLAIN; charset=US-ASCII; name=0090-netfilter-invalid-syn.patch
Content-Transfer-Encoding: BASE64
Content-ID: <Pine.LNX.4.64.0709261427220.676@bizon.gios.gov.pl>
Content-Description: 
Content-Disposition: attachment; filename=0090-netfilter-invalid-syn.patch

W05FVEZJTFRFUl06IFRyaXZpYWwgZml4IGZvciAibmZfY3RfdGNwOiBpbnZh
bGlkIFNZTiINCg0KVGhpcyBuZl9sb2dfcGFja2V0IG5lZWRzIGEgc3BhY2Ug
Y2hhci4gVHJpdmlhbCBmaXgNCg0KU2lnbmVkLW9mZi1ieTogS3J6eXN6dG9m
IFBpb3RyIE9sZWR6a2kgPG9sZUBhbnMucGw+DQoNCmRpZmYgLU51ciBsaW51
eC0yLjYuMjMtcmM4LW9yaWcvbmV0L25ldGZpbHRlci9uZl9jb25udHJhY2tf
cHJvdG9fdGNwLmMgbGludXgtMi42LjIzLXJjOC9uZXQvbmV0ZmlsdGVyL25m
X2Nvbm50cmFja19wcm90b190Y3AuYw0KLS0tIGxpbnV4LTIuNi4yMy1yYzgt
b3JpZy9uZXQvbmV0ZmlsdGVyL25mX2Nvbm50cmFja19wcm90b190Y3AuYwky
MDA3LTA5LTI1IDAyOjMzOjEwLjAwMDAwMDAwMCArMDIwMA0KKysrIGxpbnV4
LTIuNi4yMy1yYzgvbmV0L25ldGZpbHRlci9uZl9jb25udHJhY2tfcHJvdG9f
dGNwLmMJMjAwNy0wOS0yNSAxNjo1MDozOS4wMDAwMDAwMDAgKzAyMDANCkBA
IC04OTcsNyArODk3LDcgQEANCiAJCQl3cml0ZV91bmxvY2tfYmgoJnRjcF9s
b2NrKTsNCiAJCQlpZiAoTE9HX0lOVkFMSUQoSVBQUk9UT19UQ1ApKQ0KIAkJ
CQluZl9sb2dfcGFja2V0KHBmLCAwLCBza2IsIE5VTEwsIE5VTEwsDQotCQkJ
CQkgICAgICBOVUxMLCAibmZfY3RfdGNwOiBpbnZhbGlkIFNZTiIpOw0KKwkJ
CQkJICAgICAgTlVMTCwgIm5mX2N0X3RjcDogaW52YWxpZCBTWU4gIik7DQog
CQkJcmV0dXJuIC1ORl9BQ0NFUFQ7DQogCQl9DQogCWNhc2UgVENQX0NPTk5U
UkFDS19DTE9TRToNCg==

---187430788-1700815374-1190809642=:676--
