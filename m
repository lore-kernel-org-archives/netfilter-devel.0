From: Brad Fisher <brad@info-link.net>
Subject: [PATCH] Minor fix for patchlets which modify multiple projects
Date: Wed, 12 May 2004 14:04:44 -0500
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <40A2754C.F4AA6CEF@info-link.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
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

While converting a match of mine to pom-ng, I noticed that
apply_patchlet doesn't properly determine the list of projects which are
affected by the patchlet.  In my case, the patch would be incompletely
applied - the kernel space part would apply, but the userspace part
would not.  The following patch (agains pom-ng cvs) should fix this.
-Brad Fisher

Index: Netfilter_POM.pm
===================================================================
RCS file: /cvspublic/patch-o-matic-ng/Netfilter_POM.pm,v
retrieving revision 1.26
diff -u -r1.26 Netfilter_POM.pm
--- Netfilter_POM.pm    11 May 2004 13:53:13 -0000      1.26
+++ Netfilter_POM.pm    12 May 2004 19:02:22 -0000
@@ -852,9 +852,11 @@
        my(@projects);

        # print Dumper($patchlet);
-       @projects = keys %{{ keys %{$patchlet->{files}},
-                            keys %{$patchlet->{patch}},
-                            keys %{$patchlet->{ladds}} }};
+       my %projects = ( );
+       foreach my $p ( keys %{$patchlet->{files}}, keys
%{$patchlet->{patch}}, keys %{$patchlet->{ladds}}) {
+               $projects{$p} = 1;
+       }
+       @projects = keys %projects;

        foreach my $proj (@projects) {
                return 0 unless ($self->apply_newfiles($patchlet, $proj,
$revert, $test, $copy)
