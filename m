From: Jan Engelhardt <jengelh@computergmbh.de>
Subject: Re: [PATCH 07/29] [NETFILTER]: remove arpt_table indirection macro
Date: Thu, 27 Mar 2008 02:23:17 +0100 (CET)
Message-ID: <alpine.LNX.1.10.0803270216480.22661@fbirervta.pbzchgretzou.qr>
References: <alpine.LNX.1.10.0803251914060.2240@fbirervta.pbzchgretzou.qr> <d77e5bacf4b9bb4fcc89fd261529a31c7c5002b2.1206469820.git.jengelh@computergmbh.de> <47EAB39C.3050004@trash.net>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Cc: netfilter-devel@vger.kernel.org
To: Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from sovereign.computergmbh.de ([85.214.69.204]:60287 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754814AbYC0BXT (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 26 Mar 2008 21:23:19 -0400
In-Reply-To: <47EAB39C.3050004@trash.net>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


On Wednesday 2008-03-26 21:35, Patrick McHardy wrote:
> Jan Engelhardt wrote:
>>  Signed-off-by: Jan Engelhardt <jengelh@computergmbh.de>
>
> Applied, but this triggered some warnings caused by the
> constification patches I missed earlier:
>
> net/ipv4/netfilter/arp_tables.c: In function 'compat_copy_entries_to_user':
> net/ipv4/netfilter/arp_tables.c:1569: warning: passing argument 1 of 
> 'alloc_counters' discards qualifiers from pointer target type
> net/ipv4/netfilter/arp_tables.c: In function 'compat_get_entries':
> net/ipv4/netfilter/arp_tables.c:1628: warning: passing argument 1 of 
> 'xt_table_unlock' discards qualifiers from pointer target type
> net/ipv4/netfilter/arp_tables.c: In function 'compat_copy_entries_to_user':
> net/ipv4/netfilter/arp_tables.c:1569: warning: passing argument 1 of 
> 'alloc_counters' discards
>
> Again, please test with CONFIG_COMPAT if you touch this code.
> I'm leaving for tonight, please send me a patch on top of the
> faulty one to fold in for fixing this.

Right...

===
Signed-off-by: Jan Engelhardt <jengelh@computergmbh.de>

diff --git a/net/ipv4/netfilter/arp_tables.c b/net/ipv4/netfilter/arp_tables.c
index 6677095..4a305c9 100644
--- a/net/ipv4/netfilter/arp_tables.c
+++ b/net/ipv4/netfilter/arp_tables.c
@@ -737,7 +737,7 @@ static int copy_entries_to_user(unsigned int total_size,
  	unsigned int off, num;
  	struct arpt_entry *e;
  	struct xt_counters *counters;
-	const struct xt_table_info *private = table->private;
+	struct xt_table_info *private = table->private;
  	int ret = 0;
  	void *loc_cpu_entry;

@@ -1555,7 +1555,7 @@ out:
  }

  static int compat_copy_entries_to_user(unsigned int total_size,
-				       const struct xt_table *table,
+				       struct xt_table *table,
  				       void __user *userptr)
  {
  	struct xt_counters *counters;
@@ -1593,7 +1593,7 @@ static int compat_get_entries(struct net *net,
  {
  	int ret;
  	struct compat_arpt_get_entries get;
-	const struct xt_table *t;
+	struct xt_table *t;

  	if (*len < sizeof(get)) {
  		duprintf("compat_get_entries: %u < %zu\n", *len, sizeof(get));
