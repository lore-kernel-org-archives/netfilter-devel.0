Return-Path: <SRS0=5/AD=YL=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E84ACCA9EA9
	for <netfilter-devel@archiver.kernel.org>; Fri, 18 Oct 2019 15:53:25 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id A6E7E2064B
	for <netfilter-devel@archiver.kernel.org>; Fri, 18 Oct 2019 15:53:25 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2405953AbfJRPxZ (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Fri, 18 Oct 2019 11:53:25 -0400
Received: from orbyte.nwl.cc ([151.80.46.58]:44358 "EHLO orbyte.nwl.cc"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727668AbfJRPxZ (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 18 Oct 2019 11:53:25 -0400
Received: from localhost ([::1]:57448 helo=tatos)
        by orbyte.nwl.cc with esmtp (Exim 4.91)
        (envelope-from <phil@nwl.cc>)
        id 1iLUZ9-0006Ll-4m; Fri, 18 Oct 2019 17:53:23 +0200
From:   Phil Sutter <phil@nwl.cc>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     netfilter-devel@vger.kernel.org
Subject: [iptables PATCH 1/2] iptables-xml: Use add_param_to_argv()
Date:   Fri, 18 Oct 2019 17:53:08 +0200
Message-Id: <20191018155309.8250-1-phil@nwl.cc>
X-Mailer: git-send-email 2.23.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Extend the shared argv parser by storing whether a given argument was
quoted or not, then use it in iptables-xml. One remaining extra bit is
extraction of chain name in -A commands, do that afterwards in a loop.

Signed-off-by: Phil Sutter <phil@nwl.cc>
---
 iptables/iptables-xml.c                       |  78 +-
 .../testcases/ipt-save/0006iptables-xml_0     |  13 +
 .../ipt-save/dumps/fedora27-iptables.xml      | 925 ++++++++++++++++++
 iptables/xshared.c                            |   6 +-
 4 files changed, 949 insertions(+), 73 deletions(-)
 create mode 100755 iptables/tests/shell/testcases/ipt-save/0006iptables-xml_0
 create mode 100644 iptables/tests/shell/testcases/ipt-save/dumps/fedora27-iptables.xml

diff --git a/iptables/iptables-xml.c b/iptables/iptables-xml.c
index 5255e097eba88..eafee64f5e954 100644
--- a/iptables/iptables-xml.c
+++ b/iptables/iptables-xml.c
@@ -647,78 +647,8 @@ iptables_xml_main(int argc, char *argv[])
 			char *parsestart = buffer;
 			char *chain = NULL;
 
-			/* the parser */
-			char *param_start, *curchar;
-			int quote_open, quoted;
-			char param_buffer[1024];
-
 			tokenize_rule_counters(&parsestart, &pcnt, &bcnt, line);
-
-			/* This is a 'real' parser crafted in artist mode
-			 * not hacker mode. If the author can live with that
-			 * then so can everyone else */
-
-			quote_open = 0;
-			/* We need to know which args were quoted so we 
-			   can preserve quote */
-			quoted = 0;
-			param_start = parsestart;
-
-			for (curchar = parsestart; *curchar; curchar++) {
-				if (*curchar == '"') {
-					/* quote_open cannot be true if there
-					 * was no previous character.  Thus, 
-					 * curchar-1 has to be within bounds */
-					if (quote_open &&
-					    *(curchar - 1) != '\\') {
-						quote_open = 0;
-						*curchar = ' ';
-					} else {
-						quote_open = 1;
-						quoted = 1;
-						param_start++;
-					}
-				}
-				if (*curchar == ' '
-				    || *curchar == '\t' || *curchar == '\n') {
-					int param_len = curchar - param_start;
-
-					if (quote_open)
-						continue;
-
-					if (!param_len) {
-						/* two spaces? */
-						param_start++;
-						continue;
-					}
-
-					/* end of one parameter */
-					strncpy(param_buffer, param_start,
-						param_len);
-					*(param_buffer + param_len) = '\0';
-
-					/* check if table name specified */
-					if ((param_buffer[0] == '-' &&
-					     param_buffer[1] != '-' &&
-					     strchr(param_buffer, 't')) ||
-					    (!strncmp(param_buffer, "--t", 3) &&
-					     !strncmp(param_buffer, "--table", strlen(param_buffer))))
-						xtables_error(PARAMETER_PROBLEM,
-							   "Line %u seems to have a "
-							   "-t table option.\n",
-							   line);
-
-					add_argv(param_buffer, quoted);
-					if (newargc >= 2
-					    && 0 ==
-					    strcmp(newargv[newargc - 2], "-A"))
-						chain = newargv[newargc - 1];
-					quoted = 0;
-					param_start += param_len + 1;
-				} else {
-					/* regular character, skip */
-				}
-			}
+			add_param_to_argv(parsestart, line);
 
 			DEBUGP("calling do_command4(%u, argv, &%s, handle):\n",
 			       newargc, curTable);
@@ -726,6 +656,12 @@ iptables_xml_main(int argc, char *argv[])
 			for (a = 0; a < newargc; a++)
 				DEBUGP("argv[%u]: %s\n", a, newargv[a]);
 
+			for (a = 1; a < newargc; a++) {
+				if (strcmp(newargv[a - 1], "-A"))
+					continue;
+				chain = newargv[a];
+				break;
+			}
 			if (!chain) {
 				fprintf(stderr, "%s: line %u failed - no chain found\n",
 					prog_name, line);
diff --git a/iptables/tests/shell/testcases/ipt-save/0006iptables-xml_0 b/iptables/tests/shell/testcases/ipt-save/0006iptables-xml_0
new file mode 100755
index 0000000000000..50c0cae888341
--- /dev/null
+++ b/iptables/tests/shell/testcases/ipt-save/0006iptables-xml_0
@@ -0,0 +1,13 @@
+#!/bin/bash
+
+case "$(basename $XT_MULTI)" in
+	xtables-legacy-multi)
+		;;
+	*)
+		echo "skip $XT_MULTI"
+		exit 0
+		;;
+esac
+
+dump=$(dirname $0)/dumps/fedora27-iptables
+diff -u -Z <(cat ${dump}.xml) <($XT_MULTI iptables-xml <$dump)
diff --git a/iptables/tests/shell/testcases/ipt-save/dumps/fedora27-iptables.xml b/iptables/tests/shell/testcases/ipt-save/dumps/fedora27-iptables.xml
new file mode 100644
index 0000000000000..400be032fbd20
--- /dev/null
+++ b/iptables/tests/shell/testcases/ipt-save/dumps/fedora27-iptables.xml
@@ -0,0 +1,925 @@
+<iptables-rules version="1.0">
+<!-- # Completed on Sat Feb 17 10:50:33 2018 -->
+<!-- # Generated by iptables*-save v1.6.1 on Sat Feb 17 10:50:33 2018 -->
+  <table name="mangle" >
+    <chain name="PREROUTING" policy="ACCEPT" packet-count="0" byte-count="0" >
+      <rule packet-count="1" byte-count="2" >
+       <actions>
+        <call >
+          <PREROUTING_direct />
+        </call>
+       </actions>
+
+      </rule>
+
+      <rule packet-count="3" byte-count="4" >
+       <actions>
+        <call >
+          <PREROUTING_ZONES_SOURCE />
+        </call>
+       </actions>
+
+      </rule>
+
+      <rule packet-count="0" byte-count="0" >
+       <actions>
+        <call >
+          <PREROUTING_ZONES />
+        </call>
+       </actions>
+
+      </rule>
+
+    </chain>
+    <chain name="INPUT" policy="ACCEPT" packet-count="0" byte-count="0" >
+      <rule packet-count="0" byte-count="0" >
+       <actions>
+        <call >
+          <INPUT_direct />
+        </call>
+       </actions>
+
+      </rule>
+
+    </chain>
+    <chain name="FORWARD" policy="ACCEPT" packet-count="0" byte-count="0" >
+      <rule packet-count="0" byte-count="0" >
+       <actions>
+        <call >
+          <FORWARD_direct />
+        </call>
+       </actions>
+
+      </rule>
+
+    </chain>
+    <chain name="OUTPUT" policy="ACCEPT" packet-count="0" byte-count="0" >
+      <rule packet-count="0" byte-count="0" >
+       <actions>
+        <call >
+          <OUTPUT_direct />
+        </call>
+       </actions>
+
+      </rule>
+
+    </chain>
+    <chain name="POSTROUTING" policy="ACCEPT" packet-count="0" byte-count="0" >
+      <rule packet-count="0" byte-count="0" >
+       <conditions>
+        <match >
+          <o >virbr0</o>
+          <p >udp</p>
+        </match>
+        <udp >
+          <dport >68</dport>
+        </udp>
+       </conditions>
+       <actions>
+        <CHECKSUM >
+          <checksum-fill  />
+        </CHECKSUM>
+       </actions>
+
+      </rule>
+
+      <rule packet-count="0" byte-count="0" >
+       <actions>
+        <call >
+          <POSTROUTING_direct />
+        </call>
+       </actions>
+
+      </rule>
+
+    </chain>
+    <chain name="PREROUTING_ZONES" packet-count="0" byte-count="0" >
+      <rule packet-count="0" byte-count="0" >
+       <conditions>
+        <match >
+          <i >wlp58s0</i>
+        </match>
+       </conditions>
+       <actions>
+        <goto >
+          <PRE_FedoraWorkstation />
+        </goto>
+       </actions>
+
+      </rule>
+
+      <rule packet-count="0" byte-count="0" >
+       <actions>
+        <goto >
+          <PRE_FedoraWorkstation />
+        </goto>
+       </actions>
+
+      </rule>
+
+    </chain>
+    <chain name="PRE_FedoraWorkstation" packet-count="0" byte-count="0" >
+      <rule packet-count="0" byte-count="0" >
+       <actions>
+        <call >
+          <PRE_FedoraWorkstation_log />
+        </call>
+       </actions>
+
+      </rule>
+
+      <rule packet-count="0" byte-count="0" >
+       <actions>
+        <call >
+          <PRE_FedoraWorkstation_deny />
+        </call>
+       </actions>
+
+      </rule>
+
+      <rule packet-count="0" byte-count="0" >
+       <actions>
+        <call >
+          <PRE_FedoraWorkstation_allow />
+        </call>
+       </actions>
+
+      </rule>
+
+    </chain>
+    <chain name="FORWARD_direct" packet-count="0" byte-count="0" />
+    <chain name="INPUT_direct" packet-count="0" byte-count="0" />
+    <chain name="OUTPUT_direct" packet-count="0" byte-count="0" />
+    <chain name="POSTROUTING_direct" packet-count="0" byte-count="0" />
+    <chain name="PREROUTING_ZONES_SOURCE" packet-count="0" byte-count="0" />
+    <chain name="PREROUTING_direct" packet-count="0" byte-count="0" />
+    <chain name="PRE_FedoraWorkstation_allow" packet-count="0" byte-count="0" />
+    <chain name="PRE_FedoraWorkstation_deny" packet-count="0" byte-count="0" />
+    <chain name="PRE_FedoraWorkstation_log" packet-count="0" byte-count="0" />
+  </table>
+<!-- # Completed on Sat Feb 17 10:50:33 2018 -->
+<!-- # Generated by iptables*-save v1.6.1 on Sat Feb 17 10:50:33 2018 -->
+  <table name="raw" >
+    <chain name="PREROUTING" policy="ACCEPT" packet-count="1681" byte-count="2620433" >
+      <rule packet-count="0" byte-count="0" >
+       <actions>
+        <call >
+          <PREROUTING_direct />
+        </call>
+       </actions>
+
+      </rule>
+
+      <rule packet-count="0" byte-count="0" >
+       <actions>
+        <call >
+          <PREROUTING_ZONES_SOURCE />
+        </call>
+       </actions>
+
+      </rule>
+
+      <rule packet-count="0" byte-count="0" >
+       <actions>
+        <call >
+          <PREROUTING_ZONES />
+        </call>
+       </actions>
+
+      </rule>
+
+    </chain>
+    <chain name="OUTPUT" policy="ACCEPT" packet-count="1619" byte-count="171281" >
+      <rule packet-count="0" byte-count="0" >
+       <actions>
+        <call >
+          <OUTPUT_direct />
+        </call>
+       </actions>
+
+      </rule>
+
+    </chain>
+    <chain name="PREROUTING_ZONES" packet-count="0" byte-count="0" >
+      <rule packet-count="0" byte-count="0" >
+       <conditions>
+        <match >
+          <i >wlp58s0</i>
+        </match>
+       </conditions>
+       <actions>
+        <goto >
+          <PRE_FedoraWorkstation />
+        </goto>
+       </actions>
+
+      </rule>
+
+      <rule packet-count="0" byte-count="0" >
+       <actions>
+        <goto >
+          <PRE_FedoraWorkstation />
+        </goto>
+       </actions>
+
+      </rule>
+
+    </chain>
+    <chain name="PRE_FedoraWorkstation" packet-count="0" byte-count="0" >
+      <rule packet-count="0" byte-count="0" >
+       <actions>
+        <call >
+          <PRE_FedoraWorkstation_log />
+        </call>
+       </actions>
+
+      </rule>
+
+      <rule packet-count="0" byte-count="0" >
+       <actions>
+        <call >
+          <PRE_FedoraWorkstation_deny />
+        </call>
+       </actions>
+
+      </rule>
+
+      <rule packet-count="0" byte-count="0" >
+       <actions>
+        <call >
+          <PRE_FedoraWorkstation_allow />
+        </call>
+       </actions>
+
+      </rule>
+
+    </chain>
+    <chain name="PRE_FedoraWorkstation_allow" packet-count="0" byte-count="0" >
+      <rule packet-count="0" byte-count="0" >
+       <conditions>
+        <match >
+          <p >udp</p>
+        </match>
+        <udp >
+          <dport >137</dport>
+        </udp>
+       </conditions>
+       <actions>
+        <CT >
+          <helper >netbios-ns</helper>
+        </CT>
+       </actions>
+
+      </rule>
+
+    </chain>
+    <chain name="OUTPUT_direct" packet-count="0" byte-count="0" />
+    <chain name="PREROUTING_ZONES_SOURCE" packet-count="0" byte-count="0" />
+    <chain name="PREROUTING_direct" packet-count="0" byte-count="0" />
+    <chain name="PRE_FedoraWorkstation_deny" packet-count="0" byte-count="0" />
+    <chain name="PRE_FedoraWorkstation_log" packet-count="0" byte-count="0" />
+  </table>
+<!-- # Completed on Sat Feb 17 10:50:33 2018 -->
+<!-- # Generated by iptables*-save v1.6.1 on Sat Feb 17 10:50:33 2018 -->
+  <table name="filter" >
+    <chain name="INPUT" policy="ACCEPT" packet-count="0" byte-count="0" >
+      <rule packet-count="5" byte-count="6" >
+       <conditions>
+        <match >
+          <i >virbr0</i>
+          <p >udp</p>
+        </match>
+        <udp >
+          <dport >53</dport>
+        </udp>
+       </conditions>
+       <actions>
+        <ACCEPT  />
+       </actions>
+
+      </rule>
+
+      <rule packet-count="0" byte-count="123456789" >
+       <conditions>
+        <match >
+          <i >virbr0</i>
+          <p >tcp</p>
+        </match>
+        <tcp >
+          <dport >53</dport>
+        </tcp>
+       </conditions>
+       <actions>
+        <ACCEPT  />
+       </actions>
+
+      </rule>
+
+      <rule packet-count="0" byte-count="0" >
+       <conditions>
+        <match >
+          <i >virbr0</i>
+          <p >udp</p>
+        </match>
+        <udp >
+          <dport >67</dport>
+        </udp>
+       </conditions>
+       <actions>
+        <ACCEPT  />
+       </actions>
+
+      </rule>
+
+      <rule packet-count="0" byte-count="0" >
+       <conditions>
+        <match >
+          <i >virbr0</i>
+          <p >tcp</p>
+        </match>
+        <tcp >
+          <dport >67</dport>
+        </tcp>
+       </conditions>
+       <actions>
+        <ACCEPT  />
+       </actions>
+
+      </rule>
+
+      <rule packet-count="0" byte-count="0" >
+       <conditions>
+        <conntrack >
+          <ctstate >RELATED,ESTABLISHED</ctstate>
+        </conntrack>
+       </conditions>
+       <actions>
+        <ACCEPT  />
+       </actions>
+
+      </rule>
+
+      <rule packet-count="0" byte-count="0" >
+       <conditions>
+        <match >
+          <i >lo</i>
+        </match>
+       </conditions>
+       <actions>
+        <ACCEPT  />
+       </actions>
+
+      </rule>
+
+      <rule packet-count="0" byte-count="0" >
+       <actions>
+        <call >
+          <INPUT_direct />
+        </call>
+       </actions>
+
+      </rule>
+
+      <rule packet-count="0" byte-count="0" >
+       <actions>
+        <call >
+          <INPUT_ZONES_SOURCE />
+        </call>
+       </actions>
+
+      </rule>
+
+      <rule packet-count="0" byte-count="0" >
+       <actions>
+        <call >
+          <INPUT_ZONES />
+        </call>
+       </actions>
+
+      </rule>
+
+      <rule packet-count="0" byte-count="0" >
+       <conditions>
+        <conntrack >
+          <ctstate >INVALID</ctstate>
+        </conntrack>
+       </conditions>
+       <actions>
+        <DROP  />
+       </actions>
+
+      </rule>
+
+      <rule packet-count="0" byte-count="0" >
+       <actions>
+        <REJECT >
+          <reject-with >icmp-host-prohibited</reject-with>
+        </REJECT>
+       </actions>
+
+      </rule>
+
+    </chain>
+    <chain name="FORWARD" policy="ACCEPT" packet-count="0" byte-count="0" >
+      <rule packet-count="0" byte-count="0" >
+       <conditions>
+        <match >
+          <d >192.168.122.0/24</d>
+          <o >virbr0</o>
+        </match>
+        <conntrack >
+          <ctstate >RELATED,ESTABLISHED</ctstate>
+        </conntrack>
+       </conditions>
+       <actions>
+        <ACCEPT  />
+       </actions>
+
+      </rule>
+
+      <rule packet-count="0" byte-count="0" >
+       <conditions>
+        <match >
+          <s >192.168.122.0/24</s>
+          <i >virbr0</i>
+        </match>
+       </conditions>
+       <actions>
+        <ACCEPT  />
+       </actions>
+
+      </rule>
+
+      <rule packet-count="0" byte-count="0" >
+       <conditions>
+        <match >
+          <i >virbr0</i>
+          <o >virbr0</o>
+        </match>
+       </conditions>
+       <actions>
+        <ACCEPT  />
+       </actions>
+
+      </rule>
+
+      <rule packet-count="0" byte-count="0" >
+       <conditions>
+        <match >
+          <o >virbr0</o>
+        </match>
+       </conditions>
+       <actions>
+        <REJECT >
+          <reject-with >icmp-port-unreachable</reject-with>
+        </REJECT>
+       </actions>
+
+      </rule>
+
+      <rule packet-count="0" byte-count="0" >
+       <conditions>
+        <match >
+          <i >virbr0</i>
+        </match>
+       </conditions>
+       <actions>
+        <REJECT >
+          <reject-with >icmp-port-unreachable</reject-with>
+        </REJECT>
+       </actions>
+
+      </rule>
+
+      <rule packet-count="0" byte-count="0" >
+       <conditions>
+        <conntrack >
+          <ctstate >RELATED,ESTABLISHED</ctstate>
+        </conntrack>
+       </conditions>
+       <actions>
+        <ACCEPT  />
+       </actions>
+
+      </rule>
+
+      <rule packet-count="0" byte-count="0" >
+       <conditions>
+        <match >
+          <i >lo</i>
+        </match>
+       </conditions>
+       <actions>
+        <ACCEPT  />
+       </actions>
+
+      </rule>
+
+      <rule packet-count="0" byte-count="0" >
+       <actions>
+        <call >
+          <FORWARD_direct />
+        </call>
+       </actions>
+
+      </rule>
+
+      <rule packet-count="0" byte-count="0" >
+       <actions>
+        <call >
+          <FORWARD_IN_ZONES_SOURCE />
+        </call>
+       </actions>
+
+      </rule>
+
+      <rule packet-count="0" byte-count="0" >
+       <actions>
+        <call >
+          <FORWARD_IN_ZONES />
+        </call>
+       </actions>
+
+      </rule>
+
+      <rule packet-count="0" byte-count="0" >
+       <actions>
+        <call >
+          <FORWARD_OUT_ZONES_SOURCE />
+        </call>
+       </actions>
+
+      </rule>
+
+      <rule packet-count="0" byte-count="0" >
+       <actions>
+        <call >
+          <FORWARD_OUT_ZONES />
+        </call>
+       </actions>
+
+      </rule>
+
+      <rule packet-count="0" byte-count="0" >
+       <conditions>
+        <conntrack >
+          <ctstate >INVALID</ctstate>
+        </conntrack>
+       </conditions>
+       <actions>
+        <DROP  />
+       </actions>
+
+      </rule>
+
+      <rule packet-count="0" byte-count="0" >
+       <actions>
+        <REJECT >
+          <reject-with >icmp-host-prohibited</reject-with>
+        </REJECT>
+       </actions>
+
+      </rule>
+
+    </chain>
+    <chain name="OUTPUT" policy="ACCEPT" packet-count="1619" byte-count="171281" >
+      <rule packet-count="0" byte-count="0" >
+       <conditions>
+        <match >
+          <o >virbr0</o>
+          <p >udp</p>
+        </match>
+        <udp >
+          <dport >68</dport>
+        </udp>
+       </conditions>
+       <actions>
+        <ACCEPT  />
+       </actions>
+
+      </rule>
+
+      <rule packet-count="0" byte-count="0" >
+       <actions>
+        <call >
+          <OUTPUT_direct />
+        </call>
+       </actions>
+
+      </rule>
+
+    </chain>
+    <chain name="FORWARD_IN_ZONES" packet-count="0" byte-count="0" >
+      <rule packet-count="0" byte-count="0" >
+       <conditions>
+        <match >
+          <i >wlp58s0</i>
+        </match>
+       </conditions>
+       <actions>
+        <goto >
+          <FWDI_FedoraWorkstation />
+        </goto>
+       </actions>
+
+      </rule>
+
+      <rule packet-count="0" byte-count="0" >
+       <actions>
+        <goto >
+          <FWDI_FedoraWorkstation />
+        </goto>
+       </actions>
+
+      </rule>
+
+    </chain>
+    <chain name="FORWARD_OUT_ZONES" packet-count="0" byte-count="0" >
+      <rule packet-count="0" byte-count="0" >
+       <conditions>
+        <match >
+          <o >wlp58s0</o>
+        </match>
+       </conditions>
+       <actions>
+        <goto >
+          <FWDO_FedoraWorkstation />
+        </goto>
+       </actions>
+
+      </rule>
+
+      <rule packet-count="0" byte-count="0" >
+       <actions>
+        <goto >
+          <FWDO_FedoraWorkstation />
+        </goto>
+       </actions>
+
+      </rule>
+
+    </chain>
+    <chain name="FWDI_FedoraWorkstation" packet-count="0" byte-count="0" >
+      <rule packet-count="0" byte-count="0" >
+       <actions>
+        <call >
+          <FWDI_FedoraWorkstation_log />
+        </call>
+       </actions>
+
+      </rule>
+
+      <rule packet-count="0" byte-count="0" >
+       <actions>
+        <call >
+          <FWDI_FedoraWorkstation_deny />
+        </call>
+       </actions>
+
+      </rule>
+
+      <rule packet-count="0" byte-count="0" >
+       <actions>
+        <call >
+          <FWDI_FedoraWorkstation_allow />
+        </call>
+       </actions>
+
+      </rule>
+
+      <rule packet-count="0" byte-count="0" >
+       <conditions>
+        <match >
+          <p >icmp</p>
+        </match>
+       </conditions>
+       <actions>
+        <ACCEPT  />
+       </actions>
+
+      </rule>
+
+    </chain>
+    <chain name="FWDO_FedoraWorkstation" packet-count="0" byte-count="0" >
+      <rule packet-count="0" byte-count="0" >
+       <actions>
+        <call >
+          <FWDO_FedoraWorkstation_log />
+        </call>
+       </actions>
+
+      </rule>
+
+      <rule packet-count="0" byte-count="0" >
+       <actions>
+        <call >
+          <FWDO_FedoraWorkstation_deny />
+        </call>
+       </actions>
+
+      </rule>
+
+      <rule packet-count="0" byte-count="0" >
+       <actions>
+        <call >
+          <FWDO_FedoraWorkstation_allow />
+        </call>
+       </actions>
+
+      </rule>
+
+    </chain>
+    <chain name="INPUT_ZONES" packet-count="0" byte-count="0" >
+      <rule packet-count="0" byte-count="0" >
+       <conditions>
+        <match >
+          <i >wlp58s0</i>
+        </match>
+       </conditions>
+       <actions>
+        <goto >
+          <IN_FedoraWorkstation />
+        </goto>
+       </actions>
+
+      </rule>
+
+      <rule packet-count="0" byte-count="0" >
+       <actions>
+        <goto >
+          <IN_FedoraWorkstation />
+        </goto>
+       </actions>
+
+      </rule>
+
+    </chain>
+    <chain name="IN_FedoraWorkstation" packet-count="0" byte-count="0" >
+      <rule packet-count="0" byte-count="0" >
+       <actions>
+        <call >
+          <IN_FedoraWorkstation_log />
+        </call>
+       </actions>
+
+      </rule>
+
+      <rule packet-count="0" byte-count="0" >
+       <actions>
+        <call >
+          <IN_FedoraWorkstation_deny />
+        </call>
+       </actions>
+
+      </rule>
+
+      <rule packet-count="0" byte-count="0" >
+       <actions>
+        <call >
+          <IN_FedoraWorkstation_allow />
+        </call>
+       </actions>
+
+      </rule>
+
+      <rule packet-count="0" byte-count="0" >
+       <conditions>
+        <match >
+          <p >icmp</p>
+        </match>
+       </conditions>
+       <actions>
+        <ACCEPT  />
+       </actions>
+
+      </rule>
+
+    </chain>
+    <chain name="IN_FedoraWorkstation_allow" packet-count="0" byte-count="0" >
+      <rule packet-count="0" byte-count="0" >
+       <conditions>
+        <match >
+          <p >udp</p>
+        </match>
+        <udp >
+          <dport >137</dport>
+        </udp>
+        <conntrack >
+          <ctstate >NEW</ctstate>
+        </conntrack>
+       </conditions>
+       <actions>
+        <ACCEPT  />
+       </actions>
+
+      </rule>
+
+      <rule packet-count="0" byte-count="0" >
+       <conditions>
+        <match >
+          <p >udp</p>
+        </match>
+        <udp >
+          <dport >138</dport>
+        </udp>
+        <conntrack >
+          <ctstate >NEW</ctstate>
+        </conntrack>
+       </conditions>
+       <actions>
+        <ACCEPT  />
+       </actions>
+
+      </rule>
+
+      <rule packet-count="0" byte-count="0" >
+       <conditions>
+        <match >
+          <p >tcp</p>
+        </match>
+        <tcp >
+          <dport >22</dport>
+        </tcp>
+        <conntrack >
+          <ctstate >NEW</ctstate>
+        </conntrack>
+       </conditions>
+       <actions>
+        <ACCEPT  />
+       </actions>
+
+      </rule>
+
+      <rule packet-count="0" byte-count="0" >
+       <conditions>
+        <match >
+          <d >224.0.0.251/32</d>
+          <p >udp</p>
+        </match>
+        <udp >
+          <dport >5353</dport>
+        </udp>
+        <conntrack >
+          <ctstate >NEW</ctstate>
+        </conntrack>
+       </conditions>
+       <actions>
+        <ACCEPT  />
+       </actions>
+
+      </rule>
+
+      <rule packet-count="0" byte-count="0" >
+       <conditions>
+        <match >
+          <p >udp</p>
+        </match>
+        <udp >
+          <dport >1025:65535</dport>
+        </udp>
+        <conntrack >
+          <ctstate >NEW</ctstate>
+        </conntrack>
+       </conditions>
+       <actions>
+        <ACCEPT  />
+       </actions>
+
+      </rule>
+
+      <rule packet-count="7" byte-count="8" >
+       <conditions>
+        <match >
+          <p >tcp</p>
+        </match>
+        <tcp >
+          <dport >1025:65535</dport>
+        </tcp>
+        <conntrack >
+          <ctstate >NEW</ctstate>
+        </conntrack>
+       </conditions>
+       <actions>
+        <ACCEPT  />
+       </actions>
+
+      </rule>
+
+    </chain>
+    <chain name="FORWARD_IN_ZONES_SOURCE" packet-count="0" byte-count="0" />
+    <chain name="FORWARD_OUT_ZONES_SOURCE" packet-count="0" byte-count="0" />
+    <chain name="FORWARD_direct" packet-count="0" byte-count="0" />
+    <chain name="FWDI_FedoraWorkstation_allow" packet-count="0" byte-count="0" />
+    <chain name="FWDI_FedoraWorkstation_deny" packet-count="0" byte-count="0" />
+    <chain name="FWDI_FedoraWorkstation_log" packet-count="0" byte-count="0" />
+    <chain name="FWDO_FedoraWorkstation_allow" packet-count="0" byte-count="0" />
+    <chain name="FWDO_FedoraWorkstation_deny" packet-count="0" byte-count="0" />
+    <chain name="FWDO_FedoraWorkstation_log" packet-count="0" byte-count="0" />
+    <chain name="INPUT_ZONES_SOURCE" packet-count="0" byte-count="0" />
+    <chain name="INPUT_direct" packet-count="0" byte-count="0" />
+    <chain name="IN_FedoraWorkstation_deny" packet-count="0" byte-count="0" />
+    <chain name="IN_FedoraWorkstation_log" packet-count="0" byte-count="0" />
+    <chain name="OUTPUT_direct" packet-count="0" byte-count="0" />
+  </table>
+<!-- # Completed on Sat Feb 17 10:50:33 2018 -->
+</iptables-rules>
diff --git a/iptables/xshared.c b/iptables/xshared.c
index ba723f59dbaad..4c012e32c775f 100644
--- a/iptables/xshared.c
+++ b/iptables/xshared.c
@@ -484,7 +484,7 @@ static void add_param(struct xt_param_buf *param, const char *curchar)
 
 void add_param_to_argv(char *parsestart, int line)
 {
-	int quote_open = 0, escaped = 0;
+	int quote_open = 0, escaped = 0, quoted = 0;
 	struct xt_param_buf param = {};
 	char *curchar;
 
@@ -511,6 +511,7 @@ void add_param_to_argv(char *parsestart, int line)
 		} else {
 			if (*curchar == '"') {
 				quote_open = 1;
+				quoted = 1;
 				continue;
 			}
 		}
@@ -545,8 +546,9 @@ void add_param_to_argv(char *parsestart, int line)
 				      line, xt_params->program_name);
 		}
 
-		add_argv(param.buffer, 0);
+		add_argv(param.buffer, quoted);
 		param.len = 0;
+		quoted = 0;
 	}
 }
 
-- 
2.23.0

