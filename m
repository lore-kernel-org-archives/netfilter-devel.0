From: Chris Wilson <chris@netservers.co.uk>
Subject: Re: [RFC] CONNMARK getsockopt/setsockopt functionality
Date: Mon, 24 May 2004 12:17:23 +0100 (BST)
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <Pine.LNX.4.58.0405241212230.27895@chris.camcom.co.uk>
References: <1085125075.1782.36.camel@nienna.balabit>
Mime-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="-1463779581-1502270304-1085397443=:27895"
Cc: netfilter-devel <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: KOVACS Krisztian <hidden@balabit.hu>
In-Reply-To: <1085125075.1782.36.camel@nienna.balabit>
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

---1463779581-1502270304-1085397443=:27895
Content-Type: TEXT/PLAIN; charset=US-ASCII

Hi Krisztian,

>   I've created a patch for connmark, which registers a getsockopt() and
> a setsockopt() function for getting/setting the connection mark. The
> patch is for Linux 2.4.25 + CONNMARK from POM-ng, but theoretically it
> should apply on any 2.4.x version plus the newest connmark patch.

I think I found a small problem with this patch. I'm using 2.4.26 plus 
latest CVS POM-ng, and after patching with your patch, the kernel doesn't 
compile.

This is because after patching, ip_conntrack_core.c contains a 
new function get_sk_proto(struct sock *sk) which checks sk->proto->name, 
but sk doesn't have an member "proto". It does have a member "prot", and 
when I change proto to prot, the kernel compiles again (but as yet I 
have no idea whether your patch actually works :-).

Patch to your patch is attached.

Cheers, Chris.
-- 
_  __ __     _
 / __/ / ,__(_)_  | Chris Wilson -- UNIX Firewall Lead Developer |
/ (_  ,\/ _/ /_ \ | NetServers.co.uk http://www.netservers.co.uk |
\__/_/_/_//_/___/ | 21 Signet Court, Cambridge, UK. 01223 576516 |
---1463779581-1502270304-1085397443=:27895
Content-Type: TEXT/PLAIN; charset=US-ASCII; name="connmark_sockopt.patch.patch"
Content-Transfer-Encoding: BASE64
Content-ID: <Pine.LNX.4.58.0405241217231.27895@chris.camcom.co.uk>
Content-Description: 
Content-Disposition: attachment; filename="connmark_sockopt.patch.patch"

SW5kZXg6IC4uL2xvY2FsL2Nvbm5tYXJrX3NvY2tvcHQucGF0Y2gNCj09PT09
PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09
PT09PT09PT09PT09PT09PT0NCi0tLSAuLi9sb2NhbC9jb25ubWFya19zb2Nr
b3B0LnBhdGNoCShyZXZpc2lvbiA0MzI4KQ0KKysrIC4uL2xvY2FsL2Nvbm5t
YXJrX3NvY2tvcHQucGF0Y2gJKHdvcmtpbmcgY29weSkNCkBAIC02Nyw5ICs2
Nyw5IEBADQogK3N0YXRpYyBpbnQNCiArZ2V0X3NrX3Byb3RvKHN0cnVjdCBz
b2NrICpzaykNCiArew0KLSsJaWYgKHN0cmNtcChzay0+cHJvdG8tPm5hbWUs
ICJUQ1AiKSA9PSAwKQ0KKysJaWYgKHN0cmNtcChzay0+cHJvdC0+bmFtZSwg
IlRDUCIpID09IDApDQogKwkJcmV0dXJuIElQUFJPVE9fVENQOw0KLSsJZWxz
ZSBpZiAoc3RyY21wKHNrLT5wcm90by0+bmFtZSwgIlVEUCIpID09IDApDQor
KwllbHNlIGlmIChzdHJjbXAoc2stPnByb3QtPm5hbWUsICJVRFAiKSA9PSAw
KQ0KICsJCXJldHVybiBJUFBST1RPX1VEUDsNCiArCWVsc2UNCiArCQlyZXR1
cm4gMDsNCg==

---1463779581-1502270304-1085397443=:27895--
