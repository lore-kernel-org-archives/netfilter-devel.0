From: Kiran Kumar <immidi_kiran@yahoo.com>
Subject: Re: ipt_sctp undeclared variable
Date: Sun, 14 Mar 2004 19:06:53 -0800 (PST)
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <20040315030653.52069.qmail@web14008.mail.yahoo.com>
References: <87znajva8y.fsf@thorr.asgardr.info>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="0-1576328809-1079320013=:50564"
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Daniel 'NebuchadnezzaR' Dehennin <nebuchadnezzar@nerim.net>,
  netfilter-devel@lists.netfilter.org
In-Reply-To: <87znajva8y.fsf@thorr.asgardr.info>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

--0-1576328809-1079320013=:50564
Content-Type: text/plain; charset=us-ascii
Content-Id: 
Content-Disposition: inline

--- Daniel 'NebuchadnezzaR' Dehennin
<nebuchadnezzar@nerim.net> wrote:
> I try the latest pom-ng (from cvs) and I have an
> error during
> the build:
> 
> net/ipv4/netfilter/ipt_sctp.c: In function «
> match_packet »:
> net/ipv4/netfilter/ipt_sctp.c:59: error: `i'
> undeclared (first use in this function)
> net/ipv4/netfilter/ipt_sctp.c:59: error: (Each
> undeclared identifier is reported only once
> net/ipv4/netfilter/ipt_sctp.c:59: error: for each
> function it appears in.)
> make[4]: *** [net/ipv4/netfilter/ipt_sctp.o] Erreur
> 1

  The attached (trivial) patch is the fix for it. BTW,
I have submitted it to Harald as well, and it should
be in CVS some time soon.

=====
Regards,
Kiran Kumar Immidi

__________________________________
Do you Yahoo!?
Yahoo! Mail - More reliable, more storage, less spam
http://mail.yahoo.com
--0-1576328809-1079320013=:50564
Content-Type: application/octet-stream; name="bug.diff"
Content-Transfer-Encoding: base64
Content-Description: bug.diff
Content-Disposition: attachment; filename="bug.diff"

SW5kZXg6IHNjdHAvbGludXgtMi42L25ldC9pcHY0L25ldGZpbHRlci9pcHRf
c2N0cC5jCj09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09
PT09PT09PT09PT09PT09PT09PT09PT09PT09PT0KUkNTIGZpbGU6IC9jdnNw
dWJsaWMvcGF0Y2gtby1tYXRpYy1uZy9zY3RwL2xpbnV4LTIuNi9uZXQvaXB2
NC9uZXRmaWx0ZXIvaXB0X3NjdHAuYyx2CnJldHJpZXZpbmcgcmV2aXNpb24g
MS4yCmRpZmYgLXUgLXIxLjIgaXB0X3NjdHAuYwotLS0gc2N0cC9saW51eC0y
LjYvbmV0L2lwdjQvbmV0ZmlsdGVyL2lwdF9zY3RwLmMJMiBNYXIgMjAwNCAx
ODozOToyMCAtMDAwMAkxLjIKKysrIHNjdHAvbGludXgtMi42L25ldC9pcHY0
L25ldGZpbHRlci9pcHRfc2N0cC5jCTQgTWFyIDIwMDQgMTA6Mjc6MjMgLTAw
MDAKQEAgLTYsNyArNiw3IEBACiAjaW5jbHVkZSA8bGludXgvbmV0ZmlsdGVy
X2lwdjQvaXBfdGFibGVzLmg+CiAjaW5jbHVkZSA8bGludXgvbmV0ZmlsdGVy
X2lwdjQvaXB0X3NjdHAuaD4KIAotI2lmIDEKKyNpZiAwCiAjZGVmaW5lIGR1
cHJpbnRmKGZvcm1hdCwgYXJncy4uLikgcHJpbnRrKGZvcm1hdCAsICMjIGFy
Z3MpCiAjZWxzZQogI2RlZmluZSBkdXByaW50Zihmb3JtYXQsIGFyZ3MuLi4p
CkBAIC00Myw2ICs0Myw4IEBACiAJaW50IG9mZnNldDsKIAl1X2ludDMyX3Qg
Y2h1bmttYXBjb3B5WzI1NiAvIHNpemVvZiAodV9pbnQzMl90KV07CiAJc2N0
cF9jaHVua2hkcl90IHNjaDsKKworCWludCBpID0gMDsKIAogCWlmIChjaHVu
a19tYXRjaF90eXBlID09IFNDVFBfQ0hVTktfTUFUQ0hfQUxMKSB7CiAJCVND
VFBfQ0hVTktNQVBfQ09QWShjaHVua21hcGNvcHksIGNodW5rbWFwKTsK

--0-1576328809-1079320013=:50564--
