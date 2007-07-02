From: Patrick McHardy <kaber@trash.net>
Subject: Re: xt_connlimit 20070628 kernel
Date: Mon, 02 Jul 2007 14:27:49 +0200
Message-ID: <4688EF45.7020200@trash.net>
References: <Pine.LNX.4.64.0706201127080.5731@fbirervta.pbzchgretzou.qr>
	<467BAF07.6020502@trash.net>
	<Pine.LNX.4.64.0706251309521.3137@fbirervta.pbzchgretzou.qr>
	<467FA9CE.8000805@trash.net>
	<Pine.LNX.4.64.0706282121220.22579@fbirervta.pbzchgretzou.qr>
	<46840B9F.7080803@trash.net>
	<Pine.LNX.4.64.0706282130150.22579@fbirervta.pbzchgretzou.qr>
	<468410A9.70309@trash.net>
	<Pine.LNX.4.64.0706282150401.22579@fbirervta.pbzchgretzou.qr>
	<Pine.LNX.4.64.0706282155000.22579@fbirervta.pbzchgretzou.qr>
	<4684ECB5.9070402@trash.net>
	<Pine.LNX.4.64.0707011552500.15758@fbirervta.pbzchgretzou.qr>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Cc: Netfilter Developer Mailing List <netfilter-devel@lists.netfilter.org>
To: Jan Engelhardt <jengelh@computergmbh.de>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
In-Reply-To: <Pine.LNX.4.64.0707011552500.15758@fbirervta.pbzchgretzou.qr>
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

Jan Engelhardt wrote:
> On Jun 29 2007 13:27, Patrick McHardy wrote:
> 
>>A single hash would have the advantage that it would make it easier to deal
>>with IPv4 mapped addresses (thats assuming that an IPv4 mapped address and a
>>regular address should be counted as the same thing).
> 
> 
> Huwee :)
> Mathematically seen, all that is required is a hash function that is pure (GCC
> slang for "produces always the same for same input") for a tuple of
> <ipaddress, struct xt_connlimit_data>. So I could use xhash for ipv4 and yhash
> for ipv6 even and a per-connlimit_data rnd.
> 
> Right, to the topic: I think we're fine here.


That didn't answer my question. Should IPv6 mapped IPv4 addresses be
counted as the same address as the mapped IPv4 address or not?

>>Thats a lot of debugging considering that this is something quite
>>simple. I trust you tested this match, is it really necessary to
>>keep this?
> 
> 
> I certainly don't need it. Though, it's #ifdefed anyway, so... roll a dice and
> tell me :)


My one-sided dice tells me "better remove it" :)


>>>+		found    = nf_conntrack_find_get(&conn->tuple, ct);
>>
>>
>>I didn't notice this before. I just removed this "ignored_conntrack"
>>argument from nf_conntrack_find_get because it was unused so far and
>>seems to imply someone doing more complicated hash table fiddling
>>than they should be. Why exactly are you using it?
> 
> 
> This is "original code" (from POM). I can replace the last argument with NULL
> if that looks better.


Its not about looks. Do you need it or not?
(Looking below I guess not).

>>Another thing is that you're grabbing and releasing nf_conntrack_lock
>>once for each call, additionally you have an atomic_inc and an
>>atomic_dec_and_test per entry. Since you were worried about speed,
>>that part is what you should worry about. I'd suggest to hold
>>nf_conntrack_lock around the entire iteration and use
>>__nf_conntrack_find.
> 
> 
> Does this look reasonable? (Just removing the ///nf_conntrack_put lines and
> doing the locking ourselves.)
> 
>         read_lock_bh(&nf_conntrack_lock);
> 
>         /* check the saved connections */
>         list_for_each_entry_safe(conn, tmp, hash, list) {
>                 found    = __nf_conntrack_find(&conn->tuple, NULL);
>                 found_ct = NULL;
> 
>[...]
>         }
> 
>         read_unlock_bh(&nf_conntrack_lock);

Seems fine.

>>And hotdropping is quite unfriendly, it seems that as long as
>>you're able to read the addresses (which you're always), you can still
>>count the other connections.
> 
> 
> This is nf_ct_get that can fail. Without a connection, we can't figure
> anything.


You still have the addresses and port numbers to do a lookup. In
fact the most reasonable place to use this match is in the raw
table, before any resources are consumed. So it would make a lot
of sense to simply use the values from the headers (or call the
conntrack functions for tuple decoding if that makes it easier).
