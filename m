From: Chris Wilson <chris@netservers.co.uk>
Subject: Re: IPtables performance (fwd)
Date: Tue, 22 Apr 2003 12:04:26 +0100 (BST)
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <Pine.LNX.4.44.0304221149430.24242-300000@localhost>
Mime-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="=-JLt6w8EIVGdVMA2wzJsy"
Cc: Robert Olsson <robban@robtex.com>, John McEleney <john@netservers.co.uk>
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: netfilter-devel@lists.netfilter.org
Content-ID: <Pine.LNX.4.44.0304221149431.24242@localhost>
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

--=-JLt6w8EIVGdVMA2wzJsy
Content-Type: TEXT/PLAIN; CHARSET=US-ASCII
Content-ID: <Pine.LNX.4.44.0304221149432.24242@localhost>

Dear Sirs,

We have been having a problem with the performance of iptables in loading
large and complex rulesets for a long time. We have tracked it down to the
mark_source_chains kernel function, which takes about 15 seconds to
execute with a fairly large and complex ruleset on decent hardware.

We discovered Robert Olsson's patch which greatly improves the efficiency
of this function (he claims up to 1000x, we have seen around 80x with our
rulesets). This was last submitted to this list on 6th March 2002
(http://lists.netfilter.org/pipermail/netfilter-devel/2002-March/006994.html).

I cannot find any replies to this message in the archives, and the TODO 
list entry was removed in revision 1.65 with the message "todo update". We 
are really interested in this patch and would like to see it applied.

I have attached Robert's original patch which he has tested extensively,
and also a slightly cleaned-up version which we are using now and which
looks all right to me and seems to work (although I am still not sure
under what circumstances pos could be less than 0 or greater than
newinfo->size).

Please could you let me know whether you would consider including this 
patch in Netfilter.

Cheers, Chris.

[P.S. Harald: Robert sends his regards =)]
-- 
   ___ __     _
 / __// / ,__(_)_  | Chris Wilson -- UNIX Firewall Lead Developer |
/ (_ / ,\/ _/ /_ \ | NetServers.co.uk http://www.netservers.co.uk |
\ _//_/_/_//_/___/ | 21 Signet Court, Cambridge, UK. 01223 576516 |

---------- Forwarded message ----------
Date: 17 Apr 2003 15:42:15 +0200
From: Robert Olsson <robban@robtex.com>
To: Chris Wilson <chris@netservers.co.uk>
Subject: Re: IPtables performance

On Thu, 2003-04-17 at 12:13, Chris Wilson wrote:
> Dear Mr Olsson,
> 
> I read with interest about your patch for improving the rule load 
> performance of iptables by changing the algorithm used by 
> mark_source_chains. We are having exactly the same problem and would like 
> to try your patch.
> 
> However the latest version I can find is at 
> http://lists.netfilter.org/pipermail/netfilter-devel/2002-March/006994.html, 
> dated 6th March 2002. Since this has been HTML-ified, it no longer applies 
> as a working patch. I'm going to work on reintegrating it with the latest 
> iptables patch-o-matic, but first I wanted to check whether you were:
> 
> - aware of any problems with that version of the patch (since I couldn't 
>   find much discussion about it)

attached last version. problem with prior versions was that it didn't
care much about different chains (INPUT/FORWARD etc).
current version has been in production at our main firewall (we are an
ISP) with 3000 rules or something. really interlinked, takes a month to
insert without my patch :)

> - still interested in, developing or testing the patch (and how much has 
>   it been tested?)
> - happy for the code to be used under GPL

i would be happy if the code was used in netfilter

> - happy for us to resubmit the updated patch to the Netfilter developers 
>   (with your name still in the credits, of course)

sure you have my blessing. give my regards to harald :).
i hate having to patch each new version myself.

> 
> Look forward to hearing from you soon,

please keep me informed what happens

