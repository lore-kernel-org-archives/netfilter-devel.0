From: "Maciej Soltysiak" <solt@dns.toxicfilms.tv>
Subject: Full cvs access?
Date: Mon, 16 Feb 2004 14:27:18 +0100
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <003501c3f490$9a1ebec0$0e25fe96@pysiak>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="iso-8859-2"
Content-Transfer-Encoding: 7bit
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: <netfilter-devel@lists.netfilter.org>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

Hi,

it has been a while since I was syncing to cvs. I noticed that the method
to access cvs that is on the website:

    cvs -d :pserver:cvs:cvs@pserver.netfilter.org:/cvspublic co netfilter

checks out only homepage,patch-o-matic,patch-o-matic_2.5 and testsuite.

When I try to access pom-ng for example:

    cvs -d :pserver:cvs:cvs@pserver.netfilter.org:/cvspublic co
netfilter/patch-o-matic-ng

It says:
cvs server: warning: new-born netfilter/patch-o-matic-ng has disappeared

How do I access the cvs tree including the sources and pom-ng and the
homepage?
(Maybe I have some data cached and cvs freaks out?)

Regards,
Maciej
