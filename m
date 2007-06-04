From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: Bug in conntrack -U
Date: Mon, 04 Jun 2007 11:59:03 +0200
Message-ID: <4663E267.1030900@netfilter.org>
References: <1180707433.4733.7.camel@ghlodit.inl.fr>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="------------050309020307030803000201"
Cc: netfilter-devel@lists.netfilter.org
To: Eric Leblond <eric@inl.fr>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
In-Reply-To: <1180707433.4733.7.camel@ghlodit.inl.fr>
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

This is a multi-part message in MIME format.
--------------050309020307030803000201
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit

Eric Leblond wrote:
> I've found a problem with conntrack-tools. Running :
> conntrack -U -m 20 -s 192.168.50.140 -d 192.168.50.129 -p tcp --orig-port-src 43515 --orig-port-dst 22
> returns
> Operation failed: invalid parameters
> 
> Problem has been verified with kernel 2.6.20 and 2.6.17 with subversion
> compiled libraries and conntrack-tools on 32bits and 64bits system. I
> did not find the time to test it on latest kernel.

The problem seems to be in libnetfilter_conntrack. The patch attached
should fix the problem. Thanks for the report.

-- 
The dawn of the fourth age of Linux firewalling is coming; a time of
great struggle and heroic deeds -- J.Kadlecsik got inspired by J.Morris

--------------050309020307030803000201
Content-Type: text/plain;
 name="x"
Content-Transfer-Encoding: 8bit
Content-Disposition: inline;
 filename="x"

Index: src/conntrack/build.c
===================================================================
--- src/conntrack/build.c	(revisión: 6840)
+++ src/conntrack/build.c	(copia de trabajo)
@@ -252,8 +252,13 @@
 	__build_tuple(req, size, &ct->tuple[__DIR_ORIG], CTA_TUPLE_ORIG);
 	__build_tuple(req, size, &ct->tuple[__DIR_REPL], CTA_TUPLE_REPLY);
 
-	/* always build IPS_CONFIRMED */
-	__build_status(req, size, ct);
+	if (test_bit(ATTR_STATUS, ct->set))
+		__build_status(req, size, ct);
+	else {
+		/* build IPS_CONFIRMED if we're creating a new conntrack */
+		if (type == IPCTNL_MSG_CT_NEW && flags & NLM_F_CREATE)
+			__build_status(req, size, ct);
+	}
 
 	if (test_bit(ATTR_TIMEOUT, ct->set))
 		__build_timeout(req, size, ct);

--------------050309020307030803000201--
