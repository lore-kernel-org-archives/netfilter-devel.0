From: Stephane Ouellette <ouellettes@videotron.ca>
Subject: [PATCH]  Re: [PATCH]  libipt_string.c issue with save()
Date: Sun, 27 Apr 2003 11:56:18 -0400
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <3EABFDA2.3030602@videotron.ca>
References: <3EA46781.6010000@videotron.ca>
 <20030427125514.GE990@sunbeam.de.gnumonks.org>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="Boundary_(ID_KuZ0g2Q1cC4n64IaIc2MOA)"
Cc: netfilter-devel <netfilter-devel@lists.netfilter.org>
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

--Boundary_(ID_KuZ0g2Q1cC4n64IaIc2MOA)
Content-type: text/plain; charset=us-ascii; format=flowed
Content-transfer-encoding: 7BIT

Harald Welte wrote:

>On Mon, Apr 21, 2003 at 05:49:53PM -0400, Stephane Ouellette wrote:
>  
>
>>Folks,
>>
>>  the attached patch contains the following modifications:
>>    
>>
>
>thanks, applied
>
>  
>
Harald,

   I noticed that you applied the first patch I sent you, it contains a 
typo.  The attached patch fixes the error in question.
The error was introduced by hitting the "undo" key in my editor.

Stephane.



--Boundary_(ID_KuZ0g2Q1cC4n64IaIc2MOA)
Content-type: text/plain; name=libipt_string.c.patch; CHARSET=US-ASCII
Content-transfer-encoding: 7BIT
Content-disposition: inline; filename=libipt_string.c.patch

--- netfilter-orig/userspace/extensions/libipt_string.c	Sun Apr 27 11:50:00 2003
+++ netfilter-fixed/userspace/extensions/libipt_string.c	Mon Apr 21 23:37:45 2003
@@ -202,7 +202,7 @@
 	const struct ipt_string_info *info =
 	    (const struct ipt_string_info*) match->data;
 
-	printf("--string %s%s ", (info->invert) ? "! ", "", info->string);
+	printf("--string %s%s ", (info->invert) ? "! " : "", info->string);
 }
 
 

--Boundary_(ID_KuZ0g2Q1cC4n64IaIc2MOA)--
