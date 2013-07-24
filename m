From: Tomasz Bursztyka <tomasz.bursztyka@linux.intel.com>
Subject: Re: [xtables-arptables PATCH v2 3/5] nft: nft_xtables_config_load()
 called only in nft_init()
Date: Wed, 24 Jul 2013 12:36:27 +0300
Message-ID: <51EFA01B.30907@linux.intel.com>
References: <20130723161017.10040.6256.stgit@localhost> <20130723161244.10040.57825.stgit@localhost> <20130724085649.GC16434@localhost>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Giuseppe Longo <giuseppelng@gmail.com>,
	netfilter-devel@vger.kernel.org
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mga03.intel.com ([143.182.124.21]:46230 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751251Ab3GXJgx (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 24 Jul 2013 05:36:53 -0400
In-Reply-To: <20130724085649.GC16434@localhost>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hi Pablo,

>> +int nft_init(struct nft_handle *h, struct builtin_table *t,
>> >+	     const char *filename)
>                           ^^^^^^^^
>
> why do we need this new parameter?
>
> The optional /etc/xtables.conf file should contain the definition for
> all the families, that includes IPv4, IPv6, bridge and ARP.

My mistake, I advised that. Imho, it's not relevant to load everything 
for all families if the user is using only xtables-iptables for instance.

Then ok, let's have one file, but we could make a change in 
nft_xtables_config_load() so it would load only the tables of the 
current family.
It's a quick fix to do actually.

>
>> >  {
>> >  	h->nl = mnl_socket_open(NETLINK_NETFILTER);
>> >  	if (h->nl == NULL) {
>> >@@ -388,6 +389,16 @@ int nft_init(struct nft_handle *h, struct builtin_table *t)
>> >  	h->portid = mnl_socket_get_portid(h->nl);
>> >  	h->tables = t;
>> >  
>> >+	/* If built-in chains don't exist for this table, create them */
>> >+	if (nft_xtables_config_load(h, filename, 0) < 0) {
>> >+		int i;
>> >+
>> >+		if (h->tables != NULL) {
>> >+			for (i=0; i<TABLES_MAX; i++)
>> >+				nft_chain_builtin_init(h, h->tables[i].name,
>> >+						       NULL, NF_ACCEPT);
>> >+		}
>> >+	}
> I don't see what we get by moving nft_xtables_config_load here.

Why not calling this at only one unique place instead of multiple ones?
You need to call that anyway currently as soon as you list/change the 
rule set.
It's relevant to move that here, makes code clearer.

Cheers,

Tomasz
