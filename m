From: Martijn Lievaart <netfilter-devel@rtij.nl>
Subject: [PATCH] Pom-ng: test return code from File::Copy
Date: Wed, 05 May 2004 21:34:08 +0200
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <409941B0.5040100@rtij.nl>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="=_ma.rtij.nl-28454-1083785649-0001-2"
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

This is a MIME-formatted message.  If you see this text it means that your
E-mail software does not support MIME-formatted messages.

--=_ma.rtij.nl-28454-1083785649-0001-2
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit

Hi,

Trying to work out how POM-ng works, I found a slight bug. The 
returncode from the File::Copy routine is not tested. Attached patch 
fixes that.

Cheers,
Martijn Lievaart


--=_ma.rtij.nl-28454-1083785649-0001-2
Content-Type: text/plain; name="file_copy_patch"; charset=iso-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="file_copy_patch"

--- patch-o-matic-ng/Netfilter_POM.pm	2004-05-05 12:24:04.000000000 +0200
+++ patch-o-matic-ng.new/Netfilter_POM.pm	2004-05-05 18:49:26.000000000 +0200
@@ -682,7 +683,10 @@
 						return 0;
 					}
 				}
-				File::Copy::copy($srcfile, $destfile);
+				if (!File::Copy::copy($srcfile, $destfile)) {
+					$self->{ERRMSG} .= "unable to copy $srcfile to $destfile: $!\n";
+					return 0;
+				}
 				# .foo-test is executable
 				chmod((stat($srcfile))[2] & 07777, $destfile);
 			} else {

--=_ma.rtij.nl-28454-1083785649-0001-2--
