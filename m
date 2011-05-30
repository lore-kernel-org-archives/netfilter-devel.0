From: Jan Engelhardt <jengelh@medozas.de>
Subject: [PATCH 4/5] doc: update GPL license text
Date: Mon, 30 May 2011 12:18:04 +0200
Message-ID: <1306750686-11595-5-git-send-email-jengelh@medozas.de>
References: <1306750686-11595-1-git-send-email-jengelh@medozas.de>
Cc: netfilter-devel@vger.kernel.org
To: kaber@trash.net
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from seven.medozas.de ([188.40.89.202]:49385 "EHLO seven.medozas.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755752Ab1E3KSN (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 30 May 2011 06:18:13 -0400
In-Reply-To: <1306750686-11595-1-git-send-email-jengelh@medozas.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

The Open Build Service/rpmlint flagged the outdated address in the
license text :-)

iptables.x86_64: W: incorrect-fsf-address
/usr/share/doc/packages/iptables/COPYING
The Free Software Foundation address in this file seems to be outdated
or misspelled.  Ask upstream to update the address, or if this is a
license file, possibly the entire file with a new copy available from
the FSF.

Signed-off-by: Jan Engelhardt <jengelh@medozas.de>
---
 COPYING |   42 +++++++++++++++++++++---------------------
 1 files changed, 21 insertions(+), 21 deletions(-)

diff --git a/COPYING b/COPYING
index a43ea21..d159169 100644
--- a/COPYING
+++ b/COPYING
@@ -1,12 +1,12 @@
-		    GNU GENERAL PUBLIC LICENSE
-		       Version 2, June 1991
+                    GNU GENERAL PUBLIC LICENSE
+                       Version 2, June 1991
 
- Copyright (C) 1989, 1991 Free Software Foundation, Inc.
-                          675 Mass Ave, Cambridge, MA 02139, USA
+ Copyright (C) 1989, 1991 Free Software Foundation, Inc.,
+ 51 Franklin Street, Fifth Floor, Boston, MA 02110-1301 USA
  Everyone is permitted to copy and distribute verbatim copies
  of this license document, but changing it is not allowed.
 
-			    Preamble
+                            Preamble
 
   The licenses for most software are designed to take away your
 freedom to share and change it.  By contrast, the GNU General Public
@@ -15,7 +15,7 @@ software--to make sure the software is free for all its users.  This
 General Public License applies to most of the Free Software
 Foundation's software and to any other program whose authors commit to
 using it.  (Some other Free Software Foundation software is covered by
-the GNU Library General Public License instead.)  You can apply it to
+the GNU Lesser General Public License instead.)  You can apply it to
 your programs, too.
 
   When we speak of free software, we are referring to freedom, not
@@ -55,8 +55,8 @@ patent must be licensed for everyone's free use or not licensed at all.
 
   The precise terms and conditions for copying, distribution and
 modification follow.
-

-		    GNU GENERAL PUBLIC LICENSE
+
+                    GNU GENERAL PUBLIC LICENSE
    TERMS AND CONDITIONS FOR COPYING, DISTRIBUTION AND MODIFICATION
 
   0. This License applies to any program or other work which contains
@@ -110,7 +110,7 @@ above, provided that you also meet all of these conditions:
     License.  (Exception: if the Program itself is interactive but
     does not normally print such an announcement, your work based on
     the Program is not required to print an announcement.)
-

+
 These requirements apply to the modified work as a whole.  If
 identifiable sections of that work are not derived from the Program,
 and can be reasonably considered independent and separate works in
@@ -168,7 +168,7 @@ access to copy from a designated place, then offering equivalent
 access to copy the source code from the same place counts as
 distribution of the source code, even though third parties are not
 compelled to copy the source along with the object code.
-

+
   4. You may not copy, modify, sublicense, or distribute the Program
 except as expressly provided under this License.  Any attempt
 otherwise to copy, modify, sublicense or distribute the Program is
@@ -225,7 +225,7 @@ impose that choice.
 
 This section is intended to make thoroughly clear what is believed to
 be a consequence of the rest of this License.
-

+
   8. If the distribution and/or use of the Program is restricted in
 certain countries either by patents or by copyrighted interfaces, the
 original copyright holder who places the Program under this License
@@ -255,7 +255,7 @@ make exceptions for this.  Our decision will be guided by the two goals
 of preserving the free status of all derivatives of our free software and
 of promoting the sharing and reuse of software generally.
 
-			    NO WARRANTY
+                            NO WARRANTY
 
   11. BECAUSE THE PROGRAM IS LICENSED FREE OF CHARGE, THERE IS NO WARRANTY
 FOR THE PROGRAM, TO THE EXTENT PERMITTED BY APPLICABLE LAW.  EXCEPT WHEN
@@ -277,9 +277,9 @@ YOU OR THIRD PARTIES OR A FAILURE OF THE PROGRAM TO OPERATE WITH ANY OTHER
 PROGRAMS), EVEN IF SUCH HOLDER OR OTHER PARTY HAS BEEN ADVISED OF THE
 POSSIBILITY OF SUCH DAMAGES.
 
-		     END OF TERMS AND CONDITIONS
-

-	Appendix: How to Apply These Terms to Your New Programs
+                     END OF TERMS AND CONDITIONS
+
+            How to Apply These Terms to Your New Programs
 
   If you develop a new program, and you want it to be of the greatest
 possible use to the public, the best way to achieve this is to make it
@@ -291,7 +291,7 @@ convey the exclusion of warranty; and each file should have at least
 the "copyright" line and a pointer to where the full notice is found.
 
     <one line to give the program's name and a brief idea of what it does.>
-    Copyright (C) 19yy  <name of author>
+    Copyright (C) <year>  <name of author>
 
     This program is free software; you can redistribute it and/or modify
     it under the terms of the GNU General Public License as published by
@@ -303,16 +303,16 @@ the "copyright" line and a pointer to where the full notice is found.
     MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
     GNU General Public License for more details.
 
-    You should have received a copy of the GNU General Public License
-    along with this program; if not, write to the Free Software
-    Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139, USA.
+    You should have received a copy of the GNU General Public License along
+    with this program; if not, write to the Free Software Foundation, Inc.,
+    51 Franklin Street, Fifth Floor, Boston, MA 02110-1301 USA.
 
 Also add information on how to contact you by electronic and paper mail.
 
 If the program is interactive, make it output a short notice like this
 when it starts in an interactive mode:
 
-    Gnomovision version 69, Copyright (C) 19yy name of author
+    Gnomovision version 69, Copyright (C) year name of author
     Gnomovision comes with ABSOLUTELY NO WARRANTY; for details type `show w'.
     This is free software, and you are welcome to redistribute it
     under certain conditions; type `show c' for details.
@@ -335,5 +335,5 @@ necessary.  Here is a sample; alter the names:
 This General Public License does not permit incorporating your program into
 proprietary programs.  If your program is a subroutine library, you may
 consider it more useful to permit linking proprietary applications with the
-library.  If this is what you want to do, use the GNU Library General
+library.  If this is what you want to do, use the GNU Lesser General
 Public License instead of this License.
-- 
1.7.3.4

