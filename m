From: Henrik Nordstrom <hno@marasystems.com>
Subject: Re: Call for testing: patch-o-matic-ng
Date: Fri, 2 Jan 2004 13:41:32 +0100 (CET)
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <Pine.LNX.4.44.0401021230010.31039-200000@filer.marasystems.com>
References: <20031221122445.GC5058@obroa-skai.de.gnumonks.org>
Mime-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="-1463811839-382214561-1073047292=:31572"
Cc: Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Harald Welte <laforge@netfilter.org>
In-Reply-To: <20031221122445.GC5058@obroa-skai.de.gnumonks.org>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.
  Send mail to mime@docserver.cac.washington.edu for more info.

---1463811839-382214561-1073047292=:31572
Content-Type: TEXT/PLAIN; charset=US-ASCII

On Sun, 21 Dec 2003, Harald Welte wrote:

> - no wholefile-patches in CVS.  This means that entirely new files like
>   net/ipv4/netfilter/ipt_foo.c / ipt_foo.h are not stored as patches but
>   rather in their original form.   This in turn means real version
>   control on the sourcecode!

One idea for further improvement:

It would be nice if runme could support "wholefile modifications" where
both the whole original and patched files are stored rather than a diff
(patch generated on the fly when applying to the kernel source tree). This
simplifies the development phase of a extension requiring patching of
other files and also simplifies maintenance of major rewrites.

I have been using the above model for a number of kernel projects for a
long time and find it very successful at tracking the changes. What I do
is that my development tree only contains the changed files, and then a
script copies the changes over to the kernel tree. The script is designed
in such manner that it can be run multiple times to copy over new changes
to a already patched tree, completely eleminating the need to directly
modifying the full source tree directly during development.

The script I am using is attached to this message. to try it out grab for
example a copy of the user-mode-linux CVS tree or another project using
"full modified files" source layout, then place the script in the top 
level directory (the equivalence of the Linux top level source directory) 
and then run the script supplying the path to your full kernel tree as 
argument.

Note that agree that the main CVS repository probably should contain
patches like it is now rather than "wholefile patches".  But during
development I find maintaining a patch file is a little awkward and some
kind of changes easily get lost. And in the few cases where a patch mostly 
rewrites a existing file having it as a full file makes more sense than 
patch format.

> However, some stuff is still missing (see the patch-o-matic/TODO file).
> I'm working on implementing those missing features, though.

What is also missing is a equivalence to the NEWPATCHES document.

Regards
Henrik

---1463811839-382214561-1073047292=:31572
Content-Type: TEXT/PLAIN; charset=US-ASCII; name=update
Content-Transfer-Encoding: BASE64
Content-ID: <Pine.LNX.4.44.0401021341320.31572@filer.marasystems.com>
Content-Description: 
Content-Disposition: attachment; filename=update

