From: Pablo Neira Ayuso <pablo@eurodev.net>
Subject: Re: iptables 1.3.4 kernel 2.4.31 string match
Date: Mon, 02 Jan 2006 15:12:57 +0100
Message-ID: <43B934E9.2000601@eurodev.net>
References: <007a01c60f31$8f1eeaa0$102a2a0a@rjk>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="------------090407000200020909020502"
Cc: Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: "K. Jay Rogozinsky" <et.jayr@shaw.ca>
In-Reply-To: <007a01c60f31$8f1eeaa0$102a2a0a@rjk>
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

This is a multi-part message in MIME format.
--------------090407000200020909020502
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit

Hi,

K. Jay Rogozinsky wrote:
> I am hoping contacting you directly is not inappropriate.

No problem. I've cc'ed the reply to netfilter-devel for the record. It
could be useful for others.

> As I understand, iptables 1.3.4 *can* use the kernel string matching
> available starting in kernel 2.6.14.
> 
> However, we are using kernel 2.4.31 (which iptables 1.3.4 doc says is OK).

So, I updated the manpage. Attached a patch that applies to netfilter SVN.

> However, according to our "compile guy" (Thomas):
> 
> "iptables 1.3.4 does not compile when I have strings matching.  That is, the
> string match patch does something that makes iptables 1.3.4 not compile."

iptables doesn't compile the string match if it's not present in the
current kernel, eg. if you compile iptables against a linux kernel <=
2.6.14, the string match won't be compiled.

> So, given that we continue to use kernel 2.4.31, is their any applicable
> patch or approach;  We would like to use our kernel (2.4.31) with iptables
> 1.3.4 and still have string matching.

There's no backport available. The only existing way to add support for
string matching is upgrading your kernel at the moment.

-- 
Pablo

--------------090407000200020909020502
Content-Type: text/plain;
 name="man.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="man.patch"

Index: trunk/iptables/extensions/libipt_string.man
===================================================================
--- /dev/null	1970-01-01 00:00:00.000000000 +0000
+++ trunk/iptables/extensions/libipt_string.man	2006-01-02 13:35:56.000000000 +0100
@@ -0,0 +1,15 @@
+This modules matches a given string by using some pattern matching strategy. It requires a linux kernel >= 2.6.14.
+.TP
+.BI "--algo  " "bm|kmp"
+Select the pattern matching strategy. (bm = Boyer-Moore, kmp = Knuth-Pratt-Morris)
+.TP
+.BI "--from " "offset"
+Set the offset from which it starts looking for any matching. If not passed, default is 0.
+.TP
+.BI "--to " "offset"
+Set the offset from which it starts looking for any matching. If not passed, default is the packet size.
+.TP
+.BI "--string " "pattern"
+Matches the given pattern.
+.BI "--hex-string " "pattern"
+Matches the given pattern in hex notation.

--------------090407000200020909020502--
