From: Thomas Jarosch <thomas.jarosch@intra2net.com>
Subject: Re: [patch] conntrack tool: Fix loading of protocol helpers
Date: Fri, 16 Mar 2007 20:15:52 +0100
Message-ID: <20070316201552.ugc8wof8g5twc0c0@intranator.m.i2n>
References: <200703161751.08498.thomas.jarosch@intra2net.com>
	<45FACE99.5070702@netfilter.org>
Mime-Version: 1.0
Content-Type: multipart/mixed;
	boundary="=_f2cxu0bx0q0"
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@lists.netfilter.org
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
In-Reply-To: <45FACE99.5070702@netfilter.org>
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

This message is in MIME format.

--=_f2cxu0bx0q0
Content-Type: text/plain;
	charset=ISO-8859-1;
	DelSp="Yes";
	format="flowed"
Content-Disposition: inline
Content-Transfer-Encoding: 7bit

Hello Pablo,

>> Does anyone have a short example how to use the -G functionality of the tool?
>
> Have a look at the script called test.sh under SVN, you can find one there.

Thanks, that's exactly what I've searched for. I didn't notice it because it's called "test.sh". What about the attached patch for the manual page? ;-)

Cheers,
Thomas


--=_f2cxu0bx0q0
Content-Type: text/x-diff; charset=ISO-8859-1;
	name="conntrack-man-mention-usage.patch"
Content-Disposition: attachment; filename="conntrack-man-mention-usage.patch"
Content-Transfer-Encoding: 7bit

--- conntrack.8	Mon Dec 26 03:49:34 2005
+++ conntrack.new	Fri Mar 16 20:12:31 2007
@@ -127,6 +127,8 @@
 The exit code is 0 for correct function.  Errors which appear to be caused by
 invalid command line parameters cause an exit code of 2.  Any other errors
 cause an exit code of 1.
+.SH EXAMPLE USAGE
+See the included test.sh script for a extensive usage example.
 .SH BUGS
 Bugs? What's this ;-)
 .SH SEE ALSO

--=_f2cxu0bx0q0--
