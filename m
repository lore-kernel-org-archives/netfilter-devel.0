From: Alan Bartlett <ajb@elrepo.org>
Subject: Re: Linux 4.2 build error in net/netfilter/ipset/ip_set_hash_netnet.c
Date: Thu, 20 Aug 2015 21:11:45 +0100
Message-ID: <CA+_WhHx53XPyBYN+tyC7aD=XyinOFNFR9Yvc4KwLn-3sHKK_eQ@mail.gmail.com>
References: <CAHTgTXUmreHAqPfgGEd+GJNb_OEzaCuytqBTjZsE2GDqiy3TCw@mail.gmail.com>
	<20150705153520.GA23589@roeck-us.net>
	<mo0o3b$g5d$1@ger.gmane.org>
	<20150713164122.GA26283@salvia>
	<alpine.DEB.2.10.1507141910280.28425@blackhole.kfki.hu>
	<CABA31DpRS5NXQm0_tP3eMxE4E9TdtGmrZbr+ZE8JUiNs3qHbMg@mail.gmail.com>
	<20150820192739.GA18180@salvia>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary=089e0122edbab3f35c051dc3c248
Cc: Akemi Yagi <amyagi@gmail.com>, netfilter-devel@vger.kernel.org,
	Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-ig0-f172.google.com ([209.85.213.172]:34058 "EHLO
	mail-ig0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751907AbbHTULq (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 20 Aug 2015 16:11:46 -0400
Received: by igui7 with SMTP id i7so2879230igu.1
        for <netfilter-devel@vger.kernel.org>; Thu, 20 Aug 2015 13:11:46 -0700 (PDT)
In-Reply-To: <20150820192739.GA18180@salvia>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

--089e0122edbab3f35c051dc3c248
Content-Type: text/plain; charset=UTF-8

On 20 August 2015 at 20:27, Pablo Neira Ayuso <pablo@netfilter.org> wrote:
> On Tue, Aug 11, 2015 at 08:50:28AM -0700, Akemi Yagi wrote:
>> On Tue, Jul 14, 2015 at 10:12 AM, Jozsef Kadlecsik > <kadlec@blackhole.kfki.hu> wrote:
> [...]
>> > As I mentioned at the workshop, the patch
>> > net-netfilter-ipset-work-around-gcc-444-initializer-bug.patch has been
>> > added to the -mm tree at Jun 17. My impression was that that way the bug
>> > was fixed and everything was all right.
>> >
>> > Best regards,
>> > Jozsef
>>
>> The referenced patch does indeed fix the issue but it is still not in
>> Linus' tree as of kernel 4.2.0-0.rc6. Does anyone know how to push
>> forward this so the official 4.2 kernel would have the fix?
>
> Is this problem still present in 4.2.0-rc7?
>
> I can put this into my nf git tree then pass this up to David. If so,
> could you please Cc the author of that patch so he knows this is
> following its path to master, I would like to avoid that we get this
> from two different paths.
>
> Thanks!

Hello Pablo,

I can confirm that problem is still present in linux-4.2-rc7 and the
attached file shows the relevant locations within Linus' tree.

[quote]
[linux]$ date
Mon Aug 17 10:46:45 EDT 2015
[linux]$ git pull
Already up-to-date.
[linux]$ head -n 4 Makefile
VERSION = 4
PATCHLEVEL = 2
SUBLEVEL = 0
EXTRAVERSION = -rc7
[linux]$ cd net/netfilter/ipset/
[ipset]$ grep -l ' \.cidr' *
ip_set_hash_ipportnet.c
ip_set_hash_net.c
ip_set_hash_netiface.c
ip_set_hash_netnet.c
ip_set_hash_netport.c
ip_set_hash_netportnet.c
[ipset]$ for F in $(grep -l ' \.cidr' *)
> do echo -e "\n###### $F ######\n"
> grep ' \.cidr' $F
> done; echo

###### ip_set_hash_ipportnet.c ######

    struct hash_ipportnet4_elem e = { .cidr = HOST_MASK - 1 };
    struct hash_ipportnet6_elem e = { .cidr = HOST_MASK - 1 };

###### ip_set_hash_net.c ######

    struct hash_net4_elem e = { .cidr = HOST_MASK };
    struct hash_net6_elem e = { .cidr = HOST_MASK };

###### ip_set_hash_netiface.c ######

    struct hash_netiface4_elem e = { .cidr = HOST_MASK, .elem = 1 };
    struct hash_netiface6_elem e = { .cidr = HOST_MASK, .elem = 1 };

###### ip_set_hash_netnet.c ######

    struct hash_netnet4_elem e = { .cidr = { HOST_MASK, HOST_MASK, }, };
    struct hash_netnet6_elem e = { .cidr = { HOST_MASK, HOST_MASK, }, };

###### ip_set_hash_netport.c ######

    struct hash_netport4_elem e = { .cidr = HOST_MASK - 1 };
    struct hash_netport6_elem e = { .cidr = HOST_MASK  - 1 };

###### ip_set_hash_netportnet.c ######

    struct hash_netportnet4_elem e = { .cidr = { HOST_MASK, HOST_MASK, }, };
    struct hash_netportnet6_elem e = { .cidr = { HOST_MASK, HOST_MASK, }, };

[ipset]$
[/quote]

Alan.

--089e0122edbab3f35c051dc3c248
Content-Type: text/plain; charset=US-ASCII; name="ipset-gcc-447-initializer-bug.txt"
Content-Disposition: attachment;
	filename="ipset-gcc-447-initializer-bug.txt"
Content-Transfer-Encoding: base64
X-Attachment-Id: f_idkn8uv90

W2xpbnV4XSQgZGF0ZQpNb24gQXVnIDE3IDEwOjQ2OjQ1IEVEVCAyMDE1CltsaW51eF0kIGdpdCBw
dWxsCkFscmVhZHkgdXAtdG8tZGF0ZS4KW2xpbnV4XSQgaGVhZCAtbiA0IE1ha2VmaWxlClZFUlNJ
T04gPSA0ClBBVENITEVWRUwgPSAyClNVQkxFVkVMID0gMApFWFRSQVZFUlNJT04gPSAtcmM3Clts
aW51eF0kIGNkIG5ldC9uZXRmaWx0ZXIvaXBzZXQvCltpcHNldF0kIGdyZXAgLWwgJyBcLmNpZHIn
ICoKaXBfc2V0X2hhc2hfaXBwb3J0bmV0LmMKaXBfc2V0X2hhc2hfbmV0LmMKaXBfc2V0X2hhc2hf
bmV0aWZhY2UuYwppcF9zZXRfaGFzaF9uZXRuZXQuYwppcF9zZXRfaGFzaF9uZXRwb3J0LmMKaXBf
c2V0X2hhc2hfbmV0cG9ydG5ldC5jCltpcHNldF0kIGZvciBGIGluICQoZ3JlcCAtbCAnIFwuY2lk
cicgKikKPiBkbyBlY2hvIC1lICJcbiMjIyMjIyAkRiAjIyMjIyNcbiIKPiBncmVwICcgXC5jaWRy
JyAkRgo+IGRvbmU7IGVjaG8KCiMjIyMjIyBpcF9zZXRfaGFzaF9pcHBvcnRuZXQuYyAjIyMjIyMK
CglzdHJ1Y3QgaGFzaF9pcHBvcnRuZXQ0X2VsZW0gZSA9IHsgLmNpZHIgPSBIT1NUX01BU0sgLSAx
IH07CglzdHJ1Y3QgaGFzaF9pcHBvcnRuZXQ2X2VsZW0gZSA9IHsgLmNpZHIgPSBIT1NUX01BU0sg
LSAxIH07CgojIyMjIyMgaXBfc2V0X2hhc2hfbmV0LmMgIyMjIyMjCgoJc3RydWN0IGhhc2hfbmV0
NF9lbGVtIGUgPSB7IC5jaWRyID0gSE9TVF9NQVNLIH07CglzdHJ1Y3QgaGFzaF9uZXQ2X2VsZW0g
ZSA9IHsgLmNpZHIgPSBIT1NUX01BU0sgfTsKCiMjIyMjIyBpcF9zZXRfaGFzaF9uZXRpZmFjZS5j
ICMjIyMjIwoKCXN0cnVjdCBoYXNoX25ldGlmYWNlNF9lbGVtIGUgPSB7IC5jaWRyID0gSE9TVF9N
QVNLLCAuZWxlbSA9IDEgfTsKCXN0cnVjdCBoYXNoX25ldGlmYWNlNl9lbGVtIGUgPSB7IC5jaWRy
ID0gSE9TVF9NQVNLLCAuZWxlbSA9IDEgfTsKCiMjIyMjIyBpcF9zZXRfaGFzaF9uZXRuZXQuYyAj
IyMjIyMKCglzdHJ1Y3QgaGFzaF9uZXRuZXQ0X2VsZW0gZSA9IHsgLmNpZHIgPSB7IEhPU1RfTUFT
SywgSE9TVF9NQVNLLCB9LCB9OwoJc3RydWN0IGhhc2hfbmV0bmV0Nl9lbGVtIGUgPSB7IC5jaWRy
ID0geyBIT1NUX01BU0ssIEhPU1RfTUFTSywgfSwgfTsKCiMjIyMjIyBpcF9zZXRfaGFzaF9uZXRw
b3J0LmMgIyMjIyMjCgoJc3RydWN0IGhhc2hfbmV0cG9ydDRfZWxlbSBlID0geyAuY2lkciA9IEhP
U1RfTUFTSyAtIDEgfTsKCXN0cnVjdCBoYXNoX25ldHBvcnQ2X2VsZW0gZSA9IHsgLmNpZHIgPSBI
T1NUX01BU0sgIC0gMSB9OwoKIyMjIyMjIGlwX3NldF9oYXNoX25ldHBvcnRuZXQuYyAjIyMjIyMK
CglzdHJ1Y3QgaGFzaF9uZXRwb3J0bmV0NF9lbGVtIGUgPSB7IC5jaWRyID0geyBIT1NUX01BU0ss
IEhPU1RfTUFTSywgfSwgfTsKCXN0cnVjdCBoYXNoX25ldHBvcnRuZXQ2X2VsZW0gZSA9IHsgLmNp
ZHIgPSB7IEhPU1RfTUFTSywgSE9TVF9NQVNLLCB9LCB9OwoKW2lwc2V0XSQgCg==
--089e0122edbab3f35c051dc3c248--
