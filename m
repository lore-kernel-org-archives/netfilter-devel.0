From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH 1/3 nfnetlink_acct] numerous changes and improvements to
 the kernel code
Date: Thu, 11 Apr 2013 12:18:03 +0200
Message-ID: <20130411101803.GA4254@localhost>
References: <514D9D45.6090804@googlemail.com>
 <20130323151213.GA4925@localhost>
 <515203F6.10503@googlemail.com>
 <20130403104647.GA5464@localhost>
 <515DE46F.9080505@googlemail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Michael Zintakis <michael.zintakis@googlemail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:58786 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752932Ab3DKKSe (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 11 Apr 2013 06:18:34 -0400
Content-Disposition: inline
In-Reply-To: <515DE46F.9080505@googlemail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hi Michael,

On Thu, Apr 04, 2013 at 09:37:03PM +0100, Michael Zintakis wrote:
> Hello Pablo,
> 
> Pablo Neira Ayuso wrote:
> >>> BTW, atomic is not required for those two fields, this is protected by
> >>> the nfnl_lock.
> >> I disagree with you entirely.
> > 
> > At least you have to agree with me in that atomic is not required for
> > those variables :)
>
> I am not sure I do, sorry Pablo!
> 
> If we demote the two variables from "atomic_t" and "atomic64_t" to
> uint32_t and uint64_t respectively, then if thread A is in the
> middle of changing 'bthr' for example, and thread B tries to access
> it, there is nothing stopping both threads gaining access to that
> variable since it isn't afforded the protection of the atomic
> operations (put it simple there isn't atomic lock to prevent such
> access), which will cause a mess.

Those variables are already protected by nfnl_lock in
net/netfilter/nfnetlink.c.

> There is a similar case with the "refcnt" variable - it is atomic
> and therefore protected, so I don't see if I change these 2
> variables (bthr and fmt) to "normal" unsigned integers how (or what)
> will protect the access to these variables and prevent what I just
> described from happening...
> 
> >> The two fields above aren't "meaningless" - they have a purpose and
> >> are an integral part of the nfacct object. None of the fields in the
> >> nfacct object are really used in the operation of the kernel itself
> >> - the kernel merely updates these. To put it bluntly, the whole
> >> nfacct struct is used as storage and the kernel don't use any of
> >> these fields in its core operation. OK, I agree that packet and byte
> >> counters are going to be updated much more frequently by the kernel
> >> than the fmt and bthr variables, but the fact is that these,
> >> strictly speaking, do not dependent for the kernel to operate. What
> >> I've done above is not a unique approach - in the kernel code there
> >> are a lot of examples like this, it is not something new and we are
> >> not re-inventing the wheel here or breaking a new ground.
> >>
> >> Another reason for having fmt and bthr as part of the kernel nfacct
> >> struct is that this data, alongside the bytes and packet counters,
> >> is shielded and protected (in ring0), its integrity guaranteed and
> >> can only be changed via the kernel itself and nothing else. This is
> >> very important for us.
> > 
> > Sorry, I don't think putting thing in the kernel makes things more
> > secure.
>
> These properties are not directly accessible or arbitrarily
> modifiable (whether intentional or not) via userspace so in that
> sense the information contained within is "shielded" or "protected"
> by the kernel, which is what I meant with my previous posting
> (sorry, my English is not 100%).

You can modify kernel information if you manage to load a module and
have some little knowlege on where to find things in the memory space.
Truly, I think you can achive this by protecting the configuration
file from changes in your tree and some extra checksumming to follow
the track of unexpected changes.

