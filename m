From: Brad Fisher <brad@info-link.net>
Subject: [PATCH] pom-ng patchlet to add 'goto' type jumps
Date: Wed, 12 May 2004 16:49:20 -0500
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <40A29BE0.2DF2A0D6@info-link.net>
Mime-Version: 1.0
Content-Type: multipart/mixed;
 boundary="------------B322CE09283A1199D625C98E"
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
--------------B322CE09283A1199D625C98E
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit

Attached is a tar file containing a pom-ng version of a patch written by

Henrik Nordstrom to add a 'goto' style jump.  It should work for 2.4
kernels fine.
Haven't tested/ported to 2.6, but will hopefully get a chance soon.

Simply extract the file at the pom-ng base dir and it should create the
goto/ dir structure.

Please let me know if it is/is'nt acceptable for pom inclusion.  I'd
like to see it included someday...

-Brad Fisher

--------------B322CE09283A1199D625C98E
Content-Type: application/x-unknown-content-type-WinRAR;
 name="goto-pom-ng.tgz"
Content-Transfer-Encoding: base64
Content-Disposition: inline;
 filename="goto-pom-ng.tgz"

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
3o27cTfuxt24G/9349/StdPDACgAAA==
--------------B322CE09283A1199D625C98E--
