From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: NFNL_NFA_NEST
Date: Fri, 23 Mar 2007 18:37:40 +0100
Message-ID: <46041064.4080806@netfilter.org>
References: <4600BDBB.8020205@trash.net> <4601B796.5030100@netfilter.org>
	<460261EB.4000402@trash.net> <46028242.4090609@netfilter.org>
	<460284D4.30709@trash.net> <4602B25B.10909@netfilter.org>
	<4602B667.2030304@trash.net> <4603C5AC.1070808@netfilter.org>
	<4603CF78.3030501@trash.net>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="------------060806000206040601010901"
Cc: Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>
To: Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
In-Reply-To: <4603CF78.3030501@trash.net>
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
--------------060806000206040601010901
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit

Patrick McHardy wrote:
> Pablo Neira Ayuso wrote:
>> Patrick McHardy wrote:
>>
>> I implemented a simple conversion function yesterday, so we can get rid
>> of it for this library release. Anyhow, I'm still concerned about one
>> scenario, since netlink over network messages could be sent between two
>> systems A and B with different endianess and different library versions,
>> consider that A sent a message that contains one attribute that B
>> doesn't know. Thus, the message will not be completely converted by the
>> structure aware proxy function in B. Then, the message will probably be
>> passed to B's netlink subsystem that will complain about a malformed
>> attribute, returning EINVAL. For the conntrackd example, both replicas
>> should have the same configuration, so this shouldn't be a problem for
>> me, but perhaps other future applications could have problems. Another
>> point is that we'll have to cook a structure aware conversion function
>> for every netlink messages sent on the wire.
> 
> We just need one conversion function, but a structure per nested
> attribute, no?

Right, just one conversion function, sorry, the previous statement was
not accurate. What I meant is that we'll have to maintain the nested
attribute structure per subsystem and live with the possible
synchronization problems: new kernels with new nested attributes and old
libraries will not do an appropiate conversion.

Attached a patch with the conversion function and how the structure
would look like for ctnetlink, one candidate conversion function is
defined in conntrackd, I'll move it to the libraries soon.

>>> Yes, the kernel doesn't need them in any case. Which gives me an
>>> idea, we could just stop sending them in userspace and still
>>> include them in the kernel, if that makes life easier for you.
>>
>> Yes, but we'll have to remove it sooner or later, so I understand this
>> as a temporary solution, isn't it?
> 
> 
> Not necessarily. The problem with the NEST bit is the receive
> side of the kernel code, the generic stuff can't deal with it.
> On the send-side we can simply manually OR it into the type value.

I just started thinking that probably the generic infrastructure should
support the nest bit. How crazy is this idea?

-- 
The dawn of the fourth age of Linux firewalling is coming; a time of
great struggle and heroic deeds -- J.Kadlecsik got inspired by J.Morris

--------------060806000206040601010901
Content-Type: text/plain;
 name="y"
Content-Transfer-Encoding: 8bit
Content-Disposition: inline;
 filename="y"

Index: src/proxy.c
===================================================================
--- src/proxy.c	(revisión: 48)
+++ src/proxy.c	(copia de trabajo)
@@ -25,7 +25,42 @@
 #define dprintf
 #endif
 
