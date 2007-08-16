From: Sven Wegener <Sven.Wegener@STEALER.net>
Subject: [RFC] [PATCH] ipset: New set type fullipmap, userspace part
Date: Thu, 16 Aug 2007 09:22:25 +0200 (CEST)
Message-ID: <Pine.LNX.4.64.0708160900270.13455@titan.stealer.net>
References: <Pine.LNX.4.64.0708160857080.13455@titan.stealer.net>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Cc: netfilter-devel@lists.netfilter.org
To: kadlec@blackhole.kfki.hu
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
In-Reply-To: <Pine.LNX.4.64.0708160857080.13455@titan.stealer.net>
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

--- /dev/null
+++ b/ipset_fullipmap.c
@@ -0,0 +1,202 @@
+/* Copyright 2007 Sven Wegener <sven.wegener@stealer.net>
+ *
+ * This program is free software; you can redistribute it and/or modify it
+ * under the terms of the GNU General Public License as published by the Free
+ * Software Foundation; either version 2 of the License, or (at your option)
+ * any later version.
+ *
+ * This program is distributed in the hope that it will be useful, but WITHOUT
+ * ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
+ * FITNESS FOR A PARTICULAR PURPOSE. See the GNU General Public License for
+ * more details.
+ *
+ * You should have received a copy of the GNU General Public License along with
+ * this program; if not, write to the Free Software Foundation, Inc., 59 Temple
+ * Place, Suite 330, Boston, MA 02111-1307 USA
+ */
+
+#include <stdio.h>
+#include <string.h>
+#include <sys/socket.h>
+#include <netinet/in.h>
+#include <arpa/inet.h>
+
+#include <linux/netfilter_ipv4/ip_set_fullipmap.h>
+#include "ipset.h"
+
+void
+create_init(void *data)
+{
+//	struct ip_set_req_fullipmap_create *mydata = (struct ip_set_req_fullipmap_create *) data;
+}
+
+int
+create_parse(int c, char *argv[], void *data, unsigned int *flags)
+{
+//	struct ip_set_req_fullipmap_create *mydata = (struct ip_set_req_fullipmap_create *) data;
+
+	return 0;
+}
+
+void
+create_final(void *data, unsigned int flags)
+{
+//	struct ip_set_req_fullipmap_create *mydata = (struct ip_set_req_fullipmap_create *) data;
+}
+
+static struct option create_opts[] = {
+	{0}
+};
+
+ip_set_ip_t
+adt_parser(unsigned int cmd, const char *optarg, void *data)
+{
+	struct ip_set_req_fullipmap *mydata = (struct ip_set_req_fullipmap *) data;
+	ip_set_ip_t mask;
+
+	char *saved = ipset_strdup(optarg);
+	char *ptr, *tmp = saved;
+
+	if (strchr(tmp, '/')) {
+		parse_ipandmask(tmp, &mydata->start, &mask);
+		mydata->end = mydata->start | ~mask;
+	} else {
+		ptr = strsep(&tmp, ":");
+		parse_ip(ptr, &mydata->start);
+
+		if (tmp) {
+			parse_ip(tmp, &mydata->end);
+		} else {
+			mydata->end = mydata->start;
+		}
+	}
+
+	free(saved);
+
+	return 1;
+}
+
+void
+initheader(struct set *set, const void *data)
+{
+	struct ip_set_req_fullipmap_create *header = (struct ip_set_req_fullipmap_create *) data;
+	struct ip_set_fullipmap *map = (struct ip_set_fullipmap *) set->settype->header;
+
+	memset(header, 0, sizeof(*header));
+	memset(map, 0, sizeof(*map));
+}
+
+void
+__print_range(struct set *set, ip_set_ip_t start, ip_set_ip_t end, unsigned int options, int save)
+{
+	if (save)
+		printf("-A %s ", set->name);
+
+	printf("%s", ip_tostring(start, options));
+	if (start != end)
+		printf(":%s", ip_tostring(end, options));
+	printf("\n");
+}
+
+void
+__print_set(struct set *set, void *data, size_t len, unsigned int options, int save)
+{
+	unsigned int ip, start, end;
+	int i, j, inrange = 0;
+
+	for (i = 0; i < 65536; i++) {
+		for (j = 0; j < 65536; j++) {
+			ip = i * 65536 + j;
+
+			if (test_bit(ip, data)) {
+				if (!inrange) {
+					start = ip;
+					inrange = 1;
+				}
+				end = ip;
+			} else if (inrange) {
+				__print_range(set, start, end, options, save);
+				inrange = 0;
+			}
+		}
+	}
+
+	if (inrange)
+		__print_range(set, start, end, options, save);
+}
+
+void
+printheader(struct set *set, unsigned int options)
+{
+//	struct ip_set_fullipmap *mysetdata = (struct ip_set_fullipmap *) set->settype->header;
+
+	printf("\n");
+}
+
+void
+printips_sorted(struct set *set, void *data, size_t len, unsigned int options)
+{
+//	struct ip_set_fullipmap *mysetdata = (struct ip_set_fullipmap *) set->settype->header;
+
+	__print_set(set, data, len, options, 0);
+}
+
+void
+saveheader(struct set *set, unsigned int options)
+{
+//	struct ip_set_fullipmap *mysetdata = (struct ip_set_fullipmap *) set->settype->header;
+
+	printf("-N %s %s\n", set->name, set->settype->typename);
+}
+
+void
+saveips(struct set *set, void *data, size_t len, unsigned int options)
+{
+//	struct ip_set_fullipmap *mysetdata = (struct ip_set_fullipmap *) set->settype->header;
+
+	__print_set(set, data, len, options, 1);
+}
+
+void
+usage(void)
+{
+	printf(
+		"-N set fullipmap\n"
+		"-A set IP\n"
+		"-D set IP\n"
+		"-T set IP\n"
+	);
+}
+
+static struct settype settype_fullipmap = {
+	.typename = SETTYPE_NAME,
+	.protocol_version = IP_SET_PROTOCOL_VERSION,
+
+	.create_size = sizeof(struct ip_set_req_fullipmap_create),
+	.create_init = &create_init,
+	.create_parse = &create_parse,
+	.create_final = &create_final,
+	.create_opts = create_opts,
+
+	.adt_size = sizeof(struct ip_set_req_fullipmap),
+	.adt_parser = &adt_parser,
+
+	.header_size = sizeof(struct ip_set_fullipmap),
+	.initheader = &initheader,
+	.printheader = &printheader,
+	.printips = &printips_sorted,
+	.printips_sorted = &printips_sorted,
+	.saveheader = &saveheader,
+	.saveips = &saveips,
+
+	.bindip_tostring = &binding_ip_tostring,
+	.bindip_parse = &parse_ip,
+
+	.usage = &usage,
+};
+
+void
+_init(void)
+{
+	settype_register(&settype_fullipmap);
+}
