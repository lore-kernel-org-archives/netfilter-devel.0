From: "Jean-Michel Hemstedt" <jean-michel.hemstedt@alcatel.be>
Subject: Re: conntrack hash function
Date: Tue, 25 Jun 2002 22:58:39 +0200
Sender: netfilter-devel-admin@lists.samba.org
Message-ID: <040601c21c8b$14c93e00$0489cb8a@etbx180>
References: <20020625132643.C31BD45CF@lists.samba.org> <15640.49204.886734.272701@isis.cs3-inc.com>
Reply-To: "Jean-Michel Hemstedt" <jean-michel.hemstedt@alcatel.be>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="Windows-1252"
Content-Transfer-Encoding: 7bit
Return-path: <netfilter-devel-admin@lists.samba.org>
To: "Don Cohen" <don-nf@isis.cs3-inc.com>,
	<netfilter-devel@lists.samba.org>
Errors-To: netfilter-devel-admin@lists.samba.org
List-Help: <mailto:netfilter-devel-request@lists.samba.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.samba.org>
List-Subscribe: <http://lists.samba.org/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.samba.org?subject=subscribe>
List-Unsubscribe: <http://lists.samba.org/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.samba.org?subject=unsubscribe>
List-Archive: <http://lists.samba.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

hi,

just FYI, hash was already discussed in a previous thread:
'connection tracking scaling' [19 March 2002]
sorry if you were aware of it.


> > From: "Jean-Michel Hemstedt" <jean-michel.hemstedt@alcatel.be>
> 
>  > 98  static inline u_int32_t
>  > 99  hash_conntrack(const struct ip_conntrack_tuple *tuple)
>  > 100  {
>  > 101  #if 0
>  > 102          dump_tuple(tuple);
>  > 103  #endif
>  > 104          /* ntohl because more differences in low bits. */
>  > 105          /* To ensure that halves of the same connection don't hash
>  > 106             clash, we add the source per-proto again. */
>  > 107          return (ntohl(tuple->src.ip + tuple->dst.ip
>  > 108                       + tuple->src.u.all + tuple->dst.u.all
>  > 109                       + tuple->dst.protonum)
>  > 110                  + ntohs(tuple->src.u.all))
>  > 111                  % ip_conntrack_htable_size;
>  > 112  }
> 
> A few questions here:
> - Why make the two halves of the connection hash to different buckets?
>   I'd think you'd want to consider the two halves to be the same
>   connection.  So you want them to hash the same.  It would make the
>   comparison a little more expensive, but save half the space.

and would even avoid a second key computation (modulo may be costly on
prime numbers for instance) and it would also avoid a second collision 
list scanning (interresting in case of large number of collisions).

> - % table size seems not quite ideal.  Especially since the table size
>   is likely a power of 2, which means that you effectively ignore all
>   but the low order bits of the addresses and ports.

yes, modulo is slower but more robust than bit masking (&), and
is generally considered a good tradeoff between computation time
and element distribution.

Another common practice consists in bitshifting src and dst
(i.e: ipa+ipa<<20+ipa<<13) to enforce domain LSB variations.

> Perhaps one less than table size if it's even, which will lose the
> use of one bucket but then use all of the data bits in the hash.  
> Of course, the low order bits might well be good enough.
> Then again, that depends on what the -per-proto data looks like,
> and for some protos this might not vary in the low order bits.

-jmhe-