IyEvYmluL3NoDQpjZCBgZGlybmFtZSAkMGANCg0KIyBUaGlzIHZhcmlhYmxl
IGlzIHVzZWQgZm9yIGJhY2t1cCBjb3BpZXMgdG8gYWxsb3cgaW5jcmVtZW50
YWwgcGF0Y2hpbmcNCnByb2plY3Q9dW1sDQoNCktFUk5FTF9ESVI9IiR7S0VS
TkVMX0RJUjotL3Vzci9zcmMvbGludXgtJHtwcm9qZWN0fX0iDQp3aGlsZSBb
ICQjIC1nZSAxIF07IGRvDQogICAgY2FzZSAiJDEiIGluDQogICAgLWZ1bGwp
DQoJZnVsbD0xOzsNCiAgICAtb3JpZykNCiAgICAJb3JpZz0xOzsNCiAgICAq
KQ0KICAgIAlicmVhazs7DQogICAgZXNhYw0KICAgIHNoaWZ0DQpkb25lDQpL
RVJORUxfRElSPSR7MTotJHtLRVJORUxfRElSfX0NCmlmIFsgISAtZCAke0tF
Uk5FTF9ESVJ9IF07IHRoZW4NCiAgICBlY2hvICJFUlJPUjogTm8ga2VybmVs
IGRpcmVjdG9yeSINCiAgICBleGl0IDENCmZpDQpmaW5kIC4gLW5hbWUgJy4j
KicgLXByaW50MCB8IHhhcmdzIC0wIHJtIC1mDQojIENyZWF0ZSAib3JpZ2lu
YWwiIGNvcGllcyBvZiB0aGUgTGludXggc291cmNlcw0KaWYgWyAhIC1kIG9y
aWcgXSB8fCBbICRvcmlnIF07IHRoZW4NCiAgZWNobyAiRmlyc3QgdGltZS4g
Q3JlYXRpbmcgXCJwcmlzdGluZVwiIHNvdXJjZSBjb3BpZXMgaW4gJFBXRC9v
cmlnIg0KICBmaW5kIC4gLXR5cGUgZiAtcHJpbnQgLW8gLW5hbWUgJ29yaWcn
IC1wcnVuZSB8IHdoaWxlIHJlYWQgZmlsZTsgZG8NCiAgICBpZiBbIC1mICR7
S0VSTkVMX0RJUn0vJGZpbGUgXTsgdGhlbg0KICAgICAgbWtkaXIgLXAgb3Jp
Zy9gZGlybmFtZSAkZmlsZWANCiAgICAgIGNwIC1wICR7S0VSTkVMX0RJUn0v
JGZpbGUgb3JpZy8kZmlsZQ0KICAgICAgZWNobyAiICAgJGZpbGUiDQogICAg
ZmkNCiAgZG9uZQ0KICBpZiBbICRvcmlnIF07IHRoZW4NCiAgICBleGl0DQog
IGZpDQpmaQ0KIyBPbiBmdWxsIHVwZGF0ZXMsIGdldCByaWQgb2YgYWxsIHVz
ZXItbW9kZSBhcmNoaXRlY3R1cmUgZmlsZXMNCmlmIHRlc3QgJGZ1bGw7IHRo
ZW4NCiAgcm0gLXJmICR7S0VSTkVMX0RJUn0vYXJjaC91bSAke0tFUk5FTF9E
SVJ9L2luY2x1ZGUvYXNtLXVtDQpmaQ0KIyBTZXQgdXAgbmV3IFVNIGtlcm5l
bCB0cmVlIGRpcmVjdG9yaWVzDQpmaW5kIC1uYW1lIENWUyAtcHJ1bmUgLW8g
LW5hbWUgb3JpZyAtcHJ1bmUgLW8gLXR5cGUgZCAtcHJpbnQgfCAoY2QgJHtL
RVJORUxfRElSfSAmJiB4YXJncyBta2RpciAtcCApDQojIENvcHkgb3ZlciBV
TSBrZXJuZWwgY2hhbmdlcw0KZWNobyAiUGF0Y2hpbmcga2VybmVsIHdpdGgg
VU1MIGNoYW5nZXMiDQpmaW5kIFteb10qIC1uYW1lIENWUyAtcHJ1bmUgLW8g
LW5hbWUgLmN2c2lnbm9yZSAtcHJ1bmUgLW8gLW5hbWUgb3JpZyAtcHJ1bmUg
LW8gLXR5cGUgZiAtcHJpbnQgfCB3aGlsZSByZWFkIGY7IGRvDQogIGlmIHRl
c3QgLWYgb3JpZy8kZjsgdGhlbg0KICAgIGZpcnN0PQ0KICAgICMgVGhpcyBp
cyBhIHBhdGNoZWQgZmlsZS4gT25seSBjb3B5IG92ZXIgdGhlIGNoYW5nZXMs
IHByZXNlcnZlDQogICAgIyBhbnkgb3RoZXIgbG9jYWwgbW9kaWZpY2F0aW9u
cy4NCiAgICBpZiBbICEgLWYgJHtLRVJORUxfRElSfS8kZi5ubyR7cHJvamVj
dH0gXTsgdGhlbg0KICAgICAgIyBGaXJzdCB0aW1lLiBNYWtlIGEgYmFja3Vw
IGNvcHkgb2YgdGhlIG9yaWdpbmFsIChwb3NzaWJseSBtb2RpZmllZCkNCiAg
ICAgICMga2VybmVsIHNvdXJjZSwgc28gd2UgY2FuIHVwZGF0ZSBpdCBhZ2Fp
biBsYXRlciBpZiBuZWVkZWQNCiAgICAgIGNwIC1wICR7S0VSTkVMX0RJUn0v
JGYgJHtLRVJORUxfRElSfS8kZi5ubyR7cHJvamVjdH0NCiAgICAgIGZpcnN0
PTENCiAgICBmaQ0KICAgIGlmIHRlc3QgJGYgLW50ICR7S0VSTkVMX0RJUn0v
JGYgfHwgdGVzdCAkZnVsbCB8fCB0ZXN0ICRmaXJzdDsgdGhlbg0KICAgICAg
IyBBcHBseSB0aGUgY2hhbmdlcyB0byB0aGUga2VybmVsIHRyZWUNCiAgICAg
IGlmICEgdGVzdCAkZmlyc3Q7IHRoZW4NCglybSAtZiAke0tFUk5FTF9ESVJ9
LyRmDQoJY3AgLXAgJHtLRVJORUxfRElSfS8kZi5ubyR7cHJvamVjdH0gJHtL
RVJORUxfRElSfS8kZg0KICAgICAgZmkNCiAgICAgIGRpZmYgLXUgb3JpZy8k
ZiAkZiB8IHBhdGNoIC1zICR7S0VSTkVMX0RJUn0vJGYNCiAgICAgIHRvdWNo
IC1yICRmICR7S0VSTkVMX0RJUn0vJGYNCiAgICAgIGVjaG8gIlAgICAkZiIN
CiAgICBmaQ0KICBlbHNlDQogICAgIyBUaGlzIGlzIGEgcHJvamVjdCBzcGVj
aWZpYyBmaWxlLiBKdXN0IGNvcHkgaXQgb3Zlci4NCiAgICBpZiAhIHRlc3Qg
LWYgJHtLRVJORUxfRElSfS8kZiB8fCAhIGNtcCAtcyAkZiAke0tFUk5FTF9E
SVJ9LyRmIHx8IHRlc3QgJGZ1bGw7IHRoZW4NCiAgICAgIGNwIC1wICRmICR7
S0VSTkVMX0RJUn0vJGYNCiAgICAgIGVjaG8gIiAgICAkZiINCiAgICBmaQ0K
ICBmaQ0KZG9uZQ0K
---1463811839-382214561-1073047292=:31572--