> >> In the early stages of the nfacct changes, we considered a very
> >> similar approach to what you have proposed above, but rejected it,
> >> not least because the integrity and security of the data
> >> encapsulated in the nfacct struct cannot be guaranteed otherwise. We
> >> will rely heavily on this and don't need it to be changed
> >> arbitrarily (either by "mistake" or intentionally), so we decided
> >> that this is the best way going forward.
> >>
> >> In stage 2 (current plans are this to be completed by the end of q2
> >> of this year) we will extend this and create a specifically designed
> >> daemon (nfacctd), which will "talk" directly to the kernel and
> >> retrieve accounting data (much like what nfacct executable currently
> >> does, but on a bigger scale) on-demand and in real time and then
> >> send it to a central point where such data will be collected from
> >> all other machines for statistics and analysis. That daemon can't be
> >> spending extra cpu cycles parsing files that may or may not exist or
> >> check whether the data in them is or isn't reliable (whether it is
> >> "changed" on purpose or not) - that really isn't good enough.
> > 
> > I think that daemon you want to implement is ulogd2. There's already a
> > plugin available for nfacct. Thus, you can skip parsing the
> > configuration file over and over again. To dump existing stats, you
> > can add a unix socket interface for this new extension you want to do.
>
> OK, let me illustrate my point with a little pictogram. We have two
> separate possible scenarios:
> 
> Scenario 1:
> Request Station (RS) <=> Internal (trusted) network <=> Home Station (HS) - where nfacctd daemon and friends is located
> 
> Scenario 2:
> Request Station <=> Public (untrusted) network <=> Home Station
> 
> In the above scenarios, the "Request Station" can be two different
> types: a) a central server gathering statistics for all registered
> machines on the network; or b) a separate work station running
> nfacct.
> 
> In case a) above, what usually happens is that the RS connects to
> nfacctd on all registered machines using tcp connection and tells
> them "I want traffic stats from you every X seconds" (without this
> initial command the nfacctd daemon is idle and simply listens on the
> pre-defined tcp port).
> 
> Once this is done, the nfacctd daemon start sending those stats to
> RS and gets an acknowledgment. If that doesn't happen, say, 3 times
> in a row - because the RS may be inaccessible or for other reasons,
> then the daemon stores these stats in memory if permissible up to a
> point for later transmission, while regularly trying to connect to
> the RS.
> 
> Periodically, particularly during "peak" times when we expect
> traffic to be high, the central server on RS can send a command to
> the nfacctd daemons to throttle up the interval at which these
> statistics are sent. Similarly, during "slow-traffic" times, the
> opposite may happen and this interval can be extended.
> 
> In addition, the RS needs to be able to request the current traffic
> stats for a particular nfacct object (similar to "nfacct get"), as
> well as be able to change the threshold and format properties of an
> individual nfacct object on the HS.
> 
> Another possible type of "Request Station" we need to implement
> (this would require extending the nfacct executable capabilities
> once again) is a RS requesting full or partial traffic statistics by
> querying nfacctd on a particular Home Station using the nfacct
> executable. In other words, be able to do this:
> 
> nfacct list [host <HS_HOST>] [port <HS_PORT>]
> nfacct get <object-name> [host <HS_HOST>] [port <HS_PORT>]
> nfacct add <object-name> replace [format FMT_SPEC] [threshold THRESHOLD] [host <HS_HOST>] [port <HS_PORT>]
> 
> In other words, nfacct from the RS should be able to connect to
> nfacctd daemon on HS_HOST:HS_PORT and request traffic statistics on
> all objects, a single object, as well as be able to change the
> format and threshold values of a particular nfacct object.

That sounds to me a lot like IPFIX. There's some preliminary support
for it in ulogd2, it should be relatively easy to finish it.

> The connection itself will usually be on a pre-defined tcp port
> (above the 30000 range). For the final stage of the project (this is
> still in its infancy though) we will need to implement Scenario 2
> above: if the medium used by the RS to connect to the HS is
> untrusted network, then we will deploy tls encryption (that will, of
> course, require certificate chain verification on both sides).
> 
> I haven't looked at the ulog2 and the nfacct module implementation
> there in great detail, but from what I can gather, it just issues
> and records stats on all nfacct objects at pre-selected interval
> configurable at start-up (via the "pollinterval" option) and all
> this is done locally, which is obviously insufficient for us.

I mean that ulogd2 provides the framework for Netfilter's user-space
logging. It's pretty extensible. You will surely need to make some
changes for what you need, but most of the infrastructure is already
there. No need for another separated daemon.

