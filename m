From: Wim Van de Meerssche <wim.vandemeerssche@gmail.com>
Subject: Problems writing a costum target
Date: Wed, 2 Feb 2005 10:03:59 +0100
Message-ID: <6cc08a9b0502020103487e0681@mail.gmail.com>
Reply-To: Wim Van de Meerssche <wim.vandemeerssche@gmail.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="----=_Part_32_7846491.1107335039582"
To: netfilter-devel@lists.netfilter.org
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: </pipermail/netfilter-devel>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
Sender: netfilter-devel-bounces@lists.netfilter.org
Errors-To: netfilter-devel-bounces@lists.netfilter.org
List-Id: netfilter-devel.vger.kernel.org

------=_Part_32_7846491.1107335039582
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

Hi,

I'm having some trouble writing a new Netfilter target.
It's meant to make some changes to IPv6 packets (add a routing header).
However, I can't even get a simple change of IPv6 destination address to work.
Either the changes to the packet are ignored (if I use
skb_ip_make_writable), or the packet gets dropped somewhere (if I
don't use skb_ip_make_writable).

I've been testing with:
ip6tables -t mangle -A POSTROUTING -s somehost -j LOG
ip6tables -t mangle -A POSTROUTING -s somehost -j ADDRH  (see attached code)
ip6tables -t mangle -A POSTROUTING -s somehost -j LOG  (the dropped
packets mentioned above don't show up here)

I've also tried the PREROUTING hook.
The code I'm using is attached.
What am I doing wrong? (Is my poor experience with kernel programming to blame?)

Any help would be greatly appreciated.

Wim Van de Meerssche

------=_Part_32_7846491.1107335039582
Content-Type: application/octet-stream; name="ADDRHCode.c"
Content-Transfer-Encoding: base64
Content-Disposition: attachment; filename="ADDRHCode.c"

LyogVGhpcyBpcyB0aGUgaW50ZXJlc3RpbmcgcGFydCBvZiB0aGUgY29kZS4gKi8Kc3RhdGljIHVu
c2lnbmVkIGludAppcDZ0X2FkZHJoX3RhcmdldChzdHJ1Y3Qgc2tfYnVmZiAqKnBza2IsIGNvbnN0
IHN0cnVjdCBuZXRfZGV2aWNlICppbiwKICAgICAgICAgICAgICAgIGNvbnN0IHN0cnVjdCBuZXRf
ZGV2aWNlICpvdXQsIHVuc2lnbmVkIGludCBob29rbnVtLAogICAgICAgICAgICAgICAgY29uc3Qg
dm9pZCAqdGFyZ2luZm8sIHZvaWQgKnVzZXJpbmZvKQp7CiAgc3RydWN0IGlwdjZoZHIgKmlwaDsK
ICBjb25zdCBzdHJ1Y3QgaXA2dF9BRERSSF9pbmZvICppbmZvID0gdGFyZ2luZm87CiAgLyogaW5m
bzogICAgIHN0cnVjdCBpcDZ0X0FERFJIX2luZm8geyBzdHJ1Y3QgaW42X2FkZHIgdGFyZ2V0OyB9
OyAqLwoKICBpcGggPSAoKnBza2IpLT5uaC5pcHY2aDsKCiAgcHJpbnRrKC4uLmlwaC0+ZGFkZHIu
Li4pOyAvL3ByaW50cyBwYWNrZXQgaW5mbyBmb3IgZGVidWdnaW5nCgogIC8qIHdpdGggdGhlIGxp
bmUgYmVsb3csIHRoZSBwYWNrZXQgZG9lc24ndCBjaGFuZ2UuIFdpdGhvdXQgdGhlIGxpbmUsIGl0
IGdldHMgZHJvcHBlZC4gKi8KICAvL2lmICghc2tiX2lwX21ha2Vfd3JpdGFibGUocHNrYiwgc2l6
ZW9mKHN0cnVjdCBpcHY2aGRyKSkpIHJldHVybiBORl9EUk9QOwoKICBpcGgtPmRhZGRyID0gaW5m
by0+dGFyZ2V0OwoKICAoKnBza2IpLT5uZmNhY2hlIHw9IE5GQ19BTFRFUkVEOyAKCiAgcHJpbnRr
KC4uLmlwaC0+ZGFkZHIuLi4pOyAvL3ByaW50cyBwYWNrZXQgaW5mbyBmb3IgZGVidWdnaW5nICh0
aGUgY2hhbmdlIGNhbiBhbHdheXMgYmUgc2VlbiBoZXJlKQoKICByZXR1cm4gSVA2VF9DT05USU5V
RTsKfQo=
------=_Part_32_7846491.1107335039582--