> 
> Cheers, Chris.
> -- 
>    ___ __     _
>  / __// / ,__(_)_  | Chris Wilson -- UNIX Firewall Lead Developer |
> / (_ / ,\/ _/ /_ \ | NetServers.co.uk http://www.netservers.co.uk |
> \ _//_/_/_//_/___/ | 21 Signet Court, Cambridge, UK. 01223 576516 |
> 


--=-JLt6w8EIVGdVMA2wzJsy
Content-Type: TEXT/PLAIN; CHARSET=US-ASCII; NAME="iptables-olsson-speed-v2.patch"
Content-Transfer-Encoding: BASE64
Content-ID: <Pine.LNX.4.44.0304221158280.24242@localhost>
Content-Description: cleaned-up patch
Content-Disposition: ATTACHMENT; FILENAME="iptables-olsson-speed-v2.patch"

VGhpcyBpcyBteSB1cGRhdGVkIHZlcnNpb24gb2YgUm9iZXJ0IE9sc3Nvbidz
IHBhdGNoLCBhZ2FpbnN0IDIuNC4yMA0Kd2l0aCBwYXRjaC1vLW1hdGljLTIw
MDMwMTA3Lg0KDQo8Y2hyaXNAbmV0c2VydmVycy5jby51az4gMTcvMDQvMDMN
Cg0KLS0tIGxpbnV4L25ldC9pcHY0L25ldGZpbHRlci9pcF90YWJsZXMuYwlX
ZWQgQXByIDE2IDE4OjQ0OjQ1IDIwMDMNCisrKyBsaW51eC1uZnNwZWVkL25l
dC9pcHY0L25ldGZpbHRlci9pcF90YWJsZXMuYwlUaHUgQXByIDE3IDExOjM2
OjM0IDIwMDMNCkBAIC04LDQgKzgsOSBAQA0KICAqIAktIGluY3JlYXNlIG1v
ZHVsZSB1c2FnZSBjb3VudCBhcyBzb29uIGFzIHdlIGhhdmUgcnVsZXMgaW5z
aWRlDQogICogCSAgYSB0YWJsZQ0KKyAqDQorICogIDYgTWFyIDIwMDIgUm9i
ZXJ0IE9sc3NvbiA8cm9iYmFuQHJvYnRleC5jb20+DQorICogMTcgQXByIDIw
MDMgQ2hyaXMgIFdpbHNvbiA8Y2hyaXNAbmV0c2VydmVycy5jby51az4NCisg
KiAgICAgLSBtYXJrX3NvdXJjZV9jaGFpbnMgc3BlZWR1cCBmb3IgY29tcGxl
eCBjaGFpbnMNCisgKg0KICAqLw0KICNpbmNsdWRlIDxsaW51eC9jb25maWcu
aD4NCkBAIC01MDMsNCArNTA4LDcgQEANCiAJdW5zaWduZWQgaW50IGhvb2s7
DQogDQorCS8qIGtlZXAgdHJhY2sgb2Ygd2hlcmUgd2UgaGF2ZSBiZWVuOiAq
Lw0KKwl1bnNpZ25lZCBjaGFyICpiZWVuID0gdm1hbGxvYyhuZXdpbmZvLT5z
aXplKTsNCisNCiAJLyogTm8gcmVjdXJzaW9uOyB1c2UgcGFja2V0IGNvdW50
ZXIgdG8gc2F2ZSBiYWNrIHB0cnMgKHJlc2V0DQogCSAgIHRvIDAgYXMgd2Ug
bGVhdmUpLCBhbmQgY29tZWZyb20gdG8gc2F2ZSBzb3VyY2UgaG9vayBiaXRt
YXNrICovDQpAQCAtNTE1LDQgKzUyMyw1IEBADQogCQkvKiBTZXQgaW5pdGlh
bCBiYWNrIHBvaW50ZXIuICovDQogCQllLT5jb3VudGVycy5wY250ID0gcG9z
Ow0KKwkJbWVtc2V0KGJlZW4sIDAsIG5ld2luZm8tPnNpemUpOw0KIA0KIAkJ
Zm9yICg7Oykgew0KQEAgLTUyMyw0ICs1MzIsNSBAQA0KIAkJCQlwcmludGso
ImlwdGFibGVzOiBsb29wIGhvb2sgJXUgcG9zICV1ICUwOFguXG4iLA0KIAkJ
CQkgICAgICAgaG9vaywgcG9zLCBlLT5jb21lZnJvbSk7DQorCQkJCXZmcmVl
KGJlZW4pOw0KIAkJCQlyZXR1cm4gMDsNCiAJCQl9DQpAQCAtNTcwLDggKzU4
MCwxMiBAQA0KIAkJCQlpbnQgbmV3cG9zID0gdC0+dmVyZGljdDsNCiANCi0J
CQkJaWYgKHN0cmNtcCh0LT50YXJnZXQudS51c2VyLm5hbWUsDQorCQkJCWlm
ICggKHBvcyA8IDAgfHwgcG9zID49IG5ld2luZm8tPnNpemUNCisJCQkJICAg
ICAgfHwgIWJlZW5bcG9zXSkgDQorCQkJCSAgICAmJiBzdHJjbXAodC0+dGFy
Z2V0LnUudXNlci5uYW1lLA0KIAkJCQkJICAgSVBUX1NUQU5EQVJEX1RBUkdF
VCkgPT0gMA0KIAkJCQkgICAgJiYgbmV3cG9zID49IDApIHsNCiAJCQkJCS8q
IFRoaXMgYSBqdW1wOyBjaGFzZSBpdC4gKi8NCisJCQkJCWlmIChwb3MgPj0g
MCAmJiBwb3MgPCBuZXdpbmZvLT5zaXplKQ0KKwkJCQkJCWJlZW5bcG9zXSsr
Ow0KIAkJCQkJZHVwcmludGYoIkp1bXAgcnVsZSAldSAtPiAldVxuIiwNCiAJ
CQkJCQkgcG9zLCBuZXdwb3MpOw0KQEAgLTU4OSw0ICs2MDMsNSBAQA0KIAkJ
ZHVwcmludGYoIkZpbmlzaGVkIGNoYWluICV1XG4iLCBob29rKTsNCiAJfQ0K
Kwl2ZnJlZShiZWVuKTsNCiAJcmV0dXJuIDE7DQogfQ0K
--=-JLt6w8EIVGdVMA2wzJsy
Content-Type: TEXT/PLAIN; CHARSET=US-ASCII; NAME="netfilterp1.patch"
Content-Transfer-Encoding: BASE64
Content-ID: <Pine.LNX.4.44.0304221159020.24242@localhost>
Content-Description: original patch
Content-Disposition: ATTACHMENT; FILENAME="netfilterp1.patch"

LS0tIG9sZGxpbnV4L25ldC9pcHY0L25ldGZpbHRlci9pcF90YWJsZXMuYwlT
YXQgTWFyICAyIDIzOjI0OjUyIDIwMDINCisrKyBsaW51eC9uZXQvaXB2NC9u
ZXRmaWx0ZXIvaXBfdGFibGVzLmMJU3VuIE1hciAgMyAwMDoyNToyNyAyMDAy
DQpAQCAtNyw2ICs3LDEwIEBADQogICogMTkgSmFuIDIwMDIgSGFyYWxkIFdl
bHRlIDxsYWZvcmdlQGdudW1vbmtzLm9yZz4NCiAgKiAJLSBpbmNyZWFzZSBt
b2R1bGUgdXNhZ2UgY291bnQgYXMgc29vbiBhcyB3ZSBoYXZlIHJ1bGVzIGlu
c2lkZQ0KICAqIAkgIGEgdGFibGUNCisgKg0KKyAqIDIgTWFyIDIwMDIgUm9i
ZXJ0IE9sc3NvbiA8cm9iYmFuQHJvYnRleC5jb20+DQorICoJLSBtYXJrX3Nv
dXJjZV9jaGFpbnMgc3BlZWR1cCBmb3IgY29tcGxleCBjaGFpbnMNCisgKiAg
ICAgDQogICovDQogI2luY2x1ZGUgPGxpbnV4L2NvbmZpZy5oPg0KICNpbmNs
dWRlIDxsaW51eC9za2J1ZmYuaD4NCkBAIC01MDAsMTAgKzUwNCwxMiBAQA0K
IG1hcmtfc291cmNlX2NoYWlucyhzdHJ1Y3QgaXB0X3RhYmxlX2luZm8gKm5l
d2luZm8sIHVuc2lnbmVkIGludCB2YWxpZF9ob29rcykNCiB7DQogCXVuc2ln
bmVkIGludCBob29rOw0KLQ0KKwkvKiBrZWVwIHRyYWNrIG9mIHdoZXJlIHdl
IGhhdmUgYmVlbjogKi8NCisJdW5zaWduZWQgY2hhciAqYmVlbj12bWFsbG9j
KG5ld2luZm8tPnNpemUpOw0KIAkvKiBObyByZWN1cnNpb247IHVzZSBwYWNr
ZXQgY291bnRlciB0byBzYXZlIGJhY2sgcHRycyAocmVzZXQNCiAJICAgdG8g
MCBhcyB3ZSBsZWF2ZSksIGFuZCBjb21lZnJvbSB0byBzYXZlIHNvdXJjZSBo
b29rIGJpdG1hc2sgKi8NCiAJZm9yIChob29rID0gMDsgaG9vayA8IE5GX0lQ
X05VTUhPT0tTOyBob29rKyspIHsNCisJCW1lbXNldChiZWVuLDAsbmV3aW5m
by0+c2l6ZSk7DQogCQl1bnNpZ25lZCBpbnQgcG9zID0gbmV3aW5mby0+aG9v
a19lbnRyeVtob29rXTsNCiAJCXN0cnVjdCBpcHRfZW50cnkgKmUNCiAJCQk9
IChzdHJ1Y3QgaXB0X2VudHJ5ICopKG5ld2luZm8tPmVudHJpZXMgKyBwb3Mp
Ow0KQEAgLTUyMSw2ICs1MjcsNyBAQA0KIAkJCWlmIChlLT5jb21lZnJvbSAm
ICgxIDw8IE5GX0lQX05VTUhPT0tTKSkgew0KIAkJCQlwcmludGsoImlwdGFi
bGVzOiBsb29wIGhvb2sgJXUgcG9zICV1ICUwOFguXG4iLA0KIAkJCQkgICAg
ICAgaG9vaywgcG9zLCBlLT5jb21lZnJvbSk7DQorCQkJCXZmcmVlKGJlZW4p
Ow0KIAkJCQlyZXR1cm4gMDsNCiAJCQl9DQogCQkJZS0+Y29tZWZyb20NCkBA
IC01NjcsMTEgKzU3NCwxMiBAQA0KIAkJCQlwb3MgKz0gc2l6ZTsNCiAJCQl9
IGVsc2Ugew0KIAkJCQlpbnQgbmV3cG9zID0gdC0+dmVyZGljdDsNCi0NCi0J
CQkJaWYgKHN0cmNtcCh0LT50YXJnZXQudS51c2VyLm5hbWUsDQorCQkJCWlm
ICgoKDA8cG9zJiZwb3M8bmV3aW5mby0+c2l6ZSk/KGJlZW5bcG9zXTwxKTox
KQ0KKwkJCQkJJiZzdHJjbXAodC0+dGFyZ2V0LnUudXNlci5uYW1lLA0KIAkJ
CQkJICAgSVBUX1NUQU5EQVJEX1RBUkdFVCkgPT0gMA0KIAkJCQkgICAgJiYg
bmV3cG9zID49IDApIHsNCiAJCQkJCS8qIFRoaXMgYSBqdW1wOyBjaGFzZSBp
dC4gKi8NCisJCQkJCWlmICgwPHBvcyYmbmV3cG9zPG5ld2luZm8tPnNpemUp
IGJlZW5bcG9zXSsrOw0KIAkJCQkJZHVwcmludGYoIkp1bXAgcnVsZSAldSAt
PiAldVxuIiwNCiAJCQkJCQkgcG9zLCBuZXdwb3MpOw0KIAkJCQl9IGVsc2Ug
ew0KQEAgLTU4Nyw2ICs1OTUsNyBAQA0KIAkJbmV4dDoNCiAJCWR1cHJpbnRm
KCJGaW5pc2hlZCBjaGFpbiAldVxuIiwgaG9vayk7DQogCX0NCisJdmZyZWUo
YmVlbik7DQogCXJldHVybiAxOw0KIH0NCiANCg==
--=-JLt6w8EIVGdVMA2wzJsy--
