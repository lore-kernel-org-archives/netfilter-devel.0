From: Chris Wilson <chris@netservers.co.uk>
Subject: using a hash table for netfilter tables?
Date: Thu, 24 Apr 2003 12:17:09 +0100 (BST)
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <Pine.LNX.4.44.0304241208400.24242-200000@localhost>
Mime-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="8323328-359995770-1051182861=:24242"
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Andre Uratsuka Manoel <andre@insite.com.br>
Content-ID: <Pine.LNX.4.44.0304241216410.24242@localhost>
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

--8323328-359995770-1051182861=:24242
Content-Type: TEXT/PLAIN; CHARSET=US-ASCII
Content-ID: <Pine.LNX.4.44.0304241216411.24242@localhost>

Andre Uratsuka Manoel wrote:

> Hi all,
>
> I need to replace the current list-based netfilter code for something
> using hashtables. The reason is that I have hundreds of tables in a
> project, but set up times are killing me. I took a peek at the code and
> it looked easy to do, since the current list-based code already takes
> care of locking, that's a huge problem I don't have to care about.
>
> Is there something I should know abot? Any tips? Is this stupid?

Hi Andre,

If, as Patrick Schaaf suggested, you are already using iptables-restore, 
then it could be that you are having the same problems as us. Would you be 
willing to try Robert Olsson's kernel patch, to see if it makes a 
difference to your ruleset loading time? Our cleaned-up version of the 
patch is attached, or we can give you the original if you prefer.

(I posted this patch to netfilter-devel on Tuesday, but it doesn't seem to 
have made the list yet.)

Cheers, Chris.
-- 
   ___ __     _
 / __// / ,__(_)_  | Chris Wilson -- UNIX Firewall Lead Developer |
/ (_ / ,\/ _/ /_ \ | NetServers.co.uk http://www.netservers.co.uk |
\ _//_/_/_//_/___/ | 21 Signet Court, Cambridge, UK. 01223 576516 |


--8323328-359995770-1051182861=:24242
Content-Type: TEXT/PLAIN; CHARSET=US-ASCII; NAME="iptables-olsson-speed-v2.patch"
Content-Transfer-Encoding: BASE64
Content-ID: <Pine.LNX.4.44.0304241214210.24242@localhost>
Content-Description: 
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
--8323328-359995770-1051182861=:24242--
