From: "Ferry Huberts" <ferry@Hupie.com>
Subject: Re: Reset conntrack...
Date: Fri, 3 Dec 2004 14:50:44 +0100 (CET)
Message-ID: <33813.192.168.0.192.1102081844.squirrel@hupie.xs4all.nl>
References: <41AF92B1.30802@anduras.de>
	<08e901c4d92d$437085e0$1efc1e0a@rdd.soliton.co.jp>
Reply-To: ferry@Hupie.com
Mime-Version: 1.0
Content-Type: text/plain;charset=iso-8859-1
Content-Transfer-Encoding: quoted-printable
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
In-Reply-To: <08e901c4d92d$437085e0$1efc1e0a@rdd.soliton.co.jp>
To: netfilter-devel@lists.netfilter.org
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

This is great!
I've been looking for this for a while now.

But can the write to the proc entry please be in ascii format i.s.o. bina=
ry?



I use dynamically configured rules for peers that use DHCP: when a peer
address changes the old conntrack is in the way and needs to be removed. =
I
use a somewhat dirty trick for this that has more side effects than I wan=
t
so this solution appeals to me very much!

The trick (I use ESP traffic):
  # clear the connection tracking timeout for ESP traffic (generic)
  echo 0 > /proc/sys/net/ipv4/netfilter/ip_conntrack_generic_timeout \
        2> /dev/null

  delete-old-rules
  add-new-rules

  # set the connection tracking timeout for ESP traffic (generic)
  sleep 1
  echo $connectiontracking_esp_timeout \
         > /proc/sys/net/ipv4/netfilter/ip_conntrack_generic_timeout \
        2> /dev/null



--
Ferry Huberts

> Hello
>
> I made littile change in file  ip_conntrack_standalone.c
>
> This made, if you write IP address(in_addr_t format) to
>  /proc/net/ip_conntrack, any contrack with SRC address
> is written address are forced timeout/removed.
>
> I think, this is useful for linux firewall with IDS(such as snort).
>
> Sorry, I put many debug change to this file for my understand,
> thus I cannnot post as diff/patch format.
>
> YKND
>
> add those 2 functions
> -----------------------
> /* YKND    Remove conntrack entry, if src ip address match as contrack =
*/
> static inline int
> match_remove_srcip_conntrack(ulong in, struct ip_conntrack *conntrack)
> {
>  if( in =3D=3D conntrack->tuplehash[IP_CT_DIR_ORIGINAL].tuple.src.ip){
>   del_timer(&conntrack->timeout);   /* Delete from Timeout */
>   conntrack->timeout.function((unsigned long)conntrack);
>  }
>  return 0;
> }
>
> /* YKND      write entry "proc/net/ip_conntrack" */
> /*           Walk arround conntrack list and call remove entry */
> static int
> ip_conntrack_user_remove(struct file *file, const char *buffer,
>     unsigned long count, void *data)
> {
>  unsigned int i;
>  ulong in;
>  if(count !=3D sizeof(int)){
>   printk("Write size error \n");
>   return count;
>  }
>
>  in =3D *(ulong *)buffer;
>  /* DEBUG */
> // printk("Address=3D%u.%u.%u.%u was removed from conntrack \n",
> NIPQUAD(in));
>
>  READ_LOCK(&ip_conntrack_lock);
>
>  /* Traverse hash; print originals then reply. */
>  for (i =3D 0; i < ip_conntrack_htable_size; i++) {
>   const struct list_head * head =3D &ip_conntrack_hash[i];
>   do {
>    head =3D head->next;
>    if (head =3D=3D &ip_conntrack_hash[i]) {
>     head =3D NULL;
>     break;
>    }
>    if(head =3D=3D NULL){
>     break;
>    }
>   } while (!match_remove_srcip_conntrack(in, ((struct
> ip_conntrack_tuple_hash *)head)->ctrack));
>  }
>  READ_UNLOCK(&ip_conntrack_lock);
>  return count;
> }
> -----------------------
>
> and put 1 line in, function static int init_or_cleanup(int init)
>
> -----------------------
>  proc->write_proc =3D ip_conntrack_user_remove;
>
> -----------------------
>
> ----- Original Message -----
> From: "Sven Anders" <anders@anduras.de>
> To: <netfilter-devel@lists.netfilter.org>
> Sent: Friday, December 03, 2004 7:09 AM
> Subject: Reset conntrack...
>
>
>> -----BEGIN PGP SIGNED MESSAGE-----
>> Hash: SHA1
>>
>> Hello!
>>
>> Is it possible to reset the conntrack list or set any entry to the sta=
te
>> NEW to force
>> a recheck against new filter rules?
>>
>> The problem is:
>>
>> ~  If I set the (new) filtering rules with the target DROP, I want old
>> ~  (existing) connections to be dropped immediatly.
>> ~  The global rule '--state RELATED,ESTABLISHED' I set would still all=
ow
>> them...
>>
>> Regards
>> ~ Sven
>>
>> - --
>> ~ Sven Anders <anders@anduras.de>
>>
>> ~ ANDURAS service solutions AG
>> ~ Innstra=DFe 71 - 94036 Passau - Germany
>> ~ Web: www.anduras.de - Tel: +49 (0)851-4 90 50-0 - Fax: +49 (0)851-4 =
90
>> 50-55
>>
>> Rechtsform: Aktiengesellschaft - Sitz: Passau - Amtsgericht Passau HRB
>> 6032
>> Mitglieder des Vorstands: Sven Anders, Marcus Junker, Michael Sch=F6n
>> Vorsitzender des Aufsichtsrats: Dipl. Kfm. Karlheinz Antesberger
>> -----BEGIN PGP SIGNATURE-----
>> Version: GnuPG v1.2.5 (GNU/Linux)
>> Comment: Using GnuPG with Mozilla - http://enigmail.mozdev.org
>>
>> iD8DBQFBr5Kw5lKZ7Feg4EcRAsENAJ0XErp8VEr6vAIBUiyj9UM+Qm0gMgCdHQ4h
>> QzBcNjCwn8da+HnPIaGjH+M=3D
>> =3DcVzY
>> -----END PGP SIGNATURE-----
>>
>
>
>