-int nlh_payload_host2network(struct nfattr *nfa, int len)
+struct nested_attr {
+	struct nested_attr *next;
+};
+
+static struct nested_attr is_nested_tuple_ip[CTA_IP_MAX] = {};
+static struct nested_attr is_nested_tuple_proto[CTA_PROTO_MAX] = {};
+static struct nested_attr is_nested_protoinfo_tcp[CTA_PROTOINFO_TCP_MAX] = {};
+static struct nested_attr is_nested_nat_proto[CTA_PROTONAT_MAX] = {};
+
+static struct nested_attr is_nested_tuple[CTA_TUPLE_MAX] = {
+	[CTA_TUPLE_IP-1]        = { .next = is_nested_tuple_ip },
+	[CTA_TUPLE_PROTO-1]     = { .next = is_nested_tuple_proto },
+};
+static struct nested_attr is_nested_protoinfo[CTA_PROTOINFO_MAX] = {
+	[CTA_PROTOINFO_TCP-1]   = { .next = is_nested_protoinfo_tcp },
+};
+static struct nested_attr is_nested_counters[CTA_COUNTERS_MAX] = {};
+static struct nested_attr is_nested_nat[CTA_NAT_MAX] = {
+	[CTA_NAT_PROTO-1]       = { .next = is_nested_nat_proto },
+};
+static struct nested_attr is_nested_help[CTA_HELP_MAX] = {};
+
+struct nested_attr is_nested[CTA_MAX] = {
+	[CTA_TUPLE_ORIG-1]      = { .next = is_nested_tuple },
+	[CTA_TUPLE_REPLY-1]     = { .next = is_nested_tuple },
+	[CTA_PROTOINFO-1]       = { .next = is_nested_protoinfo },
+	[CTA_HELP-1]            = { .next = is_nested_help },
+	[CTA_NAT_SRC-1]         = { .next = is_nested_nat },
+	[CTA_COUNTERS_ORIG-1]   = { .next = is_nested_counters },
+	[CTA_COUNTERS_REPLY-1]  = { .next = is_nested_counters },
+	[CTA_NAT_DST-1]         = { .next = is_nested_nat },
+};
+
+static int payload_hton(struct nfattr *nfa, 
+			int len, 
+			struct nested_attr *is_nested)
 {
 	struct nfattr *__nfa;
 
@@ -36,12 +71,13 @@
 			nfa->nfa_len, len,
 			nfa->nfa_type & NFNL_NFA_NEST ? "NEST":"");
 
-		if (nfa->nfa_type & NFNL_NFA_NEST) {
+		if (is_nested[NFA_TYPE(nfa)-1].next) {
 			if (NFA_PAYLOAD(nfa) > len)
 				return -1;
 
-			if (nlh_payload_host2network(NFA_DATA(nfa), 
-						     NFA_PAYLOAD(nfa)) == -1)
+			if (payload_hton(NFA_DATA(nfa), 
+					 NFA_PAYLOAD(nfa),
+					 is_nested[NFA_TYPE(nfa)-1].next) == -1)
 				return -1;
 		}
 
@@ -70,10 +106,10 @@
 
 	nfhdr->res_id    = htons(nfhdr->res_id);
 
-	return nlh_payload_host2network(NFM_NFA(NLMSG_DATA(nlh)), len);
+	return payload_hton(NFM_NFA(NLMSG_DATA(nlh)), len, is_nested);
 }
 
-int nlh_payload_network2host(struct nfattr *nfa, int len)
+int payload_ntoh(struct nfattr *nfa, int len, struct nested_attr *is_nested)
 {
 	nfa->nfa_type = ntohs(nfa->nfa_type);
 	nfa->nfa_len  = ntohs(nfa->nfa_len);
@@ -85,12 +121,13 @@
 		        nfa->nfa_len, len, 
 		        nfa->nfa_type & NFNL_NFA_NEST ? "NEST":"");
 
-		if (nfa->nfa_type & NFNL_NFA_NEST) {
+		if (is_nested[NFA_TYPE(nfa)-1].next) {
 			if (NFA_PAYLOAD(nfa) > len)
 				return -1;
 
-			if (nlh_payload_network2host(NFA_DATA(nfa),
-						     NFA_PAYLOAD(nfa)) == -1)
+			if (payload_ntoh(NFA_DATA(nfa),
+					 NFA_PAYLOAD(nfa),
+					 is_nested[NFA_TYPE(nfa)-1].next) == -1)
 				return -1;
 		}
 
@@ -120,5 +157,5 @@
 
 	nfhdr->res_id    = ntohs(nfhdr->res_id);
 
-	return nlh_payload_network2host(NFM_NFA(NLMSG_DATA(nlh)), len);
+	return payload_ntoh(NFM_NFA(NLMSG_DATA(nlh)), len, is_nested);
 }

--------------060806000206040601010901--
