From: Rocky Chan <rocky.chan@nwstor.com>
Subject: Availability of libiptc in iptables-1.4.4 or above
Date: Tue, 15 Dec 2009 01:17:33 -0800 (PST)
Message-ID: <949864.93400.qm@web1108.biz.mail.sk1.yahoo.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Shing Yee Chu <shingyee.chu@nwstor.com>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from web1108.biz.mail.sk1.yahoo.com ([74.6.114.40]:34972 "HELO
	web1108.biz.mail.sk1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1759462AbZLOJYR convert rfc822-to-8bit
	(ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 15 Dec 2009 04:24:17 -0500
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hello there. I am currently working on a project which uses libiptc for=
 modifying iptables rules within a Ubuntu PC. As I upgraded the distrib=
ution to Ubuntu 9.10, which includes iptables-1.4.4. When I try to incl=
ude the header files to my program, I found that the definition of "str=
uct iptc_handle_t" has been removed and replaced by "struct iptc_handle=
" or simply "STRUCT_TC_HANDLE", which is significantly different from t=
he one defined in iptables-1.3.3 where I can run my codes perfectly. Mo=
reover, the structure definition is moved into libiptc.c, which might h=
ave caused the compilation error below:

iptc_policy.c:6: error: storage size of =E2=80=98h=E2=80=99 isn=E2=80=99=
t known

where 'h' is the "struct iptc_handle" I have declared in my codes.=20

Is there any way to make my codes work like before without making a lot=
 of modifications? Or simply libiptc is no longer available for us to m=
anipulate iptables?  Thanks in advance and sorry for my poor English.

Rocky
--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
