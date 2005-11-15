From: Pablo Neira <pablo@eurodev.net>
Subject: Bug#327007: BUG: iptables -j does not work for chains with a length >=28 (was moe infos...)
Date: Tue, 15 Nov 2005 18:46:59 +0100
Message-ID: <437A1F13.5080305@eurodev.net>
References: <200511150139.51688.bernd@zeimetz.de> <200511151715.32138.bernd@zeimetz.de>
Reply-To: Pablo Neira <pablo@eurodev.net>, 327007@bugs.debian.org
Mime-Version: 1.0
Content-Type: multipart/mixed;
 boundary="------------010003090000030909050904"
Cc: netfilter-devel@lists.netfilter.org, 327007@bugs.debian.org
Return-path: <bounce-debian-bugs-dist=glddb-debian-bugs-dist=m.gmane.org@lists.debian.org>
Resent-Message-ID: <handler.327007.B327007.11320768653876@bugs.debian.org>
To: Bernd Zeimetz <bernd@zeimetz.de>
In-Reply-To: <200511151715.32138.bernd@zeimetz.de>
List-Post: <mailto:debian-bugs-dist@lists.debian.org>
List-Help: <mailto:debian-bugs-dist-request@lists.debian.org?subject=help>
List-Subscribe: <mailto:debian-bugs-dist-request@lists.debian.org?subject=subscribe>
List-Unsubscribe: <mailto:debian-bugs-dist-request@lists.debian.org?subject=unsubscribe>
List-Id: netfilter-devel.vger.kernel.org

This is a multi-part message in MIME format.
--------------010003090000030909050904
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit

Bernd Zeimetz wrote:
> Hi,
> 
> 
>>As you can see the bug does not happen for chains
>>- with a length <=28
>>- with a name containing only numbers
>>- with a name beginning with numbers and having less than ~11 letters at
>>the end.
> 
> 
> this is - of course - not true. I didn't realize that
> 
> 
>>iptables -N 123456789012345678yzabcdefgh
>>and this works:
>>iptables -A FORWARD -j 123456789012345678yzabcdefghij
> 
> 
> this happened pretty often while testing.
> 
> 
>>set_revision(target->t->u.user.name, target->revision); // iptables.c:2397
> 
> What does set_revision really do? Is it still needed?

This was included to add support for match/target revisions without
breaking backward compatibility.

The patch attached fixes the problem that you're reporting here. I tried
with the shell script attached and seems to work fine. I'll pass it to
Harald.

-- 
Pablo

--------------010003090000030909050904
Content-Type: text/plain;
 name="x"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="x"

Index: iptables.c
===================================================================
--- iptables.c	(revision 4511)
+++ iptables.c	(working copy)
@@ -2394,7 +2396,9 @@
 			target->t = fw_calloc(1, size);
 			target->t->u.target_size = size;
 			strcpy(target->t->u.user.name, jumpto);
-			set_revision(target->t->u.user.name, target->revision);
+			if (!iptc_is_chain(jumpto, *handle))
+				set_revision(target->t->u.user.name,
+					     target->revision);
 			if (target->init != NULL)
 				target->init(target->t, &fw.nfcache);
 		}

--------------010003090000030909050904
Content-Type: text/x-sh;
 name="test.sh"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="test.sh"

 iptables -N 123456789012345678901234567
 iptables -A FORWARD -j 123456789012345678901234567
 iptables -N 1234567890123456789012345678
 iptables -A FORWARD -j 1234567890123456789012345678
 iptables -N 12345678901234567890123456789
 iptables -A FORWARD -j 12345678901234567890123456789
 iptables -N 12345678901234567890abcdefg
 iptables -A FORWARD -j 12345678901234567890abcdefg
 iptables -N 12345678901234567890abcdefgh
 iptables -A FORWARD -j 12345678901234567890abcdefgh
 iptables -N 12345678901234567890abcdefghi
 iptables -A FORWARD -j 12345678901234567890abcdefghi
 iptables -N 12345678901234567890abcdefghij
 iptables -A FORWARD -j 12345678901234567890abcdefghij
 iptables -N 1234567890123456789zabcdefghij
 iptables -A FORWARD -j 1234567890123456789zabcdefghij
 iptables -N abcde678901234567890abcdefghij
 iptables -A FORWARD -j abcde678901234567890abcdefghij
 iptables -N abcdesdasdasdfafasfaabcdefghij
 iptables -A FORWARD -j abcdesdasdasdfafasfaabcdefghij
 iptables -N 0bcdesdasdasdfafasfaabcdefghij
 iptables -A FORWARD -j 0bcdesdasdasdfafasfaabcdefghij
 iptables -N 0bcdesdasdasdfafasfaabcdefghi
 iptables -A FORWARD -j 0bcdesdasdasdfafasfaabcdefghi
 iptables -N 0bcdesdasdasdfafasfaabcdefgh
 iptables -A FORWARD -j 0bcdesdasdasdfafasfaabcdefgh




--------------010003090000030909050904--
