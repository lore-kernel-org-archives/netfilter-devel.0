From: Thierry Du Tre <thierry@dtsystems.be>
Subject: Re: [PATCH] extensions : multiple to-dst/to-src arguments for
 ip6t_DNAT/SNAT not reported
Date: Tue, 16 Jan 2018 16:31:30 +0100
Message-ID: <d89d256c-5b4a-451a-6ffa-12bb972d1db3@dtsystems.be>
References: <65034694-62fb-3e6a-b15c-1176e65eae65@dtsystems.be>
 <20180116130612.iwzo3kbff7a7oobb@salvia>
 <16017f6b-7836-d905-9a4b-78df9904d511@dtsystems.be>
 <497cfaec-f39b-b9f5-7c49-d282002a3d74@dtsystems.be>
 <20180116152320.c6osokv3rhc55a45@salvia>
 <20180116152415.oev5fcu55evn43gj@salvia>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@vger.kernel.org
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-wm0-f68.google.com ([74.125.82.68]:39490 "EHLO
        mail-wm0-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751071AbeAPPbe (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 16 Jan 2018 10:31:34 -0500
Received: by mail-wm0-f68.google.com with SMTP id i11so9382456wmf.4
        for <netfilter-devel@vger.kernel.org>; Tue, 16 Jan 2018 07:31:33 -0800 (PST)
In-Reply-To: <20180116152415.oev5fcu55evn43gj@salvia>
Content-Language: nl
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Op 16/01/2018 om 16:24 schreef Pablo Neira Ayuso:
> On Tue, Jan 16, 2018 at 04:23:20PM +0100, Pablo Neira Ayuso wrote:
>> On Tue, Jan 16, 2018 at 04:20:40PM +0100, Thierry Du Tre wrote:
>>> Op 16/01/2018 om 16:06 schreef Thierry Du Tre:
>>>> Op 16/01/2018 om 14:06 schreef Pablo Neira Ayuso:
>>>>> Hi Thierry,
>>>>>
>>>>> On Tue, Jan 16, 2018 at 01:44:37PM +0100, Thierry Du Tre wrote:
>>>>>> This patch is fixing the detection of multiple '--to-destination' in a DNAT rule and '--to-source' in SNAT rule for IPv6.
>>>>>> Currently, when defining multiple values for these, only the last will be used and others ignored silently.
>>>>>>
>>>>>> The checks for (cb->xflags & F_X_TO_[DEST/SRC]) always fails because the flags are never set before.
>>>>>> It seems to be a copy-paste artefact since introduction of the IPv6 DNAT/SNAT extensions based on IPv4 code.
>>>>>>
>>>>>> I also removed the kernel_version checks because they seem useless. Extensions for IPv6 DNAT/SNAT are using xt_target with revision 1.
>>>>>> That seems only added since kernel version 3.7-rc1 and therefore the check for > v2.6.10 will always return true.
>>>>>> The check is probably also coming from the IPv4 copy-paste.
>>>>>
>>>>> Thanks for fixing up this.
>>>>>
>>>>> Would you also send us a patch to add tests:
>>>>>
>>>>>         extensions/libip6t_DNAT.t
>>>>>
>>>>
>>>> The following should cover this patch.
>>>> (without patch, libip6t_SNAT.t and libip6t_DNAT.t will fail)
>>>
>>> Added another test + fixed typo (too late)
>>
>> No problem, send a follow up patch with more tests.
> 
> BTW, the new patch to add more tests needs to go on top of your
> previous patch.

I hope this works :

---
 extensions/libip6t_DNAT.t | 1 +
 extensions/libip6t_SNAT.t | 1 +
 extensions/libipt_DNAT.t  | 1 +
 extensions/libipt_SNAT.t  | 1 +
 4 files changed, 4 insertions(+)

diff --git a/extensions/libip6t_DNAT.t b/extensions/libip6t_DNAT.t
index 0ba96bf..6d8f1da 100644
--- a/extensions/libip6t_DNAT.t
+++ b/extensions/libip6t_DNAT.t
@@ -3,6 +3,7 @@
 -j DNAT --to-destination dead::beef;=;OK
 -j DNAT --to-destination dead::beef-dead::fee7;=;OK
 -j DNAT --to-destination [dead::beef]:1025-65535;;FAIL
+-j DNAT --to-destination [dead::beef] --to-destination [dead::fee7];;FAIL
 -p tcp -j DNAT --to-destination [dead::beef]:1025-65535;=;OK
 -p tcp -j DNAT --to-destination [dead::beef-dead::fee7]:1025-65535;=;OK
 -p tcp -j DNAT --to-destination [dead::beef-dead::fee7]:1025-65536;;FAIL
diff --git a/extensions/libip6t_SNAT.t b/extensions/libip6t_SNAT.t
index 0f14894..d188a6b 100644
--- a/extensions/libip6t_SNAT.t
+++ b/extensions/libip6t_SNAT.t
@@ -3,6 +3,7 @@
 -j SNAT --to-source dead::beef;=;OK
 -j SNAT --to-source dead::beef-dead::fee7;=;OK
 -j SNAT --to-source [dead::beef]:1025-65535;;FAIL
+-j SNAT --to-source [dead::beef] --to-source [dead::fee7];;FAIL
 -p tcp -j SNAT --to-source [dead::beef]:1025-65535;=;OK
 -p tcp -j SNAT --to-source [dead::beef-dead::fee7]:1025-65535;=;OK
 -p tcp -j SNAT --to-source [dead::beef-dead::fee7]:1025-65536;;FAIL
diff --git a/extensions/libipt_DNAT.t b/extensions/libipt_DNAT.t
index a7a45e9..1959801 100644
--- a/extensions/libipt_DNAT.t
+++ b/extensions/libipt_DNAT.t
@@ -3,6 +3,7 @@
 -j DNAT --to-destination 1.1.1.1;=;OK
 -j DNAT --to-destination 1.1.1.1-1.1.1.10;=;OK
 -j DNAT --to-destination 1.1.1.1:1025-65535;;FAIL
+-j DNAT --to-destination 1.1.1.1 --to-destination 2.2.2.2;;FAIL
 -p tcp -j DNAT --to-destination 1.1.1.1:1025-65535;=;OK
 -p tcp -j DNAT --to-destination 1.1.1.1-1.1.1.10:1025-65535;=;OK
 -p tcp -j DNAT --to-destination 1.1.1.1-1.1.1.10:1025-65536;;FAIL
diff --git a/extensions/libipt_SNAT.t b/extensions/libipt_SNAT.t
index 34c5822..186e1cb 100644
--- a/extensions/libipt_SNAT.t
+++ b/extensions/libipt_SNAT.t
@@ -3,6 +3,7 @@
 -j SNAT --to-source 1.1.1.1;=;OK
 -j SNAT --to-source 1.1.1.1-1.1.1.10;=;OK
 -j SNAT --to-source 1.1.1.1:1025-65535;;FAIL
+-j SNAT --to-source 1.1.1.1 --to-source 2.2.2.2;;FAIL
 -p tcp -j SNAT --to-source 1.1.1.1:1025-65535;=;OK
 -p tcp -j SNAT --to-source 1.1.1.1-1.1.1.10:1025-65535;=;OK
 -p tcp -j SNAT --to-source 1.1.1.1-1.1.1.10:1025-65536;;FAIL
-- 
2.7.4
