From: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Subject: Re: [PATCH 02/13] IP set core support
Date: Tue, 25 Jan 2011 22:23:47 +0100 (CET)
Message-ID: <alpine.DEB.2.00.1101252150450.19648@blackhole.kfki.hu>
References: <1295618527-9583-1-git-send-email-kadlec@blackhole.kfki.hu> <1295618527-9583-2-git-send-email-kadlec@blackhole.kfki.hu> <1295618527-9583-3-git-send-email-kadlec@blackhole.kfki.hu> <alpine.DEB.2.00.1101212232290.10581@blackhole.kfki.hu>
 <4D3EE277.9070804@trash.net>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: netfilter-devel@vger.kernel.org,
	Pablo Neira Ayuso <pablo@netfilter.org>
To: Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from smtp2.kfki.hu ([148.6.0.28]:52980 "EHLO smtp2.kfki.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754063Ab1AYVXs (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 25 Jan 2011 16:23:48 -0500
In-Reply-To: <4D3EE277.9070804@trash.net>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Tue, 25 Jan 2011, Patrick McHardy wrote:

> Please see below for a few more comments on the netlink protocol.
> 
> On 21.01.2011 22:39, Jozsef Kadlecsik wrote:
> > +static int
> > +dump_init(struct netlink_callback *cb)
> > +{
> > +	struct nlmsghdr *nlh = nlmsg_hdr(cb->skb);
> > +	int min_len = NLMSG_SPACE(sizeof(struct nfgenmsg));
> > +	struct nlattr *cda[IPSET_ATTR_CMD_MAX+1];
> > +	struct nlattr *attr = (void *)nlh + min_len;
> > +	ip_set_id_t index;
> > +
> > +	/* Second pass, so parser can't fail */
> > +	nla_parse(cda, IPSET_ATTR_CMD_MAX,
> > +		  attr, nlh->nlmsg_len - min_len, ip_set_setname_policy);
> > +
> > +	/* cb->args[0] : dump single set/all sets
> > +	 *         [1] : set index
> > +	 *         [..]: type specific
> > +	 */
> > +
> > +	if (!cda[IPSET_ATTR_SETNAME]) {
> > +		cb->args[0] = DUMP_ALL;
> > +		return 0;
> > +	}
> > +
> > +	index = find_set_id(nla_data(cda[IPSET_ATTR_SETNAME]));
> > +	if (index == IPSET_INVALID_ID)
> > +		return -EEXIST;
> 
> This error code doesn't seem right, EEXIST indicates that
> something already exists on creation, not that something
> doesn't exist. EINVAL for invalid values and ENOENT for
> non-existant sets seems more appropriate.

I'll fix all the mentioned error codes ;-).
 
> > +
> > +	cb->args[0] = DUMP_ONE;
> > +	cb->args[1] = index;
> > +	return 0;
> > +}
> > +
> > +static int
> > +ip_set_dump_start(struct sk_buff *skb, struct netlink_callback *cb)
> > +{
> > +	ip_set_id_t index = IPSET_INVALID_ID, max;
> > +	struct ip_set *set = NULL;
> > +	struct nlmsghdr *nlh = NULL;
> > +	unsigned int flags = NETLINK_CB(cb->skb).pid ? NLM_F_MULTI : 0;
> > +	int ret = 0;
> > +
> > +	if (cb->args[0] == DUMP_INIT) {
> > +		ret = dump_init(cb);
> > +		if (ret < 0) {
> > +			/* We have to create and send the error message
> > +			 * manually :-( */
> > +			netlink_ack(cb->skb, nlmsg_hdr(cb->skb), ret);
> 
> This should probably only be done if the NLM_F_ACK flag was set
> on the request.

I never thought to set NLM_F_ACK for dumping. I'll set the flag in the 
request but I believe I have to send the error message regardless of the 
flag: the dump initialization fails iff the named set does not exist and 
it should be reported.
 
> > +static int
> > +call_ad(struct sk_buff *skb, const struct nlattr *const attr[],
> > +	struct ip_set *set, const struct nlattr *nla,
> > +	enum ipset_adt adt, u32 flags)
> > +{
> > +	struct nlattr *head = nla_data(nla);
> > +	int ret, len = nla_len(nla), retried = 0;
> > +	u32 lineno = 0;
> > +	bool eexist = flags & IPSET_FLAG_EXIST;
> > +
> > +	do {
> > +		write_lock_bh(&set->lock);
> > +		ret = set->variant->uadt(set, head, len, adt,
> > +					 &lineno, flags);
> > +		write_unlock_bh(&set->lock);
> > +	} while (ret == -EAGAIN &&
> > +		 set->variant->resize &&
> > +		 (ret = set->variant->resize(set, retried++)) == 0);
> > +
> > +	if (!ret || (ret == -IPSET_ERR_EXIST && eexist))
> > +		return 0;
> > +	if (lineno && attr[IPSET_ATTR_LINENO]) {
> > +		/* Error in restore/batch mode: send back lineno */
> > +		u32 *errline = nla_data(attr[IPSET_ATTR_LINENO]);
> > +
> > +		*errline = lineno;
> 
> This appears to be modifying the (const) attributes received
> from userspace.

The code comes from the time when the argument of the netlink dump 
function was not constified. I reparse the skb and set the lineno that 
way, thanks for spotting!
 
> > +
> > +	if (attr[IPSET_ATTR_DATA]) {
> > +		ret = call_ad(skb, attr,
> > +			      set, attr[IPSET_ATTR_DATA], IPSET_ADD, flags);
> > +	} else {
> > +		int nla_rem;
> > +
> > +		nla_for_each_nested(nla, attr[IPSET_ATTR_ADT], nla_rem) {
> > +			if (nla_type(nla) != IPSET_ATTR_DATA ||
> > +			    !flag_nested(nla))
> > +				return -IPSET_ERR_PROTOCOL;
> 
> Since addition can fail due to size problems anyways it not very
> important, but we could perform validation before attempting to
> add members so the operation either succeeds or fails entirely.

Yeah, it's a protocol check, so it should come first. But the call again 
to nla_for_each_nested wouldn't be too ugly? Wrapping the condition into 
unlikely() would make it better?

> To really make sense that would require to test for existance of
> members on deletion and for enough space (+ possibly pre-allocation)
> on addition though, so for now we can ignore it I guess.

> > +
> > +	read_lock_bh(&set->lock);
> > +	ret = set->variant->uadt(set,
> > +				 nla_data(attr[IPSET_ATTR_DATA]),
> > +				 nla_len(attr[IPSET_ATTR_DATA]),
> > +				 IPSET_TEST, NULL, 0);
> > +	read_unlock_bh(&set->lock);
> > +	/* Userspace can't trigger element to be re-added */
> > +	if (ret == -EAGAIN)
> > +		ret = 1;
> 
> This value is returned to userspace, what does '1' mean?

The test functions return a positive integer for success. The only 
exception is the -EAGAIN return value, which means an incomplete element 
was tested and it triggers the core to re-add the element. However 
re-adding is meaningful for kernel side tests only. So for the sake of 
consistency, the return value is corrected to a positive integer.

The bitmap:ip,mac type uses -EAGAIN: if the element was added without the 
MAC part then when it's tested as a kernel requests, by re-adding the 
element we can fill out the MAC part from the tested packet.

> > +
> > +	return ret < 0 ? ret : ret > 0 ? 0 : -IPSET_ERR_EXIST;

And here the return codes are converted to usable values for the 
userspace. The whole dancing back and forth is due to the three-valued 
nature of the return codes of the test function: error, match, nomatch. 
Add/del is simpler: error or success.

> > +	set = ip_set_list[index];
> > +
> > +	skb2 = nlmsg_new(NLMSG_DEFAULT_SIZE, GFP_KERNEL);
> > +	if (skb2 == NULL)
> > +		return -ENOMEM;
> > +
> > +	nlh2 = start_msg(skb2, NETLINK_CB(skb).pid, nlh->nlmsg_seq, 0,
> > +			 IPSET_CMD_HEADER);
> > +	if (!nlh2)
> > +		goto nlmsg_failure;
> > +	NLA_PUT_U8(skb2, IPSET_ATTR_PROTOCOL, IPSET_PROTOCOL);
> > +	NLA_PUT_STRING(skb2, IPSET_ATTR_SETNAME, set->name);
> > +	NLA_PUT_STRING(skb2, IPSET_ATTR_TYPENAME, set->type->name);
> > +	NLA_PUT_U8(skb2, IPSET_ATTR_FAMILY, set->family);
> > +	NLA_PUT_U8(skb2, IPSET_ATTR_REVISION, set->type->revision);
> > +	nlmsg_end(skb2, nlh2);
> > +
> > +	ret = netlink_unicast(ctnl, skb2, NETLINK_CB(skb).pid, MSG_DONTWAIT);
> > +	if (ret < 0)
> > +		return -EFAULT;
> 
> Why not propagate the error?

I don't quite understand what do you mean. Should I attempt to send a 
second message?
 
Best regards,
Jozsef
-
E-mail  : kadlec@blackhole.kfki.hu, kadlec@mail.kfki.hu
PGP key : http://www.kfki.hu/~kadlec/pgp_public_key.txt
Address : KFKI Research Institute for Particle and Nuclear Physics
          H-1525 Budapest 114, POB. 49, Hungary
