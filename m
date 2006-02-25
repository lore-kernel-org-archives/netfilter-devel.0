From: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Subject: Re: problem with ipset and 2.4.31, again...
Date: Sat, 25 Feb 2006 09:36:35 +0100 (CET)
Message-ID: <Pine.LNX.4.58.0602250924060.13768@blackhole.kfki.hu>
References: <20060224111012.GA26233@packetconsulting.pl>
	<Pine.LNX.4.58.0602241409590.10263@blackhole.kfki.hu>
	<20060224143251.GA27210@packetconsulting.pl>
Mime-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="110391808-633974216-1140856595=:13768"
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Piotr Chytla <pch@packetconsulting.pl>
In-Reply-To: <20060224143251.GA27210@packetconsulting.pl>
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
  Send mail to mime@docserver.cac.washington.edu for more info.

--110391808-633974216-1140856595=:13768
Content-Type: TEXT/PLAIN; charset=US-ASCII

Hi,

On Fri, 24 Feb 2006, Piotr Chytla wrote:

> On Fri, Feb 24, 2006 at 02:15:37PM +0100, Jozsef Kadlecsik wrote:
> > > ipset from patch-o-matic-ng(r6345) fails to compile on 2.4.31/32, Problem and
> > > solution is the same as this :
> >
> > We are at rev 6470 in p-o-m-ng, I think you are using a too old release.
> >
> Sorry my mistake, It wasn't rev 6345, I'm using ftp snapshot
> patch-o-matic-ng-20060222.

You are right, the lock definition relied on lockhelp.h. Instead of
putting back the lockhelp.h dependency, the attached patch removes it
completely from the 2.4.* branch of the patch. It has been commited
in svn as well. Thank you for letting me about the problem.

Best regards,
Jozsef
-
E-mail  : kadlec@blackhole.kfki.hu, kadlec@sunserv.kfki.hu
PGP key : http://www.kfki.hu/~kadlec/pgp_public_key.txt
Address : KFKI Research Institute for Particle and Nuclear Physics
          H-1525 Budapest 114, POB. 49, Hungary
--110391808-633974216-1140856595=:13768
Content-Type: TEXT/PLAIN; charset=US-ASCII;
	name="ipset-2.4-debug-lockhelp.patch"
Content-Transfer-Encoding: BASE64
Content-ID: <Pine.LNX.4.58.0602250936350.13768@blackhole.kfki.hu>
Content-Description: ipset-2.4-debug-lockhelp.patch
Content-Disposition: attachment; filename="ipset-2.4-debug-lockhelp.patch"

LS0tIGxpbnV4LWxvY2toZWxwL25ldC9pcHY0L25ldGZpbHRlci9pcF9zZXQu
YwkyMDA1LTEwLTI4IDE3OjM5OjMzLjAwMDAwMDAwMCArMDIwMA0KKysrIGxp
bnV4L25ldC9pcHY0L25ldGZpbHRlci9pcF9zZXQuYwkyMDA2LTAyLTI1IDA4
OjU0OjM5LjAwMDAwMDAwMCArMDEwMA0KQEAgLTMyLDcgKzMyLDcgQEANCiAN
CiBzdGF0aWMgc3RydWN0IGxpc3RfaGVhZCBzZXRfdHlwZV9saXN0OwkJLyog
YWxsIHJlZ2lzdGVyZWQgc2V0cyAqLw0KIHN0YXRpYyBzdHJ1Y3QgaXBfc2V0
ICoqaXBfc2V0X2xpc3Q7CQkvKiBhbGwgaW5kaXZpZHVhbCBzZXRzICovDQot
c3RhdGljIERFQ0xBUkVfUldMT0NLKGlwX3NldF9sb2NrKTsJCS8qIHByb3Rl
Y3RzIHRoZSBsaXN0cyBhbmQgdGhlIGhhc2ggKi8NCitzdGF0aWMgcndsb2Nr
X3QgaXBfc2V0X2xvY2sgPSBSV19MT0NLX1VOTE9DS0VEOwkvKiBwcm90ZWN0
cyB0aGUgbGlzdHMgYW5kIHRoZSBoYXNoICovDQogc3RhdGljIERFQ0xBUkVf
TVVURVgoaXBfc2V0X2FwcF9tdXRleCk7CQkvKiBzZXJpYWxpemVzIHVzZXIg
YWNjZXNzICovDQogc3RhdGljIGlwX3NldF9pZF90IGlwX3NldF9tYXggPSBD
T05GSUdfSVBfTkZfU0VUX01BWDsNCiBzdGF0aWMgaXBfc2V0X2lkX3QgaXBf
c2V0X2JpbmRpbmdzX2hhc2hfc2l6ZSA9ICBDT05GSUdfSVBfTkZfU0VUX0hB
U0hTSVpFOw0K

--110391808-633974216-1140856595=:13768--
