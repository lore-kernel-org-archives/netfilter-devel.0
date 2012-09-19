From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH] conntrackd: make conntrackd namespace aware
Date: Wed, 19 Sep 2012 10:21:43 +0200
Message-ID: <20120919082143.GA20453@1984>
References: <1346461915-6309-1-git-send-email-aatteka@nicira.com>
 <20120906170253.GA17317@1984>
 <CAA=3Oq=G9g=9LkKxhobU1cTLtU3jyuGJZn4kn_E4LJXk11Escw@mail.gmail.com>
 <20120911154458.GB28012@1984>
 <CAA=3Oqm_tGgKpWf2V=Ki7Le-UcA7o_-_o+77TRjPX6-4RYha2Q@mail.gmail.com>
 <20120918192320.GA1182@1984>
 <CAA=3OqkaM_s4DEdL3D8tG5SCkRpubgzfw2a0snGZBGU0KD09Gg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="J/dobhs11T7y2rNN"
Cc: netfilter-devel@vger.kernel.org
To: Ansis Atteka <aatteka@nicira.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:47287 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752877Ab2ISIVv (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 19 Sep 2012 04:21:51 -0400
Content-Disposition: inline
In-Reply-To: <CAA=3OqkaM_s4DEdL3D8tG5SCkRpubgzfw2a0snGZBGU0KD09Gg@mail.gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


--J/dobhs11T7y2rNN
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Tue, Sep 18, 2012 at 03:36:54PM -0700, Ansis Atteka wrote:
> On Tue, Sep 18, 2012 at 12:23 PM, Pablo Neira Ayuso <pablo@netfilter.org> wrote:
> > On Thu, Sep 13, 2012 at 12:37:18AM -0700, Ansis Atteka wrote:
> > [...]
> >> I know that this would be a massive change, so I might miss
> >> something in the proposal. Anyway feel free to correct me or ask for
> >> more details where necessary. Here is a list of necessary changes:
> >>
> >> 1. Quite a lot of refactoring in configuration parser.
> >>
> >> I would suggest to split ct_conf struct into three logical pieces (i.e. smaller
> >> structs):
> >> a. channel config (instance per remote conntrackd instance)
> >> b. conntrack-state config (instance per namespace)
> >> c. static/global config (single instance; Would contain path to log
> >> file, unix socket e.t.c.)
> >
> > I always wanted to clean up ct_conf. See patch attached, I didn't
> > commit it yet since I want to give it some test (Please, not need to
> > rebase the patch we're currently discussing upon it).
>
> I don't see any patches attached.

Sorry, here it is.

> >> This decoupling would allow much more easily to maintain relation
> >> between conntrack-states and channels (for example, when multiple
> >> namespaces are using the same channel).
> >
> > I'm not familiar with the channel definition you're using.
>
> By "channel" I meant channel & channel_ops structures.
>
> > link abstraction (ie. TCP / UDP / MCAST / TIPC ...).
>
> I guess we are actually talking about the same thing.

OK, so what new channel do you need to add. What communication
primitive will it use?

> >> Also, currently CONFIG(X) macro allows to reference only a single ct_conf
> >> instance. This will need to be changed so that each namespace has its own
> >> ct_conf_sync instance. And each channel has its own ct_conf_channel instance.
> >>
> >> Also, I am afraid that, for this to make more sense, I would have to extend
> >> conntrackd.conf syntax, For example,introduce following top-level sections:
> >> channel {}, sync {} and global {} respectively.
> >>
> >> 2. Allow to add, remove and list configuration dynamically without
> >> restarting conntrackd. This would require ability to start conntrackd
> >> with minimal global/static configuration. After that add namespaces and
> >> channel configuration by using Unix Domain socket.
> >>
> >> For example, instead of starting conntrackd with following command:
> >> conntrackd -C /etc/conntrackd/conntrackd.conf
> >>
> >> One would have to use something like this:
> >> conntrackd --global-config /etc/conntrackd/conntrackd_global.conf #
> >> This config file would just specify Unix socket, log file e.t.c.
> >> and then on-the-fly add channel and namespace configuration with:
> >> conntrackd -U /var/run/conntrackd.ctl --add
> >> /etc/conntrackd/conntrackd_namespace1.conf
> >> conntrackd -U /var/run/conntrackd.ctl --add
> >> /etc/conntrackd/conntrackd_channel1.conf
> >> conntrackd -U /var/run/conntrackd.ctl --add
> >> /etc/conntrackd/conntrackd_namespace2.conf
> >> conntrackd -U /var/run/conntrackd.ctl --add
> >> /etc/conntrackd/conntrackd_channel2.conf
> >>
> >> We could glue namespaces together with channels by using some IDs.
> >>
> >> Another question is, whether over the Unix domain socket we would prefer to
> >> transfer binary (already parsed) or textual (yet unparsed) configuration?
> >>
> >> Also, I would need to figure out if/how to maintain backward compatibility with
> >> already existing commands, when there are multiple namespaces (e.g. dump
> >> internal cache, commit external cache ...).
> >>
> >> 3. Wire protocol format improvements, so that namespace ID would be encapsulated
> >> into the protocol too. This is required, when same channel is being
> >> used by multiple namespaces.
> >
> > This only requires adding one new TLV attribute to identify this. So
> > we don't need to bloat the header with one field that is not use.
>
> Here is how I am currently doing that:
> 
> struct nethdr {
> #if __BYTE_ORDER == __LITTLE_ENDIAN
> 	uint8_t type:4,
> 		version:4;
> #elif __BYTE_ORDER == __BIG_ENDIAN
> 	uint8_t version:4,
> 		type:4;
> #else
> #error  "Unknown system endianess!"
> #endif
> 	uint8_t flags;
> 	uint16_t len;
> 	uint32_t seq;
> 	uint32_t nsid; < -present only if nethdr.flag &
> };
> nsid is the namespace id. This field would be present only
> if nethdr.flags & NET_F_NAMESPACE != 0.

That adds an always zero field for the non-namespace case in the
protocol fixed header. TLVs can be used for optional fields.

> Could you please elaborate more on your suggested approach? If I
> understand it correctly, then you want to add the namespace id
> inside the data section that follows immediately after the nethdr
> structure as TLV variable?

Yes.

See enum nta_attr and add NTA_NAMESPACE and NTA_EXP_NAMESPACE. Then
implement that attribute in src/build.c and src/parse.c.

You can change msg2ct_alloc and msg2exp_alloc to return the netns
value:

struct nf_conntrack *msg2ct_alloc(struct nethdr *net, int remain, int *ns);

> Also, if I understand correctly, then after nethdr conntrackd
> simply transfers nf_conntrack struct (or the contents of cache
> object). I have had imagined that we should have cache table
> per namespace, so storing namespace id inside nf_conntrackd
> would become redundant.

You don't need to store in the struct nf_conntrack, you can slightly
generalize the parse function to:

static void
ns_parse_u32(void *data, int attr, void *data)
{
        int *ns = data;

        *ns = ntohl(*ns);
}

No need to always take struct nf_conntrack as first parameter. Then
msg2ct returns the namespace.

> What is your take on this?
>
> >
> >> 4. Similarly as CONFIG(x) was broken down into 3 logical pieces, the
> >> same thing would
> >> need to be done for STATE(x) macros.
> >
> > This seems to be a huge changeset what you're proposing.
> >
> > I need some convincing architecture example that describes how this
> > can be used before you submit such a big patch. I need to understand
> > it to know if there is a different way to make this.

Still waiting for the description of the big picture of the
architecture.

--J/dobhs11T7y2rNN
Content-Type: text/x-diff; charset=us-ascii
Content-Disposition: attachment; filename="0001-src-cleanup-struct-ct_conf.patch"

>From 6aa52c43f2babafa5ed842b5648e832e1544370d Mon Sep 17 00:00:00 2001
From: Pablo Neira Ayuso <pablo@netfilter.org>
Date: Thu, 13 Sep 2012 14:09:26 +0200
Subject: [PATCH] src: cleanup struct ct_conf

This patch reorganized the huge struct ct_conf and group
parameters by scope.

Some renaming were also done to use more descriptive names.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 include/conntrackd.h  |   74 ++++-----
 src/build.c           |    5 +-
 src/cache-ct.c        |   14 +-
 src/cache-exp.c       |   10 +-
 src/cache.c           |    7 +-
 src/cache_timer.c     |    4 +-
 src/channel.c         |    2 +-
 src/ctnl.c            |   46 +++---
 src/external_inject.c |    2 +-
 src/internal_bypass.c |    4 +-
 src/log.c             |   20 +--
 src/main.c            |   18 ++-
 src/netlink.c         |   39 +++--
 src/read_config_yy.y  |  416 +++++++++++++++++++++++++------------------------
 src/run.c             |   18 +--
 src/sync-alarm.c      |   13 +-
 src/sync-ftfw.c       |   10 +-
 src/sync-mode.c       |   30 ++--
 src/sync-notrack.c    |    2 +-
 19 files changed, 367 insertions(+), 367 deletions(-)

diff --git a/include/conntrackd.h b/include/conntrackd.h
index 19e613c..b4b4c51 100644
--- a/include/conntrackd.h
+++ b/include/conntrackd.h
@@ -85,51 +85,51 @@ union inet_address {
 #define CONFIG(x) conf.x
 
 struct ct_conf {
-	char logfile[FILENAME_MAXLEN];
-	int syslog_facility;
-	char lockfile[FILENAME_MAXLEN];
-	int hashsize;			/* hashtable size */
-	int channel_num;
-	int channel_default;
-	int channel_type_global;
-	struct channel_conf channel[MULTICHANNEL_MAX];
-	struct local_conf local;	/* unix socket facilities */
-	int nice;
-	int limit;
-	int refresh;
-	int cache_timeout;		/* cache entries timeout */
-	int commit_timeout;		/* committed entries timeout */
-	unsigned int purge_timeout;	/* purge kernel entries timeout */
-	unsigned int netlink_buffer_size;
-	unsigned int netlink_buffer_size_max_grown;
-	int nl_overrun_resync;
-	unsigned int flags;
-	int family;			/* protocol family */
-	unsigned int resend_queue_size; /* FTFW protocol */
-	unsigned int window_size;
-	int poll_kernel_secs;
-	int filter_from_kernelspace;
-	int event_iterations_limit;
 	struct {
-		int error_queue_length;
-	} channelc;
+		unsigned int flags;
+		int family;			/* protocol family */
+		char logfile[FILENAME_MAXLEN];
+		int syslog_facility;
+		char lockfile[FILENAME_MAXLEN];
+		int nice;
+		int sched_type;
+		int sched_prio;
+		struct local_conf local;	/* unix socket facilities */
+	} general;
 	struct {
-		int internal_cache_disable;
-		int external_cache_disable;
-		int tcp_window_tracking;
-	} sync;
+		int buckets;		/* number of buckets */
+		int max_entries;	/* maximum number of entries */
+	} hashtable;
+	struct {
+		int num;
+		int default_num;
+		int type;
+		struct channel_conf conf[MULTICHANNEL_MAX];
+		int error_queue_length;
+	} channel;
 	struct {
 		int subsys_id;
 		int groups;
 		int events_reliable;
-	} netlink;
-	struct {
+		int event_iterations_limit;
+		unsigned int buffer_size;
+		unsigned int buffer_size_max;
+		int overrun_resync;
 		int commit_steps;
-	} general;
+		int poll_secs;		    /* poll from kernel every X secs */
+		unsigned int purge_timeout; /* purge kernel entries timeout */
+		int filter_from_kernel;
+		int commit_timeout;	    /* committed entries timeout */
+	} nl;
 	struct {
-		int type;
-		int prio;
-	} sched;
+		int internal_cache_disable;	/* is internal cache enabled? */
+		int external_cache_disable;	/* is external cache enabled? */
+		int tcp_window_tracking;	/* is TCP tracking enabled? */
+		int alarm_timeout;		/* alarm protocol */
+		int alarm_refresh;		/* alarm protocol */
+		unsigned int resend_queue_size; /* FTFW protocol */
+		unsigned int window_size;	/* FTFW protocol */
+	} sync;
 	struct {
 		char logfile[FILENAME_MAXLEN];
 		int syslog_facility;
diff --git a/src/build.c b/src/build.c
index 7d4ef12..9c921c4 100644
--- a/src/build.c
+++ b/src/build.c
@@ -191,7 +191,7 @@ void ct2msg(const struct nf_conntrack *ct, struct nethdr *n)
 	if (l4proto_fcn[l4proto].build)
 		l4proto_fcn[l4proto].build(ct, n);
 
-	if (!CONFIG(commit_timeout) && nfct_attr_is_set(ct, ATTR_TIMEOUT))
+	if (!CONFIG(nl).commit_timeout && nfct_attr_is_set(ct, ATTR_TIMEOUT))
 		ct_build_u32(ct, ATTR_TIMEOUT, n, NTA_TIMEOUT);
 	if (nfct_attr_is_set(ct, ATTR_MARK))
 		ct_build_u32(ct, ATTR_MARK, n, NTA_MARK);
@@ -335,7 +335,8 @@ void exp2msg(const struct nf_expect *exp, struct nethdr *n)
 	if (exp_l4proto_fcn[l4proto].build)
 		exp_l4proto_fcn[l4proto].build(ct, n, NTA_EXP_MASK_PORT);
 
-	if (!CONFIG(commit_timeout) && nfexp_attr_is_set(exp, ATTR_EXP_TIMEOUT))
+	if (!CONFIG(nl).commit_timeout &&
+	    nfexp_attr_is_set(exp, ATTR_EXP_TIMEOUT))
 		exp_build_u32(exp, ATTR_EXP_TIMEOUT, n, NTA_EXP_TIMEOUT);
 
 	exp_build_u32(exp, ATTR_EXP_FLAGS, n, NTA_EXP_FLAGS);
diff --git a/src/cache-ct.c b/src/cache-ct.c
index 0ad8d2a..0cf8f2b 100644
--- a/src/cache-ct.c
+++ b/src/cache-ct.c
@@ -132,7 +132,7 @@ static int cache_ct_dump_step(void *data1, void *n)
 	 * 	specific and it breaks conntrackd modularity. Probably
 	 * 	there's a nicer way to do this but until I come up with it...
 	 */
-	if (CONFIG(flags) & CTD_SYNC_FTFW && obj->status == C_OBJ_DEAD)
+	if (CONFIG(general).flags & CTD_SYNC_FTFW && obj->status == C_OBJ_DEAD)
 		return 0;
 
 	/* do not show cached timeout, this may confuse users */
@@ -176,8 +176,8 @@ cache_ct_commit_step(struct __commit_container *tmp, struct cache_object *obj)
 	int ret, retry = 1, timeout;
 	struct nf_conntrack *ct = obj->ptr;
 
-	if (CONFIG(commit_timeout)) {
-		timeout = CONFIG(commit_timeout);
+	if (CONFIG(nl).commit_timeout) {
+		timeout = CONFIG(nl).commit_timeout;
 	} else {
 		timeout = time(NULL) - obj->lastupdate;
 		if (timeout < 0) {
@@ -263,9 +263,9 @@ static int cache_ct_commit(struct cache *c, struct nfct_handle *h, int clientfd)
 		STATE_SYNC(commit).current =
 			hashtable_iterate_limit(c->h, &tmp,
 						STATE_SYNC(commit).current,
-						CONFIG(general).commit_steps,
+						CONFIG(nl).commit_steps,
 						cache_ct_commit_master);
-		if (STATE_SYNC(commit).current < CONFIG(hashsize)) {
+		if (STATE_SYNC(commit).current < CONFIG(hashtable).buckets) {
 			STATE_SYNC(commit).state = COMMIT_STATE_MASTER;
 			/* give it another step as soon as possible */
 			write_evfd(STATE_SYNC(commit).evfd);
@@ -277,9 +277,9 @@ static int cache_ct_commit(struct cache *c, struct nfct_handle *h, int clientfd)
 		STATE_SYNC(commit).current =
 			hashtable_iterate_limit(c->h, &tmp,
 						STATE_SYNC(commit).current,
-						CONFIG(general).commit_steps,
+						CONFIG(nl).commit_steps,
 						cache_ct_commit_related);
-		if (STATE_SYNC(commit).current < CONFIG(hashsize)) {
+		if (STATE_SYNC(commit).current < CONFIG(hashtable).buckets) {
 			STATE_SYNC(commit).state = COMMIT_STATE_RELATED;
 			/* give it another step as soon as possible */
 			write_evfd(STATE_SYNC(commit).evfd);
diff --git a/src/cache-exp.c b/src/cache-exp.c
index e88877a..bbacf6d 100644
--- a/src/cache-exp.c
+++ b/src/cache-exp.c
@@ -132,7 +132,7 @@ static int cache_exp_dump_step(void *data1, void *n)
 	 *	specific and it breaks conntrackd modularity. Probably
 	 *	there's a nicer way to do this but until I come up with it...
 	 */
-	if (CONFIG(flags) & CTD_SYNC_FTFW && obj->status == C_OBJ_DEAD)
+	if (CONFIG(general).flags & CTD_SYNC_FTFW && obj->status == C_OBJ_DEAD)
 		return 0;
 
 	/* do not show cached timeout, this may confuse users */
@@ -172,8 +172,8 @@ static int cache_exp_commit_step(void *data, void *n)
 	int ret, retry = 1, timeout;
 	struct nf_expect *exp = obj->ptr;
 
-	if (CONFIG(commit_timeout)) {
-		timeout = CONFIG(commit_timeout);
+	if (CONFIG(nl).commit_timeout) {
+		timeout = CONFIG(nl).commit_timeout;
 	} else {
 		timeout = time(NULL) - obj->lastupdate;
 		if (timeout < 0) {
@@ -240,9 +240,9 @@ cache_exp_commit(struct cache *c, struct nfct_handle *h, int clientfd)
 		STATE_SYNC(commit).current =
 			hashtable_iterate_limit(c->h, &tmp,
 						STATE_SYNC(commit).current,
-						CONFIG(general).commit_steps,
+						CONFIG(nl).commit_steps,
 						cache_exp_commit_step);
-		if (STATE_SYNC(commit).current < CONFIG(hashsize)) {
+		if (STATE_SYNC(commit).current < CONFIG(hashtable).buckets) {
 			STATE_SYNC(commit).state = COMMIT_STATE_MASTER;
 			/* give it another step as soon as possible */
 			write_evfd(STATE_SYNC(commit).evfd);
diff --git a/src/cache.c b/src/cache.c
index 7c41e54..38ff2fa 100644
--- a/src/cache.c
+++ b/src/cache.c
@@ -98,10 +98,9 @@ struct cache *cache_create(const char *name, enum cache_type type,
 	}
 	c->ops = ops;
 
-	c->h = hashtable_create(CONFIG(hashsize),
-				CONFIG(limit),
-				c->ops->hash,
-				c->ops->cmp);
+	c->h = hashtable_create(CONFIG(hashtable).buckets,
+				CONFIG(hashtable).max_entries,
+				c->ops->hash, c->ops->cmp);
 	if (!c->h) {
 		free(c->features);
 		free(c->feature_offset);
diff --git a/src/cache_timer.c b/src/cache_timer.c
index 5881236..6d66351 100644
--- a/src/cache_timer.c
+++ b/src/cache_timer.c
@@ -35,13 +35,13 @@ static void timer_add(struct cache_object *obj, void *data)
 	struct alarm_block *a = data;
 
 	init_alarm(a, obj, timeout);
-	add_alarm(a, CONFIG(cache_timeout), 0);
+	add_alarm(a, CONFIG(sync).alarm_timeout, 0);
 }
 
 static void timer_update(struct cache_object *obj, void *data)
 {
 	struct alarm_block *a = data;
-	add_alarm(a, CONFIG(cache_timeout), 0);
+	add_alarm(a, CONFIG(sync).alarm_timeout, 0);
 }
 
 static void timer_destroy(struct cache_object *obj, void *data)
diff --git a/src/channel.c b/src/channel.c
index 8b7c319..ce674f0 100644
--- a/src/channel.c
+++ b/src/channel.c
@@ -33,7 +33,7 @@ int channel_init(void)
 	ops[CHANNEL_UDP] = &channel_udp;
 	ops[CHANNEL_TCP] = &channel_tcp;
 
-	errorq = queue_create("errorq", CONFIG(channelc).error_queue_length, 0);
+	errorq = queue_create("errorq", CONFIG(channel).error_queue_length, 0);
 	if (errorq == NULL) {
 		return -1;
 	}
diff --git a/src/ctnl.c b/src/ctnl.c
index bb54727..e7a44d7 100644
--- a/src/ctnl.c
+++ b/src/ctnl.c
@@ -41,7 +41,7 @@
 
 void ctnl_kill(void)
 {
-	if (!(CONFIG(flags) & CTD_POLL))
+	if (!(CONFIG(general).flags & CTD_POLL))
 		nfct_close(STATE(event));
 
 	nfct_close(STATE(resync));
@@ -85,7 +85,7 @@ static void local_resync_master(void)
 
 static void local_exp_flush_master(void)
 {
-	if (!(CONFIG(flags) & CTD_EXPECT))
+	if (!(CONFIG(general).flags & CTD_EXPECT))
 		return;
 
 	STATE(stats).nl_kernel_table_flush++;
@@ -102,7 +102,7 @@ static void local_exp_flush_master(void)
 
 static void local_exp_resync_master(void)
 {
-	if (!(CONFIG(flags) & CTD_EXPECT))
+	if (!(CONFIG(general).flags & CTD_EXPECT))
 		return;
 
 	if (STATE(mode)->internal->flags & INTERNAL_F_POPULATE) {
@@ -164,10 +164,10 @@ static void do_polling_alarm(struct alarm_block *a, void *data)
 		STATE(mode)->internal->exp.purge();
 
 	nl_send_resync(STATE(resync));
-	if (CONFIG(flags) & CTD_EXPECT)
+	if (CONFIG(general).flags & CTD_EXPECT)
 		nl_send_expect_resync(STATE(resync));
 
-	add_alarm(&STATE(polling_alarm), CONFIG(poll_kernel_secs), 0);
+	add_alarm(&STATE(polling_alarm), CONFIG(nl).poll_secs, 0);
 }
 
 static int event_handler(const struct nlmsghdr *nlh,
@@ -180,7 +180,7 @@ static int event_handler(const struct nlmsghdr *nlh,
 	STATE(stats).nl_events_received++;
 
 	/* skip user-space filtering if already do it in the kernel */
-	if (ct_filter_conntrack(ct, !CONFIG(filter_from_kernelspace))) {
+	if (ct_filter_conntrack(ct, !CONFIG(nl).filter_from_kernel)) {
 		STATE(stats).nl_events_filtered++;
 		goto out;
 	}
@@ -329,7 +329,7 @@ static void event_cb(void *data)
 
 	ret = nfct_catch(STATE(event));
 	/* reset event iteration limit counter */
-	STATE(event_iterations_limit) = CONFIG(event_iterations_limit);
+	STATE(event_iterations_limit) = CONFIG(nl).event_iterations_limit;
 	if (ret == -1) {
 		switch(errno) {
 		case ENOBUFS:
@@ -359,10 +359,10 @@ static void event_cb(void *data)
 			 *    we resync ourselves.
 			 */
 			nl_resize_socket_buffer(STATE(event));
-			if (CONFIG(nl_overrun_resync) > 0 &&
+			if (CONFIG(nl).overrun_resync > 0 &&
 			    STATE(mode)->internal->flags & INTERNAL_F_RESYNC) {
 				add_alarm(&STATE(resync_alarm),
-					  CONFIG(nl_overrun_resync),0);
+					  CONFIG(nl).overrun_resync, 0);
 			}
 			STATE(stats).nl_catch_event_failed++;
 			STATE(stats).nl_overrun++;
@@ -399,14 +399,14 @@ static void poll_cb(void *data)
 
 int ctnl_init(void)
 {
-	if (CONFIG(flags) & CTD_STATS_MODE)
+	if (CONFIG(general).flags & CTD_STATS_MODE)
 		STATE(mode) = &stats_mode;
-	else if (CONFIG(flags) & CTD_SYNC_MODE)
+	else if (CONFIG(general).flags & CTD_SYNC_MODE)
 		STATE(mode) = &sync_mode;
 	else {
 		fprintf(stderr, "WARNING: No running mode specified. "
 				"Defaulting to statistics mode.\n");
-		CONFIG(flags) |= CTD_STATS_MODE;
+		CONFIG(general).flags |= CTD_STATS_MODE;
 		STATE(mode) = &stats_mode;
 	}
 
@@ -417,7 +417,7 @@ int ctnl_init(void)
 	}
 
 	/* resynchronize (like 'dump' socket) but it also purges old entries */
-	STATE(resync) = nfct_open(CONFIG(netlink).subsys_id, 0);
+	STATE(resync) = nfct_open(CONFIG(nl).subsys_id, 0);
 	if (STATE(resync)== NULL) {
 		dlog(LOG_ERR, "can't open netlink handler: %s",
 		     strerror(errno));
@@ -428,7 +428,7 @@ int ctnl_init(void)
 			       NFCT_T_ALL,
 			       STATE(mode)->internal->ct.resync,
 			       NULL);
-	if (CONFIG(flags) & CTD_POLL) {
+	if (CONFIG(general).flags & CTD_POLL) {
 		register_fd(nfct_fd(STATE(resync)), poll_cb,
 				NULL, STATE(fds));
 	} else {
@@ -438,7 +438,7 @@ int ctnl_init(void)
 	fcntl(nfct_fd(STATE(resync)), F_SETFL, O_NONBLOCK);
 
 	if (STATE(mode)->internal->flags & INTERNAL_F_POPULATE) {
-		STATE(dump) = nfct_open(CONFIG(netlink).subsys_id, 0);
+		STATE(dump) = nfct_open(CONFIG(nl).subsys_id, 0);
 		if (STATE(dump) == NULL) {
 			dlog(LOG_ERR, "can't open netlink handler: %s",
 			     strerror(errno));
@@ -448,7 +448,7 @@ int ctnl_init(void)
 		nfct_callback_register(STATE(dump), NFCT_T_ALL,
 				       dump_handler, NULL);
 
-		if (CONFIG(flags) & CTD_EXPECT) {
+		if (CONFIG(general).flags & CTD_EXPECT) {
 			nfexp_callback_register(STATE(dump), NFCT_T_ALL,
 						exp_dump_handler, NULL);
 		}
@@ -458,7 +458,7 @@ int ctnl_init(void)
 			return -1;
 		}
 
-		if (CONFIG(flags) & CTD_EXPECT) {
+		if (CONFIG(general).flags & CTD_EXPECT) {
 			if (nl_dump_expect_table(STATE(dump)) == -1) {
 				dlog(LOG_ERR, "can't get kernel "
 					      "expect table");
@@ -467,7 +467,7 @@ int ctnl_init(void)
 		}
 	}
 
-	STATE(get) = nfct_open(CONFIG(netlink).subsys_id, 0);
+	STATE(get) = nfct_open(CONFIG(nl).subsys_id, 0);
 	if (STATE(get) == NULL) {
 		dlog(LOG_ERR, "can't open netlink handler: %s",
 		     strerror(errno));
@@ -476,12 +476,12 @@ int ctnl_init(void)
 	}
 	nfct_callback_register(STATE(get), NFCT_T_ALL, get_handler, NULL);
 
-	if (CONFIG(flags) & CTD_EXPECT) {
+	if (CONFIG(general).flags & CTD_EXPECT) {
 		nfexp_callback_register(STATE(get), NFCT_T_ALL,
 					exp_get_handler, NULL);
 	}
 
-	STATE(flush) = nfct_open(CONFIG(netlink).subsys_id, 0);
+	STATE(flush) = nfct_open(CONFIG(nl).subsys_id, 0);
 	if (STATE(flush) == NULL) {
 		dlog(LOG_ERR, "cannot open flusher handler");
 		return -1;
@@ -489,9 +489,9 @@ int ctnl_init(void)
 	/* register this handler as the origin of a flush operation */
 	origin_register(STATE(flush), CTD_ORIGIN_FLUSH);
 
-	if (CONFIG(flags) & CTD_POLL) {
+	if (CONFIG(general).flags & CTD_POLL) {
 		init_alarm(&STATE(polling_alarm), NULL, do_polling_alarm);
-		add_alarm(&STATE(polling_alarm), CONFIG(poll_kernel_secs), 0);
+		add_alarm(&STATE(polling_alarm), CONFIG(nl).poll_secs, 0);
 		dlog(LOG_NOTICE, "running in polling mode");
 	} else {
 		init_alarm(&STATE(resync_alarm), NULL, do_overrun_resync_alarm);
@@ -513,7 +513,7 @@ int ctnl_init(void)
 		nfct_callback_register2(STATE(event), NFCT_T_ALL,
 				        event_handler, NULL);
 
-		if (CONFIG(flags) & CTD_EXPECT) {
+		if (CONFIG(general).flags & CTD_EXPECT) {
 			nfexp_callback_register2(STATE(event), NFCT_T_ALL,
 						 exp_event_handler, NULL);
 		}
diff --git a/src/external_inject.c b/src/external_inject.c
index 0ad3478..1e9b759 100644
--- a/src/external_inject.c
+++ b/src/external_inject.c
@@ -42,7 +42,7 @@ struct {
 static int external_inject_init(void)
 {
 	/* handler to directly inject conntracks into kernel-space */
-	inject = nfct_open(CONFIG(netlink).subsys_id, 0);
+	inject = nfct_open(CONFIG(nl).subsys_id, 0);
 	if (inject == NULL) {
 		dlog(LOG_ERR, "can't open netlink handler: %s",
 		     strerror(errno));
diff --git a/src/internal_bypass.c b/src/internal_bypass.c
index 1194339..7aed9f7 100644
--- a/src/internal_bypass.c
+++ b/src/internal_bypass.c
@@ -52,7 +52,7 @@ static void internal_bypass_ct_dump(int fd, int type)
 	u_int32_t family = AF_UNSPEC;
 	int ret;
 
-	h = nfct_open(CONFIG(netlink).subsys_id, 0);
+	h = nfct_open(CONFIG(nl).subsys_id, 0);
 	if (h == NULL) {
 		dlog(LOG_ERR, "can't allocate memory for the internal cache");
 		return;
@@ -183,7 +183,7 @@ static void internal_bypass_exp_dump(int fd, int type)
 	u_int32_t family = AF_UNSPEC;
 	int ret;
 
-	h = nfct_open(CONFIG(netlink).subsys_id, 0);
+	h = nfct_open(CONFIG(nl).subsys_id, 0);
 	if (h == NULL) {
 		dlog(LOG_ERR, "can't allocate memory for the internal cache");
 		return;
diff --git a/src/log.c b/src/log.c
index d4de111..7dbdfe8 100644
--- a/src/log.c
+++ b/src/log.c
@@ -29,11 +29,11 @@
 
 int init_log(void)
 {
-	if (CONFIG(logfile)[0]) {
-		STATE(log) = fopen(CONFIG(logfile), "a+");
+	if (CONFIG(general).logfile[0]) {
+		STATE(log) = fopen(CONFIG(general).logfile, "a+");
 		if (STATE(log) == NULL) {
 			fprintf(stderr, "ERROR: can't open logfile `%s'."
-				"Reason: %s\n", CONFIG(logfile), 
+				"Reason: %s\n", CONFIG(general).logfile,
 						strerror(errno));
 			return -1;
 		}
@@ -45,7 +45,7 @@ int init_log(void)
 		STATE(stats_log) = fopen(CONFIG(stats).logfile, "a+");
 		if (STATE(stats_log) == NULL) {
 			fprintf(stderr, "ERROR: can't open logfile `%s'."
-				"Reason: %s\n", CONFIG(stats).logfile, 
+				"Reason: %s\n", CONFIG(stats).logfile,
 						strerror(errno));
 			return -1;
 		}
@@ -53,9 +53,9 @@ int init_log(void)
 		setlinebuf(STATE(stats_log));
 	}
 
-	if (CONFIG(syslog_facility) != -1 || 
+	if (CONFIG(general).syslog_facility != -1 ||
 	    CONFIG(stats).syslog_facility != -1)
-		openlog(PACKAGE, LOG_PID, CONFIG(syslog_facility));
+		openlog(PACKAGE, LOG_PID, CONFIG(general).syslog_facility);
 
 	return 0;
 }
@@ -97,7 +97,7 @@ void dlog(int priority, const char *format, ...)
 		fflush(fd);
 	}
 
-	if (CONFIG(syslog_facility) != -1) {
+	if (CONFIG(general).syslog_facility != -1) {
 		va_start(args, format);
 		vsyslog(priority, format, args);
 		va_end(args);
@@ -136,7 +136,7 @@ void dlog_ct(FILE *fd, struct nf_conntrack *ct, unsigned int type)
 
 	if (fd == STATE(log)) {
 		/* error reporting */
-		if (CONFIG(syslog_facility) != -1)
+		if (CONFIG(general).syslog_facility != -1)
 			syslog(LOG_ERR, "%s", tmp);
 	} else if (fd == STATE(stats_log)) {
 		/* connection logging */
@@ -173,7 +173,7 @@ void dlog_exp(FILE *fd, struct nf_expect *exp, unsigned int type)
 
 	if (fd == STATE(log)) {
 		/* error reporting */
-		if (CONFIG(syslog_facility) != -1)
+		if (CONFIG(general).syslog_facility != -1)
 			syslog(LOG_ERR, "%s", tmp);
 	} else if (fd == STATE(stats_log)) {
 		/* connection logging */
@@ -190,7 +190,7 @@ void close_log(void)
 	if (STATE(stats_log) != NULL)
 		fclose(STATE(stats_log));
 
-	if (CONFIG(syslog_facility) != -1 || 
+	if (CONFIG(general).syslog_facility != -1 ||
 	    CONFIG(stats).syslog_facility != -1)
 		closelog();
 }
diff --git a/src/main.c b/src/main.c
index 831a3c2..33abd1d 100644
--- a/src/main.c
+++ b/src/main.c
@@ -328,7 +328,8 @@ int main(int argc, char *argv[])
 	}
 
 	if (type == REQUEST) {
-		if (do_local_request(action, &conf.local, local_step) == -1) {
+		if (do_local_request(action, &CONFIG(general).local,
+							local_step) == -1) {
 			fprintf(stderr, "can't connect: is conntrackd "
 					"running? appropriate permissions?\n");
 			exit(EXIT_FAILURE);
@@ -345,10 +346,10 @@ int main(int argc, char *argv[])
 	/*
 	 * lock file
 	 */
-	ret = open(CONFIG(lockfile), O_CREAT | O_EXCL | O_TRUNC, 0600);
+	ret = open(CONFIG(general).lockfile, O_CREAT | O_EXCL | O_TRUNC, 0600);
 	if (ret == -1) {
 		fprintf(stderr, "lockfile `%s' exists, perhaps conntrackd "
-			        "already running?\n", CONFIG(lockfile));
+			        "already running?\n", CONFIG(general).lockfile);
 		exit(EXIT_FAILURE);
 	}
 	close(ret);
@@ -356,14 +357,15 @@ int main(int argc, char *argv[])
 	/*
 	 * Setting process priority and scheduler
 	 */
-	nice(CONFIG(nice));
+	nice(CONFIG(general).nice);
 
-	if (CONFIG(sched).type != SCHED_OTHER) {
+	if (CONFIG(general).sched_type != SCHED_OTHER) {
 		struct sched_param schedparam = {
-			.sched_priority = CONFIG(sched).prio,
+			.sched_priority = CONFIG(general).sched_prio,
 		};
 
-		ret = sched_setscheduler(0, CONFIG(sched).type, &schedparam);
+		ret = sched_setscheduler(0, CONFIG(general).sched_type,
+					 &schedparam);
 		if (ret == -1) {
 			perror("sched");
 			exit(EXIT_FAILURE);
@@ -378,7 +380,7 @@ int main(int argc, char *argv[])
 		close_log();
 		fprintf(stderr, "ERROR: conntrackd cannot start, please "
 				"check the logfile for more info\n");
-		unlink(CONFIG(lockfile));
+		unlink(CONFIG(general).lockfile);
 		exit(EXIT_FAILURE);
 	}
 
diff --git a/src/netlink.c b/src/netlink.c
index bd38d99..6ae7b53 100644
--- a/src/netlink.c
+++ b/src/netlink.c
@@ -33,11 +33,11 @@ struct nfct_handle *nl_init_event_handler(void)
 {
 	struct nfct_handle *h;
 
-	h = nfct_open(CONFIG(netlink).subsys_id, CONFIG(netlink).groups);
+	h = nfct_open(CONFIG(nl).subsys_id, CONFIG(nl).groups);
 	if (h == NULL)
 		return NULL;
 
-	if (CONFIG(netlink).events_reliable) {
+	if (CONFIG(nl).events_reliable) {
 		int on = 1;
 
 		setsockopt(nfct_fd(h), SOL_NETLINK,
@@ -51,7 +51,7 @@ struct nfct_handle *nl_init_event_handler(void)
 	}
 
 	if (STATE(filter)) {
-		if (CONFIG(filter_from_kernelspace)) {
+		if (CONFIG(nl).filter_from_kernel) {
 			if (nfct_filter_attach(nfct_fd(h),
 					       STATE(filter)) == -1) {
 				dlog(LOG_ERR, "cannot set event filtering: %s",
@@ -67,13 +67,12 @@ struct nfct_handle *nl_init_event_handler(void)
 	fcntl(nfct_fd(h), F_SETFL, O_NONBLOCK);
 
 	/* set up socket buffer size */
-	if (CONFIG(netlink_buffer_size) &&
-	    CONFIG(netlink_buffer_size) <=
-			CONFIG(netlink_buffer_size_max_grown)) {
+	if (CONFIG(nl).buffer_size &&
+	    CONFIG(nl).buffer_size <= CONFIG(nl).buffer_size_max) {
 		/* we divide netlink_buffer_size by 2 here since value passed
 		   to kernel gets doubled in SO_RCVBUF; see net/core/sock.c */
-		CONFIG(netlink_buffer_size) =
-		  nfnl_rcvbufsiz(nfct_nfnlh(h), CONFIG(netlink_buffer_size)/2);
+		CONFIG(nl).buffer_size =
+		  nfnl_rcvbufsiz(nfct_nfnlh(h), CONFIG(nl).buffer_size/2);
 	} else {
 		dlog(LOG_NOTICE, "NetlinkBufferSize is either not set or "
 				 "is greater than NetlinkBufferSizeMaxGrowth. "
@@ -86,11 +85,11 @@ struct nfct_handle *nl_init_event_handler(void)
 		getsockopt(nfct_fd(h), SOL_SOCKET,
 			   SO_RCVBUF, &read_size, &socklen);
 
-		CONFIG(netlink_buffer_size) = read_size;
+		CONFIG(nl).buffer_size = read_size;
 	}
 
 	dlog(LOG_NOTICE, "netlink event socket buffer size has been set "
-			 "to %u bytes", CONFIG(netlink_buffer_size));
+			 "to %u bytes", CONFIG(nl).buffer_size);
 
 	return h;
 }
@@ -115,7 +114,7 @@ static int warned = 0;
 
 void nl_resize_socket_buffer(struct nfct_handle *h)
 {
-	unsigned int s = CONFIG(netlink_buffer_size);
+	unsigned int s = CONFIG(nl).buffer_size;
 
 	/* already warned that we have reached the maximum buffer size */
 	if (warned)
@@ -124,7 +123,7 @@ void nl_resize_socket_buffer(struct nfct_handle *h)
 	/* since sock_setsockopt in net/core/sock.c doubles the size of socket
 	   buffer passed to it using nfnl_rcvbufsiz, only call nfnl_rcvbufsiz
 	   if new value is not greater than netlink_buffer_size_max_grown */
-	if (s*2 > CONFIG(netlink_buffer_size_max_grown)) {
+	if (s*2 > CONFIG(nl).buffer_size_max) {
 		dlog(LOG_WARNING,
 		     "netlink event socket buffer size cannot "
 		     "be doubled further since it will exceed "
@@ -139,16 +138,16 @@ void nl_resize_socket_buffer(struct nfct_handle *h)
 		return;
 	}
 
-	CONFIG(netlink_buffer_size) = nfnl_rcvbufsiz(nfct_nfnlh(h), s);
+	CONFIG(nl).buffer_size = nfnl_rcvbufsiz(nfct_nfnlh(h), s);
 
 	/* notify the sysadmin */
 	dlog(LOG_NOTICE, "netlink event socket buffer size has been doubled "
-			 "to %u bytes", CONFIG(netlink_buffer_size));
+			 "to %u bytes", CONFIG(nl).buffer_size);
 }
 
 int nl_dump_conntrack_table(struct nfct_handle *h)
 {
-	return nfct_query(h, NFCT_Q_DUMP, &CONFIG(family));
+	return nfct_query(h, NFCT_Q_DUMP, &CONFIG(general).family);
 }
 
 static int
@@ -182,7 +181,7 @@ int nl_flush_conntrack_table_selective(void)
 	}
 	nfct_callback_register(h, NFCT_T_ALL, nl_flush_selective_cb, NULL);
 
-	ret = nfct_query(h, NFCT_Q_DUMP, &CONFIG(family));
+	ret = nfct_query(h, NFCT_Q_DUMP, &CONFIG(general).family);
 
 	nfct_close(h);
 
@@ -191,7 +190,7 @@ int nl_flush_conntrack_table_selective(void)
 
 int nl_send_resync(struct nfct_handle *h)
 {
-	int family = CONFIG(family);
+	int family = CONFIG(general).family;
 	return nfct_send(h, NFCT_Q_DUMP, &family);
 }
 
@@ -380,16 +379,16 @@ int nl_get_expect(struct nfct_handle *h, const struct nf_expect *exp)
 
 int nl_dump_expect_table(struct nfct_handle *h)
 {
-	return nfexp_query(h, NFCT_Q_DUMP, &CONFIG(family));
+	return nfexp_query(h, NFCT_Q_DUMP, &CONFIG(general).family);
 }
 
 int nl_flush_expect_table(struct nfct_handle *h)
 {
-	return nfexp_query(h, NFCT_Q_FLUSH, &CONFIG(family));
+	return nfexp_query(h, NFCT_Q_FLUSH, &CONFIG(general).family);
 }
 
 int nl_send_expect_resync(struct nfct_handle *h)
 {
-	int family = CONFIG(family);
+	int family = CONFIG(general).family;
 	return nfexp_send(h, NFCT_Q_DUMP, &family);
 }
diff --git a/src/read_config_yy.y b/src/read_config_yy.y
index 72a9654..cccbb37 100644
--- a/src/read_config_yy.y
+++ b/src/read_config_yy.y
@@ -116,7 +116,7 @@ line : ignore_protocol
 
 logfile_bool : T_LOG T_ON
 {
-	strncpy(conf.logfile, DEFAULT_LOGFILE, FILENAME_MAXLEN);
+	strncpy(CONFIG(general).logfile, DEFAULT_LOGFILE, FILENAME_MAXLEN);
 };
 
 logfile_bool : T_LOG T_OFF
@@ -125,54 +125,54 @@ logfile_bool : T_LOG T_OFF
 
 logfile_path : T_LOG T_PATH_VAL
 {
-	strncpy(conf.logfile, $2, FILENAME_MAXLEN);
+	strncpy(CONFIG(general).logfile, $2, FILENAME_MAXLEN);
 };
 
 syslog_bool : T_SYSLOG T_ON
 {
-	conf.syslog_facility = DEFAULT_SYSLOG_FACILITY;
+	CONFIG(general).syslog_facility = DEFAULT_SYSLOG_FACILITY;
 };
 
 syslog_bool : T_SYSLOG T_OFF
 {
-	conf.syslog_facility = -1;
+	CONFIG(general).syslog_facility = -1;
 }
 
 syslog_facility : T_SYSLOG T_STRING
 {
 	if (!strcmp($2, "daemon"))
-		conf.syslog_facility = LOG_DAEMON;
+		CONFIG(general).syslog_facility = LOG_DAEMON;
 	else if (!strcmp($2, "local0"))
-		conf.syslog_facility = LOG_LOCAL0;
+		CONFIG(general).syslog_facility = LOG_LOCAL0;
 	else if (!strcmp($2, "local1"))
-		conf.syslog_facility = LOG_LOCAL1;
+		CONFIG(general).syslog_facility = LOG_LOCAL1;
 	else if (!strcmp($2, "local2"))
-		conf.syslog_facility = LOG_LOCAL2;
+		CONFIG(general).syslog_facility = LOG_LOCAL2;
 	else if (!strcmp($2, "local3"))
-		conf.syslog_facility = LOG_LOCAL3;
+		CONFIG(general).syslog_facility = LOG_LOCAL3;
 	else if (!strcmp($2, "local4"))
-		conf.syslog_facility = LOG_LOCAL4;
+		CONFIG(general).syslog_facility = LOG_LOCAL4;
 	else if (!strcmp($2, "local5"))
-		conf.syslog_facility = LOG_LOCAL5;
+		CONFIG(general).syslog_facility = LOG_LOCAL5;
 	else if (!strcmp($2, "local6"))
-		conf.syslog_facility = LOG_LOCAL6;
+		CONFIG(general).syslog_facility = LOG_LOCAL6;
 	else if (!strcmp($2, "local7"))
-		conf.syslog_facility = LOG_LOCAL7;
+		CONFIG(general).syslog_facility = LOG_LOCAL7;
 	else {
 		print_err(CTD_CFG_WARN, "'%s' is not a known syslog facility, "
 					"ignoring", $2);
 		break;
 	}
 
-	if (conf.stats.syslog_facility != -1 &&
-	    conf.syslog_facility != conf.stats.syslog_facility)
+	if (CONFIG(stats).syslog_facility != -1 &&
+	    CONFIG(general).syslog_facility != CONFIG(stats).syslog_facility)
 	    	print_err(CTD_CFG_WARN, "conflicting Syslog facility "
 					"values, defaulting to General");
 };
 
 lock : T_LOCK T_PATH_VAL
 {
-	strncpy(conf.lockfile, $2, FILENAME_MAXLEN);
+	strncpy(CONFIG(general).lockfile, $2, FILENAME_MAXLEN);
 };
 
 strip_nat: T_STRIP_NAT
@@ -182,22 +182,22 @@ strip_nat: T_STRIP_NAT
 
 refreshtime : T_REFRESH T_NUMBER
 {
-	conf.refresh = $2;
+	CONFIG(sync).alarm_refresh = $2;
 };
 
 expiretime: T_EXPIRE T_NUMBER
 {
-	conf.cache_timeout = $2;
+	CONFIG(sync).alarm_timeout = $2;
 };
 
 timeout: T_TIMEOUT T_NUMBER
 {
-	conf.commit_timeout = $2;
+	CONFIG(nl).commit_timeout = $2;
 };
 
 purge: T_PURGE T_NUMBER
 {
-	conf.purge_timeout = $2;
+	CONFIG(nl).purge_timeout = $2;
 };
 
 checksum: T_CHECKSUM T_ON 
@@ -208,7 +208,7 @@ checksum: T_CHECKSUM T_ON
 	 * XXX: The use of Checksum outside of the Multicast clause is broken
 	 *	if we have more than one dedicated links.
 	 */
-	conf.channel[0].u.mcast.checksum = 0;
+	CONFIG(channel).conf[0].u.mcast.checksum = 0;
 };
 
 checksum: T_CHECKSUM T_OFF
@@ -219,7 +219,7 @@ checksum: T_CHECKSUM T_OFF
 	 * XXX: The use of Checksum outside of the Multicast clause is broken
 	 *	if we have more than one dedicated links.
 	 */
-	conf.channel[0].u.mcast.checksum = 1;
+	CONFIG(channel).conf[0].u.mcast.checksum = 1;
 };
 
 ignore_traffic : T_IGNORE_TRAFFIC '{' ignore_traffic_options '}'
@@ -285,32 +285,32 @@ ignore_traffic_option : T_IPV6_ADDR T_IP
 
 multicast_line : T_MULTICAST '{' multicast_options '}'
 {
-	if (conf.channel_type_global != CHANNEL_NONE &&
-	    conf.channel_type_global != CHANNEL_MCAST) {
+	if (CONFIG(channel).type != CHANNEL_NONE &&
+	    CONFIG(channel).type != CHANNEL_MCAST) {
 		print_err(CTD_CFG_ERROR, "cannot use `Multicast' with other "
 					 "dedicated link protocols!");
 		exit(EXIT_FAILURE);
 	}
-	conf.channel_type_global = CHANNEL_MCAST;
-	conf.channel[conf.channel_num].channel_type = CHANNEL_MCAST;
-	conf.channel[conf.channel_num].channel_flags = CHANNEL_F_BUFFERED;
-	conf.channel_num++;
+	CONFIG(channel).type = CHANNEL_MCAST;
+	CONFIG(channel).conf[CONFIG(channel).num].channel_type = CHANNEL_MCAST;
+	CONFIG(channel).conf[CONFIG(channel).num].channel_flags = CHANNEL_F_BUFFERED;
+	CONFIG(channel).num++;
 };
 
 multicast_line : T_MULTICAST T_DEFAULT '{' multicast_options '}'
 {
-	if (conf.channel_type_global != CHANNEL_NONE &&
-	    conf.channel_type_global != CHANNEL_MCAST) {
+	if (CONFIG(channel).type != CHANNEL_NONE &&
+	    CONFIG(channel).type != CHANNEL_MCAST) {
 		print_err(CTD_CFG_ERROR, "cannot use `Multicast' with other "
 					 "dedicated link protocols!");
 		exit(EXIT_FAILURE);
 	}
-	conf.channel_type_global = CHANNEL_MCAST;
-	conf.channel[conf.channel_num].channel_type = CHANNEL_MCAST;
-	conf.channel[conf.channel_num].channel_flags = CHANNEL_F_DEFAULT |
+	CONFIG(channel).type = CHANNEL_MCAST;
+	CONFIG(channel).conf[CONFIG(channel).num].channel_type = CHANNEL_MCAST;
+	CONFIG(channel).conf[CONFIG(channel).num].channel_flags = CHANNEL_F_DEFAULT |
 						       CHANNEL_F_BUFFERED;
-	conf.channel_default = conf.channel_num;
-	conf.channel_num++;
+	CONFIG(channel).default_num = CONFIG(channel).num;
+	CONFIG(channel).num++;
 };
 
 multicast_options :
@@ -320,19 +320,19 @@ multicast_option : T_IPV4_ADDR T_IP
 {
 	__max_dedicated_links_reached();
 
-	if (!inet_aton($2, &conf.channel[conf.channel_num].u.mcast.in)) {
+	if (!inet_aton($2, &CONFIG(channel).conf[CONFIG(channel).num].u.mcast.in)) {
 		print_err(CTD_CFG_WARN, "%s is not a valid IPv4 address", $2);
 		break;
 	}
 
-        if (conf.channel[conf.channel_num].u.mcast.ipproto == AF_INET6) {
+        if (CONFIG(channel).conf[CONFIG(channel).num].u.mcast.ipproto == AF_INET6) {
 		print_err(CTD_CFG_WARN, "your multicast address is IPv4 but "
 					"is binded to an IPv6 interface? "
 					"Surely, this is not what you want");
 		break;
 	}
 
-	conf.channel[conf.channel_num].u.mcast.ipproto = AF_INET;
+	CONFIG(channel).conf[CONFIG(channel).num].u.mcast.ipproto = AF_INET;
 };
 
 multicast_option : T_IPV6_ADDR T_IP
@@ -341,7 +341,7 @@ multicast_option : T_IPV6_ADDR T_IP
 
 #ifdef HAVE_INET_PTON_IPV6
 	if (inet_pton(AF_INET6, $2,
-		      &conf.channel[conf.channel_num].u.mcast.in) <= 0) {
+		      &CONFIG(channel).conf[CONFIG(channel).num].u.mcast.in) <= 0) {
 		print_err(CTD_CFG_WARN, "%s is not a valid IPv6 address", $2);
 		break;
 	}
@@ -350,17 +350,17 @@ multicast_option : T_IPV6_ADDR T_IP
 	break;
 #endif
 
-	if (conf.channel[conf.channel_num].u.mcast.ipproto == AF_INET) {
+	if (CONFIG(channel).conf[CONFIG(channel).num].u.mcast.ipproto == AF_INET) {
 		print_err(CTD_CFG_WARN, "your multicast address is IPv6 but "
 					"is binded to an IPv4 interface? "
 					"Surely this is not what you want");
 		break;
 	}
 
-	conf.channel[conf.channel_num].u.mcast.ipproto = AF_INET6;
+	CONFIG(channel).conf[CONFIG(channel).num].u.mcast.ipproto = AF_INET6;
 
-	if (conf.channel[conf.channel_num].channel_ifname[0] &&
-	    !conf.channel[conf.channel_num].u.mcast.ifa.interface_index6) {
+	if (CONFIG(channel).conf[CONFIG(channel).num].channel_ifname[0] &&
+	    !CONFIG(channel).conf[CONFIG(channel).num].u.mcast.ifa.interface_index6) {
 		unsigned int idx;
 
 		idx = if_nametoindex($2);
@@ -370,8 +370,8 @@ multicast_option : T_IPV6_ADDR T_IP
 			break;
 		}
 
-		conf.channel[conf.channel_num].u.mcast.ifa.interface_index6 = idx;
-		conf.channel[conf.channel_num].u.mcast.ipproto = AF_INET6;
+		CONFIG(channel).conf[CONFIG(channel).num].u.mcast.ifa.interface_index6 = idx;
+		CONFIG(channel).conf[CONFIG(channel).num].u.mcast.ipproto = AF_INET6;
 	}
 };
 
@@ -379,19 +379,19 @@ multicast_option : T_IPV4_IFACE T_IP
 {
 	__max_dedicated_links_reached();
 
-	if (!inet_aton($2, &conf.channel[conf.channel_num].u.mcast.ifa)) {
+	if (!inet_aton($2, &CONFIG(channel).conf[CONFIG(channel).num].u.mcast.ifa)) {
 		print_err(CTD_CFG_WARN, "%s is not a valid IPv4 address", $2);
 		break;
 	}
 
-        if (conf.channel[conf.channel_num].u.mcast.ipproto == AF_INET6) {
+        if (CONFIG(channel).conf[CONFIG(channel).num].u.mcast.ipproto == AF_INET6) {
 		print_err(CTD_CFG_WARN, "your multicast interface is IPv4 but "
 					"is binded to an IPv6 interface? "
 					"Surely, this is not what you want");
 		break;
 	}
 
-	conf.channel[conf.channel_num].u.mcast.ipproto = AF_INET;
+	CONFIG(channel).conf[CONFIG(channel).num].u.mcast.ipproto = AF_INET;
 };
 
 multicast_option : T_IPV6_IFACE T_IP
@@ -405,7 +405,7 @@ multicast_option : T_IFACE T_STRING
 
 	__max_dedicated_links_reached();
 
-	strncpy(conf.channel[conf.channel_num].channel_ifname, $2, IFNAMSIZ);
+	strncpy(CONFIG(channel).conf[CONFIG(channel).num].channel_ifname, $2, IFNAMSIZ);
 
 	idx = if_nametoindex($2);
 	if (!idx) {
@@ -413,9 +413,9 @@ multicast_option : T_IFACE T_STRING
 		break;
 	}
 
-	if (conf.channel[conf.channel_num].u.mcast.ipproto == AF_INET6) {
-		conf.channel[conf.channel_num].u.mcast.ifa.interface_index6 = idx;
-		conf.channel[conf.channel_num].u.mcast.ipproto = AF_INET6;
+	if (CONFIG(channel).conf[CONFIG(channel).num].u.mcast.ipproto == AF_INET6) {
+		CONFIG(channel).conf[CONFIG(channel).num].u.mcast.ifa.interface_index6 = idx;
+		CONFIG(channel).conf[CONFIG(channel).num].u.mcast.ipproto = AF_INET6;
 	}
 };
 
@@ -429,61 +429,61 @@ multicast_option : T_BACKLOG T_NUMBER
 multicast_option : T_GROUP T_NUMBER
 {
 	__max_dedicated_links_reached();
-	conf.channel[conf.channel_num].u.mcast.port = $2;
+	CONFIG(channel).conf[CONFIG(channel).num].u.mcast.port = $2;
 };
 
 multicast_option: T_SNDBUFF T_NUMBER
 {
 	__max_dedicated_links_reached();
-	conf.channel[conf.channel_num].u.mcast.sndbuf = $2;
+	CONFIG(channel).conf[CONFIG(channel).num].u.mcast.sndbuf = $2;
 };
 
 multicast_option: T_RCVBUFF T_NUMBER
 {
 	__max_dedicated_links_reached();
-	conf.channel[conf.channel_num].u.mcast.rcvbuf = $2;
+	CONFIG(channel).conf[CONFIG(channel).num].u.mcast.rcvbuf = $2;
 };
 
 multicast_option: T_CHECKSUM T_ON 
 {
 	__max_dedicated_links_reached();
-	conf.channel[conf.channel_num].u.mcast.checksum = 0;
+	CONFIG(channel).conf[CONFIG(channel).num].u.mcast.checksum = 0;
 };
 
 multicast_option: T_CHECKSUM T_OFF
 {
 	__max_dedicated_links_reached();
-	conf.channel[conf.channel_num].u.mcast.checksum = 1;
+	CONFIG(channel).conf[CONFIG(channel).num].u.mcast.checksum = 1;
 };
 
 udp_line : T_UDP '{' udp_options '}'
 {
-	if (conf.channel_type_global != CHANNEL_NONE &&
-	    conf.channel_type_global != CHANNEL_UDP) {
+	if (CONFIG(channel).type != CHANNEL_NONE &&
+	    CONFIG(channel).type != CHANNEL_UDP) {
 		print_err(CTD_CFG_ERROR, "cannot use `UDP' with other "
 					 "dedicated link protocols!");
 		exit(EXIT_FAILURE);
 	}
-	conf.channel_type_global = CHANNEL_UDP;
-	conf.channel[conf.channel_num].channel_type = CHANNEL_UDP;
-	conf.channel[conf.channel_num].channel_flags = CHANNEL_F_BUFFERED;
-	conf.channel_num++;
+	CONFIG(channel).type = CHANNEL_UDP;
+	CONFIG(channel).conf[CONFIG(channel).num].channel_type = CHANNEL_UDP;
+	CONFIG(channel).conf[CONFIG(channel).num].channel_flags = CHANNEL_F_BUFFERED;
+	CONFIG(channel).num++;
 };
 
 udp_line : T_UDP T_DEFAULT '{' udp_options '}'
 {
-	if (conf.channel_type_global != CHANNEL_NONE &&
-	    conf.channel_type_global != CHANNEL_UDP) {
+	if (CONFIG(channel).type != CHANNEL_NONE &&
+	    CONFIG(channel).type != CHANNEL_UDP) {
 		print_err(CTD_CFG_ERROR, "cannot use `UDP' with other "
 					 "dedicated link protocols!");
 		exit(EXIT_FAILURE);
 	}
-	conf.channel_type_global = CHANNEL_UDP;
-	conf.channel[conf.channel_num].channel_type = CHANNEL_UDP;
-	conf.channel[conf.channel_num].channel_flags = CHANNEL_F_DEFAULT |
+	CONFIG(channel).type = CHANNEL_UDP;
+	CONFIG(channel).conf[CONFIG(channel).num].channel_type = CHANNEL_UDP;
+	CONFIG(channel).conf[CONFIG(channel).num].channel_flags = CHANNEL_F_DEFAULT |
 						       CHANNEL_F_BUFFERED;
-	conf.channel_default = conf.channel_num;
-	conf.channel_num++;
+	CONFIG(channel).default_num = CONFIG(channel).num;
+	CONFIG(channel).num++;
 };
 
 udp_options :
@@ -493,11 +493,11 @@ udp_option : T_IPV4_ADDR T_IP
 {
 	__max_dedicated_links_reached();
 
-	if (!inet_aton($2, &conf.channel[conf.channel_num].u.udp.server.ipv4)) {
+	if (!inet_aton($2, &CONFIG(channel).conf[CONFIG(channel).num].u.udp.server.ipv4)) {
 		print_err(CTD_CFG_WARN, "%s is not a valid IPv4 address", $2);
 		break;
 	}
-	conf.channel[conf.channel_num].u.udp.ipproto = AF_INET;
+	CONFIG(channel).conf[CONFIG(channel).num].u.udp.ipproto = AF_INET;
 };
 
 udp_option : T_IPV6_ADDR T_IP
@@ -506,7 +506,7 @@ udp_option : T_IPV6_ADDR T_IP
 
 #ifdef HAVE_INET_PTON_IPV6
 	if (inet_pton(AF_INET6, $2,
-		      &conf.channel[conf.channel_num].u.udp.server.ipv6) <= 0) {
+		      &CONFIG(channel).conf[CONFIG(channel).num].u.udp.server.ipv6) <= 0) {
 		print_err(CTD_CFG_WARN, "%s is not a valid IPv6 address", $2);
 		break;
 	}
@@ -514,18 +514,18 @@ udp_option : T_IPV6_ADDR T_IP
 	print_err(CTD_CFG_WARN, "cannot find inet_pton(), IPv6 unsupported!");
 	break;
 #endif
-	conf.channel[conf.channel_num].u.udp.ipproto = AF_INET6;
+	CONFIG(channel).conf[CONFIG(channel).num].u.udp.ipproto = AF_INET6;
 };
 
 udp_option : T_IPV4_DEST_ADDR T_IP
 {
 	__max_dedicated_links_reached();
 
-	if (!inet_aton($2, &conf.channel[conf.channel_num].u.udp.client)) {
+	if (!inet_aton($2, &CONFIG(channel).conf[CONFIG(channel).num].u.udp.client)) {
 		print_err(CTD_CFG_WARN, "%s is not a valid IPv4 address", $2);
 		break;
 	}
-	conf.channel[conf.channel_num].u.udp.ipproto = AF_INET;
+	CONFIG(channel).conf[CONFIG(channel).num].u.udp.ipproto = AF_INET;
 };
 
 udp_option : T_IPV6_DEST_ADDR T_IP
@@ -534,7 +534,7 @@ udp_option : T_IPV6_DEST_ADDR T_IP
 
 #ifdef HAVE_INET_PTON_IPV6
 	if (inet_pton(AF_INET6, $2,
-		      &conf.channel[conf.channel_num].u.udp.client) <= 0) {
+		      &CONFIG(channel).conf[CONFIG(channel).num].u.udp.client) <= 0) {
 		print_err(CTD_CFG_WARN, "%s is not a valid IPv6 address", $2);
 		break;
 	}
@@ -542,7 +542,7 @@ udp_option : T_IPV6_DEST_ADDR T_IP
 	print_err(CTD_CFG_WARN, "cannot find inet_pton(), IPv6 unsupported!");
 	break;
 #endif
-	conf.channel[conf.channel_num].u.udp.ipproto = AF_INET6;
+	CONFIG(channel).conf[CONFIG(channel).num].u.udp.ipproto = AF_INET6;
 };
 
 udp_option : T_IFACE T_STRING
@@ -550,78 +550,79 @@ udp_option : T_IFACE T_STRING
 	int idx;
 
 	__max_dedicated_links_reached();
-	strncpy(conf.channel[conf.channel_num].channel_ifname, $2, IFNAMSIZ);
+	strncpy(CONFIG(channel).conf[CONFIG(channel).num].channel_ifname, $2, IFNAMSIZ);
 
 	idx = if_nametoindex($2);
 	if (!idx) {
 		print_err(CTD_CFG_WARN, "%s is an invalid interface", $2);
 		break;
 	}
-	conf.channel[conf.channel_num].u.udp.server.ipv6.scope_id = idx;
+	CONFIG(channel).conf[CONFIG(channel).num].u.udp.server.ipv6.scope_id = idx;
 };
 
 udp_option : T_PORT T_NUMBER
 {
 	__max_dedicated_links_reached();
-	conf.channel[conf.channel_num].u.udp.port = $2;
+	CONFIG(channel).conf[CONFIG(channel).num].u.udp.port = $2;
 };
 
 udp_option: T_SNDBUFF T_NUMBER
 {
 	__max_dedicated_links_reached();
-	conf.channel[conf.channel_num].u.udp.sndbuf = $2;
+	CONFIG(channel).conf[CONFIG(channel).num].u.udp.sndbuf = $2;
 };
 
 udp_option: T_RCVBUFF T_NUMBER
 {
 	__max_dedicated_links_reached();
-	conf.channel[conf.channel_num].u.udp.rcvbuf = $2;
+	CONFIG(channel).conf[CONFIG(channel).num].u.udp.rcvbuf = $2;
 };
 
 udp_option: T_CHECKSUM T_ON 
 {
 	__max_dedicated_links_reached();
-	conf.channel[conf.channel_num].u.udp.checksum = 0;
+	CONFIG(channel).conf[CONFIG(channel).num].u.udp.checksum = 0;
 };
 
 udp_option: T_CHECKSUM T_OFF
 {
 	__max_dedicated_links_reached();
-	conf.channel[conf.channel_num].u.udp.checksum = 1;
+	CONFIG(channel).conf[CONFIG(channel).num].u.udp.checksum = 1;
 };
 
 tcp_line : T_TCP '{' tcp_options '}'
 {
-	if (conf.channel_type_global != CHANNEL_NONE &&
-	    conf.channel_type_global != CHANNEL_TCP) {
+	if (CONFIG(channel).type != CHANNEL_NONE &&
+	    CONFIG(channel).type != CHANNEL_TCP) {
 		print_err(CTD_CFG_ERROR, "cannot use `TCP' with other "
 					 "dedicated link protocols!");
 		exit(EXIT_FAILURE);
 	}
-	conf.channel_type_global = CHANNEL_TCP;
-	conf.channel[conf.channel_num].channel_type = CHANNEL_TCP;
-	conf.channel[conf.channel_num].channel_flags = CHANNEL_F_BUFFERED |
+	CONFIG(channel).type = CHANNEL_TCP;
+	CONFIG(channel).conf[CONFIG(channel).num].channel_type = CHANNEL_TCP;
+	CONFIG(channel).conf[CONFIG(channel).num].channel_flags = CHANNEL_F_BUFFERED |
 						       CHANNEL_F_STREAM |
 						       CHANNEL_F_ERRORS;
-	conf.channel_num++;
+	CONFIG(channel).num++;
 };
 
 tcp_line : T_TCP T_DEFAULT '{' tcp_options '}'
 {
-	if (conf.channel_type_global != CHANNEL_NONE &&
-	    conf.channel_type_global != CHANNEL_TCP) {
+	if (CONFIG(channel).type != CHANNEL_NONE &&
+	    CONFIG(channel).type != CHANNEL_TCP) {
 		print_err(CTD_CFG_ERROR, "cannot use `TCP' with other "
 					 "dedicated link protocols!");
 		exit(EXIT_FAILURE);
 	}
-	conf.channel_type_global = CHANNEL_TCP;
-	conf.channel[conf.channel_num].channel_type = CHANNEL_TCP;
-	conf.channel[conf.channel_num].channel_flags = CHANNEL_F_DEFAULT |
+	CONFIG(channel).type = CHANNEL_TCP;
+	CONFIG(channel).conf[CONFIG(channel).num].channel_type = CHANNEL_TCP;
+	CONFIG(channel).conf[CONFIG(channel).num].channel_flags =
+						       CHANNEL_F_DEFAULT |
 						       CHANNEL_F_BUFFERED |
 						       CHANNEL_F_STREAM |
 						       CHANNEL_F_ERRORS;
-	conf.channel_default = conf.channel_num;
-	conf.channel_num++;
+	CONFIG(channel).default_num = CONFIG(channel).num;
+	CONFIG(channel).num++;
 };
 
 tcp_options :
@@ -631,11 +632,11 @@ tcp_option : T_IPV4_ADDR T_IP
 {
 	__max_dedicated_links_reached();
 
-	if (!inet_aton($2, &conf.channel[conf.channel_num].u.tcp.server.ipv4)) {
+	if (!inet_aton($2, &CONFIG(channel).conf[CONFIG(channel).num].u.tcp.server.ipv4)) {
 		print_err(CTD_CFG_WARN, "%s is not a valid IPv4 address", $2);
 		break;
 	}
-	conf.channel[conf.channel_num].u.tcp.ipproto = AF_INET;
+	CONFIG(channel).conf[CONFIG(channel).num].u.tcp.ipproto = AF_INET;
 };
 
 tcp_option : T_IPV6_ADDR T_IP
@@ -644,7 +645,7 @@ tcp_option : T_IPV6_ADDR T_IP
 
 #ifdef HAVE_INET_PTON_IPV6
 	if (inet_pton(AF_INET6, $2,
-		      &conf.channel[conf.channel_num].u.tcp.server.ipv6) <= 0) {
+		      &CONFIG(channel).conf[CONFIG(channel).num].u.tcp.server.ipv6) <= 0) {
 		print_err(CTD_CFG_WARN, "%s is not a valid IPv6 address", $2);
 		break;
 	}
@@ -652,18 +653,18 @@ tcp_option : T_IPV6_ADDR T_IP
 	print_err(CTD_CFG_WARN, "cannot find inet_pton(), IPv6 unsupported!");
 	break;
 #endif
-	conf.channel[conf.channel_num].u.tcp.ipproto = AF_INET6;
+	CONFIG(channel).conf[CONFIG(channel).num].u.tcp.ipproto = AF_INET6;
 };
 
 tcp_option : T_IPV4_DEST_ADDR T_IP
 {
 	__max_dedicated_links_reached();
 
-	if (!inet_aton($2, &conf.channel[conf.channel_num].u.tcp.client)) {
+	if (!inet_aton($2, &CONFIG(channel).conf[CONFIG(channel).num].u.tcp.client)) {
 		print_err(CTD_CFG_WARN, "%s is not a valid IPv4 address", $2);
 		break;
 	}
-	conf.channel[conf.channel_num].u.tcp.ipproto = AF_INET;
+	CONFIG(channel).conf[CONFIG(channel).num].u.tcp.ipproto = AF_INET;
 };
 
 tcp_option : T_IPV6_DEST_ADDR T_IP
@@ -672,7 +673,7 @@ tcp_option : T_IPV6_DEST_ADDR T_IP
 
 #ifdef HAVE_INET_PTON_IPV6
 	if (inet_pton(AF_INET6, $2,
-		      &conf.channel[conf.channel_num].u.tcp.client) <= 0) {
+		      &CONFIG(channel).conf[CONFIG(channel).num].u.tcp.client) <= 0) {
 		print_err(CTD_CFG_WARN, "%s is not a valid IPv6 address", $2);
 		break;
 	}
@@ -680,7 +681,7 @@ tcp_option : T_IPV6_DEST_ADDR T_IP
 	print_err(CTD_CFG_WARN, "cannot find inet_pton(), IPv6 unsupported!");
 	break;
 #endif
-	conf.channel[conf.channel_num].u.tcp.ipproto = AF_INET6;
+	CONFIG(channel).conf[CONFIG(channel).num].u.tcp.ipproto = AF_INET6;
 };
 
 tcp_option : T_IFACE T_STRING
@@ -688,60 +689,60 @@ tcp_option : T_IFACE T_STRING
 	int idx;
 
 	__max_dedicated_links_reached();
-	strncpy(conf.channel[conf.channel_num].channel_ifname, $2, IFNAMSIZ);
+	strncpy(CONFIG(channel).conf[CONFIG(channel).num].channel_ifname, $2, IFNAMSIZ);
 
 	idx = if_nametoindex($2);
 	if (!idx) {
 		print_err(CTD_CFG_WARN, "%s is an invalid interface", $2);
 		break;
 	}
-	conf.channel[conf.channel_num].u.tcp.server.ipv6.scope_id = idx;
+	CONFIG(channel).conf[CONFIG(channel).num].u.tcp.server.ipv6.scope_id = idx;
 };
 
 tcp_option : T_PORT T_NUMBER
 {
 	__max_dedicated_links_reached();
-	conf.channel[conf.channel_num].u.tcp.port = $2;
+	CONFIG(channel).conf[CONFIG(channel).num].u.tcp.port = $2;
 };
 
 tcp_option: T_SNDBUFF T_NUMBER
 {
 	__max_dedicated_links_reached();
-	conf.channel[conf.channel_num].u.tcp.sndbuf = $2;
+	CONFIG(channel).conf[CONFIG(channel).num].u.tcp.sndbuf = $2;
 };
 
 tcp_option: T_RCVBUFF T_NUMBER
 {
 	__max_dedicated_links_reached();
-	conf.channel[conf.channel_num].u.tcp.rcvbuf = $2;
+	CONFIG(channel).conf[CONFIG(channel).num].u.tcp.rcvbuf = $2;
 };
 
 tcp_option: T_CHECKSUM T_ON 
 {
 	__max_dedicated_links_reached();
-	conf.channel[conf.channel_num].u.tcp.checksum = 0;
+	CONFIG(channel).conf[CONFIG(channel).num].u.tcp.checksum = 0;
 };
 
 tcp_option: T_CHECKSUM T_OFF
 {
 	__max_dedicated_links_reached();
-	conf.channel[conf.channel_num].u.tcp.checksum = 1;
+	CONFIG(channel).conf[CONFIG(channel).num].u.tcp.checksum = 1;
 };
 
 tcp_option: T_ERROR_QUEUE_LENGTH T_NUMBER
 {
 	__max_dedicated_links_reached();
-	CONFIG(channelc).error_queue_length = $2;
+	CONFIG(channel).error_queue_length = $2;
 };
 
 hashsize : T_HASHSIZE T_NUMBER
 {
-	conf.hashsize = $2;
+	CONFIG(hashtable).buckets = $2;
 };
 
 hashlimit: T_HASHLIMIT T_NUMBER
 {
-	conf.limit = $2;
+	CONFIG(hashtable).max_entries = $2;
 };
 
 unix_line: T_UNIX '{' unix_options '}';
@@ -752,12 +753,12 @@ unix_options:
 
 unix_option : T_PATH T_PATH_VAL
 {
-	strcpy(conf.local.path, $2);
+	strcpy(CONFIG(general).local.path, $2);
 };
 
 unix_option : T_BACKLOG T_NUMBER
 {
-	conf.local.backlog = $2;
+	CONFIG(general).local.backlog = $2;
 };
 
 ignore_protocol: T_IGNORE_PROTOCOL '{' ignore_proto_list '}'
@@ -797,12 +798,12 @@ ignore_proto: T_STRING
 
 sync: T_SYNC '{' sync_list '}'
 {
-	if (conf.flags & CTD_STATS_MODE) {
+	if (CONFIG(general).flags & CTD_STATS_MODE) {
 		print_err(CTD_CFG_ERROR, "cannot use both `Stats' and `Sync' "
 					 "clauses in conntrackd.conf");
 		exit(EXIT_FAILURE);
 	}
-	conf.flags |= CTD_SYNC_MODE;
+	CONFIG(general).flags |= CTD_SYNC_MODE;
 };
 
 sync_list:
@@ -846,29 +847,29 @@ option: T_TCP_WINDOW_TRACKING T_OFF
 
 option: T_EXPECT_SYNC T_ON
 {
-	CONFIG(flags) |= CTD_EXPECT;
-	CONFIG(netlink).subsys_id = NFNL_SUBSYS_NONE;
-	CONFIG(netlink).groups = NF_NETLINK_CONNTRACK_NEW |
-				 NF_NETLINK_CONNTRACK_UPDATE |
-				 NF_NETLINK_CONNTRACK_DESTROY |
-				 NF_NETLINK_CONNTRACK_EXP_NEW |
-				 NF_NETLINK_CONNTRACK_EXP_UPDATE |
-				 NF_NETLINK_CONNTRACK_EXP_DESTROY;
+	CONFIG(general).flags |= CTD_EXPECT;
+	CONFIG(nl).subsys_id = NFNL_SUBSYS_NONE;
+	CONFIG(nl).groups = NF_NETLINK_CONNTRACK_NEW |
+			    NF_NETLINK_CONNTRACK_UPDATE |
+			    NF_NETLINK_CONNTRACK_DESTROY |
+			    NF_NETLINK_CONNTRACK_EXP_NEW |
+			    NF_NETLINK_CONNTRACK_EXP_UPDATE |
+			    NF_NETLINK_CONNTRACK_EXP_DESTROY;
 };
 
 option: T_EXPECT_SYNC T_OFF
 {
-	CONFIG(netlink).subsys_id = NFNL_SUBSYS_CTNETLINK;
-	CONFIG(netlink).groups = NF_NETLINK_CONNTRACK_NEW |
-				 NF_NETLINK_CONNTRACK_UPDATE |
-				 NF_NETLINK_CONNTRACK_DESTROY;
+	CONFIG(nl).subsys_id = NFNL_SUBSYS_CTNETLINK;
+	CONFIG(nl).groups = NF_NETLINK_CONNTRACK_NEW |
+			    NF_NETLINK_CONNTRACK_UPDATE |
+			    NF_NETLINK_CONNTRACK_DESTROY;
 };
 
 option: T_EXPECT_SYNC '{' expect_list '}'
 {
-	CONFIG(flags) |= CTD_EXPECT;
-	CONFIG(netlink).subsys_id = NFNL_SUBSYS_NONE;
-	CONFIG(netlink).groups = NF_NETLINK_CONNTRACK_NEW |
+	CONFIG(general).flags |= CTD_EXPECT;
+	CONFIG(nl).subsys_id = NFNL_SUBSYS_NONE;
+	CONFIG(nl).groups = NF_NETLINK_CONNTRACK_NEW |
 				 NF_NETLINK_CONNTRACK_UPDATE |
 				 NF_NETLINK_CONNTRACK_DESTROY |
 				 NF_NETLINK_CONNTRACK_EXP_NEW |
@@ -886,17 +887,17 @@ expect_item: T_STRING
 
 sync_mode_alarm: T_SYNC_MODE T_ALARM '{' sync_mode_alarm_list '}'
 {
-	conf.flags |= CTD_SYNC_ALARM;
+	CONFIG(general).flags |= CTD_SYNC_ALARM;
 };
 
 sync_mode_ftfw: T_SYNC_MODE T_FTFW '{' sync_mode_ftfw_list '}'
 {
-	conf.flags |= CTD_SYNC_FTFW;
+	CONFIG(general).flags |= CTD_SYNC_FTFW;
 };
 
 sync_mode_notrack: T_SYNC_MODE T_NOTRACK '{' sync_mode_notrack_list '}'
 {
-	conf.flags |= CTD_SYNC_NOTRACK;
+	CONFIG(general).flags |= CTD_SYNC_NOTRACK;
 };
 
 sync_mode_alarm_list:
@@ -958,12 +959,12 @@ resend_buffer_size: T_RESEND_BUFFER_SIZE T_NUMBER
 
 resend_queue_size: T_RESEND_QUEUE_SIZE T_NUMBER
 {
-	conf.resend_queue_size = $2;
+	CONFIG(sync).resend_queue_size = $2;
 };
 
 window_size: T_WINDOWSIZE T_NUMBER
 {
-	conf.window_size = $2;
+	CONFIG(sync).window_size = $2;
 };
 
 destroy_timeout: T_DESTROY_TIMEOUT T_NUMBER
@@ -1126,42 +1127,42 @@ general_line: hashsize
 
 netlink_buffer_size: T_BUFFER_SIZE T_NUMBER
 {
-	conf.netlink_buffer_size = $2;
+	CONFIG(nl).buffer_size = $2;
 };
 
 netlink_buffer_size_max_grown : T_BUFFER_SIZE_MAX_GROWN T_NUMBER
 {
-	conf.netlink_buffer_size_max_grown = $2;
+	CONFIG(nl).buffer_size_max = $2;
 };
 
 netlink_overrun_resync : T_NETLINK_OVERRUN_RESYNC T_ON
 {
-	conf.nl_overrun_resync = 30;
+	CONFIG(nl).overrun_resync = 30;
 };
 
 netlink_overrun_resync : T_NETLINK_OVERRUN_RESYNC T_OFF
 {
-	conf.nl_overrun_resync = -1;
+	CONFIG(nl).overrun_resync = -1;
 };
 
 netlink_overrun_resync : T_NETLINK_OVERRUN_RESYNC T_NUMBER
 {
-	conf.nl_overrun_resync = $2;
+	CONFIG(nl).overrun_resync = $2;
 };
 
 netlink_events_reliable : T_NETLINK_EVENTS_RELIABLE T_ON
 {
-	conf.netlink.events_reliable = 1;
+	CONFIG(nl).events_reliable = 1;
 };
 
 netlink_events_reliable : T_NETLINK_EVENTS_RELIABLE T_OFF
 {
-	conf.netlink.events_reliable = 0;
+	CONFIG(nl).events_reliable = 0;
 };
 
 nice : T_NICE T_SIGNED_NUMBER
 {
-	conf.nice = $2;
+	CONFIG(general).nice = $2;
 };
 
 scheduler : T_SCHEDULER '{' scheduler_options '}';
@@ -1173,9 +1174,9 @@ scheduler_options :
 scheduler_line : T_TYPE T_STRING
 {
 	if (strcasecmp($2, "rr") == 0) {
-		conf.sched.type = SCHED_RR;
+		CONFIG(general).sched_type = SCHED_RR;
 	} else if (strcasecmp($2, "fifo") == 0) {
-		conf.sched.type = SCHED_FIFO;
+		CONFIG(general).sched_type = SCHED_FIFO;
 	} else {
 		print_err(CTD_CFG_ERROR, "unknown scheduler `%s'", $2);
 		exit(EXIT_FAILURE);
@@ -1184,8 +1185,8 @@ scheduler_line : T_TYPE T_STRING
 
 scheduler_line : T_PRIO T_NUMBER
 {
-	conf.sched.prio = $2;
-	if (conf.sched.prio < 0 || conf.sched.prio > 99) {
+	CONFIG(general).sched_prio = $2;
+	if (CONFIG(general).sched_prio < 0 || CONFIG(general).sched_prio > 99) {
 		print_err(CTD_CFG_ERROR, "`Priority' must be [0, 99]\n", $2);
 		exit(EXIT_FAILURE);
 	}
@@ -1194,21 +1195,21 @@ scheduler_line : T_PRIO T_NUMBER
 family : T_FAMILY T_STRING
 {
 	if (strncmp($2, "IPv6", strlen("IPv6")) == 0)
-		conf.family = AF_INET6;
+		CONFIG(general).family = AF_INET6;
 	else
-		conf.family = AF_INET;
+		CONFIG(general).family = AF_INET;
 };
 
 event_iterations_limit : T_EVENT_ITER_LIMIT T_NUMBER
 {
-	CONFIG(event_iterations_limit) = $2;
+	CONFIG(nl).event_iterations_limit = $2;
 };
 
 poll_secs: T_POLL_SECS T_NUMBER
 {
-	conf.flags |= CTD_POLL;
-	conf.poll_kernel_secs = $2;
-	if (conf.poll_kernel_secs == 0) {
+	CONFIG(general).flags |= CTD_POLL;
+	CONFIG(nl).poll_secs = $2;
+	if (CONFIG(nl).poll_secs == 0) {
 		print_err(CTD_CFG_ERROR, "`PollSecs' clause must be > 0");
 		exit(EXIT_FAILURE);
 	}
@@ -1216,17 +1217,17 @@ poll_secs: T_POLL_SECS T_NUMBER
 
 filter : T_FILTER '{' filter_list '}'
 {
-	CONFIG(filter_from_kernelspace) = 0;
+	CONFIG(nl).filter_from_kernel = 0;
 };
 
 filter : T_FILTER T_FROM T_USERSPACE '{' filter_list '}'
 {
-	CONFIG(filter_from_kernelspace) = 0;
+	CONFIG(nl).filter_from_kernel = 0;
 };
 
 filter : T_FILTER T_FROM T_KERNELSPACE '{' filter_list '}'
 {
-	CONFIG(filter_from_kernelspace) = 1;
+	CONFIG(nl).filter_from_kernel = 1;
 };
 
 filter_list : 
@@ -1497,12 +1498,12 @@ filter_state_item : tcp_states T_FOR T_TCP;
 
 stats: T_STATS '{' stats_list '}'
 {
-	if (conf.flags & CTD_SYNC_MODE) {
+	if (CONFIG(general).flags & CTD_SYNC_MODE) {
 		print_err(CTD_CFG_ERROR, "cannot use both `Stats' and `Sync' "
 					 "clauses in conntrackd.conf");
 		exit(EXIT_FAILURE);
 	}
-	conf.flags |= CTD_STATS_MODE;
+	CONFIG(general).flags |= CTD_STATS_MODE;
 };
 
 stats_list:
@@ -1518,7 +1519,7 @@ stat_line: stat_logfile_bool
 
 stat_logfile_bool : T_LOG T_ON
 {
-	strncpy(conf.stats.logfile, DEFAULT_STATS_LOGFILE, FILENAME_MAXLEN);
+	strncpy(CONFIG(stats).logfile, DEFAULT_STATS_LOGFILE, FILENAME_MAXLEN);
 };
 
 stat_logfile_bool : T_LOG T_OFF
@@ -1527,47 +1528,47 @@ stat_logfile_bool : T_LOG T_OFF
 
 stat_logfile_path : T_LOG T_PATH_VAL
 {
-	strncpy(conf.stats.logfile, $2, FILENAME_MAXLEN);
+	strncpy(CONFIG(stats).logfile, $2, FILENAME_MAXLEN);
 };
 
 stat_syslog_bool : T_SYSLOG T_ON
 {
-	conf.stats.syslog_facility = DEFAULT_SYSLOG_FACILITY;
+	CONFIG(stats).syslog_facility = DEFAULT_SYSLOG_FACILITY;
 };
 
 stat_syslog_bool : T_SYSLOG T_OFF
 {
-	conf.stats.syslog_facility = -1;
+	CONFIG(stats).syslog_facility = -1;
 }
 
 stat_syslog_facility : T_SYSLOG T_STRING
 {
 	if (!strcmp($2, "daemon"))
-		conf.stats.syslog_facility = LOG_DAEMON;
+		CONFIG(stats).syslog_facility = LOG_DAEMON;
 	else if (!strcmp($2, "local0"))
-		conf.stats.syslog_facility = LOG_LOCAL0;
+		CONFIG(stats).syslog_facility = LOG_LOCAL0;
 	else if (!strcmp($2, "local1"))
-		conf.stats.syslog_facility = LOG_LOCAL1;
+		CONFIG(stats).syslog_facility = LOG_LOCAL1;
 	else if (!strcmp($2, "local2"))
-		conf.stats.syslog_facility = LOG_LOCAL2;
+		CONFIG(stats).syslog_facility = LOG_LOCAL2;
 	else if (!strcmp($2, "local3"))
-		conf.stats.syslog_facility = LOG_LOCAL3;
+		CONFIG(stats).syslog_facility = LOG_LOCAL3;
 	else if (!strcmp($2, "local4"))
-		conf.stats.syslog_facility = LOG_LOCAL4;
+		CONFIG(stats).syslog_facility = LOG_LOCAL4;
 	else if (!strcmp($2, "local5"))
-		conf.stats.syslog_facility = LOG_LOCAL5;
+		CONFIG(stats).syslog_facility = LOG_LOCAL5;
 	else if (!strcmp($2, "local6"))
-		conf.stats.syslog_facility = LOG_LOCAL6;
+		CONFIG(stats).syslog_facility = LOG_LOCAL6;
 	else if (!strcmp($2, "local7"))
-		conf.stats.syslog_facility = LOG_LOCAL7;
+		CONFIG(stats).syslog_facility = LOG_LOCAL7;
 	else {
 		print_err(CTD_CFG_WARN, "'%s' is not a known syslog facility, "
 					"ignoring.", $2);
 		break;
 	}
 
-	if (conf.syslog_facility != -1 &&
-	    conf.stats.syslog_facility != conf.syslog_facility)
+	if (CONFIG(general).syslog_facility != -1 &&
+	    CONFIG(stats).syslog_facility != CONFIG(general).syslog_facility)
 		print_err(CTD_CFG_WARN, "conflicting Syslog facility "
 					"values, defaulting to General");
 };
@@ -1579,7 +1580,7 @@ buffer_size: T_STAT_BUFFER_SIZE T_NUMBER
 
 helper: T_HELPER '{' helper_list '}'
 {
-	conf.flags |= CTD_HELPER;
+	CONFIG(general).flags |= CTD_HELPER;
 };
 
 helper_list:
@@ -1832,7 +1833,7 @@ static void __kernel_filter_add_state(int value)
 
 static void __max_dedicated_links_reached(void)
 {
-	if (conf.channel_num >= MULTICHANNEL_MAX) {
+	if (CONFIG(channel).num >= MULTICHANNEL_MAX) {
 		print_err(CTD_CFG_ERROR, "too many dedicated links in "
 					 "the configuration file "
 					 "(Maximum: %d)", MULTICHANNEL_MAX);
@@ -1850,9 +1851,9 @@ init_config(char *filename)
 		return -1;
 
 	/* Zero may be a valid facility */
-	CONFIG(syslog_facility) = -1;
+	CONFIG(general).syslog_facility = -1;
 	CONFIG(stats).syslog_facility = -1;
-	CONFIG(netlink).subsys_id = -1;
+	CONFIG(nl).subsys_id = -1;
 
 	/* Initialize list of user-space helpers */
 	INIT_LIST_HEAD(&CONFIG(cthelper).list);
@@ -1864,51 +1865,52 @@ init_config(char *filename)
 	fclose(fp);
 
 	/* default to IPv4 */
-	if (CONFIG(family) == 0)
-		CONFIG(family) = AF_INET;
+	if (CONFIG(general).family == 0)
+		CONFIG(general).family = AF_INET;
 
 	/* set to default is not specified */
-	if (strcmp(CONFIG(lockfile), "") == 0)
-		strncpy(CONFIG(lockfile), DEFAULT_LOCKFILE, FILENAME_MAXLEN);
+	if (strcmp(CONFIG(general).lockfile, "") == 0)
+		strncpy(CONFIG(general).lockfile, DEFAULT_LOCKFILE,
+			FILENAME_MAXLEN);
 
 	/* default to 180 seconds of expiration time: cache entries */
-	if (CONFIG(cache_timeout) == 0)
-		CONFIG(cache_timeout) = 180;
+	if (CONFIG(sync).alarm_timeout == 0)
+		CONFIG(sync).alarm_timeout = 180;
 
 	/* default to 60 seconds: purge kernel entries */
-	if (CONFIG(purge_timeout) == 0)
-		CONFIG(purge_timeout) = 60;
+	if (CONFIG(nl).purge_timeout == 0)
+		CONFIG(nl).purge_timeout = 60;
 
 	/* default to 60 seconds of refresh time */
-	if (CONFIG(refresh) == 0)
-		CONFIG(refresh) = 60;
+	if (CONFIG(sync).alarm_refresh == 0)
+		CONFIG(sync).alarm_refresh = 60;
 
-	if (CONFIG(resend_queue_size) == 0)
-		CONFIG(resend_queue_size) = 131072;
+	if (CONFIG(sync).resend_queue_size == 0)
+		CONFIG(sync).resend_queue_size = 131072;
 
 	/* default to a window size of 300 packets */
-	if (CONFIG(window_size) == 0)
-		CONFIG(window_size) = 300;
+	if (CONFIG(sync).window_size == 0)
+		CONFIG(sync).window_size = 300;
 
-	if (CONFIG(event_iterations_limit) == 0)
-		CONFIG(event_iterations_limit) = 100;
+	if (CONFIG(nl).event_iterations_limit == 0)
+		CONFIG(nl).event_iterations_limit = 100;
 
 	/* default number of bucket of the hashtable that are committed in
 	   one run loop. XXX: no option available to tune this value yet. */
-	if (CONFIG(general).commit_steps == 0)
-		CONFIG(general).commit_steps = 8192;
+	if (CONFIG(nl).commit_steps == 0)
+		CONFIG(nl).commit_steps = 8192;
 
 	/* if overrun, automatically resync with kernel after 30 seconds */
-	if (CONFIG(nl_overrun_resync) == 0)
-		CONFIG(nl_overrun_resync) = 30;
+	if (CONFIG(nl).overrun_resync == 0)
+		CONFIG(nl).overrun_resync = 30;
 
 	/* default to 128 elements in the channel error queue */
-	if (CONFIG(channelc).error_queue_length == 0)
-		CONFIG(channelc).error_queue_length = 128;
+	if (CONFIG(channel).error_queue_length == 0)
+		CONFIG(channel).error_queue_length = 128;
 
-	if (CONFIG(netlink).subsys_id == -1) {
-		CONFIG(netlink).subsys_id = NFNL_SUBSYS_CTNETLINK;
-		CONFIG(netlink).groups = NF_NETLINK_CONNTRACK_NEW |
+	if (CONFIG(nl).subsys_id == -1) {
+		CONFIG(nl).subsys_id = NFNL_SUBSYS_CTNETLINK;
+		CONFIG(nl).groups = NF_NETLINK_CONNTRACK_NEW |
 					 NF_NETLINK_CONNTRACK_UPDATE |
 					 NF_NETLINK_CONNTRACK_DESTROY;
 	}
diff --git a/src/run.c b/src/run.c
index 3337694..c558465 100644
--- a/src/run.c
+++ b/src/run.c
@@ -47,14 +47,14 @@ void killer(int foo)
 
 	local_server_destroy(&STATE(local));
 
-	if (CONFIG(flags) & (CTD_SYNC_MODE | CTD_STATS_MODE))
+	if (CONFIG(general).flags & (CTD_SYNC_MODE | CTD_STATS_MODE))
 		ctnl_kill();
 
-	if (CONFIG(flags) & CTD_HELPER)
+	if (CONFIG(general).flags & CTD_HELPER)
 		cthelper_kill();
 
 	destroy_fds(STATE(fds));
-	unlink(CONFIG(lockfile));
+	unlink(CONFIG(general).lockfile);
 	dlog(LOG_NOTICE, "---- shutdown received ----");
 	close_log();
 
@@ -166,7 +166,7 @@ static void dump_stats_runtime(int fd)
 			STATE(stats).nl_overrun,
 			STATE(stats).nl_kernel_table_flush,
 			STATE(stats).nl_kernel_table_resync,
-			CONFIG(netlink_buffer_size),
+			CONFIG(nl).buffer_size,
 			STATE(stats).child_process_failed,
 			STATE(stats).child_process_error_segfault,
 			STATE(stats).child_process_error_term,
@@ -199,10 +199,10 @@ static int local_handler(int fd, void *data)
 		break;
 	}
 
-	if (CONFIG(flags) & (CTD_SYNC_MODE | CTD_STATS_MODE))
+	if (CONFIG(general).flags & (CTD_SYNC_MODE | CTD_STATS_MODE))
 		return ctnl_local(fd, type, data);
 
-	if (CONFIG(flags) & CTD_HELPER)
+	if (CONFIG(general).flags & CTD_HELPER)
 		return cthelper_local(fd, type, data);
 
 	return ret;
@@ -226,7 +226,7 @@ init(void)
 	}
 
 	/* local UNIX socket */
-	if (local_server_create(&STATE(local), &CONFIG(local)) == -1) {
+	if (local_server_create(&STATE(local), &CONFIG(general).local) == -1) {
 		dlog(LOG_ERR, "can't open unix socket!");
 		return -1;
 	}
@@ -252,11 +252,11 @@ init(void)
 		return -1;
 
 	/* Initialization */
-	if (CONFIG(flags) & (CTD_SYNC_MODE | CTD_STATS_MODE))
+	if (CONFIG(general).flags & (CTD_SYNC_MODE | CTD_STATS_MODE))
 		if (ctnl_init() < 0)
 			return -1;
 
-	if (CONFIG(flags) & CTD_HELPER) {
+	if (CONFIG(general).flags & CTD_HELPER) {
 		if (cthelper_init() < 0)
 			return -1;
 	}
diff --git a/src/sync-alarm.c b/src/sync-alarm.c
index acaf5e6..d32975a 100644
--- a/src/sync-alarm.c
+++ b/src/sync-alarm.c
@@ -35,12 +35,11 @@ struct cache_alarm {
 
 static void alarm_enqueue(struct cache_object *obj, int query);
 
-static void refresher(struct alarm_block *a, void *data)
+static void alarm_refresher(struct alarm_block *a, void *data)
 {
 	struct cache_object *obj = data;
 
-	add_alarm(a, 
-		  random() % CONFIG(refresh) + 1,
+	add_alarm(a, random() % CONFIG(sync).alarm_refresh + 1,
 		  ((random() % 5 + 1)  * 200000) - 1);
 
 	alarm_enqueue(obj, NET_T_STATE_CT_UPD);
@@ -52,17 +51,15 @@ static void cache_alarm_add(struct cache_object *obj, void *data)
 
 	queue_node_init(&ca->qnode, Q_ELEM_OBJ);
 	ca->obj = obj;
-	init_alarm(&ca->alarm, obj, refresher);
-	add_alarm(&ca->alarm,
-		  random() % CONFIG(refresh) + 1,
+	init_alarm(&ca->alarm, obj, alarm_refresher);
+	add_alarm(&ca->alarm, random() % CONFIG(sync).alarm_refresh + 1,
 		  ((random() % 5 + 1)  * 200000) - 1);
 }
 
 static void cache_alarm_update(struct cache_object *obj, void *data)
 {
 	struct cache_alarm *ca = data;
-	add_alarm(&ca->alarm, 
-		  random() % CONFIG(refresh) + 1,
+	add_alarm(&ca->alarm, random() % CONFIG(sync).alarm_refresh + 1,
 		  ((random() % 5 + 1)  * 200000) - 1);
 }
 
diff --git a/src/sync-ftfw.c b/src/sync-ftfw.c
index 1bc2d9f..3f94e71 100644
--- a/src/sync-ftfw.c
+++ b/src/sync-ftfw.c
@@ -148,7 +148,7 @@ static void do_alive_alarm(struct alarm_block *a, void *data)
 
 static int ftfw_init(void)
 {
-	rs_queue = queue_create("rsqueue", CONFIG(resend_queue_size), 0);
+	rs_queue = queue_create("rsqueue", CONFIG(sync).resend_queue_size, 0);
 	if (rs_queue == NULL) {
 		dlog(LOG_ERR, "cannot create rs queue");
 		return -1;
@@ -158,7 +158,7 @@ static int ftfw_init(void)
 	add_alarm(&alive_alarm, ALIVE_INT, 0);
 
 	/* set ack window size */
-	window = CONFIG(window_size);
+	window = CONFIG(sync).window_size;
 
 	return 0;
 }
@@ -389,7 +389,7 @@ static int ftfw_recv(const struct nethdr *net)
 		/* we have received a hello while we had data to acknowledge.
 		 * reset the window, the other doesn't know anthing about it. */
 		if (ack_from_set && before(net->seq, ack_from)) {
-			window = CONFIG(window_size) - 1;
+			window = CONFIG(sync).window_size - 1;
 			ack_from = net->seq;
 		}
 
@@ -417,7 +417,7 @@ static int ftfw_recv(const struct nethdr *net)
 		tx_queue_add_ctlmsg(NET_F_NACK, exp_seq, net->seq-1);
 
 		/* count this message as part of the new window */
-		window = CONFIG(window_size) - 1;
+		window = CONFIG(sync).window_size - 1;
 		ack_from = net->seq;
 		ack_from_set = 1;
 		break;
@@ -444,7 +444,7 @@ bypass:
 		if (--window <= 0) {
 			/* received a window, send an acknowledgement */
 			tx_queue_add_ctlmsg(NET_F_ACK, ack_from, net->seq);
-			window = CONFIG(window_size);
+			window = CONFIG(sync).window_size;
 			ack_from_set = 0;
 		}
 	}
diff --git a/src/sync-mode.c b/src/sync-mode.c
index e69ecfe..942392a 100644
--- a/src/sync-mode.c
+++ b/src/sync-mode.c
@@ -255,7 +255,7 @@ static void channel_handler(void *data)
 	struct channel *c = data;
 	int k;
 
-	for (k=0; k<CONFIG(event_iterations_limit); k++) {
+	for (k=0; k<CONFIG(nl).event_iterations_limit; k++) {
 		if (channel_handler_routine(c) == -1) {
 			break;
 		}
@@ -370,16 +370,16 @@ static int init_sync(void)
 	}
 	memset(state.sync, 0, sizeof(struct ct_sync_state));
 
-	if (CONFIG(flags) & CTD_SYNC_FTFW)
+	if (CONFIG(general).flags & CTD_SYNC_FTFW)
 		STATE_SYNC(sync) = &sync_ftfw;
-	else if (CONFIG(flags) & CTD_SYNC_ALARM)
+	else if (CONFIG(general).flags & CTD_SYNC_ALARM)
 		STATE_SYNC(sync) = &sync_alarm;
-	else if (CONFIG(flags) & CTD_SYNC_NOTRACK)
+	else if (CONFIG(general).flags & CTD_SYNC_NOTRACK)
 		STATE_SYNC(sync) = &sync_notrack;
 	else {
 		fprintf(stderr, "WARNING: No synchronization mode specified. "
 				"Defaulting to FT-FW mode.\n");
-		CONFIG(flags) |= CTD_SYNC_FTFW;
+		CONFIG(general).flags |= CTD_SYNC_FTFW;
 		STATE_SYNC(sync) = &sync_ftfw;
 	}
 
@@ -410,7 +410,7 @@ static int init_sync(void)
 
 	/* channel to send events on the wire */
 	STATE_SYNC(channel) =
-		multichannel_open(CONFIG(channel), CONFIG(channel_num));
+		multichannel_open(CONFIG(channel).conf, CONFIG(channel).num);
 	if (STATE_SYNC(channel) == NULL) {
 		dlog(LOG_ERR, "can't open channel socket");
 		return -1;
@@ -451,7 +451,7 @@ static int init_sync(void)
 			tx_queue_cb, NULL, STATE(fds)) == -1)
 		return -1;
 
-	STATE_SYNC(commit).h = nfct_open(CONFIG(netlink).subsys_id, 0);
+	STATE_SYNC(commit).h = nfct_open(CONFIG(nl).subsys_id, 0);
 	if (STATE_SYNC(commit).h == NULL) {
 		dlog(LOG_ERR, "can't create handler to commit");
 		return -1;
@@ -607,9 +607,9 @@ static int local_handler_sync(int fd, int type, void *data)
 	case RESET_TIMERS:
 		if (!alarm_pending(&STATE_SYNC(reset_cache_alarm))) {
 			dlog(LOG_NOTICE, "flushing conntrack table in %d secs",
-					 CONFIG(purge_timeout));
+					 CONFIG(nl).purge_timeout);
 			add_alarm(&STATE_SYNC(reset_cache_alarm),
-				  CONFIG(purge_timeout), 0);
+				  CONFIG(nl).purge_timeout, 0);
 		}
 		break;
 	case CT_FLUSH_CACHE:
@@ -664,7 +664,7 @@ static int local_handler_sync(int fd, int type, void *data)
 		queue_stats_show(fd);
 		break;
 	case EXP_STATS:
-		if (!(CONFIG(flags) & CTD_EXPECT))
+		if (!(CONFIG(general).flags & CTD_EXPECT))
 			break;
 
 		STATE(mode)->internal->exp.stats(fd);
@@ -674,7 +674,7 @@ static int local_handler_sync(int fd, int type, void *data)
 		dump_stats_sync(fd);
 		break;
 	case EXP_DUMP_INTERNAL:
-		if (!(CONFIG(flags) & CTD_EXPECT))
+		if (!(CONFIG(general).flags & CTD_EXPECT))
 			break;
 
 		if (fork_process_new(CTD_PROC_ANY, 0, NULL, NULL) == 0) {
@@ -683,7 +683,7 @@ static int local_handler_sync(int fd, int type, void *data)
 		}
 		break;
 	case EXP_DUMP_EXTERNAL:
-		if (!(CONFIG(flags) & CTD_EXPECT))
+		if (!(CONFIG(general).flags & CTD_EXPECT))
 			break;
 
 		if (fork_process_new(CTD_PROC_ANY, 0, NULL, NULL) == 0) {
@@ -692,7 +692,7 @@ static int local_handler_sync(int fd, int type, void *data)
 		}
 		break;
 	case EXP_COMMIT:
-		if (!(CONFIG(flags) & CTD_EXPECT))
+		if (!(CONFIG(general).flags & CTD_EXPECT))
 			break;
 
 		dlog(LOG_NOTICE, "committing expectation cache");
@@ -710,7 +710,7 @@ static int local_handler_sync(int fd, int type, void *data)
 		dlog(LOG_NOTICE, "flushing caches");
 		STATE(mode)->internal->ct.flush();
 		STATE_SYNC(external)->ct.flush();
-		if (CONFIG(flags) & CTD_EXPECT) {
+		if (CONFIG(general).flags & CTD_EXPECT) {
 			STATE(mode)->internal->exp.flush();
 			STATE_SYNC(external)->exp.flush();
 		}
@@ -718,7 +718,7 @@ static int local_handler_sync(int fd, int type, void *data)
 	case ALL_COMMIT:
 		dlog(LOG_NOTICE, "committing all external caches");
 		STATE_SYNC(commit).rq[0].cb = STATE_SYNC(external)->ct.commit;
-		if (CONFIG(flags) & CTD_EXPECT) {
+		if (CONFIG(general).flags & CTD_EXPECT) {
 			STATE_SYNC(commit).rq[1].cb =
 				STATE_SYNC(external)->exp.commit;
 		} else {
diff --git a/src/sync-notrack.c b/src/sync-notrack.c
index a7df4e7..263f763 100644
--- a/src/sync-notrack.c
+++ b/src/sync-notrack.c
@@ -102,7 +102,7 @@ static void kernel_resync(void)
 	u_int32_t family = AF_UNSPEC;
 	int ret;
 
-	h = nfct_open(CONFIG(netlink).subsys_id, 0);
+	h = nfct_open(CONFIG(nl).subsys_id, 0);
 	if (h == NULL) {
 		dlog(LOG_ERR, "can't allocate memory for the internal cache");
 		return;
-- 
1.7.10.4


--J/dobhs11T7y2rNN--
