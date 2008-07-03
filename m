From: Krzysztof Oledzki <ole@ans.pl>
Subject: Re: [ANNOUNCE] ipset-2.3.2
Date: Thu, 3 Jul 2008 17:49:30 +0200 (CEST)
Message-ID: <Pine.LNX.4.64.0807031747500.4958@bizon.gios.gov.pl>
References: <Pine.LNX.4.64.0807021449020.32444@blackhole.kfki.hu>
 <Pine.LNX.4.64.0807021536140.4958@bizon.gios.gov.pl>
 <Pine.LNX.4.64.0807021545290.32444@blackhole.kfki.hu>
 <Pine.LNX.4.64.0807021547090.4958@bizon.gios.gov.pl>
 <Pine.LNX.4.64.0807021559170.32444@blackhole.kfki.hu>
 <Pine.LNX.4.64.0807031150290.1816@blackhole.kfki.hu>
Mime-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="-187430788-1420603205-1215100170=:4958"
Cc: netfilter@vger.kernel.org, netfilter-devel@vger.kernel.org
To: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from bizon.gios.gov.pl ([212.244.124.8]:55803 "EHLO
	bizon.gios.gov.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751691AbYGCPth (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 3 Jul 2008 11:49:37 -0400
In-Reply-To: <Pine.LNX.4.64.0807031150290.1816@blackhole.kfki.hu>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

---187430788-1420603205-1215100170=:4958
Content-Type: TEXT/PLAIN; charset=ISO-8859-2; format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE



On Thu, 3 Jul 2008, Jozsef Kadlecsik wrote:

> On Wed, 2 Jul 2008, Jozsef Kadlecsik wrote:
>
>> On Wed, 2 Jul 2008, Krzysztof Oledzki wrote:
>>
>>>>> Is statically linking still supported?
>>>>
>>>> No, it has never been supported. (Probaly you mean iptables?)
>>>
>>> No, I mean kernel.
>>>
>>> I ask because http://ipset.netfilter.org/install.html no longer points =
to a
>>> pom-ng file and it seems that
>>> ftp://ftp.netfilter.org/pub/patch-o-matic-ng/snapshot/ is currently aba=
ndoned
>>> - there have been no new files created since 2008-05-21.
>>
>> Oh, I see. I'll add back a pom-ng snapshot to ipset.netfilter.org. The
>> pom-ng repository is available from svn - the snapshot creation was
>> probably stopped when most of the repositories were moved to git.
>
> In ordert to cut the last ropes tying ipset to pom-ng, I added support to
> "patch" the kernel directly to the ipset package.
>
> So I have just released ipset-2.3.2a, which includes the required bits an=
d
> files with and updated README file on how to compile modular and
> non-modular kernels with ipset support. Please give it a try and report m=
e
> if something would be missing.

Works For Me, thank you.

Best regards,

 =09=09=09=09Krzysztof Ol=EAdzki
---187430788-1420603205-1215100170=:4958--
