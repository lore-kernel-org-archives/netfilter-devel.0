From: syrius.ml@no-log.org
Subject: pom-ng:runme  : ignore case
Date: Wed, 28 Apr 2004 17:30:20 +0200
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <87ad0wrvhs.878yggrvhs@877jw0rvhs.message.id>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Netfilter Developers List <netfilter-devel@lists.netfilter.org>
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

I think it would be better to ignore the case of the answer.

<patch>
--- runme.orig  2004-04-28 17:04:33.000000000 +0200
+++ runme       2004-04-28 17:12:26.000000000 +0200
@@ -289,6 +289,7 @@
                    $key = <STDIN>;
                }
                chomp($key);
+               $key=lc($key);
                if ($key eq 'y') {
                        my $ret = Netfilter_POM::dependencies_fulfilled($plets,
                                                                $plname);
</patch>

BTW, something seems weird.
I'm trying pom-ng on a 2.6.6-rc3 (kernel version shouldn't be important)
runme shows that nf-log is already applied and cstat is not in the
list of applied patches. When I try to apply tcp-window-tracking, it
says "present 'ctstat' conflicts with to-be-installed
'tcp-window-tracking'"
The point is that runme doesn't see ctstat installed but says it's
present.
If I remove !cstats from tcp-window-tracking's info file, it says
"apply_dependencies: unable to apply dependent nf-log:" but nf-log is
already listed as applied...

-- 
