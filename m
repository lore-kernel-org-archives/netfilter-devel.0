From: KOVACS Krisztian <hidden@balabit.hu>
Subject: Conntrack & NAT question
Date: Thu, 15 Jul 2004 11:03:45 +0200
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <1089882225.2556.10.camel@nienna.balabit>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: netfilter-devel <netfilter-devel@lists.netfilter.org>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org


  Hi,

  While re-thinking the conntrack entry update facility of ct_sync, I
was thinking on the relation of conntrack entries, their NAT-related
information, and confirmation.

  So, in theory, I think that the tuples of an already confirmed
conntrack entry cannot be changed. Since NAT (usually) changes the reply
tuple, their NAT entries should be constant as well after confirming.
However, I'm having weird things in ct_sync... In theory, ct_sync
replicates confirmed conntrack entries only, so there shouldn't be any
problem if my theory 'confirmed entries have constant tuples' is true.
However, I have somethink like this in the update function:

	[...]

	if (new) {
		memcpy(&ct->tuplehash[IP_CT_DIR_ORIGINAL].tuple, &sct->orig,
		       sizeof(struct ip_conntrack_tuple));
		memcpy(&ct->tuplehash[IP_CT_DIR_REPLY].tuple, &sct->reply,
		       sizeof(struct ip_conntrack_tuple));
	} else {
		CT_SYNC_ASSERT(memcmp(&ct->tuplehash[IP_CT_DIR_ORIGINAL].tuple,
				    &sct->orig, sizeof(sct->orig)) == 0);
		CT_SYNC_ASSERT(memcmp(&ct->tuplehash[IP_CT_DIR_REPLY].tuple,
				    &sct->reply, sizeof(sct->reply)) == 0);
		CT_SYNC_DUMP_TUPLE(&sct->orig);
		CT_SYNC_DUMP_TUPLE(&sct->reply);
	}

	[...]

  The 'new' parameter means we're updating an entry we've just created.
So, unless the entry is new, we check whether the tuples in the update
message are the same as ours. And, unfortunately, I have a few assertion
failed messages in the logs... :(

  Any idea? What am I missing?

-- 
 Regards,
   Krisztian KOVACS
