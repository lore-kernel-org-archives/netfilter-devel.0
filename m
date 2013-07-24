From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [xtables-arptables PATCH v2 3/5] nft: nft_xtables_config_load()
 called only in nft_init()
Date: Wed, 24 Jul 2013 12:56:38 +0200
Message-ID: <20130724105638.GA17248@localhost>
References: <20130723161017.10040.6256.stgit@localhost>
 <20130723161244.10040.57825.stgit@localhost>
 <20130724085649.GC16434@localhost>
 <51EFA01B.30907@linux.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Giuseppe Longo <giuseppelng@gmail.com>,
	netfilter-devel@vger.kernel.org
To: Tomasz Bursztyka <tomasz.bursztyka@linux.intel.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:60039 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751149Ab3GXK4n (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 24 Jul 2013 06:56:43 -0400
Content-Disposition: inline
In-Reply-To: <51EFA01B.30907@linux.intel.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hi,

On Wed, Jul 24, 2013 at 12:36:27PM +0300, Tomasz Bursztyka wrote:
> Hi Pablo,
> 
> >>+int nft_init(struct nft_handle *h, struct builtin_table *t,
> >>>+	     const char *filename)
> >                          ^^^^^^^^
> >
> >why do we need this new parameter?
> >
> >The optional /etc/xtables.conf file should contain the definition for
> >all the families, that includes IPv4, IPv6, bridge and ARP.
> 
> My mistake, I advised that. Imho, it's not relevant to load
> everything for all families if the user is using only
> xtables-iptables for instance.
> 
> Then ok, let's have one file, but we could make a change in
> nft_xtables_config_load() so it would load only the tables of the
> current family.
> It's a quick fix to do actually.

Yes, that's the way to go.

> >>>  {
> >>>  	h->nl = mnl_socket_open(NETLINK_NETFILTER);
> >>>  	if (h->nl == NULL) {
> >>>@@ -388,6 +389,16 @@ int nft_init(struct nft_handle *h, struct builtin_table *t)
> >>>  	h->portid = mnl_socket_get_portid(h->nl);
> >>>  	h->tables = t;
> >>>  >+	/* If built-in chains don't exist for this table, create
> >>them */
> >>>+	if (nft_xtables_config_load(h, filename, 0) < 0) {
> >>>+		int i;
> >>>+
> >>>+		if (h->tables != NULL) {
> >>>+			for (i=0; i<TABLES_MAX; i++)
> >>>+				nft_chain_builtin_init(h, h->tables[i].name,
> >>>+						       NULL, NF_ACCEPT);
> >>>+		}
> >>>+	}
> >
> >I don't see what we get by moving nft_xtables_config_load here.
> 
> Why not calling this at only one unique place instead of multiple ones?
> You need to call that anyway currently as soon as you list/change
> the rule set.
> It's relevant to move that here, makes code clearer.

OK, but there are other chunks in this patch that are unclear to me:

@@ -1100,6 +1100,11 @@  int do_commandx(struct nft_handle *h, int
argc, char *argv[], char **table)
        if (h->ops == NULL)
                xtables_error(PARAMETER_PROBLEM, "Unknown family");
 
+       if (h->tables == NULL) {
+                if (nft_init(h, tables, XTABLES_CONFIG_DEFAULT) < 0)
+                        xtables_error(OTHER_PROBLEM, "Could not initialize nftables layer.");
+        }
+
        h->ops->post_parse(command, &cs, &args);
 
        if (command == CMD_REPLACE &&

By looking at patch 1, h->tables always point to some array of tables,
so that should always evaluates true.

Please, resolve all open issue and get back to me with a patch for
this if you think the time is worth to discuss this small
refactorization.

Thanks.
