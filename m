From: Patrick McHardy <kaber@trash.net>
Subject: Re: [PATCH] Minor fix for patchlets which modify multiple projects
Date: Thu, 13 May 2004 05:02:04 +0200
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <40A2E52C.3010103@trash.net>
References: <40A2754C.F4AA6CEF@info-link.net>
Mime-Version: 1.0
Content-Type: multipart/mixed;
 boundary="------------090007030609020601080908"
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Brad Fisher <brad@info-link.net>
In-Reply-To: <40A2754C.F4AA6CEF@info-link.net>
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
--------------090007030609020601080908
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit

Brad Fisher wrote:

>While converting a match of mine to pom-ng, I noticed that
>apply_patchlet doesn't properly determine the list of projects which are
>affected by the patchlet.  In my case, the patch would be incompletely
>applied - the kernel space part would apply, but the userspace part
>would not.  The following patch (agains pom-ng cvs) should fix this.
>-Brad Fisher
>

Thanks Brad, I've applied a small variation of this, because I don't know if
perl will complain about two equally named variables (@projects and %projects)
with warnings turned on.

Regards
Patrick




--------------090007030609020601080908
Content-Type: text/plain;
 name="y"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="y"

Index: Netfilter_POM.pm
===================================================================
RCS file: /cvsroot/patch-o-matic-ng/Netfilter_POM.pm,v
retrieving revision 1.26
diff -u -r1.26 Netfilter_POM.pm
--- Netfilter_POM.pm	11 May 2004 13:53:13 -0000	1.26
+++ Netfilter_POM.pm	13 May 2004 02:57:05 -0000
@@ -852,9 +852,11 @@
 	my(@projects);
 
 	# print Dumper($patchlet);
-	@projects = keys %{{ keys %{$patchlet->{files}}, 
-			     keys %{$patchlet->{patch}},
-			     keys %{$patchlet->{ladds}} }};
+	foreach my $p ( keys %{$patchlet->{files}},
+	                keys %{$patchlet->{patch}},
+			keys %{$patchlet->{ladds}} ) {
+		push @projects, $p;
+	}
 
 	foreach my $proj (@projects) {
 		return 0 unless ($self->apply_newfiles($patchlet, $proj, $revert, $test, $copy)

--------------090007030609020601080908--
