From: Robert de Bath <list-netfilter@debath.co.uk>
Subject: Re: Bug Report: IPtables 1.2.* segfaulted by iptables 1.3.* [PATCH]
Date: Sat, 30 Jul 2005 08:12:31 +0100 (BST)
Message-ID: <df9eaa1431a9e102@mayday.cix.co.uk>
References: <9927912d05072704113d7e8707@mail.gmail.com>
	<e756d62eb5442015@mayday.cix.co.uk>
	<20050729105834.GD7063@rama.de.gnumonks.org>
Mime-Version: 1.0
Content-Type: MULTIPART/MIXED;
	BOUNDARY="-1463809397-1106440432-1122707551=:3746"
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Harald Welte <laforge@netfilter.org>
In-Reply-To: <20050729105834.GD7063@rama.de.gnumonks.org>
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

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

---1463809397-1106440432-1122707551=:3746
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed

On Fri, 29 Jul 2005, Harald Welte wrote:

> On Thu, Jul 28, 2005 at 11:53:49AM +0100, Robert de Bath wrote:
>> Hi all,
>> I've been mixing iptables 1.2.8/1.2.11 and 1.3.1/2 tools and unlike I would

> other issues with this as well (one has been added to INCOMPATIBILITIES
> recently).
Yup, spotted that but nfcache is per entry so it doesn't break _this_.

> If the fix is non-intrusive and doesn't reaquire a lot of additional
> computational complexity, I would accept such a patch.  Otherwise I
> don't really think it's worth supporting such a setup.  Usually you have
> one version of iptables installed, not multiple.

<grin> The change was a _lot_ easier than I thought, looks like it's a
real bug too. [attached]

-- 
Rob.                          (Robert de Bath <robert$ @ debath.co.uk>)
                                              <http://www.debath.co.uk/>

---1463809397-1106440432-1122707551=:3746
Content-Type: TEXT/PLAIN; charset=US-ASCII; name=dif
Content-Transfer-Encoding: BASE64
Content-ID: <Pine.LNX.4.61.0507300812310.3746@mayday.local>
Content-Description: 
Content-Disposition: attachment; filename=dif

LS0tIGxpYmlwdGMvbGliaXB0Yy5jLm9yaWcJMjAwNS0wNy0xOSAyMzowMzo0
OS4wMDAwMDAwMDAgKzAxMDANCisrKyBsaWJpcHRjL2xpYmlwdGMuYwkyMDA1
LTA3LTMwIDA3OjU5OjA2LjMxMjIzODY0NCArMDEwMA0KQEAgLTM5OSw3ICsz
OTksNyBAQA0KIAkvKiBzb3J0IG9ubHkgdXNlciBkZWZpbmVkIGNoYWlucyAq
Lw0KIAlpZiAoIWMtPmhvb2tudW0pIHsNCiAJCWxpc3RfZm9yX2VhY2hfZW50
cnkodG1wLCAmaC0+Y2hhaW5zLCBsaXN0KSB7DQotCQkJaWYgKHN0cmNtcChj
LT5uYW1lLCB0bXAtPm5hbWUpIDw9IDApIHsNCisJCQlpZiAoIXRtcC0+aG9v
a251bSAmJiBzdHJjbXAoYy0+bmFtZSwgdG1wLT5uYW1lKSA8PSAwKSB7DQog
CQkJCWxpc3RfYWRkKCZjLT5saXN0LCB0bXAtPmxpc3QucHJldik7DQogCQkJ
CXJldHVybjsNCiAJCQl9DQo=

---1463809397-1106440432-1122707551=:3746--
