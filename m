From: Krzysztof Oledzki <ole@ans.pl>
Subject: Re: [patch] ipset 2.3.0 segfault on '-U :all: {:all:|:default:}
Date: Fri, 30 May 2008 12:02:57 +0200 (CEST)
Message-ID: <Pine.LNX.4.64.0805301200280.17471@bizon.gios.gov.pl>
References: <483F111A.40700@shorewall.net> <Pine.LNX.4.64.0805300917070.10875@blackhole.kfki.hu>
Mime-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="-187430788-589088867-1212141777=:17471"
Cc: Tom Eastep <teastep@shorewall.net>, netfilter-devel@vger.kernel.org
To: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from bizon.gios.gov.pl ([212.244.124.8]:59874 "EHLO
	bizon.gios.gov.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752994AbYE3KDP (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 30 May 2008 06:03:15 -0400
In-Reply-To: <Pine.LNX.4.64.0805300917070.10875@blackhole.kfki.hu>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

---187430788-589088867-1212141777=:17471
Content-Type: TEXT/PLAIN; charset=ISO-8859-2; format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE



On Fri, 30 May 2008, Jozsef Kadlecsik wrote:

> On Thu, 29 May 2008, Tom Eastep wrote:
>
>> Segfault occurs at line 1641 as a result of dereferencing a null pointer=
 while
>> testing the set type for iptreemap.
>>
>> Patch attached.
>
> Thank you the report and the patch: I'll apply it as soon as the svn->git
> migration of ipset source is ready.

This remains me that I forget to send this little patch to make checkentry=
=20
static.

Best regards,

 =09=09=09Krzysztof Ol=EAdzki
---187430788-589088867-1212141777=:17471
Content-Type: TEXT/PLAIN; charset=US-ASCII; name=ipset-checkentry-static.patch
Content-Transfer-Encoding: BASE64
Content-ID: <Pine.LNX.4.64.0805301202570.17471@bizon.gios.gov.pl>
Content-Description: 
Content-Disposition: attachment; filename=ipset-checkentry-static.patch

LS0tIGlwdF9zZXQuYwkyMDA3LTA4LTI4IDEzOjI5OjEyLjAwMDAwMDAwMCAr
MDIwMA0KKysrIGlwdF9zZXQuYy0xCTIwMDgtMDUtMzAgMTE6NTg6MDIuMDAw
MDAwMDAwICswMjAwDQpAQCAtNTcsNyArNTcsNyBAQA0KIH0NCiANCiAjaWYg
TElOVVhfVkVSU0lPTl9DT0RFID49IEtFUk5FTF9WRVJTSU9OKDIsNiwyMykN
Ci1ib29sDQorc3RhdGljIGJvb2wNCiAjZWxzZQ0KIHN0YXRpYyBpbnQNCiAj
ZW5kaWYNCg==

---187430788-589088867-1212141777=:17471--
