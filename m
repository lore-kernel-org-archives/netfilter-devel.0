From: Ari Sundholm <megari@freedb.org>
Subject: Kernel panic still happens due to bug in connlimit on kernel 2.6.11
Date: Sun, 05 Jun 2005 14:54:33 +0300
Message-ID: <1117972473.11871.17.camel@megaricomp>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: netfilter-devel@lists.netfilter.org
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

Hello!

(Please CC me as I am not subscribed)

I recently ran into kernel panics with my shiny new 2.6.11 kernel. After
a lot of grief I found out that the connlimit module used to have a bug
which lead into an inevitable NULL pointer dereference and a panic.
After removing all iptables rules using connlimit and rebooting I got no
further panics during 48 hours - the kernel would panic in less than 10
hours when the rules were still there. This was highly suggestive that
there was still something wrong. And indeed, there was: the original
problem was never fixed!

I found out that a patch had been discussed and apparently found good
(on May 19). Someone was supposed to commit the patch. However, it seems
the patch was never committed - I took a look at the SVN trunk for
pom-ng today.

Please fix this at your earliest convenience.

Best regards,

Ari Sundholm
megari@freedb.org
Author of cddbcomp - THE Delphi component for freedb access
Moderator of freedb forums
freedb core team
Support languages: Finnish, English, German, Swedish
DISCLAIMER: Despite being part of the freedb team I only represent myself unless otherwise noted. Freedb is in no way responsible for my actions or opinions.
