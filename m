From: Brad Fisher <brad@info-link.net>
Subject: [PATCH] comment match port to pom-ng
Date: Wed, 12 May 2004 16:43:25 -0500
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <40A29A7D.A1111933@info-link.net>
Mime-Version: 1.0
Content-Type: multipart/mixed;
 boundary="------------5AB58550973E15B5F60DEA3F"
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: netfilter-devel@lists.netfilter.org
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

This is a multi-part message in MIME format.
--------------5AB58550973E15B5F60DEA3F
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit

Attached is a tar file containing the comment match I wrote a while back
(Also posted before for old POM with no response:
http://marc.theaimsgroup.com/?l=netfilter-devel&m=107056927528485&w=2).
I've ported it to pom-ng, and it should work for 2.4 kernels fine.
Haven't tested 2.6 kernels, but will hopefully get a chance soon.

Simply extract the file at the pom-ng base dir and it should create the
comment/ dir structure.  For this patch to apply properly, you must
first apply the pom-ng patch I submitted to this list earlier today,
otherwise you'll end up with a half-patched kernel/userspace.

Please let me know if it is/is'nt acceptable for pom inclusion.  I'd
like to see it included someday...

-Brad Fisher

--------------5AB58550973E15B5F60DEA3F
Content-Type: application/x-unknown-content-type-WinRAR;
 name="comment-pom-ng.tgz"
Content-Transfer-Encoding: base64
Content-Disposition: inline;
 filename="comment-pom-ng.tgz"

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
/OXxfzAAlyAAeAAA
--------------5AB58550973E15B5F60DEA3F--