> >>>>  	if (matching) {
> >>>>  		if (nlh->nlmsg_flags & NLM_F_REPLACE) {
> >>>> -			/* reset counters if you request a replacement. */
> >>>> +			/* reset counters if you request a replacement */
> >>>> +			if (!tb[NFACCT_PKTS]) {
> >>>> +				/*
> >>>> +				 * Prevent resetting the packets counter if
> >>>> +				 * either fmt or bthr are specified.
> >>>> +				 *
> >>>> +				 * This is done for backward compatibility,
> >>>> +				 * otherwise resetting these counters should
> >>>> +				 * only be allowed when tb[NFACCT_PKTS] is
> >>>> +				 * explicitly specified and == 0.
> >>>> +				 *
> >>>> +				 */
> >>>> +				if (!tb[NFACCT_FMT] &&
> >>>> +				    !tb[NFACCT_BTHR]) {
> >>>>  			atomic64_set(&matching->pkts, 0);
> >>>> +				}
> >>>> +			} else {
> >>>> +				atomic64_set(&matching->pkts,
> >>>> +				be64_to_cpu(nla_get_be64(tb[NFACCT_PKTS])));
> >>> The replacement operation is not so easy. Note that you may hit
> >>> inconsistencies if while replacing the packet counter, the kernel
> >>> updates the byte counter, and then you replace the byte counter. You
> >>> would be leaking bytes and packets.
> >>>
> >> If I understand you correctly Pablo, you are worried that the packet
> >> and byte counters can be, in a way "misaligned". But if we are to
> >> update these values we don't really care if the old values get
> >> updated or not prior to that change, do we?
> >>
> >> In other words, the packet value is updated and the kernel changes
> >> the byte value in the meantime. If we are later (in the same call)
> >> replacing the bytes value why do we care that there is a momentary
> >> inconsistency - we are going to replace it with a new value anyway?
> > 
> > IMO we should care.
>
> Pablo, let me re-cap so that I make sure we are discussing the same
> thing...
> 
> Since nfnetlink_acct.c allows only packet or only byte counters to
> be updated, this may cause inconsistency (a valid concern!). So,
> what I proposed in my previous posting is roughly the following:
> 
> nfnetlink_acct.c::nfnl_acct_new:
> 	if (matching) {
> /*...*/
> 		if (tb[NFACCT_PKTS] && tb[NFACCT_BYTES]) {
> 			atomic64_set(&nfacct->pkts,
> 				be64_to_cpu(nla_get_be64(tb[NFACCT_PKTS])));
> 			atomic64_set(&nfacct->bytes,
> 				be64_to_cpu(nla_get_be64(tb[NFACCT_BYTES])));
> 		} else if (tb[NFACCT_PKTS] || tb[NFACCT_BYTES])	{
> 			return -EINVAL;	// or "return -EBUSY;"
> /*...*/
> 
> If I understand you correctly, you are concerned that between the
> time after "atomic64_set(&nfacct->pkts..." is executed and
> "atomic64_set(&nfacct->bytes" not yet started/finished, even though
> these two statements follow one after another, you think there will
> be a momentary inconsistency between the byte and packet counter
> values, is that right?
> 
> If that is so, then the existing kernel code is having the same
> problem. For example:
> 
> a)
> nfnetlink_acct.c::nfnl_acct_new:
> 	if (matching) {
> 		if (nlh->nlmsg_flags & NLM_F_REPLACE) {
> 			/* reset counters if you request a replacement.	*/
> 			atomic64_set(&matching->pkts, 0);
> 			atomic64_set(&matching->bytes, 0);

We should check there if that acct object is in used. I think there is
no user-space code using the NLM_F_REPLACE flag IIRC.

> 			return 0;
> 		}
> 		return -EBUSY;
> 	}
> 
> b)
> nfnetlink_acct.c::nfnl_acct_fill_info:
> 	if (type == NFNL_MSG_ACCT_GET_CTRZERO) {
> 		pkts = atomic64_xchg(&acct->pkts, 0);
> 		bytes =	atomic64_xchg(&acct->bytes, 0);
> 	} else {
> 		pkts = atomic64_read(&acct->pkts);
> 		bytes =	atomic64_read(&acct->bytes);
> 	}

In this case, we don't leak packet/bytes counters.

> c)
> nfnetlink_acct.c::nfnl_acct_update:
> 	atomic64_inc(&nfacct->pkts);
> 	atomic64_add(skb->len, &nfacct->bytes);
> 
> In all of the above cases (a-c) the update statements are identical
> with what I proposed above, so if this is undesirable, then the
> existing code in the kernel in the above 3 cases I listed should
> also be changed, correct?

I don't see why c) is wrong. My concern is mostly about leaking data.

> > Let me check if I can come with some lockless way
> > to replace counters, so we can remove that -EBUSY limitation.
>
> This discussion we are having pointed me to some interesting idea.
> 
> Packet and byte counters are always updated in "unison" - one cannot
> (or should not) be updated without the other. The current "atomic"
> operations are performed separately (and independently!) for packet
> and then byte counters. Each atomic operation (atomic64_set,
> atomic64_inc etc) does a spinlock, again, separately for packet and
> byte counters. If we are always updating these variables in "unison"
> together, then we don't really need to do 2 locks - we need just
> one.
> 
> In other words, we can "demote" pkts and bytes variables from
> "atomic64_t" to uint64_t and use a manual lock which is specific for
> each nfacct object to update these values. In other words, something
> like this:
> 
> struct nf_acct {
> 	uint64_t		pkts;
> 	uint64_t		bytes;
> 	atomic64_t		bthr;
> 	atomic_t		fmt;
> 	struct list_head	head;
> 	atomic_t		refcnt;
> 	char			name[NFACCT_NAME_MAX];
> 	/* Lock	protecting packet & byte counters */
> 	rwlock_t		pb_lock;
> 	struct rcu_head		rcu_head;
> };
> /*...*/
> 
> nfnetlink_acct.c::nfnl_acct_new:
> 	if (matching) {
> /*...*/
> 		if (tb[NFACCT_PKTS] && tb[NFACCT_BYTES]) {
> 			write_lock_bh(&nfacct->pb_lock);
> 			nfacct->pkts =
> 				be64_to_cpu(nla_get_be64(tb[NFACCT_PKTS]));
> 			nfacct->bytes =
> 				be64_to_cpu(nla_get_be64(tb[NFACCT_BYTES]));
> 			write_unlock_bh(&nfacct->pb_lock);
> 		} else if (tb[NFACCT_PKTS] || tb[NFACCT_BYTES])	{
> 			return -EINVAL;	// or "return -EBUSY;"
> /*...*/
> 
> 	nfacct = kzalloc(sizeof(struct nf_acct), GFP_KERNEL);
> 	if (nfacct == NULL)
> 		return -ENOMEM;
> 
> 	strncpy(nfacct->name, nla_data(tb[NFACCT_NAME]), NFACCT_NAME_MAX);
> 	rwlock_init(&nfacct->pb_lock);
> /*...*/
> 
> nfnetlink_acct.c::nfnl_acct_fill_info:
> 	if (type == NFNL_MSG_ACCT_GET_CTRZERO) {
> 		write_lock_bh(&acct->pb_lock);
> 		pkts = acct->pkts;
> 		bytes =	acct->bytes;
> 		acct->pkts = 0;
> 		acct->bytes = 0;
> 		write_unlock_bh(&acct->pb_lock);
> 	} else {
> 		read_lock_bh(&acct->pb_lock);
> 		pkts = acct->pkts;
> 		bytes =	acct->bytes;
> 		read_unlock_bh(&acct->pb_lock);
> 	}
> /*...*/
> 
> nfnetlink_acct.c::nfnl_acct_update:
> 	write_lock_bh(&nfacct->pb_lock);
> 	nfacct->pkts += 1;
> 	nfacct->bytes += skb->len;
> 	write_unlock_bh(&nfacct->pb_lock);
> 
> That way, we use only one lock (instead of two as was the case with
> "atomic64_set" and friends) and there should not be any concerns any
> longer as to whether there will be any inconsistency between packet
> and byte counter values because these are applied in "unison" during
> a write lock, which is later released after the operation is
> complete. What do you think, would that be satisfactory?

Eric Dumazet proposed during the latest workshop that we could add
some flag to allow different flavours of acct object:

* per-cpu based, they consume more memory, but they are lockless.
* compact, lock based, they consume little memory, but bottleneck is
  locking.

So you select what you need according to your requirements.  I plan to
send some patches to support this.

Regards.
