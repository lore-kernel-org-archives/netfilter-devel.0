From: Herve Eychenne <rv@wallfire.org>
Subject: Re: [PATCH] Make hashsize ip_conntrack parameter writable
Date: Thu, 6 Oct 2005 14:15:16 +0200
Message-ID: <20051006121516.GR29780@eychenne.org>
References: <1128536584.9868.1.camel@localhost.localdomain>
Reply-To: rv@wallfire.org
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8bit
Cc: Netfilter development mailing list <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Rusty Russell <rusty@rustcorp.com.au>
Content-Disposition: inline
In-Reply-To: <1128536584.9868.1.camel@localhost.localdomain>
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

On Thu, Oct 06, 2005 at 04:23:03AM +1000, Rusty Russell wrote:

 Hi Rusty and all,

> Status: Tested on 2.6.14-rc3-git3
> Signed-off-by: Rusty Russell <rusty@rustcorp.com.au> (authored)

> It's fairly simple to resize the hash table, but currently you need to
> remove and reinsert the module.  That's bad (we lose connection
> state).  Harald has even offered to write a daemon which sets this
> based on load.

Hope you're having fun at the workshop. Seems like. :-)

Almost two years ago (3 Nov 2005), during the initial redaction of
http://www.wallfire.org/misc/netfilter_conntrack_perf.txt
I asked :
  Is it possible to modify HASHSIZE at runtime when ip_conntrack is
  not compiled as a module? If not, shouldn't we enable this with
  /proc, like CONNTRACK_MAX?
And Harald replied:
  no.  It is non-trivial to change the hash size after we have conntrack
  entries in the table.  It would mean we'd need to re-hash all alrady
  existing connections.

No one else dared to comment at that time...
Well, it's good to see times have changed. ;-)

Anyway, the resize process implies some rehashing... I guess the resizing
of a hash on-place (without allocating/populating another one) is
really tricky, if not practically impossible.

So if x if the dimension of the new hash table and y is the size of the
memory occupied by all the current connections, you should always dispose
of x * sizeof(ptr) + y of extra free memory before the resize.
That is good to know, I suppose.

As all netfilter operations are probably freezed during the resize,
this leads to the next question: how much time will the resize take?

+       for (i = 0; i < ip_conntrack_htable_size; i++) {
+               while (!list_empty(&ip_conntrack_hash[i])) {
+                       h = list_entry(ip_conntrack_hash[i].next, struct ip_conntrack_tuple_hash, list);
+                       list_del(&h->list);
+                       bucket = __hash_conntrack(&h->tuple, hashsize);
+                       list_add_tail(&h->list, &hash[bucket]);
+               }
+       }

How many cycles will an iteration take? (so we can get an estimation of
the latency period in function of the processor speed and of the
current number of connections)

If this can be really long (seconds?... I have no idea), what would you
think about doing the list_del() calls outside (after) of the
locking section?


One last (silly) question. As you can specify the size of the hash
table with
# modprobe ip_conntrack hashsize=1024
at runtime, I suppose you can also set it at boot time by adding
ip_conntrack.hashsize=1024
as a kernel boot parameter (static til now). Am I right?
Is the list of all tunable parameters (at least for netfilter) available
somewhere?

 Herve

-- 
 _
(°=  Hervé Eychenne
//)  Homepage:          http://www.eychenne.org/
v_/_ WallFire project:  http://www.wallfire.org/
