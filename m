From: Stephane Ouellette <ouellettes@videotron.ca>
Subject: [PATCH][TRIVIAL]  Non-existent option in runme script
Date: Sat, 09 Aug 2003 14:02:54 -0400
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <3F35374E.6020708@videotron.ca>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="Boundary_(ID_8yuw6GZRcLbP4ToIg4+7wg)"
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Harald Welte <laforge@netfilter.org>
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

--Boundary_(ID_8yuw6GZRcLbP4ToIg4+7wg)
Content-type: text/plain; charset=us-ascii; format=flowed
Content-transfer-encoding: 7BIT

Harald,

    the following patch removes a non-existent option on the prompt of 
the "runme" script in P-O-M.

Stephane


--Boundary_(ID_8yuw6GZRcLbP4ToIg4+7wg)
Content-type: text/plain; name=runme.patch; CHARSET=US-ASCII
Content-transfer-encoding: 7BIT
Content-disposition: inline; filename=runme.patch

--- netfilter/patch-o-matic/runme	Sat Aug  9 13:55:57 2003
+++ netfilter-fixed/patch-o-matic/runme	Sat Aug  9 13:56:23 2003
@@ -813,7 +813,7 @@
 		while [ "$ANSWER" = "" ]
 		do
 		    echo "-----------------------------------------------------------------"
-		    echo -n "Do you want to `modesense 1` this patch "'[N/y/t/f/a/r/b/w/v/q/?] '
+		    echo -n "Do you want to `modesense 1` this patch "'[N/y/t/f/a/r/b/w/q/?] '
 		    read ANSWER
 		    case "$ANSWER" in 
 		        y*|Y*)

--Boundary_(ID_8yuw6GZRcLbP4ToIg4+7wg)--
