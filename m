From: "Forte Systems - Iosif Peterfi" <iosif.peterfi@fortesys.ro>
Subject: RE: FIX: connlimit NULL pointer kernel panic (was: connlimit patch
	crashes 2.6.11 kernel)
Date: Thu, 19 May 2005 10:58:02 +0300
Message-ID: <46527.2523616024$1116489381@news.gmane.org>
References: <428C03B4.7000900@eurodev.net>
Mime-Version: 1.0
Content-Type: multipart/mixed;
	boundary="----=_NextPart_000_0008_01C55C61.A0A7ECF0"
Cc: mateusz@republika.pl, netfilter-devel@lists.netfilter.org, kaber@trash.net
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: "'Pablo Neira'" <pablo@eurodev.net>
In-Reply-To: <428C03B4.7000900@eurodev.net>
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

This is a multi-part message in MIME format.

------=_NextPart_000_0008_01C55C61.A0A7ECF0
Content-Type: text/plain;
	charset="US-ASCII"
Content-Transfer-Encoding: 7bit

Here is a diff -urN patch for what has been discussed except the conntrack
event-api. Works fine on 2.6.1-gentoo-r8, patch-o-matic-ng-20050516. 

Thanks a lot.

-----Original Message-----
From: netfilter-devel-bounces@lists.netfilter.org
[mailto:netfilter-devel-bounces@lists.netfilter.org] On Behalf Of Pablo
Neira
Sent: Thursday, May 19, 2005 6:11 AM
To: Damon Gray
Cc: mateusz@republika.pl; netfilter-devel@lists.netfilter.org;
kaber@trash.net
Subject: Re: FIX: connlimit NULL pointer kernel panic (was: connlimit patch
crashes 2.6.11 kernel)

Damon Gray wrote:
> The problem is that it is the usual case that "found" will not equal 
> NULL, but the memcmp will also not equal 0. This makes it so 
> tuplehash_to_ctrack(found) is never run so "found_ct" is always NULL. 
> Later in the function "found_ct" is dereferenced when it is NULL, which 
> causes the kernel panic. These operations need to be reordered so it is 
> guarantee that if "found" != NULL then tuplehash_to_ctrack will always 
> be run.
> 
> Basically it needs to be changed to:
> 
>  if (found != NULL && (found_ct = tuplehash_to_ctrack(found)) != NULL &&
>    0 == memcmp(&conn->tuple,&tuple,sizeof(tuple)) &&
>    found_ct->proto.tcp.state != TCP_CONNTRACK_TIME_WAIT) {

nice, could you post a patch against SVN? so it can be applied easily. 
While you are at it, could you sed 's/spin_lock/spin_lock_bh/g' as well? 
a quick look tells me that current locking is wrong.

For the record, this patch should be re-made to work on top of the 
conntrack-event-api, that way it will support more protocols than just 
tcp. Actually, someone already did this thing some time ago [1].

[1] 
https://lists.netfilter.org/pipermail/netfilter-devel/2004-November/017314.h
tml

--
Pablo



-- 
This message was scanned for spam and viruses by BitDefender.
For more information please visit http://linux.bitdefender.com/


------=_NextPart_000_0008_01C55C61.A0A7ECF0
Content-Type: application/octet-stream;
	name="ipt_connlimit.c.patch"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: attachment;
	filename="ipt_connlimit.c.patch"

--- ipt_connlimit.c.orig        2005-05-19 10:15:30.000000000 +0300
+++ ipt_connlimit.c     2005-05-19 10:27:31.000000000 +0300
@@ -55,7 +55,7 @@
        struct ipt_connlimit_conn *conn;
        struct list_head *hash,*lh;

-       spin_lock(&data->lock);
+       spin_lock_bh(&data->lock);
        tuple =3D ct->tuplehash[0].tuple;
        hash =3D &data->iphash[ipt_iphash(addr & mask)];

@@ -64,8 +64,8 @@
                struct ip_conntrack *found_ct =3D NULL;
                conn =3D list_entry(lh,struct ipt_connlimit_conn,list);
                found =3D ip_conntrack_find_get(&conn->tuple,ct);
-               if (0 =3D=3D memcmp(&conn->tuple,&tuple,sizeof(tuple)) =
&&
-                   found !=3D NULL && (found_ct =3D =
tuplehash_to_ctrack(found)) !=3D NULL &&
+               if (found !=3D NULL && (found_ct =3D =
tuplehash_to_ctrack(found)) !=3D NULL &&
+                   0 =3D=3D memcmp(&conn->tuple,&tuple,sizeof(tuple)) =
&&
                    found_ct->proto.tcp.state !=3D =
TCP_CONNTRACK_TIME_WAIT) {
                        /* Just to be sure we have it only once in the =
list.
                           We should'nt see tuples twice unless someone =
hooks this
------=_NextPart_000_0008_01C55C61.A0A7ECF0
Content-Type: text/plain; name="BitDefender.txt"
Content-Disposition: inline; filename="BitDefender.txt"


-- 
This message was scanned for spam and viruses by BitDefender.
For more information please visit http://linux.bitdefender.com/

------=_NextPart_000_0008_01C55C61.A0A7ECF0--
